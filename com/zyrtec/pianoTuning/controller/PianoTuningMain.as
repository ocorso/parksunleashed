package com.zyrtec.pianoTuning.controller
{
	import com.bigspaceship.events.AnimationEvent;
	import com.bigspaceship.utils.Out;
	import com.g2.gaming.framework.*;
	import com.g2.gaming.framework.events.ButtonIdEvent;
	import com.g2.gaming.framework.events.LevelScreenUpdateEvent;
	import com.g2.gaming.framework.events.ScoreBoardUpdateEvent;
	import com.g2.gaming.framework.events.SoundEvent;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	import com.zyrtec.events.ZyrtecGameEvent;
	import com.zyrtec.interfaces.ILeaderboard;
	import com.zyrtec.interfaces.IScreen;
	import com.zyrtec.pianoTuning.game.PianoTuningGame;
	import com.zyrtec.pianoTuning.model.PTModel;
	import com.zyrtec.pianoTuning.model.SoundData;
	import com.zyrtec.pianoTuning.view.scoring.LifeMeterElement;
	import com.zyrtec.pianoTuning.view.scoring.PTScoreboard;
	import com.zyrtec.pianoTuning.view.screens.*;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.utils.getDefinitionByName;

	// =================================================
	// ================ @Class
	// =================================================
	public class PianoTuningMain extends GameFramework
	{
		//custom display constants on scoreboard (put in model)
		public static const TIME:String = "time";						//	timer count
		public static const TUNES_CORRECT:String = "tunesCorrect";	//	num pairs remaining		public static const LIVES:String = "lives";		
		public static const PLAYER_TO_BEAT : String = "PLAYER_TO_BEAT";
		public static const SCORE_TO_BEAT : String = "SCORE_TO_BEAT";
		//	num pairs remaining
		
		private var _model:PTModel; //model
		private var _gameWidth:uint=940;
		private var _gameHeight:uint=600;
		
		private var _gameBG:MovieClip;
		private var _gameShadow:MovieClip;
		private var _endAnimation:MovieClip; //game over animation if needed'
		private var _gameOverMessage:PTGameOverMessage;
		
		// =================================================
		// ================ @Constructor
		// =================================================
		public function PianoTuningMain()
		{	
			Out.info(this, "constructor");
			TweenPlugin.activate([GlowFilterPlugin, VisiblePlugin]);
			_model = PTModel.getInstance();
		}
		
		// =================================================
		// ================ @Callable
		// =================================================
		public function updateLeaderboard():void{
			Out.status(this, "updateLeaderboard");
			_model.addEventListener(ZyrtecGameEvent.ON_LEADERBOARD_RESULT, _onLeaderboardResults);
			_model.shell.leaderboardcallback(_model.dataToSend);
		}
		///FUNCTION : INIT
		override public function init():void {
			if (game == null) {
				_gameBG = new GameBkg();
				_gameBG.x = (940 - _gameBG.width) / 2; //219;
				_gameBG.y = (600 - _gameBG.height) / 2; //-500;//-_gameBG.height;
				_gameBG.mouseEnabled = false;
				addChild(_gameBG);
				
				_gameShadow = new GameShadow();
				_gameShadow.x = 203;
				_gameShadow.y = 530;
				_gameShadow.alpha = 0;
				addChild(_gameShadow);
				
				game = new PianoTuningGame(_gameWidth, _gameHeight);
				game.x = _gameBG.x;				game.y = _gameBG.y;
				addChild(game);
			}
			
			//set up scoreboard
			if (scoreBoard == null) {
				scoreBoard = new ScoreboardMC();
				scoreBoard.x = _gameBG.x + _gameBG.width + 5;
				scoreBoard.y = _gameBG.y - 20; //-scoreBoard.height;//35;
				scoreBoard.mouseChildren = false;
				scoreBoard.mouseEnabled = false;
				//register the "time" element and clock movieclip in the scoreboard clip which will be updated:
				PTScoreboard(scoreBoard).createTextElement(PianoTuningMain.TUNES_CORRECT, PTScoreboard(scoreBoard).clock);
				var lifeMeterElement:LifeMeterElement = new LifeMeterElement();
				lifeMeterElement.y = 132;
				scoreBoard.addChild(lifeMeterElement);
				PTScoreboard(scoreBoard).createTextElement(PianoTuningMain.LIVES, lifeMeterElement);				PTScoreboard(scoreBoard).createTextElement(PianoTuningMain.PLAYER_TO_BEAT, PTScoreboard(scoreBoard).playerToBeat);				PTScoreboard(scoreBoard).createTextElement(PianoTuningMain.SCORE_TO_BEAT, PTScoreboard(scoreBoard).scoreToBeat);
				addChild(scoreBoard);
			}
			
/* 			//instructions screen 
         	if (instructionsScreen==null) {
         		instructionsScreen = new ScreenInstructionsMC();
				instructionsScreen.id = FrameWorkStates.STATE_SYSTEM_INSTRUCTIONS;
				instructionsScreen.x = 204;	
				instructionsScreen.y = -instructionsScreen.height;//54;	
         		addChild(instructionsScreen); 
         		instructionsScreen.visible = false;
         	}*/
                  	
          	///new level screen
        	if (levelInScreen == null) {
         		levelInScreen 			= new ScreenLevelInMC();
         		levelInScreen.id 		= FrameWorkStates.STATE_SYSTEM_LEVEL_IN;
				levelInScreen.x 		= 450;//(_gameWidth-levelInScreen.width)/2;
				levelInScreen.y 		= 180;// (_gameHeight-levelInScreen.height)/2;
         		addChild(levelInScreen); 
         		levelInScreen.visible 	= false;
         	}
         	
         	//game over screen //high scoreboard displayed
 			if (gameOverScreen==null) {
				gameOverScreen 			= new PTScreenHighScores();
				gameOverScreen.id 		= FrameWorkStates.STATE_SYSTEM_GAME_OVER;
				gameOverScreen.x 		= (_gameWidth-gameOverScreen.width)/2;
				gameOverScreen.y 		= -gameOverScreen.height;
				gameOverScreen.stop();
         		addChild(gameOverScreen);
         		gameOverScreen.visible 	= false; 
    		}
			
    		if(_gameOverMessage==null){
				_gameOverMessage 			= new PTGameOverMessage(new PTUserFeedback());
				_gameOverMessage.view.x		= _gameWidth/2;
				_gameOverMessage.view.y		= 205;
				addChild(_gameOverMessage.view);
			}
			
         	//pause screen
         	if (pauseScreen==null) {
         		pauseScreen 			= new ScreenPauseMC();
         		pauseScreen.id 			= FrameWorkStates.STATE_SYSTEM_PAUSE;
         		pauseScreen.x 			= 492;
         		pauseScreen.y 			= 268;
				pauseScreen.scaleX 		= pauseScreen.scaleY = 0;
         		addChild(pauseScreen);
         		pauseScreen.visible 	= false;
         	}
 
         	//Set standard wait time between levels 
         	waitTime = 30;//= 1 second
 			
			//CREATE SOUND MANAGER //////////////////////
 			soundManager = new SoundManager();
			//register external sounds:
			var SoundClass:Class;
			for (var s:int = 4; s < 11; s++) {
				SoundClass = getDefinitionByName("Note" + s) as Class;
				soundManager.addSound("note" + s, Sound(new SoundClass()));
			}
			soundManager.addSound(SoundData.SOUND_CORRECT, new SoundCorrect());
			soundManager.addSound(SoundData.SOUND_WRONG, new SoundWrong());

        	//create timer and run it one time 
        	frameRate = 31; 
			switchSystemState(FrameWorkStates.STATE_SYSTEM_NEW_GAME);
		}
		
		//FUNCTION : ON SHOW SYSTEM INSTRUCTIONS
		override public function systemInstructions():void
		{
/*			trace("system instructions");
			instructionsScreen.visible = true;
			instructionsScreen.addEventListener(ButtonIdEvent.BUTTON_ID, okButtonClickListener, false, 0, true);
			
			soundManager.playSound(SoundData.SOUND_AMBIENT, true,1000,0,0.4);
			
			ScreenInstructions(instructionsScreen).showQuiz();
			
			///ANIMATE INSTRUCTIONS IN NOW //if showing quiz --- call addEvents after animation is done, otherwise do nothing
			TweenMax.to(instructionsScreen, 0.6, {y:54, delay:0.2, ease:Back.easeOut, onComplete:function enableQuizEvents():void { if (_model.showQuiz) {ScreenInstructions(instructionsScreen).addEvents();}}});
			_gameShadow.width = instructionsScreen.width;
			_gameShadow.x = instructionsScreen.x;
			TweenMax.to(_gameShadow, 0.6, {alpha:1});
			
			switchSystemState(FrameWorkStates.STATE_SYSTEM_WAIT_FOR_CLOSE);
			nextSystemState = FrameWorkStates.STATE_SYSTEM_NEW_GAME;
			*/
		}
		
		//FUNCTION : ON GAME START
		override public function systemNewGame():void { 
			
			Out.info(this, "system new game");
         	game.addEventListener(ScoreBoardUpdateEvent.UPDATE_TEXT,scoreBoardUpdateListener, false, 0, true); 
         	game.addEventListener(SoundEvent.PLAY_SOUND, soundEventListener,false, 0, true);
         	game.addEventListener(SoundEvent.STOP_SOUND, soundEventListener,false, 0, true);
         	game.addEventListener(Game.GAME_OVER, gameOverListener, false, 0, true);
         	game.addEventListener(Game.NEW_LEVEL, newLevelListener, false, 0, true);
         	game.addEventListener(Game.PAUSE, pauseListener, false, 0, true);
         	game.newGame();
			
			TweenMax.to(_gameBG, 0.6, {y:60, ease:Back.easeOut});
			TweenMax.to(_gameShadow, 0.6, {alpha:1, overwrite:false, onStart:function changeShadow():void{_gameShadow.width = _gameBG.width; _gameShadow.x = _gameBG.x;}});
			TweenMax.to(scoreBoard, 0.4, {y:65, delay:0.4, ease:Back.easeOut, onComplete:PianoTuningGame(game).animateIn});
			
			switchSystemState(FrameWorkStates.STATE_SYSTEM_WAIT);
      	
		}  
		
		//FUNCTION : ON LEVEL IN ("3...2...1...GO!")
		override public function systemLevelIn():void {
			Out.status(this, "system level in screen");
			levelInScreen.visible = true;
			levelInScreen.alpha = 1;
			levelInScreen.addEventListener(ButtonIdEvent.BUTTON_ID,okButtonClickListener); 
			ScreenLevelIn(levelInScreen).startAnimation();         	         
			switchSystemState(FrameWorkStates.STATE_SYSTEM_WAIT_FOR_CLOSE); //waits for animation done 
			nextSystemState = FrameWorkStates.STATE_SYSTEM_GAME_PLAY; 
		}
		
		//FUNCTION : ON GAME OVER - SHOW HIGH SCORES / REPLAY, etc
		override public function systemGameOver():void
		{
			gameOverScreen.addEventListener(ButtonIdEvent.BUTTON_ID, okButtonClickListener); 
      		gameOverScreen.visible = true;
			
			//animate game Out
			TweenMax.to(_gameBG, 0.4, {y:-500, ease:Back.easeIn});
			TweenMax.to(_gameShadow, 0.3, {alpha:0, ease:Back.easeIn});
			TweenMax.to(scoreBoard, 0.3, {y:-500, ease:Back.easeIn});
			
			ILeaderboard(gameOverScreen).setStaticText(); 
			
			_model.addEventListener(ZyrtecGameEvent.ON_LEADERBOARD_RESULT, _onLeaderboardResults);
			_model.shell.leaderboardcallback(_model.dataToSend);
			//			_model.addEventListener(ZyrtecGameEvent.ON_LEADERBOARD_RESULT, PianoTuningGame(game).updateToBeat);
			//			_model.shell.leaderboardcallback(_model.dataToSend);
			//			_model.leaderboardResults = _model.shell.leaderboardcallback(_model.dataToSend);
			
			var yOff:Number = (_gameHeight-gameOverScreen.height)/2;
			TweenMax.to(gameOverScreen, .5, {y:yOff, delay:1, ease:Back.easeOut, onComplete:ILeaderboard(gameOverScreen).addEvents});
			TweenMax.to(_gameShadow, .5, {alpha:1, delay:0.5, onStart:function changeShadow():void{_gameShadow.width = gameOverScreen.width; _gameShadow.x = gameOverScreen.x;}});
			
			switchSystemState(FrameWorkStates.STATE_SYSTEM_WAIT_FOR_CLOSE);
			nextSystemState = FrameWorkStates.STATE_SYSTEM_NEW_GAME; //STATE_SYSTEM_INSTRUCTIONS - skip instructions
		}

		//FUNCTION : HANDLE GAME OVER
		override public function gameOverListener(e:Event):void
		{
       		game.removeEventListener(ScoreBoardUpdateEvent.UPDATE_TEXT,scoreBoardUpdateListener); 
        	game.removeEventListener(LevelScreenUpdateEvent.UPDATE_TEXT, levelScreenUpdateListener);
         	game.removeEventListener(SoundEvent.PLAY_SOUND, soundEventListener); 
         	game.removeEventListener(SoundEvent.STOP_SOUND, soundEventListener); 
         	game.removeEventListener(Game.GAME_OVER, gameOverListener); 
         	game.removeEventListener(Game.NEW_LEVEL, newLevelListener); 
         	game.removeEventListener(Game.PAUSE, pauseListener); 
			
			PianoTuningGame(game).hideElements();
			_gameOverMessage.showGameOver();
			_gameOverMessage.addEventListener(AnimationEvent.OUT, _sss);
			switchSystemState(FrameWorkStates.STATE_SYSTEM_WAIT); 
     	}
		
		protected function _sss(event:Event):void
		{
			_gameOverMessage.removeEventListener(AnimationEvent.OUT, _sss);			
         	switchSystemState(FrameWorkStates.STATE_SYSTEM_GAME_OVER); 
		}
		
      	//FUNCTIO : ON SYSTEM PAUSE
      	override public function systemPause():void
		{
      		trace(" SYSTEM PAUSING");
      		paused = true;
         	pauseScreen.visible = true;
          	TweenMax.to(pauseScreen, 0.5, {scaleX:1, scaleY:1, ease:Back.easeOut, onComplete:function onPauseOut():void {ScreenPauseHelp(pauseScreen).addEvents(); pauseScreen.addEventListener(ButtonIdEvent.BUTTON_ID, okButtonClickListener, false, 0, true);}});         	         
         	switchSystemState(FrameWorkStates.STATE_SYSTEM_WAIT_FOR_CLOSE); 
         	nextSystemState = FrameWorkStates.STATE_SYSTEM_GAME_PLAY;
		}
      	
      	//FUNCTION : VIEW HIGH SCORES (FROM HOME SCREEN, CODE CLICK, OR GAME COMPLETION)
      	public function showHighScores(e:Event=null):void {
      		gameOverScreen.visible = true;
      		//(gameOverScreen).showHighScores();
      		//TweenMax.to(gameOverScreen, 0.6, {y:(496-gameOverScreen.height+20)/2, ease:Back.easeOut, onComplete:function onGameOverOut():void { gameOverScreen.addEventListener("BACK_CLICKED", onBackFromHighScores, false, 0, true);}});
      	}
      	
      	//FUNCTION : DESTROY -- KILL ALL LISTENERS IN THE GAME FROM THE SHELL
		public function destroy():void {
			gameTimer.removeEventListener(TimerEvent.TIMER, runGame);
			gameTimer.stop();
			PianoTuningGame(game).destroy();
			
			// STOP ALL SOUNDS !!
		
			pauseScreen.removeEventListener(ButtonIdEvent.BUTTON_ID,okButtonClickListener);
			game.removeEventListener(ScoreBoardUpdateEvent.UPDATE_TEXT,scoreBoardUpdateListener); 
         	game.removeEventListener(LevelScreenUpdateEvent.UPDATE_TEXT, levelScreenUpdateListener);
         	game.removeEventListener(SoundEvent.PLAY_SOUND, soundEventListener);
         	game.removeEventListener(SoundEvent.STOP_SOUND, soundEventListener); 
         	game.removeEventListener(Game.GAME_OVER, gameOverListener);
         	game.removeEventListener(Game.NEW_LEVEL, newLevelListener);
         	game.removeEventListener(Game.PAUSE, pauseListener);
         	removeEventListener(EVENT_WAIT_COMPLETE, waitCompleteListener);
         	(gameOverScreen as PTScreenHighScores).removeEvents();
         	gameOverScreen.removeEventListener(ButtonIdEvent.BUTTON_ID, okButtonClickListener);
      
         	ScreenPauseHelp(pauseScreen).removeEvents();
      		pauseScreen.removeEventListener(ButtonIdEvent.BUTTON_ID, okButtonClickListener);
		}
		
		// =================================================
		// ================ @Handlers
		// =================================================
		
		//FUNCTION : PLAY BUTTONS FROM VARIOUS SCREENS - HANDLE ANIMATION OF DIFFERENT SCREENS
		override public function okButtonClickListener(e:ButtonIdEvent):void {
			switch(e.id) {
				case FrameWorkStates.STATE_SYSTEM_TITLE: //we're not using this
					//removeChild(titleScreen); 
					//titleScreen.removeEventListener(ButtonIdEvent.BUTTON_ID,okButtonClickListener); 
					//switchSystemState(nextSystemState);
					break; 
				
				case FrameWorkStates.STATE_SYSTEM_GAME_OVER: 
					gameOverScreen.removeEventListener(ButtonIdEvent.BUTTON_ID,okButtonClickListener);  
					(gameOverScreen as PTScreenHighScores).removeEvents();
					TweenMax.to(gameOverScreen, 0.6, {y:-gameOverScreen.height, ease:Back.easeIn, visible:false, onComplete:switchSystemState, onCompleteParams:[nextSystemState]});               
					TweenMax.to(_gameShadow, 0.6, {alpha:0, delay:0.2});
					break; 
				
				case FrameWorkStates.STATE_SYSTEM_PAUSE: 
					paused = false;
					pauseScreen.removeEventListener(ButtonIdEvent.BUTTON_ID,okButtonClickListener);
					ScreenPauseHelp(pauseScreen).removeEvents();
					TweenMax.to(pauseScreen, 0.6, {scaleX:0, scaleY:0, ease:Back.easeIn, visible:false, onComplete:function onResume():void {game.resumeGame(); switchSystemState(nextSystemState);}});             
					break; 
				
				case FrameWorkStates.STATE_SYSTEM_LEVEL_IN: 
					levelInScreen.removeEventListener(ButtonIdEvent.BUTTON_ID,okButtonClickListener); 
//					TweenMax.to(levelInScreen, 0.1, {alpha:0, visible:false, onComplete:function startGameEvents():void {PianoTuningGame(game).addEvents(); switchSystemState(nextSystemState);}});             					TweenMax.to(levelInScreen, 0.1, {alpha:0, visible:false, onComplete:function startGameEvents():void {PianoTuningGame(game).kickOff(); switchSystemState(nextSystemState);}});             
					break; 
			}
		}
		
		//FUNCTION : ON PAUSE CLICKED
		private function onPauseClicked(e:Event):void { //need to prevent the end level screen from overlapping
			PianoTuningGame(game).removeEvents();
			switchSystemState(FrameWorkStates.STATE_SYSTEM_PAUSE); 
		}
		
		//FUNCTION : VIEW SCORES
		private function viewScoresListener(e:Event):void {
			
		}
		
		//FUNCTION : SCOREBOARD UPDATE 
		override public function scoreBoardUpdateListener(e:ScoreBoardUpdateEvent):void {
			scoreBoard.update(e.element, e.value);
//			if(e.element=="pairsRemaining" && e.value!="0/24") {//+(PTModel.TOTAL_TILES/2).toString())){
//				TweenMax.to(ScoreboardPianoTuning(scoreBoard).bg.glowy, 0.2, {glowFilter:{color:0xFF8201, alpha:1, blurX:15, blurY:15, strength:4}, yoyo:true, repeat:5});
//				scoreBoard.gotoAndPlay("SHAKE");
//			}
		}
		
		//FUNCTION : ON LEADERBOARD RESULTS IN
		private function _onLeaderboardResults($e:ZyrtecGameEvent):void{
			Out.warning(this, "--> _onLeaderboardResults");
			_model.removeEventListener(ZyrtecGameEvent.ON_LEADERBOARD_RESULT, _onLeaderboardResults);
			ILeaderboard(gameOverScreen).updateLeaderboard();
			
		}
		
	}
}