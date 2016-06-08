#extension-multigames

A minimalistic OpenFL / Lime extension to manage multiple gaming networks using a single API.

###Currently supports

* Google Play Games (Android)
* Google Play Games (All platforms / haXe API)
* Amazon Game Circle (Android)
* Game Center (iOS)

###Simple use Example

```haxe
// This example show a simple ussage example.

import extension.multigames.Multigames;

class SimpleExample {
	function new(){
		// First of all, you must initialize all your networks.
		Multigames.initGameCenter();
		Multigames.initGameCircle();
		Multigames.initGPGRest('XXXXXXXX-XXXXXXXXX.apps.googleusercontent.com','XXXXXXXXXXXXXXXXXX');
		Multigames.initGPG(true);		
		Multigames.loadResourcesFromXML('<resources>
											<string name="app_id">391003675259</string>
											<string name="achievement_complete_stage_1">XXX-XXXXXXXXX</string>
											<string name="achievement_unlock_stage_2">XXX-XXXXXXXXX</string>
											<string name="achievement_complete_stage_2">XXX-XXXXXXXXX</string>
											<string name="achievement_unlock_stage_3">XXX-XXXXXXXXX</string>
											<string name="achievement_complete_stage_3">XXX-XXXXXXXXX</string>
											<string name="achievement_unlock_stage_4">XXX-XXXXXXXXX</string>
											<string name="achievement_complete_stage_4">XXX-XXXXXXXXX</string>
											<string name="achievement_unlock_stage_5">XXX-XXXXXXXXX</string>
											<string name="achievement_complete_stage_5">XXX-XXXXXXXXX</string>
											<string name="achievement_unlock_stage_6">XXX-XXXXXXXXX</string>
											<string name="achievement_complete_stage_6">XXX-XXXXXXXXX</string>
											<string name="leaderboard_completed_levels">XXX-XXXXXXXXX</string>
										</resources>');

		// Then, in case you want to use clud storage ("google play saved games" or "amazon whispersync for games")
		Multigames.setOnLoadGameCompleteCallback(onLoadGameComplete);
		Multigames.setOnLoadGameConflictCallback(onLoadGameConflict);										

		// Set the achievements steps (you need to decice how many steps you want achievements to have)
		Multigames.setAchievementSteps("achievement_complete_stage_1",20);
		Multigames.setAchievementSteps("achievement_complete_stage_2",20);
		Multigames.setAchievementSteps("achievement_complete_stage_3",20);
		Multigames.setAchievementSteps("achievement_complete_stage_4",20);
		Multigames.setAchievementSteps("achievement_complete_stage_5",20);
		Multigames.setAchievementSteps("achievement_complete_stage_6",20);
		Multigames.setAchievementSteps("achievement_unlock_stage_2",15);
		Multigames.setAchievementSteps("achievement_unlock_stage_3",15);
		Multigames.setAchievementSteps("achievement_unlock_stage_4",15);
		Multigames.setAchievementSteps("achievement_unlock_stage_5",15);
		Multigames.setAchievementSteps("achievement_unlock_stage_6",15);

	}

	function gameOver() {
		Multigames.setProgress('achievement_complete_stage_1',3,50); // here you specify the progess to 3/50 (for google play games will just tell 3 steps);
		Multigames.reveal('achievement_complete_stage_4'); // will reveal a hidden achievement (except for amazon, where hidden achievements get's reveals automatically when compelted)
		Multigames.setScore("leaderboard_completed_levels", 1234);
		// ...
		// ...
		// PLEASE CHECK THE Multigames.hx class for complete method list.
	}
	
	function showLeaderboards() {
		// some implementation
		Multigames.displayLeaderboard("leaderboard_completed_levels");
	}

	function showAchievements() {
		// some implementation
		Multigames.displayAchievements();
	}

	function getFromCloud(key:String){
		Multigames.loadSavedGame(key);
	}

	private function onLoadGameComplete(name:String,data:String) {	
		trace("Loaded: "+data);
		if(you-want-to-save-your-game){
			// You always need to save the game to the last opened game.
			var data:String = 'some data';
			var description:String = 'Autosaved game...';
			Multigames.commitAndCloseGame(data,description);
		}else{
			// You need to close the game if you're not saving / replacing it.
			Multigames.discardAndCloseGame();
		}
	}

	private function onLoadGameConflict(name:String,data:String,conflictData:String) {
		trace("I found a conflict!");
		trace("Local data: "+data);
		trace("Remote data: "+conflictData);
		var mergedData = resolveConflictAsYouWish(data, conflictData);
		Multigames.commitAndCloseGame(mergedData,"autosave / conflict solved",true); //true for resolvingConflict
	}

}

```

###How to Install

```bash
haxelib install extension-multigames
```

then on your project.xml add

```xml
    <haxelib name="extension-multigames" />
```

###How to use / build for each platform

To build using **Google Play Games** on Android
```bash
lime build android
```
Please note that for the native version of GooglePlayGames (android) you'll also need to add your google play games ID in your project.xml:
```xml
<setenv name="GOOGLE_PLAY_GAMES_ID" value="32180581421" /> <!-- REPLACE THIS WITH YOUR GOOGLE PLAY GAMES ID! -->
```


To build using **Game Center**
```bash
lime build ios
```


To build using **Amazon Game Circle**
```bash
lime build android -Damazon
```
Please note that you'll need to add the gamecircle_api_key.txt file in your assets folder like this:
```xml
<assets path="Assets/gamecircle_api_key.txt" rename="api_key.txt" if="amazon"/>
```


To build using **Google Play Games / REST API** (the default on every other platform)

```bash
lime build blackberry
lime build tizen
lime build windows
lime build mac
lime build linux 
```


###License

The MIT License (MIT) - [LICENSE.md](LICENSE.md)

Copyright &copy;  2015 SempaiGames (http://www.sempaigames.com)

Author: Federico Bricker
