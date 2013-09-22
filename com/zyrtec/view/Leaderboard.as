﻿package com.zyrtec.view{	import com.bigspaceship.utils.Out;	import com.greensock.*;	import com.greensock.TweenMax;	import com.greensock.easing.*;	import com.greensock.plugins.*;	import com.theginbin.ui.RollOverButton;	import com.theginbin.utils.BasicFrameTimer;	import com.theginbin.utils.TimeConverter;	import com.theginbin.utils.ConvertStringUtil;	import com.zyrtec.events.ZyrtecGameEvent;	import com.zyrtec.model.MiniGameModel;		import flash.display.MovieClip;	import flash.display.Sprite;	import flash.events.Event;	import flash.events.EventDispatcher;	import flash.events.IEventDispatcher;	import flash.events.MouseEvent;	import flash.events.TimerEvent;	import flash.external.ExternalInterface;	import flash.net.URLRequest;	import flash.net.navigateToURL;	import flash.utils.Timer;
		public class Leaderboard extends EventDispatcher	{		public static const POP_UP_WIDTH			:Number = 550;		public static const POP_UP_HEIGHT			:Number = 420;				public var model:MiniGameModel;	// Game Model 		public var leaderboardClip:MovieClip; //view		public var playerHolder:Sprite; //container clip for leaderboard player clips		public var sessionTimer:Timer;		public var sessionTime:Number=0;						public function Leaderboard(leaderboardClipMC:MovieClip, gameModel:MiniGameModel)		{			model = gameModel;			leaderboardClip = leaderboardClipMC;						TweenPlugin.activate([VisiblePlugin]);						//facebook invite screen shows on play again --- this may not be for every game			if (leaderboardClip.screenInviteMC!=null) {				leaderboardClip.screenInviteMC.visible = false;				leaderboardClip.overlayMC.visible = false;				leaderboardClip.overlayMC.alpha = 0;				leaderboardClip.screenInviteMC.scaleX = leaderboardClip.screenInviteMC.scaleY = 0;				leaderboardClip.overlayMC.mouseEnabled = false;			}						playerHolder = new Sprite(); 			playerHolder.x = 371;			playerHolder.y = 156;			playerHolder.alpha = 0;						leaderboardClip.addChildAt(playerHolder, leaderboardClip.getChildIndex(leaderboardClip.overlayMC)-1);						leaderboardClip.txtLoading.alpha = 0;			leaderboardClip.txtYourRank.alpha = 0;		}				// =================================================		// ================ @Callable		// =================================================				public function addEvents():void {			leaderboardClip.visible = true;			RollOverButton(leaderboardClip.btnPlayAgain).addEvents();			leaderboardClip.btnPlayAgain.addEventListener(MouseEvent.CLICK, onPlayAgainClick, false, 0, true);						RollOverButton(leaderboardClip.btnFBShare).addEvents();			leaderboardClip.btnFBShare.addEventListener(MouseEvent.CLICK, onFacebookShareClick, false, 0, true);						RollOverButton(leaderboardClip.btnBack).addEvents();			leaderboardClip.btnBack.addEventListener(MouseEvent.CLICK, onBackClick, false, 0, true);						if (!model.isLoggedIn) { 				RollOverButton(leaderboardClip.signupAreaMC.btnSignup).addEvents();				leaderboardClip.signupAreaMC.btnSignup.addEventListener(MouseEvent.CLICK, onSignUpClick, false, 0, true);								RollOverButton(leaderboardClip.signupAreaMC.btnLogin).addEvents();				leaderboardClip.signupAreaMC.btnLogin.addEventListener(MouseEvent.CLICK, onLogInClick, false, 0, true);			}		}				public function removeEvents():void {			if(sessionTimer!=null) {				sessionTimer.removeEventListener(TimerEvent.TIMER, onSessionTimer);				sessionTimer.stop();			}						RollOverButton(leaderboardClip.btnPlayAgain).removeEvents();			leaderboardClip.btnPlayAgain.removeEventListener(MouseEvent.CLICK, onPlayAgainClick);			RollOverButton(leaderboardClip.btnFBShare).removeEvents();			leaderboardClip.btnFBShare.removeEventListener(MouseEvent.CLICK, onFacebookShareClick);						RollOverButton(leaderboardClip.btnBack).removeEvents();			leaderboardClip.btnBack.removeEventListener(MouseEvent.CLICK, onBackClick);						if (RollOverButton(leaderboardClip.btnReload)!=null) {				RollOverButton(leaderboardClip.btnReload).removeEvents();			}			leaderboardClip.btnReload.removeEventListener(MouseEvent.CLICK, onReloadClick);						RollOverButton(leaderboardClip.signupAreaMC.btnSignup).removeEvents();			leaderboardClip.signupAreaMC.btnSignup.removeEventListener(MouseEvent.CLICK, onSignUpClick);						RollOverButton(leaderboardClip.signupAreaMC.btnLogin).removeEvents();			leaderboardClip.signupAreaMC.btnLogin.removeEventListener(MouseEvent.CLICK, onLogInClick);						if (leaderboardClip.screenInviteMC!=null) {				leaderboardClip.screenInviteMC.btnSkip.removeEventListener(MouseEvent.CLICK, onInviteSkipClick);				leaderboardClip.screenInviteMC.btnInvite.removeEventListener(MouseEvent.CLICK, onInviteFriendClick);			}		}				//FUNCTION : SET THE LEADERBOARD STATIC TEXT --- NOTE : THIS WILL BE DIFFERENT ACROSS GAMES -- OVERRIDE THIS!		public function setStaticText():void {			if (model.isLoggedIn) {  //gray these out				leaderboardClip.signupAreaMC.alpha = 0.4;			}						leaderboardClip.txtLoading.alpha = 1;						leaderboardClip.txtTimeComplete.txt.autoSize = "right";			leaderboardClip.txtTimeComplete.txt.text = model.displayScore;						//display stars earned			leaderboardClip.txtMinutes.txt.autoSize = "left";			leaderboardClip.txtStars.txt.autoSize = "left";						//SAMPLE TEXT FOR FILLING IN STARS DATA :::::::			/*var minutes:uint = model.score/60000;			if (minutes < 2) { //3 stars				leaderboardClip.star1.gotoAndStop(2);				leaderboardClip.star2.gotoAndStop(2);				leaderboardClip.star3.gotoAndStop(2);				leaderboardClip.txtMinutes.txt.text = "< 2 minutes.";				leaderboardClip.txtStars.txt.text = "3 stars";				model.stars = 3;			} else if (minutes >= 2 && minutes < 3){ //2 stars				leaderboardClip.star1.gotoAndStop(2);				leaderboardClip.star2.gotoAndStop(2);				leaderboardClip.txtMinutes.txt.text = "< 3 minutes.";				leaderboardClip.txtStars.txt.text = "2 stars";				model.stars = 2;			} else if (minutes >=3){ //1 star				leaderboardClip.star1.gotoAndStop(2);				leaderboardClip.txtMinutes.txt.text = "> 3 minutes.";				leaderboardClip.txtStars.txt.text = "1 star";				model.stars = 1;			}*/		}				//FUNCTION : SET THE LEADERBOARD DYNAMIC TEXT 		public function setLeaderboardText():void {			TweenMax.to(leaderboardClip.txtLoading, 0.4, {alpha:0});						var i:uint;			if (playerHolder.numChildren>0) { //clear out the leaderboard data before this animates in				var clip:MovieClip;				for (i = 0; i < playerHolder.numChildren; i++) {					clip = MovieClip(playerHolder.getChildAt(i));					clip.visible = false;					clip = null;				}			}			var resultsObj:Object = model.leaderboardResults;						if (!model.isLoggedIn || !resultsObj.hasOwnProperty("TopScore") || resultsObj.TopScore==null || resultsObj.TopScore==undefined) {				leaderboardClip.txtYourRank.txtTime.text = model.displayScore; 			} else {				leaderboardClip.txtYourRank.txtTime.text = getPlayerScoreDisplay(resultsObj.TopScore); 			}						/*if (resultsObj.hasOwnProperty("Rank") && resultsObj.Rank!=null && resultsObj.Rank!=undefined) {				leaderboardClip.txtYourRank.txtRank.text = resultsObj.Rank;			} else {				leaderboardClip.txtYourRank.txtRank.text = "";			}*/						if (resultsObj.hasOwnProperty("SessionName") && resultsObj.SessionName!=null && resultsObj.SessionName!=undefined) {				leaderboardClip.txtSession.txt.text = resultsObj.SessionName;			}						//start the session countdown clock			if (resultsObj.hasOwnProperty("TimeLeft") && resultsObj.TimeLeft!=null && resultsObj.TimeLeft!=undefined) {				sessionTime = resultsObj.TimeLeft;								Out.debug(this, "sessionTime: "+ sessionTime);								if (sessionTime>1000) { //only use the timer if the time left is greater than 1 second					Out.info(this, "it thinks sessionTime > 1000 !!!!!");					if(sessionTimer==null) {						sessionTimer = new Timer(1000);					}					sessionTimer.addEventListener(TimerEvent.TIMER, onSessionTimer);					sessionTimer.start();				} else Out.error(this, "it thinks sessionTime < 1000 !!!!!");			}else Out.error(this, "we don't have TimeLeft");						//populate the leaderboard			var leaderboardPlayer:MovieClip;			var spacing:uint = 10;			var rank:String;			if (resultsObj.hasOwnProperty("Scores") && resultsObj.Scores!=null && resultsObj.Scores!=undefined) {				for (i=0; i<resultsObj.Scores.length; i++) { //just grab first 5 players					leaderboardPlayer = new LeaderboardPlayerMC();					Out.status(this, "SCORES ARRAY -- looping through array and i == "+i+" and order == "+resultsObj.Scores[i].order+" and name == "+resultsObj.Scores[i].name+" and score == "+getPlayerScoreDisplay(resultsObj.Scores[i].score));					leaderboardPlayer.txtRank.text = resultsObj.Scores[i].order; //assuming "order" will correspond to the order of the array					leaderboardPlayer.txtName.text = resultsObj.Scores[i].name;					leaderboardPlayer.txtScore.text = getPlayerScoreDisplay(resultsObj.Scores[i].score);										leaderboardPlayer.y = (leaderboardPlayer.height+spacing)*i;										playerHolder.addChild(leaderboardPlayer);				}			}						//fade in			TweenMax.to(playerHolder, 0.4, {alpha:1, delay:0.4});			TweenMax.to(leaderboardClip.txtYourRank, 0.4, {alpha:1, delay:0.4});			TweenMax.delayedCall(0.4, addReloadEvents);								}//end function				//FUNCTION : DISABLE LOG IN AREA -- user has signed up on the leaderboard screen		public function disableLogInSignUp():void{			Out.status(this, "LEADERBOARD : disable log in sign up area - model.isLoggedIn = "+model.isLoggedIn);			if (model.isLoggedIn) {  //gray these out				RollOverButton(leaderboardClip.signupAreaMC.btnSignup).removeEvents();				leaderboardClip.signupAreaMC.btnSignup.removeEventListener(MouseEvent.CLICK, onSignUpClick);				RollOverButton(leaderboardClip.signupAreaMC.btnLogin).removeEvents();				leaderboardClip.signupAreaMC.btnLogin.removeEventListener(MouseEvent.CLICK, onLogInClick);				leaderboardClip.signupAreaMC.alpha = 0.4;			}		}		// =================================================		// ================ @Workers		// =================================================		public function addReloadEvents():void {			RollOverButton(leaderboardClip.btnReload).addEvents();			leaderboardClip.btnReload.addEventListener(MouseEvent.CLICK, onReloadClick, false, 0, true);		}				public function addInviteEvents():void {			if (leaderboardClip.screenInviteMC!=null) {				RollOverButton(leaderboardClip.screenInviteMC.btnInvite).addEvents();				RollOverButton(leaderboardClip.screenInviteMC.btnSkip).addEvents();				leaderboardClip.screenInviteMC.btnInvite.addEventListener(MouseEvent.CLICK, onInviteFriendClick);				leaderboardClip.screenInviteMC.btnSkip.addEventListener(MouseEvent.CLICK, onInviteSkipClick);			}		}				public function getPlayerScoreDisplay(numString:String):String {			var displayScore:String="";			if (model.displayScore.indexOf(":")>0) { //if contains ":", display the score like a clock				var timeConverter:TimeConverter = new TimeConverter();				displayScore = timeConverter.convertTime(Number(numString), "milliseconds");			} else {				if (numString.length>3) { //add commas to the score if needed					displayScore = ConvertStringUtil.addNumberCommas(numString);				} else {					displayScore = numString;				}			}						return displayScore;		}				// =================================================		// ================ @Handlers		// =================================================				public function onSessionTimer(e:TimerEvent):void {			//Out.debug(this, "tick: " +sessionTime);			var timeString:String;			var numArray:Array;			var timeConverter:TimeConverter;			if (sessionTime>1000) {				timeConverter = new TimeConverter();				sessionTime-=1000;				timeString = timeConverter.convertMillisecondsToHours(sessionTime);				numArray = timeString.split( ":" );				leaderboardClip.txtTimeRemaining.txtHour.text = numArray[0];				leaderboardClip.txtTimeRemaining.txtMin.text = numArray[1];				leaderboardClip.txtTimeRemaining.txtSec.text = numArray[2];				//leaderboardClip.txtTimeRemaining.txtMs.text = numArray[3];			} else {				if (sessionTimer!=null){					sessionTimer.removeEventListener(TimerEvent.TIMER, onSessionTimer);					sessionTimer.stop();				}				leaderboardClip.txtTimeRemaining.txtHour.text = "00";				leaderboardClip.txtTimeRemaining.txtMin.text = "00";				leaderboardClip.txtTimeRemaining.txtSec.text = "00";				//leaderboardClip.txtTimeRemaining.txtMs.text = "00";			}		}				public function onPlayAgainClick(e:MouseEvent):void{ //restart the game, go to next system state			RollOverButton(leaderboardClip.btnPlayAgain).removeEvents();			leaderboardClip.btnPlayAgain.removeEventListener(MouseEvent.CLICK, onPlayAgainClick);			dispatchEvent(new ZyrtecGameEvent(ZyrtecGameEvent.PLAY_AGAIN));		}				public function onInviteSkipClick(e:MouseEvent=null):void{			if (leaderboardClip.screenInviteMC!=null) {				RollOverButton(leaderboardClip.screenInviteMC.btnInvite).removeEvents();				RollOverButton(leaderboardClip.screenInviteMC.btnSkip).removeEvents();				leaderboardClip.screenInviteMC.btnSkip.removeEventListener(MouseEvent.CLICK, onInviteSkipClick);				TweenMax.to(leaderboardClip.screenInviteMC, 0.2, {scaleX:0, scaleY:0, ease:Back.easeIn, visible:false});				TweenMax.to(leaderboardClip.overlayMC, 0.2, {alpha:0, visible:false});			}			dispatchEvent(new ZyrtecGameEvent(ZyrtecGameEvent.PLAY_AGAIN));		}				//OVERRIDE THIS TO USE FRIEND BONUS IF NEEDED		public function onInviteFriendClick(e:MouseEvent):void{ //open invite pop up			/*if (leaderboardClip.screenInviteMC!=null) {				RollOverButton(leaderboardClip.screenInviteMC.btnInvite).removeEvents();				RollOverButton(leaderboardClip.screenInviteMC.btnSkip).removeEvents();				leaderboardClip.screenInviteMC.btnInvite.removeEventListener(MouseEvent.CLICK, onInviteFriendClick);				TweenMax.to(leaderboardClip.screenInviteMC, 0.2, {scaleX:0, scaleY:0, ease:Back.easeIn, visible:false});				TweenMax.to(leaderboardClip.overlayMC, 0.2, {alpha:0, visible:false});				model.hasFriendBonus = true; //this would be confirmed after the facebook invite javascript call, but putting here for now			}*/			dispatchEvent(new ZyrtecGameEvent(ZyrtecGameEvent.PLAY_AGAIN));///PLACEHOLDER so game restarts no matter what		}				public function onBackClick(e:MouseEvent):void{ //tell the shell to kill the game			removeEvents();			model.shell.completecallback();		}				//OVERRIDE THIS TO DISPLAY GAME SPECIFIC MESSAGING !!!!!!!		public function onFacebookShareClick(e:MouseEvent):void{ //share page on facebook			var title:String ="Come find me in the park!";			var copy:String = "I earned "+model.stars+" stars for finishing in "+model.displayScore+" minutes and unlocked the Heavy Hitter badge at ZYRTEC%26reg; Parks Unleashed%26trade;. Ch-ch-check it out.";			var url:String = "http://www.facebook.com/sharer.php?s=100&p[title]="+title+"&p[url]="+model.shareURL+"&p[images][0]="+model.badgeURL+"&p[summary]="+copy;			if (ExternalInterface.available){				ExternalInterface.call("openPopup", url, "Share on Facebook", POP_UP_WIDTH, POP_UP_HEIGHT);			}else navigateToURL(new URLRequest(url), "_blank");		}				public function onLogInClick(e:MouseEvent):void{ //tell shell to log in			model.shell.logincallback();			/*Out.status(this, "is model logged in = "+model.isLoggedIn);			model.uid = "1";			Out.status(this, "is model logged in now = "+model.isLoggedIn);			disableLogInSignUp();*/		}				public function onSignUpClick(e:MouseEvent):void{ //tell shell to sign up			model.shell.signincallback();		}				public function onReloadClick(e:MouseEvent):void{ //tell shell to sign up			//RollOverButton(leaderboardClip.btnReload).removeEvents();			Out.status(this, "reloading clicked");			leaderboardClip.btnReload.removeEventListener(MouseEvent.CLICK, onReloadClick);			model.isRefreshScore = true;			model.addEventListener(ZyrtecGameEvent.ON_LEADERBOARD_RESULT, _onLeaderboardResults);			model.shell.leaderboardcallback(model.dataToSend);						//FOR TESTING ONLY:			//model.leaderboardResults = model.shell.leaderboardcallback(model.dataToSend);		}				//FUNCTION : ON LEADERBOARD RESULTS IN		private function _onLeaderboardResults($e:ZyrtecGameEvent):void{			Out.status(this, "leaderboard results in after reloading click");			model.removeEventListener(ZyrtecGameEvent.ON_LEADERBOARD_RESULT, _onLeaderboardResults);			setLeaderboardText();		}				// =================================================		// ================ @Getters / Setters		// =================================================			}}