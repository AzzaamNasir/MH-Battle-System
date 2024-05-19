### Things added this past week(Since 18th May):
- Now all types of selections are valid and work perfectly(i.e. Self and All can be selected as targets for the effects)
- Healing attacks work, just put the value in dmg in negative

## How do I open this? And run it?
First, download the zip file from here.
You will need to download Godot 4.2 or above. Then open Godot and click import, and then select the import option and select the zip file you have downloaded.
After the project opens in Godot for the first time, close it and open it again. Then click the play button on the top right(Or press F5). The game will tell you what to do from there.

## Why does this exist?
My primary goal in creating this was to provide a way to ***test out new minion/move ideas as well as balance out existing minions*** before we get them into the final game.
This way, we don't have to waste time implementing new features into the final project, only to remove them later. This is why I have also made it (comparitively) easier to create new minions.
I have not implemented any features which are not a part of the battle system directly. For example, I haven't (and don't plan to) include features like levelling, exp, stars, battle AI etc 

## What is yet to be implemented?
I am yet to implement the following features:
1. Super effective, Not effective, and Critical attacks
2. Overtime damage
3. Status effects
4. Energy

These next things are implemented, but might not work as intended in the projects current stage:

1. Multiple effect attacks

These next things might be implemented if I have time:
1. Battle modifiers(Like shield bubbles)
2. Easier way to add minions(Like creating a custom csv importer)

## How to add new minions/edit existing minions:
Step 1: In the Godot window, locate the `FileSystem` Panel. It should be in the bottom left by default. In the panel, go to Minions->Resources. Here is where all our Minions data will be stored. You can double click on any of the .tres files to
open the Minions data in the `Inspector`(Panel on the right) and edit the data of the minions already present
Step 2: To create a new minion, Right click on The resources folder and click on *Create New->Resource* ![image](https://github.com/AzzaamNasir/Min-Hero/assets/162361059/d8248d46-99fa-4100-8f99-fecb6e467b96)
Step 3: In the dialogue box that opens, search for `MinionData` and click `Create`. Name it the minion's name and save it in Minions->Resources. It should appear in the FileSystem under resources. Double click and open it
Step 4: Double Click on the new .tres file that was created. It should open up in the inspector. Fill all the details.(For sprite, just search the minion's name in the FileSystem and you should see an image, just drag it to the sprite box)
Step 5: To add Moves to the minion, Click on the box next to Minion Moves which says `Array[MoveData]`. Now click on add element. A box with the word *empty* should appear. In the FileSystem, go to Moves->Resources and drag and drop whatever move 
you want to the *empty* box. Repeat this for upto 6 moves per minion![image](https://github.com/AzzaamNasir/Min-Hero/assets/162361059/cdd8975b-d819-4fa7-8760-68cf4868d3e2)
Step 6: We are almost there! Now, in the file system, go to the scenes folder, right click on tigertan, and click duplicate. Name it as you wish, and then double click on the .tscn file that was created. It should open in the `Scene` panel(top left).
Click on the thing where it says *Tigertan* next to a blue circle. It should open in the inspector, where you can drag the .tres file you previously created in the resources folder to the place where it says Minion Data in the inspector
Step 7: Go to the FileSystem and Double click on the `Minions.tres` file in the Minions folder. It should open in the inspector. Just click on the box next to `Run` a couple of times. Don't worry if you don't see anything happening.

**Congrats! Your minion has been added!**

## How to add new moves/edit existing moves:
Step 1: In the Godot window, locate the `FileSystem` Panel. It should be in the bottom left by default. In the panel, go to Moves->Resources. Here is where all our Move's data will be stored. You can double click on any of the .tres files to
open the Moves data in the `Inspector`(Panel on the right) and edit the data of the Moves already present
Step 2: To create a new move, Right click on The resources folder and click on *Create New->Resource* ![image](https://github.com/AzzaamNasir/Min-Hero/assets/162361059/24ab6955-466a-4fce-8a60-92318513e259)
Step 3: In the dialogue box that opens, search for `MoveData` and click `Create`. Name it the Move's name and save it in Moves->Resources. It should appear in the FileSystem under resources. Double click and open it
Step 4: Double Click on the new .tres file that was created. It should open up in the inspector. Fill all the details.(For sprite, just search the move's name in the FileSystem and you should see an image, just drag it to the sprite box)
Step 5: Now it's time to add what the move does. This might sound a bit complicated. The way i'm handling these moves is by having each move consist of multiple Moveeffects. So for example, burn is made of 2 MoveEffects. 1. Damage the enemy for 20
damage. 2. Damage the enemy for 5 points per turn for 3 turns. Let's see how to create it
  - Click on Add Element -> empty -> New MoveEffect. I'll now explain what each property is
	  - Accuracy,Target no, Type, Target are pretty self explanatory
	  - Target Selector: Who will choose which minions are targeted? Are they chosen by the player, at random, or is it the minion attacking, or is it all the minions of the enemy or ally team?
	  - Dmg: The x and y are basically Min-Max. Like batch bolt deals from 1-45 damage. So x is 1, y is 45. For healing, put negative values
	  - Do Overtime: Will this effect last over time? Only use this in the particular effect, not for the move e.g. in the Burn example, only the 2nd effect will have Do Overtime checked
	  - Buff attribute: What attribute will be buffed? (Only shown if Type is buffed/debuffed) Put in negative for debuff
	  - BUff percent: Self explanatory
	  - Override properties: Basically means whether this effect should have its own targets. for example, in Burn, you want both the immediate and overtime damage to happen to the same target. So you will have Override checked in the first effect since you have to select enemies, but unchecked in the 2nd because you want to act on the same enemies as before
  - Fill the properties respectively. Repeat this for all the effects you need

**Congrats! Your move has been created. You can now use it in any minion**
