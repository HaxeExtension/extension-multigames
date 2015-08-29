package extension.multigames;

#if (gpgnative || gpgrest)
import extension.gpg.GooglePlayGames;
#end

#if ios
import extension.gamecenter.GameCenter;
#end

#if amazon
import extension.gc.GameCircle;
#end

class Multigames {

	#if amazon
	private static var lastOpenedGame:String=null;
	#end

	///////////////////////////////////////////////////////////////////////////
	//// LEADERBOARDS 
	///////////////////////////////////////////////////////////////////////////

	public static function setScore(leaderboardName:String,score:Int) {
		#if (gpgnative || gpgrest)
			GooglePlayGames.setScore(GooglePlayGames.getID(leaderboardName),score);
		#elseif ios
			GameCenter.reportScore(leaderboardName, score);
		#elseif amazon
			GameCircle.setScore(leaderboardName, score); 		
		#end
	}

	///////////////////////////////////////////////////////////////////////////
	//// ACHIEVEMENTS 
	///////////////////////////////////////////////////////////////////////////

	public static function setProgress(achievementName:String, count:Int, totalSteps:Int):Bool{
		#if (gpgnative || gpgrest)
			return GooglePlayGames.setSteps(GooglePlayGames.getID(achievementName),count);
		#elseif ios
			GameCenter.reportAchievement(achievementName, (100.0 * count)/totalSteps);
			return true;
		#elseif amazon
			return GameCircle.setSteps(achievementName, (100.0 * count)/totalSteps);			
		#else
			return false;
		#end
	}

	public static function reveal(achievementName:String):Bool{
		#if (gpgnative || gpgrest)
			return GooglePlayGames.reveal(GooglePlayGames.getID(achievementName));
		#elseif ios
			GameCenter.reportAchievement(achievementName, 0);
			return true;
		#elseif amazon
			return true;
		#else
			return false;
		#end
	}

	public static function unlock(achievementName:String):Bool{
		#if (gpgnative || gpgrest)
			return GooglePlayGames.unlock(GooglePlayGames.getID(achievementName));
		#elseif ios
			GameCenter.reportAchievement(achievementName, 100);
			return true;
		#elseif amazon
			return GameCircle.setSteps(achievementName, 100);			
		#else
			return false;
		#end
	}

	///////////////////////////////////////////////////////////////////////////
	//// UI 
	///////////////////////////////////////////////////////////////////////////

	public static function displayAllLeaderboards(defaultLeaderboard:String){
		#if (gpgnative || gpgrest)
			GooglePlayGames.displayAllScoreboards();
		#elseif ios
			GameCenter.showLeaderboard(defaultLeaderboard);
		#elseif amazon
			GameCircle.displayAllScoreboards(); 
		#end
	}

	public static function displayLeaderboard(leaderboardName:String){
		#if (gpgnative || gpgrest)
			GooglePlayGames.displayScoreboard(GooglePlayGames.getID(leaderboardName));
		#elseif ios
			GameCenter.showLeaderboard(leaderboardName);
		#elseif amazon
			GameCircle.displayScoreboard(leaderboardName); 
		#end
	}

	public static function displayAchievements(){
		#if (gpgnative || gpgrest)
			GooglePlayGames.displayAchievements();
		#elseif ios
			GameCenter.showAchievements();
		#elseif amazon
			GameCircle.displayAchievements();
		#end
	}

	///////////////////////////////////////////////////////////////////////////
	//// CLOUD 
	///////////////////////////////////////////////////////////////////////////

	// DEPRECATED!
	#if gpgnative
	public static function legacyCloudGet(id:Int){
		GooglePlayGames.cloudGet(id);
	}
	#end

	public static function loadSavedGame(name:String){
		#if gpgnative
			GooglePlayGames.loadSavedGame(name);
		#elseif amazon
			GameCircle.cloudGet(name);
			lastOpenedGame = name;
		#end
	}

	public static function discardAndCloseGame(){
		#if gpgnative
			GooglePlayGames.discardAndCloseGame();
		#elseif amazon
			lastOpenedGame=null;
		#end
	}

	public static function commitAndCloseGame(data:String,description:String,resolvingConflict:Bool=false){
		#if gpgnative
			GooglePlayGames.commitAndCloseGame(data,description);
		#elseif amazon
			if(lastOpenedGame==null) return;
			GameCircle.cloudSet(lastOpenedGame,data);
			if(resolvingConflict) GameCircle.markConflictAsResolved(lastOpenedGame);
			lastOpenedGame=null;
		#end
	}

	///////////////////////////////////////////////////////////////////////////
	//// CALLBACKS
	///////////////////////////////////////////////////////////////////////////

	public static function setOnLoadGameCompleteCallback(onLoadGameComplete:String->String->Void){
		#if gpgnative
			GooglePlayGames.onLoadGameComplete=onLoadGameComplete;
		#elseif amazon
			GameCircle.onCloudGetComplete=onLoadGameComplete;
		#end
	}

	public static function setOnLoadGameConflictCallback(onLoadGameConflict:String->String->String->Void){
		#if gpgnative
			GooglePlayGames.onLoadGameConflict=onLoadGameConflict;
		#elseif amazon
			GameCircle.onCloudGetConflict=onLoadGameConflict;
		#end
	}

	// DEPRECATED!
	#if gpgnative
	public static function setOnCloudGetCompleteCallback(onCloudGetComplete:Int->String->Void){
		GooglePlayGames.onCloudGetComplete=onCloudGetComplete;
	}
	public static function setOnCloudGetConflictCallback(onCloudGetConflict:Int->String->String->Void){
		GooglePlayGames.onCloudGetConflict=onCloudGetConflict;
	}
	#end


	///////////////////////////////////////////////////////////////////////////
	//// INIT 
	///////////////////////////////////////////////////////////////////////////

	public static function login(){
		#if (gpgnative || gpgrest)
		GooglePlayGames.login();
		#end
	}

	public static function initGameCenter(){
		#if ios
		GameCenter.authenticate();
		#end
	}

	public static function initGameCircle(){
		#if amazon
		GameCircle.init(true);
		#end
	}

	public static function initGPG(enableCloudStorage:Bool){
		#if gpgnative
		GooglePlayGames.init(enableCloudStorage);
		#end
	}

	public static function initGPGRest(clientId : String, clientSecret : String) {
		#if gpgrest
		GooglePlayGames.init(clientId, clientSecret);
		#end
	}

	public static function loadResourcesFromXML(xml:String){
		#if (gpgnative || gpgrest)
		GooglePlayGames.loadResourcesFromXML(xml);
		#end
	}
}