# Plutonium-T6-Any-Player-EE-Scripts
The following scripts allow the main Easter Egg quests to be done with any number of players—whether it is solo (1 player), duo (2 players), trio (3 players), or even more than 4 players—while aiming to be as similar to the original Easter Eggs as possible.

## Installation
1. [Download the latest release](https://github.com/Hadi77KSA/Plutonium-T6-Any-Player-EE-Scripts/releases/latest/download/release.zip).
2. Extract the `zm_any_player_ee` folder from the ZIP file that was downloaded.
3. Go to `%localappdata%\Plutonium\storage\t6` by pressing Win+R then pasting the mentioned path then pressing OK, and open the `mods` folder. If the `mods` folder does not exist, create it.

![run window](https://github.com/user-attachments/assets/edbc54f8-f3b6-4e8e-b0bd-4b9635776aa1)

4. Move the `zm_any_player_ee` folder to inside the `mods` folder.
5. Start the game and load the mod through the in-game `Mods` menu.

![mods menu](https://github.com/user-attachments/assets/a282836f-940d-4420-bd2d-3d8219c0fc62)

#### Patches
Can be found in `zm_any_player_ee.iwd\scripts\zm\Patches`
* `die_rise_extra_no_reset_floor_puzzle.gsc` can be used along with `die_rise_any_player_ee.gsc`  
The file goes in `scripts\zm\zm_highrise`  
This patch makes the floor symbols not reset once an incorrect symbol is stepped on.
* `nav_autocomplete.gsc` to go in `scripts\zm`  
This patch builds the Nav Tables and applies the Navcards to all maps for all players.

### Alternative Installation Methods
Following any of these methods makes the scripts be loaded automatically without needing to select the mod from the in-game `Mods` menu.

#### All Scripts
- Follow steps 1 & 2 from the main installation instructions.
- Go to `%localappdata%\Plutonium\storage\t6` by pressing Win+R then pasting the mentioned path then press OK.
- Open the `zm_any_player_ee` folder and copy the `zm_any_player_ee.iwd` file from inside of it.
- Paste the `zm_any_player_ee.iwd` file into the `t6` folder.

#### Individual Files
- Follow steps 1 & 2 from the main installation instructions.
- Go to `%localappdata%\Plutonium\storage\t6` by pressing Win+R then pasting the mentioned path then press OK, and open the `scripts\zm` directory. Create the `scripts\zm` directory if it does not exist.
- Open the `zm_any_player_ee` folder then the `zm_any_player_ee.iwd` file from inside of it, and extract the `scripts` folder.
- Find the files from the extracted `scripts` folder and place them into their respective map's folder. If the map's folder does not exist, create it and place it into the directory `%localappdata%\Plutonium\storage\t6\scripts\zm`.
  - TranZit's scripts go to `scripts\zm\zm_transit`
  - Die Rise's scripts go to `scripts\zm\zm_highrise`
  - Buried's scripts go to `scripts\zm\zm_buried`
  - Origins' scripts go to `scripts\zm\zm_tomb`

## Features
### TranZit
#### - Tower Step and Lamp Post Step for the Maxis Side
For solo, only require 1 Turbine.

### Die Rise
#### - Nav Table
The script by default will automatically build the Nav Table if it is not already built. To prevent this, the person hosting will need to [open the console](https://plutonium.pw/docs/opening-console/) and execute the following command:
```
set any_player_ee_highrise_nav "0"
```

#### - Elevators Step and Dragon Puzzle
Require the same amount as the number of players.  
If the Dragon Puzzle step is failed, it will reset back to require the same amount as the number of players.

#### - Trample Steam Step
##### a) Maxis Side
- On solo and on 3p while the 1st ball is already flinging between Trample Steams placed on a set of lion symbols, only one Trample Steam will be required in order to be able to place down a ball.
- If the number of players is 3 or less, the players will have the ability to place both balls on the same set of Trample Steams.
- On 3p, having the 1st ball flinging is required to be able to place the other ball on the lone Trample Steam.

##### b) Richtofen Side
Requires the players to place Trample Steams only on the same amount of symbols as players.

### Buried
#### a) Maxis Side
##### - Wisp Step
For less than 3p, wisp will no longer rely on zombies getting near it.

##### - Bells Step
For less than 3p, time limit will be removed. Will only reset if it is failed.

#### b) Richtofen Side
##### - Round Infinity A.K.A. the Time Bomb Step
On 4p or less, requires all players in the lobby to be near the location of the Time Bomb.  
If the number of players is greater than 4, the step will only work if 4 players are near the location, no more no less, exactly how it works without the mod.

#### Sharpshooter
Minimum number of required targets:
- 1p: 20 targets (Candy Shop)
- 2p: 39 targets (Candy Shop + Saloon (19))
- Otherwise: all 84 targets

#### Super Easter Egg
Allows for the Super Easter Egg button to be accessible with any number of players as long as:
- the players have, collectively, inserted the Navcards on all three Victis maps of TranZit, Die Rise, and Buried;
- each player in the lobby has completed the Victis maps' Easter Eggs on the same side across the maps;
- the completed side across all players is the same.

For more than 4 players, the mod will only check the player progress that is shown on the box.

### Origins
Spawns stone tablets near the challenge boxes for players to grab the One Inch Punch from. This allows for matches of 5+ players to be able to obtain the One Inch Punch to complete *Step 6: Wield a Fist of Iron* of the Easter Egg.

## Alternative Mods With Extra Features + Other Maps
- TranZit Extra: makes the EMP step on the Richtofen quest on solo only require 2 EMPs instead of 4.  
[tranzit_extra_richtofen_solo.gsc](https://github.com/Hadi77KSA/Plutonium-T6-Any-Player-EE-Extra-Scripts/releases/latest/download/tranzit_extra_richtofen_solo.gsc)
- Die Rise Extra: on the Trample Steam step on the Maxis side while there are less than 4 players, gives the players the ability to pick up extra Trample Steams, and the zombies will ignore the Trample Steams placed during the step.  
[die_rise_extra_springpads_maxis.gsc](https://github.com/Hadi77KSA/Plutonium-T6-Any-Player-EE-Extra-Scripts/releases/latest/download/die_rise_extra_springpads_maxis.gsc)
- Mob of the Dead: cleaned-up version of [teh_bandit's mod](https://forum.plutonium.pw/post/66551). This mod functions the same way as his mod, where a bot is spawned in once all mobsters' numbers are entered into the number pad on solo.  
[motd_solo.gsc](https://github.com/Hadi77KSA/teh-bandit-Plutonium-T6ZM-Solo-Mods/releases/latest/download/motd_solo.gsc)  
To install, follow the steps in the **Individual Files** alternative installation method. The script goes to `scripts\zm\zm_prison`
- Buried Extra: different versions have been provided containing the following features:-
  - Richtofen maze levers step notifies the players whether each lever has sparked or not.  
[buried_extra_richtofen_maze_lever_sparks.gsc](https://github.com/Hadi77KSA/Plutonium-T6-Any-Player-EE-Extra-Scripts/releases/latest/download/buried_extra_richtofen_maze_lever_sparks.gsc)
  - Maxis bells step auto-completes once started on solo.  
[buried_extra_maxis_solo_bells.gsc](https://github.com/Hadi77KSA/Plutonium-T6-Any-Player-EE-Extra-Scripts/releases/latest/download/buried_extra_maxis_solo_bells.gsc)
  - On the sharpshooter step on 3p, the players can choose the minimum number of targets to either be 61–65 or all targets on every attempt; where choosing the minimum to be 61–65 targets is done by shooting less than or exactly 65 targets, and choosing the minimum to be all targets is done by shooting more than 65 targets.  
[buried_extra_sharpshooter_3p.gsc](https://github.com/Hadi77KSA/Plutonium-T6-Any-Player-EE-Extra-Scripts/releases/latest/download/buried_extra_sharpshooter_3p.gsc)

## FAQ
### Q: Do I/we need all of these mods to do all the EEs?
A: Depends on the number of players and which maps and side you choose. The host is required to have the mods installed. The following shows the required files:
  - 1p:-
    - TranZit Maxis: `tranzit_maxis_any_player_ee.gsc`
    - Die Rise: `die_rise_any_player_ee.gsc`
    - Buried and Super: `buried_any_player_ee.gsc`
  - 2p:-
    - Die Rise: `die_rise_any_player_ee.gsc`
    - Buried and Super: `buried_any_player_ee.gsc`
  - 3p:-
    - Die Rise: `die_rise_any_player_ee.gsc`
    - Buried Richtofen and Super: `buried_any_player_ee.gsc`
  - 4p:- None
  - More than 4p:-
    - Super: `buried_any_player_ee.gsc`
    - Origins: `origins_any_player_ee.gsc`

### Q: I am stuck on some Easter Egg step. Could you help?
A: Generally, if you ask for help with any Easter Egg step, I will try to assist you. Note that the scripts do not modify anything outside of what is mentioned. Refer to the **Features** section for the changes made by the scripts, otherwise you could check existing guides such as the ones from the [CoD Fandom Wiki](https://callofduty.fandom.com/wiki/Category:Call_of_Duty:_Black_Ops_II_Zombies_Main_Quests).

### Q: How do I make sure the scripts are loaded?
A: Most of my scripts come with a message in green/blue/yellow colours that appears when the player loads in indicating the scripts are loaded. Another method of checking is to get the host to execute the Plutonium [console](https://plutonium.pw/docs/opening-console/) commands:
```
flashScriptHashes; scriptHashes
```
If the scripts are loaded, they will appear in the list of scripts.

### Q: I want to use this without loading it as a mod so that I can have my normal stats or play with a different mod loaded. How do I load these scripts without loading them as a mod from the Mods menu?
A: Since my mod is composed of only `.gsc` script files, it can be loaded without the need to select it from the in-game `Mods` menu. To do so, follow one of the **Alternative Installation Methods** to make the scripts able to be loaded automatically.

### Q: On TranZit, should I worry that Maxis says the Turbine does not have enough power shortly after placing the Turbine under the tower?
A: Likely a vanilla game issue, especially if the Turbine begins not emitting power. If the Turbine is emitting power, then you probably should not worry. Wait at least 6 seconds after placing the Turbine(s) before killing the Avogadro just to be safe.

### Q: On Die Rise, why is the elevator step not completing even though we are standing on enough elevator symbols?
A: Vanilla game problem. You need to make sure the Nav Table is fully built.

### Q: On Die Rise, why is the Ballistic Knife step not completing even though Maxis said his quote about reincarnation, and the Ballistic Knife is upgraded and is shot into the Buddha room?
A: Vanilla game problem. The player shooting the Ballistic Knife must not have a melee weapon (Bowie Knife, Galvaknuckles) nor have bled out, which includes falling off the map and getting crushed with the exception of doing so while having Who's Who or solo Quick Revive. To fix this, get another player—who does not have a melee weapon nor has bled out—to do the step.

## Credits
- CCDeroga: [TranZit Maxis mod](https://forum.plutonium.pw/topic/15338/zm-release-solo-maxis-tranzit), [Buried Maxis mod](https://forum.plutonium.pw/topic/15604/release-zm-buried-maxis-solo-ee).
- teh_bandit: TranZit Richtofen mod, [Mob of the Dead mod](https://forum.plutonium.pw/topic/16734/release-zombies-mob-of-the-dead-easter-egg-solo-improved), and other contributions mentioned in the credited people's scripts.
- DaddyDontStop: [Die Rise Maxis mod](https://forum.plutonium.pw/topic/16736/release-zombies-die-rise-solo-ee-maxis), Buried Maxis mod.
- shyperson0/znchi: [Die Rise Richtofen mod](https://forum.plutonium.pw/topic/14737/gsc-zm-solo-die-rise-richtofen).
- Stick Gaming/Nathan3197: [Buried Richtofen mod](https://forum.plutonium.pw/topic/16021/release-zm-buried-easter-egg-quality-of-life-improvement).
- Raheem1 and the Easter Egg speedrunning community: testing my Die Rise's mod, and giving opinions on my changes made to Die Rise's mod and Buried's mod.
