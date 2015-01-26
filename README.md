# hubot-lunch-rotation

Rotate through lunch weekly by individual

## Installation

```
npm install --save hubot-lunch-rotation
```

## Usage

* Ask this week's lunch option
```
hubot lunch

> This week, User chose Jimmy Johns!
```

* Set your preferred lunch
```
hubot lunch set Cafe Rio

> Preferred lunch for User is Cafe Rio
```

* Remove yourself from the lunch queue
```
hubot lunch unset

> You've been removed from the lunch queue
```

* Show lunch queue
```
hubot lunch queue

> Cubbys - User1
  Dickey's BBQ - User2
  Pho+ - User3
```

* Clear the lunch queue - use with caution
```
hubot lunch is for the weak

> Lunch queue has been emptied.
```
