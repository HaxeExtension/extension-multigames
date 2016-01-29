package extension.multigames;

#if (gpgnative || gpgrest)
import extension.gpg.GooglePlayGames;
#end

#if ios
import extension.gamecenter.GameCenter;
import extension.gamecenter.GameCenterEvent;
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

	public static function getPlayerScore(leaderboardName:String):Bool {
		#if (gpgnative || gpgrest)
			return (GooglePlayGames.getPlayerScore(GooglePlayGames.getID(leaderboardName)));
		#elseif amazon
			return (GameCircle.getPlayerScore(leaderboardName));
		#elseif ios
			GameCenter.getPlayerScore(leaderboardName);
			return true;
		#else
			return false;
		#end
	}

	///////////////////////////////////////////////////////////////////////////
	//// ACHIEVEMENTS 
	///////////////////////////////////////////////////////////////////////////

	private static var totalStepsHash:Map<String, Int> = new Map<String, Int>();
	private static var currentStepsHash:Map<String, Int> = new Map<String, Int>();

	public static function setAchievementTotalSteps(achievementName:String, totalSteps:Int):Void {
		totalStepsHash.set(achievementName, totalSteps);
		currentStepsHash.set(achievementName, 0);
	}

	public static function setProgress(achievementName:String, steps:Int):Bool {
		#if (gpgnative || gpgrest)
			return (GooglePlayGames.setSteps(GooglePlayGames.getID(achievementName), steps));
		#elseif amazon
			if (currentStepsHash.get(achievementName) < steps) currentStepsHash.set(achievementName, steps);
			return (GameCircle.setProgress(achievementName, (100.0 * steps) / totalStepsHash.get(achievementName)));
		#elseif ios
			if (currentStepsHash.get(achievementName) < steps) currentStepsHash.set(achievementName, steps);
			GameCenter.reportAchievement(achievementName, (100.0 * steps) / totalStepsHash.get(achievementName));
			return true;
		#else
			return false;
		#end
	}

	public static function increment(achievementName:String, steps:Int):Bool {
		#if (gpgnative || gpgrest)
			return (GooglePlayGames.increment(GooglePlayGames.getID(achievementName), steps));
		#elseif (amazon || ios)
			var newCantSteps = steps + currentStepsHash.get(achievementName);
			setProgress(achievementName, newCantSteps);
			return true;
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
			return GameCircle.setProgress(achievementName, 100);			
		#else
			return false;
		#end
	}

	public static function getAchievementStatus(achievementName:String):Bool {
		#if (gpgnative || gpgrest)
			return (GooglePlayGames.getAchievementStatus(GooglePlayGames.getID(achievementName)));
		#elseif amazon
			return (GameCircle.getAchievementStatus(achievementName));
		#elseif ios
			GameCenter.getAchievementStatus(achievementName);
			return true;
		#else
			return false;
		#end
	}

	public static function getAchievementCurrentSteps(achievementName:String):Bool {
		#if (gpgnative || gpgrest)
			return (GooglePlayGames.getCurrentAchievementSteps(GooglePlayGames.getID(achievementName)));
		#elseif amazon
			return (GameCircle.getAchievementProgress(achievementName));
		#elseif ios
			GameCenter.getAchievementProgress(achievementName);
			return true;
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

	public static function setOnGetAchievementStatus(onGetPlayerAchievementStatus:String->Int->Void) {
		#if (gpgnative || gpgrest)
			GooglePlayGames.onGetPlayerAchievementStatus = onGetPlayerAchievementStatus;
		#elseif amazon
			GameCircle.onGetPlayerAchievementStatus = onGetPlayerAchievementStatus;
		#elseif ios
			var onGetAchStatus:Dynamic -> Void = function(e:Dynamic) {
				if (onGetPlayerAchievementStatus != null) onGetPlayerAchievementStatus(e.data1, Std.parseInt(e.data2));
			}
			GameCenter.addEventListener(GameCenterEvent.ON_GET_ACHIEVEMENT_STATUS_SUCESS, onGetAchStatus);
		#end
	}
	
	public static function setOnGetAchievementCurrentSteps(onGetPlayerCurrentSteps:String->Int->Void) {
		#if amazon
			var onGetPlayerCurrentStepsFloat:String -> Float -> Void = function(achievementName:String, percent:Float){
				var currentSteps = Math.round((percent * totalStepsHash.get(achievementName)) / 100);
				onGetPlayerCurrentSteps(achievementName, currentSteps);
			}
			GameCircle.onGetPlayerCurrentProgress = onGetPlayerCurrentStepsFloat;
		#elseif (gpgnative || gpgrest)
			GooglePlayGames.onGetPlayerCurrentSteps = onGetPlayerCurrentSteps;
		#elseif ios
			var onGetAchSteps:Dynamic -> Void = function(e:Dynamic) {
				if (onGetPlayerCurrentSteps != null) {
					var currentPercent = Std.parseFloat(e.data2);
					var currentSteps = Math.round((currentPercent * totalStepsHash.get(e.data1)) / 100);
					onGetPlayerCurrentSteps(e.data1, currentSteps);
				}
			}
			GameCenter.addEventListener(GameCenterEvent.ON_GET_ACHIEVEMENT_PROGRESS_SUCESS, onGetAchSteps);
		#end
	}

	public static function setOnGetPlayerScore(onGetPlayerScore:String->Int->Void) {
		#if (gpgnative || gpgrest)
			GooglePlayGames.onGetPlayerScore = onGetPlayerScore;
		#elseif amazon
			GameCircle.onGetPlayerScore = onGetPlayerScore;
		#elseif ios
			var onGetScore:Dynamic -> Void = function(e:Dynamic) {
				if (onGetPlayerScore != null) onGetPlayerScore(e.data1, Std.parseInt(e.data2));
			}
			GameCenter.addEventListener(GameCenterEvent.ON_GET_PLAYER_SCORE_SUCESS, onGetScore);
		#end
	}

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