package com.zyrtec.pianoTuning {
	
	import com.bigspaceship.events.AnimationEvent;
	import com.bigspaceship.utils.Out;
	import com.greensock.easing.*;
	import com.zyrtec.adapters.*;
	import com.zyrtec.interfaces.*;
	import com.zyrtec.pianoTuning.controller.PianoTuningMain;
	import com.zyrtec.pianoTuning.model.PTGameData;
	import com.zyrtec.pianoTuning.model.PTModel;
	import com.zyrtec.pianoTuning.view.screens.PTScreenHighScores;
	
	import flash.display.MovieClip;
	import flash.media.SoundTransform;
	
	import net.ored.util.ORedUtils;
	
	// =================================================
	// ================ @Class
	// =================================================
	public class PianoTuningApp extends MovieClip implements IMiniGame
	{
		private var _model:PTModel;
		private var _gameMain:PianoTuningMain;
		private var _mainScreen:MovieClip;
		
		//sound vars
		private var _muteSoundTransform:SoundTransform = new SoundTransform();
		private var _soundMute:Boolean = false;
		

		// =================================================
		// ================ @Callable ====================
		// =================================================
		public function initMiniGame($completecallback:Function, $leaderboardcallback:Function, $logincallback:Function, $signincallback:Function, $gamedata:Object):void
		{
			Out.status(this, "initMiniGame");
			_model = PTModel.getInstance();
			_model.initialize(this.stage);
			_model.setGameData(new PTGameData($gamedata));
			
			//all shell calls go through the shell adapter via the model.
			_model.shell.initialize($completecallback, $leaderboardcallback, $logincallback, $signincallback); 
			_model.shell.app = this;
			
			// ADD background elements
			_mainScreen = new ScreenMainMC();
			_mainScreen.x = 197;//(940-_mainScreen.width)/2;
			_mainScreen.y = 35;//(630-_mainScreen.height)/2;
			addChild(_mainScreen);
			
			// ADD main game controller
			_gameMain = new PianoTuningMain(); 
			addChild(_gameMain);
			_gameMain.visible = false;
			_gameMain.init();
			
			//PLAY background animation
			_mainScreen.addEventListener(AnimationEvent.COMPLETE, onAnimationComplete, false, 0, true);
			_mainScreen.gotoAndPlay(2);
		}
		
		public function muteGame($b:Boolean):void
		{
			if (!$b) {
				_soundMute=false;
				_muteSoundTransform.volume=1;
				flash.media.SoundMixer.soundTransform=_muteSoundTransform;
			} else {
				_muteSoundTransform.volume=0;
				_soundMute = true;
				flash.media.SoundMixer.soundTransform=_muteSoundTransform;
			}
		}
		
		public function gameQuit():Boolean
		{
			_gameMain.destroy();
			return true;
		}
		
		public function gamePause($b:Boolean):void
		{
			
		}
		
		public function setGameData($o:Object):void{
			_model.setGameData(new PTGameData($o));
			var _go:PTScreenHighScores = _gameMain.gameOverScreen as PTScreenHighScores;
			_go.leaderboard.disableLogInSignUp();
			_gameMain.updateLeaderboard();
		}
		
		public function setLeaderBoard($o:Object):void{
			Out.status(this, "PianoTuningApp setLeaderBoard ");
			_model.leaderboardResults = $o;
		}
		
		public function getScore():Object{ 
			return _model.scoreToSend;
		}
		
		
		// =================================================
		// ================ @Workers
		// =================================================
		
		private function signincallback($o:Object=null):void {};
		
		//private function trackingcallback($o:Object=null):void {};
		
		private function leaderboardcallback($o:Object=null):Array {
			var array:Array = new Array(); //array containing info for each player stored in an object
			return array;
		};
		
		private function completecallback():void {}; //game session has ended
		
		private function logincallback():void {}; //show log in screen
		
		// =================================================
		// ================ @Handlers
		// =================================================
		
		//FUNCTION : ON INITIAL ANIMATION COMPLETE
		private function onAnimationComplete(e:AnimationEvent):void {
			_mainScreen.removeEventListener(AnimationEvent.COMPLETE, onAnimationComplete);
			_gameMain.visible = true;
			PianoTuningMain(_gameMain).frameRate = 31; //independent from movie frame rate
			PianoTuningMain(_gameMain).startTimer(); ///// START GAMING RUNNING HERE !!!! ////
		}
		// =================================================
		// ================ @Constructor
		// =================================================
		public function PianoTuningApp()
		{
			//ORedUtils.turnOutOn();
			Out.info(this, "Welcome to Piano Tuning! like a boss");
			
			/* // SHELL CALLS // */
			//muteGame(false); 
			
			var gd:Object = { //TEST GAME DATA OBJECT
				uid:"-1",
				sid:"-1",
				gid:"-1",
				cdn:"",
				name:"Gina B.",
				isArcadeMode:false,
				numLives:3
			};
			
			//initMiniGame(completecallback, leaderboardcallback, logincallback, signincallback, gd);
		
		}//end constructor
	}//end class
}//end package
