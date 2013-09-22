package com.zyrtec.dogmatch.view.screens.highscores
{
	import com.greensock.*;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	import com.theginbin.ui.RollOverButton;
	import com.theginbin.utils.BasicFrameTimer;
	import com.theginbin.utils.TimeConverter;
	import com.zyrtec.dogmatch.model.DMModel;
	import com.zyrtec.events.ZyrtecGameEvent;
	import com.zyrtec.model.MiniGameModel;
	import com.zyrtec.view.Leaderboard;
	import com.zyrtec.analytics.Tracking;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.Timer;
	import flash.external.ExternalInterface;
	
	public class DMLeaderboard extends Leaderboard
	{
		public function DMLeaderboard(leaderboardClipMC:MovieClip, gameModel:MiniGameModel)
		{
			super(leaderboardClipMC, gameModel);
		}
		
		//FUNCTION : SET THE LEADERBOARD STATIC TEXT
		override public function setStaticText():void {
			if (model.isLoggedIn) {  //gray these out
				leaderboardClip.signupAreaMC.alpha = 0.4;
			}
			
			leaderboardClip.txtLoading.alpha = 1;
			
			//DMModel(model).levelsCompleted;
			
			leaderboardClip.txtTimeComplete.txt.autoSize = "right";
			leaderboardClip.congratulationsMC.visible = true; 
			if (model.displayScore == "00:00:00") {
				leaderboardClip.txtTimeComplete.txt.text = "Incomplete";
			} else {
				leaderboardClip.txtTimeComplete.txt.text = model.displayScore;
			}
			
			//display stars earned 
			leaderboardClip.txtMinutes.txt.autoSize = "left";
			leaderboardClip.txtStars.txt.autoSize = "left";
			
			var minutes:uint = DMModel(model).score/60000;
		
			if(!DMModel(model).levelsCompleted){
				leaderboardClip.txtLivesLeft.txt.text = "NA";
			//	leaderboardClip.congratulationsMC.visible = false; 
				trace(" congrats MC is INvisible ");
				leaderboardClip.txtMinutes.txt.text = "not completing all levels.";
				leaderboardClip.txtStars.txt.text = "0 stars";
				leaderboardClip.star1.gotoAndStop(1);
				leaderboardClip.star2.gotoAndStop(1);
				leaderboardClip.star3.gotoAndStop(1);
			}else{		
				leaderboardClip.txtLivesLeft.txt.text = "- "+ DMModel(model).livesString + " seconds";
				//leaderboardClip.congratulationsMC.visible = true; 
				trace(" congrats MC is visible ");
				
				if (minutes <2) { //3 stars
					leaderboardClip.txtMinutes.txt.text = "finishing in < 2 minutes.";
					leaderboardClip.txtStars.txt.text = "3 stars";
					leaderboardClip.star1.gotoAndStop(2);
					leaderboardClip.star2.gotoAndStop(2);
					leaderboardClip.star3.gotoAndStop(2);
					model.stars = 3;
				} else if (minutes >=2 && minutes < 3){ //2 stars
					leaderboardClip.txtMinutes.txt.text = "finishing in < 3 minutes.";
					leaderboardClip.txtStars.txt.text = "2 stars";
					leaderboardClip.star1.gotoAndStop(2);
					leaderboardClip.star2.gotoAndStop(2);
					model.stars = 2;
				} else if (minutes >=3 && minutes <5){ //1 star
					leaderboardClip.txtMinutes.txt.text = "finishing in < 5 minute.";
					leaderboardClip.txtStars.txt.text = "1 star";
					leaderboardClip.star1.gotoAndStop(2);
					model.stars = 1;
				}
			}
		}
		
		//FUNCTION : SET THE LEADERBOARD DYNAMIC TEXT -- OVERRIDING BECAUSE SCORES ARRAY SHOULD BE ASCENDING AND BACKEND RETURNS DESCENDING
		override public function setLeaderboardText():void {
			//trace("results obj = "+model.leaderboardResults);
			trace("SETTING LEADERBOARD TEXT");
			TweenMax.to(leaderboardClip.txtLoading, 0.4, {alpha:0});
			
			var i:int;
			if (playerHolder.numChildren>0) { //clear out the leaderboard data before this animates in
				var clip:MovieClip;
				for (i = 0; i < playerHolder.numChildren; i++) {
					clip = MovieClip(playerHolder.getChildAt(i));
					clip.visible = false;
					clip = null;
				}
			}
			
			var resultsObj:Object = model.leaderboardResults;
			
			if (!model.isLoggedIn || !resultsObj.hasOwnProperty("TopScore") || resultsObj.TopScore==null || resultsObj.TopScore==undefined) {
				if (model.displayScore == "00:00:00") {
					leaderboardClip.txtYourRank.txtTime.text = "Incomplete"; 
				} else {
					leaderboardClip.txtYourRank.txtTime.text = model.displayScore; 
				}
			} else {
				if (resultsObj.TopScore=="-1") {
					leaderboardClip.txtYourRank.txtTime.text = "Incomplete"; 
				} else {
					leaderboardClip.txtYourRank.txtTime.text = getPlayerScoreDisplay(resultsObj.TopScore); 
				}
			}
			
			/*if (resultsObj.hasOwnProperty("Rank") && resultsObj.Rank!=null && resultsObj.Rank!=undefined) {
			leaderboardClip.txtYourRank.txtRank.text = resultsObj.Rank;
			} else {
			leaderboardClip.txtYourRank.txtRank.text = "";
			}*/
			
			if (resultsObj.hasOwnProperty("SessionName") && resultsObj.SessionName!=null && resultsObj.SessionName!=undefined) {
				leaderboardClip.txtSession.txt.text = resultsObj.SessionName;
			}
			
			//start the session countdown clock
			if (resultsObj.hasOwnProperty("TimeLeft") && resultsObj.TimeLeft!=null && resultsObj.TimeLeft!=undefined) {
				sessionTime = resultsObj.TimeLeft;
				if (sessionTime>1000) { //only use the timer if the time left is greater than 1 second
					if(sessionTimer==null) {
						sessionTimer = new Timer(1000);
					}
					sessionTimer.addEventListener(TimerEvent.TIMER, onSessionTimer);
					sessionTimer.start();
				}
			}
			
			//populate the leaderboard
			var leaderboardPlayer:MovieClip;
			var spacing:uint = 10;
			var rank:String;
			var scoresLength:int;
			if (resultsObj.hasOwnProperty("Scores") && resultsObj.Scores!=null && resultsObj.Scores!=undefined) {
				scoresLength = resultsObj.Scores.length;
				
				for (i=0; i<resultsObj.Scores.length; i++) { //just grab first 5 players
					leaderboardPlayer = new LeaderboardPlayerMC();
					trace("SCORES ARRAY -- looping through array and i == "+i+" and order == "+resultsObj.Scores[(scoresLength-1)-i].order+" and name == "+resultsObj.Scores[(scoresLength-1)-i].name+" and score == "+getPlayerScoreDisplay(resultsObj.Scores[(scoresLength-1)-i].score));
					leaderboardPlayer.txtRank.text = (i+1).toString();//resultsObj.Scores[i].order; //assuming "order" will correspond to the order of the array
					leaderboardPlayer.txtName.text = resultsObj.Scores[(scoresLength-1)-i].name;
					leaderboardPlayer.txtScore.text = getPlayerScoreDisplay(resultsObj.Scores[(scoresLength-1)-i].score);
					
					leaderboardPlayer.y = (leaderboardPlayer.height+spacing)*i;
					
					playerHolder.addChild(leaderboardPlayer);
				}
			}
			
			//fade in
			TweenMax.to(playerHolder, 0.4, {alpha:1, delay:0.4});
			TweenMax.to(leaderboardClip.txtYourRank, 0.4, {alpha:1, delay:0.4});
			TweenMax.delayedCall(0.4, addReloadEvents);
		}
		
		//FUNCTION : ON FACEBOOK SHARE CLICK
		override public function onFacebookShareClick(e:MouseEvent):void{ //share page on facebook
			var title:String ="I just unlocked the Perfect Pairing Badge.";
			var copy:String;
			Tracking.track(Tracking.L2_SHARE_PERFECTPAIRING); //tracking
			
			if((!DMModel(model).levelsCompleted)){
				copy = "I earned "+model.stars+" stars for finishing The Perfect Pairing Game at ZYRTEC%26reg; Parks Unleashed%26trade;. Beat that, bucko!";
			}else{
					copy = "I earned "+model.stars+" stars for finishing The Perfect Pairing Game in a whopping "+model.displayScore+" minutes and unlocked the Match Dogs badge at ZYRTEC%26reg; Parks Unleashed%26trade;. Beat that, bucko!";
			
			}		
			//var copy:String = "I earned "+model.stars+" stars for finishing in "+model.displayScore+" minutes and unlocked the Match Dogs badge at ZYRTEC%26reg; Parks Unleashed%26trade;. Ch-ch-check it out.";
			var url:String = "http://www.facebook.com/sharer.php?s=100&p[title]="+title+"&p[url]="+model.shareURL+"&p[images][0]="+model.badgeURL+"&p[summary]="+copy;
			if (ExternalInterface.available){
				ExternalInterface.call("openPopup", url, "ShareFacebook", Leaderboard.POP_UP_WIDTH, Leaderboard.POP_UP_HEIGHT);
			}else navigateToURL(new URLRequest(url), "_blank");
		}
	}
}