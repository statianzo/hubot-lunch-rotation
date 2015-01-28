Error.stackTraceLimit = 1

lunch = require("../src/lunch")


module.exports =
  set:
    "Sets preference to lunch list": (test) ->
      res = lunch.set([], "User", "Jimmy Johns")
      test.deepEqual(res[0], {user: "User", choice: "Jimmy Johns"})
      test.done()

    "Updates existing lunch preference": (test) ->
      added = lunch.set([], "User", "Jimmy Johns")
      updated = lunch.set(added, "User", "KFC")
      test.equal(updated.length, 1)
      test.deepEqual(updated[0], {user: "User", choice: "KFC"})
      test.done()

  unset:
    "Unsets a preferred lunch": (test) ->
      added = lunch.set([], "User", "Jimmy Johns")
      updated = lunch.unset(added, "User")
      test.deepEqual(updated, [])
      test.done()

    "Copes with entry not found": (test) ->
      updated = lunch.unset([], "User")
      test.deepEqual(updated, [])
      test.done()

  rotate:
    "Rotates a list": (test) ->
      orig = [1,2,3]
      res = lunch.rotate(orig)
      test.deepEqual(res, [2,3,1])
      test.done()

    "Rotates an empty list": (test) ->
      res = lunch.rotate([])
      test.deepEqual(res, [])
      test.done()

  queue:
    "Lists queue of upcoming": (test) ->
      expected = "1. B - A\n2. D - C"
      res = lunch.queue([{user: 'A', choice: 'B'}, {user: 'C', choice:'D'}])
      test.equal(res, expected)
      test.done()
