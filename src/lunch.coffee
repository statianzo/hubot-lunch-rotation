# Description:
#   Rotate through lunch weekly by individual
#
# Dependencies:
#
# Configuration:
#
# Commands:
#   hubot lunch - Returns this week's lunch option
#   hubot lunch set <choice> - Set your preferred lunch
#   hubot lunch queue - List the upcoming lunch queue
#
# Authors:
#   statianzo
#

{
  append
  clone
  compose
  findIndex
  head
  isEmpty
  isNil
  join
  mapIndexed
  propEq
  reject
  remove
  tail
} = require('ramda')

moment = require('moment')

noEntries = "No choices have been made. You will go hungry."
resetReply = "As you wish. All lunches have been removed."
formatEntry = (e, i) -> "#{i+1}. #{e.choice} - #{e.user}"
formatThisWeek = (e) -> "This week #{e.user} chose #{e.choice}!"
compact = reject(isNil)

lunch = (robot) ->
  load = ->
     robot.brain.get('lunch') || {latestWeek: moment().isoWeek(), choices: []}
  save = (lunchData) ->
     robot.brain.set('lunch', lunchData)

  entryOfWeek = (lunchData) ->
    week = moment().isoWeek()
    if lunchData.latestWeek != week
      lunchData.latestWeek = week
      lunchData.choices = lunch.rotate(lunchData.choices)
      save(lunchData)
    head(lunchData.choices)

  robot.respond /lunch$/i, (msg) ->
    lunchData = load()
    entry = entryOfWeek(lunchData)
    if !entry
      msg.send noEntries
    else
      msg.send formatThisWeek(entry)

  robot.respond /lunch set (.*)$/i, (msg) ->
    choice = msg.match[1].trim().toLowerCase()
    user = msg.message.user.name
    lunchData = load()
    lunchData.choices = lunch.set(lunchData.choices, user, choice)
    save(lunchData)

    msg.reply "your preferred lunch is now #{choice}."

  robot.respond /lunch unset$/i, (msg) ->
    user = msg.message.user.name
    lunchData = load()
    lunchData.choices = lunch.unset(lunchData.choices, user)
    save(lunchData)

    msg.reply "you've removed yourself from the lunch queue."

  robot.respond /lunch queue$/i, (msg) ->
    lunchData = load()
    if isEmpty(lunchData.choices)
      msg.send noEntries
    else
      msg.send lunch.queue(lunchData.choices)

  robot.respond /lunch is for the weak/i, (msg) ->
    save(null)
    msg.send resetReply

  if process.env.LUNCH_DEBUG
    robot.respond /lunch debug data/i, (msg) ->
      lunchData = load()
      msg.send JSON.stringify(lunchData);

    robot.respond /lunch debug set week (\d+)/i, (msg) ->
      lunchData = load()
      lunchData.latestWeek = parseInt(msg.match[1])
      save(lunchData)
      msg.send JSON.stringify(lunchData);

    robot.respond /lunch debug date/i, (msg) ->
      lunchData = load()
      msg.send JSON.stringify
        latestWeek: lunchData.latestWeek,
        moment: moment(),
        isoWeek: moment().isoWeek()

    robot.respond /lunch debug rotate/i, (msg) ->
      lunchData = load()
      lunchData.choices = lunch.rotate(lunchData.choices)
      save(lunchData)
      msg.send JSON.stringify(lunchData);



lunch.set = (lunches, user, choice) ->
  entry = {user, choice}
  existingIndex = findIndex(propEq('user', user), lunches)
  if existingIndex > -1
    cloned = clone(lunches)
    cloned[existingIndex] = entry
    cloned
  else
    append(entry, lunches)

lunch.unset = (lunches, user) ->
  existingIndex = findIndex(propEq('user', user), lunches)
  remove(existingIndex, 1, lunches)


lunch.rotate = (list) ->
  compact(append(head(list), tail(list)))

lunch.queue = compose(join("\n"), mapIndexed(formatEntry))

module.exports = lunch
