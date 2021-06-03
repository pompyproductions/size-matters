# Size Matters

## Summary

Size Matters is a game —originally created for the first GoGodotJam— where you start the game as a rock that gains conscience, progresses through the world, interacts with NPCs (choosing whether to have combat or not), eventually consuming them to grow (or choosing not to). 

Different paths lead to different endings (relatively simple): for example, if you never have combat, you might not be considered a threat by the end boss of the first level, and the game might then and there. If you choose not to consume your victims, you might squeeze through a hole that you otherwise wouldn't fit in.

## Mechanics

It works with a hybrid combat system between turn-based and real-time. Every character gets a turn counter which fills up based on character's current speed (as you grow, that number decreases). The action is determined at the beginning of the turn: players pick their next action while the current turn is underway, whereas the NPCs set their next action based on their pattern.

Every turn, the characters perform their action twice: once in the beginning, again halfway.

## Goals

### 0.1

0.1 is going to be a fully-functional, 1-level-long proof of concept for the game "Size Matters". The goal is to have a POC that is as polished and satisfying as possible. As it stands, the game doesn't feel very intuitive and some people who played the game had problems with the first actions they wanted to do.

#### 0.1.1 (RELEASED)

**0.1.1** is the version submitted to GoGodotJam. Incomplete and buggy code in many parts. 

**Bugs to solve:**  
* Dialog boxes: revamp the "show dialog" and "close dialog". The dialog stays stuck in scene if you're quick enough.
* Combat: NPCs next and current turns are always the same. Separate the "decision maker" from the "current turn".

**Existing features to complete**:
* Scene switcher: Transition. Add new scenes between splash screen and main game, that would work as a tutorial.
* GUI text: works great, but diversify the text ("Tab to cycle" doesn't say much).
* GUI arrows: somehow convey better the idea that those 4 squares are your arrow keys.
* ESC menu: revamp and fill with actual content. 
* Combat: add actual combat. Probably skip the parry for now (take it out of the options).

#### 0.1.2 (NEXT)

**0.1.2** will have the same feature goals as **0.1.1**, but actually working this time.

#### 0.1.3

0.1.3 will build further upon the "feel" of the game: polishing graphics, adding sound, enhancing the experience, but same content.

#### 0.1.4

0.1.4 will be the first "content" update, adding the parry mechanic, room difficulty & procedural NPC generation, final room (& boss), and 2 endings (combat, non-combat).