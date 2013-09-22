﻿package com.zyrtec.cardqueen.controller{	import com.g2.gaming.framework.*;	import com.g2.gaming.framework.events.ButtonIdEvent;	import com.g2.gaming.framework.events.LevelScreenUpdateEvent;	import com.g2.gaming.framework.events.ScoreBoardUpdateEvent;	import com.g2.gaming.framework.events.SoundEvent;	import com.greensock.TweenMax;	import com.greensock.easing.*;	import com.greensock.plugins.*;	import com.zyrtec.cardqueen.events.CardQueenEvent;	import com.zyrtec.cardqueen.game.CardQueenGame;	import com.zyrtec.cardqueen.model.CQModel;	import com.zyrtec.cardqueen.model.SoundData;	import com.zyrtec.cardqueen.view.scoring.ScoreboardCardQueen;	import com.zyrtec.cardqueen.view.screens.*;	import com.zyrtec.events.ZyrtecGameEvent;		import flash.display.MovieClip;	import flash.events.Event;	import flash.events.TimerEvent;	import flash.media.Sound;	import flash.net.URLRequest;		import com.zyrtec.analytics.Tracking;	// =================================================	// ================ @Class	// =================================================	public class CardQueenMain extends GameFramework	{			private var _model:CQModel; //model		private var _gameWidth:uint=940;		private var _gameHeight:uint=600;				private var _gameBG:MovieClip;		private var _gameShadow:MovieClip;		private var _endAnimation:MovieClip; //game over animation if needed				// =================================================		// ================ @Constructor		// =================================================		public function CardQueenMain()		{						TweenPlugin.activate([GlowFilterPlugin, VisiblePlugin]);			_model = CQModel.getInstance();		}				// =================================================		// ================ @Callable		// =================================================		///FUNCTION : INIT		override public function init():void {			if (game == null) {				_gameBG = new GameBkg();				_gameBG.x = 186;				_gameBG.y = -500;//-_gameBG.height;				//_gameBG.visible = false;				_gameBG.mouseEnabled = false;				addChild(_gameBG);								_gameShadow = new GameShadow();				_gameShadow.x = 186;//203;				_gameShadow.y = 480;//525;				_gameShadow.width = _gameBG.width;				_gameShadow.alpha = 0;				addChild(_gameShadow);								game = new CardQueenGame(_gameWidth, _gameHeight);				addChild(game);			}						//set up scoreboard			if (scoreBoard == null) {				scoreBoard = new ScoreboardMC();				scoreBoard.x = 776;				scoreBoard.y = -scoreBoard.height;//35;				scoreBoard.mouseChildren = false;				scoreBoard.mouseEnabled = false;				//register the "time" element and clock movieclip in the scoreboard clip which will be updated:				ScoreboardCardQueen(scoreBoard).createTextElement(CQModel.SCORE, ScoreboardCardQueen(scoreBoard).points);				ScoreboardCardQueen(scoreBoard).createTextElement(CQModel.LEVEL, ScoreboardCardQueen(scoreBoard).level);				ScoreboardCardQueen(scoreBoard).createTextElement(CQModel.LIVES, ScoreboardCardQueen(scoreBoard).lives);				addChild(scoreBoard);			}			 			//instructions screen          	/*if (instructionsScreen==null) {         		instructionsScreen = new ScreenInstructionsMC();				instructionsScreen.id = FrameWorkStates.STATE_SYSTEM_INSTRUCTIONS;				instructionsScreen.x = 204;					instructionsScreen.y = -instructionsScreen.height;//54;	         		addChild(instructionsScreen);          		instructionsScreen.visible = false;         	}*/                  	          	///new level screen        	if (levelInScreen == null) {         		levelInScreen = new ScreenLevelInMC();         		levelInScreen.id = FrameWorkStates.STATE_SYSTEM_LEVEL_IN;				levelInScreen.x = 480;//(_gameWidth-levelInScreen.width)/2;				levelInScreen.y = 190;// (_gameHeight-levelInScreen.height)/2;         		addChild(levelInScreen);          		levelInScreen.visible = false;         	}         	         	//game over screen //high scoreboard displayed 			if (gameOverScreen==null) {				gameOverScreen = new ScreenHighScores();				gameOverScreen.id = FrameWorkStates.STATE_SYSTEM_GAME_OVER;				gameOverScreen.x = (_gameWidth-gameOverScreen.width)/2;				gameOverScreen.y = -gameOverScreen.height;				gameOverScreen.stop();         		addChild(gameOverScreen);         		gameOverScreen.visible = false;     		}    		         	//pause screen         	if (pauseScreen==null) {         		pauseScreen = new ScreenPauseMC();         		pauseScreen.id = FrameWorkStates.STATE_SYSTEM_PAUSE;         		pauseScreen.x = 492;         		pauseScreen.y = 268;				pauseScreen.scaleX = pauseScreen.scaleY = 0;         		addChild(pauseScreen);         		pauseScreen.visible = false;         	}          	//Set standard wait time between levels          	waitTime = 30;//= 1 second 						//CREATE SOUND MANAGER ////////////////////// 			soundManager = new SoundManager();			//register external sounds: 			/*soundManager.addSound(SoundData.SOUND_AMBIENT, new Sound(new URLRequest(SoundData.SOUND_AMBIENT_PATH)));			soundManager.addSound(SoundData.SOUND_CORRECT, new Sound(new URLRequest(SoundData.SOUND_CORRECT_PATH)));			*/						//sounds from the library:			soundManager.addSound(SoundData.SOUND_TIMER,new SoundTimer());			soundManager.addSound(SoundData.SOUND_UP,new SoundUp());			soundManager.addSound(SoundData.SOUND_DOWN,new SoundDown());			soundManager.addSound(SoundData.SOUND_SHUFFLE,new SoundShuffle());			//soundManager.addSound(SoundData.SOUND_HOORAY,new SoundHooray());			soundManager.addSound(SoundData.SOUND_LOSE,new SoundLose());			soundManager.addSound(SoundData.SOUND_WRONG,new SoundWrong());			soundManager.addSound(SoundData.SOUND_CORRECT,new SoundCorrect());						//to PLAY sound (see class function parameters):			/////soundManager.playSound(CardQueenMain.SOUND_GAMEPLAY, false, 1, 0.5, 0.8);			//to STOP sound (see class function parameters):			////soundManager.stopSound(CardQueenMain.SOUND_GAMEPLAY, false);			        	//create timer and run it one time         	frameRate = 31; 						// SET INITIAL GAME STATE ///////////////////////////////////////////////////////			switchSystemState(FrameWorkStates.STATE_SYSTEM_NEW_GAME);		}				//FUNCTION : ON SHOW SYSTEM INSTRUCTIONS		/*override public function systemInstructions():void		{			trace("system instructions");			instructionsScreen.visible = true;			instructionsScreen.addEventListener(ButtonIdEvent.BUTTON_ID, okButtonClickListener, false, 0, true);						soundManager.playSound(SoundData.SOUND_AMBIENT, true,1000,0,0.4);						ScreenInstructions(instructionsScreen).showQuiz();						///ANIMATE INSTRUCTIONS IN NOW //if showing quiz --- call addEvents after animation is done, otherwise do nothing			TweenMax.to(instructionsScreen, 0.6, {y:54, delay:0.2, ease:Back.easeOut, onComplete:function enableQuizEvents():void { if (_model.showQuiz) {ScreenInstructions(instructionsScreen).addEvents();}}});			_gameShadow.width = instructionsScreen.width;			_gameShadow.x = instructionsScreen.x;			TweenMax.to(_gameShadow, 0.6, {alpha:1});						switchSystemState(FrameWorkStates.STATE_SYSTEM_WAIT_FOR_CLOSE);			nextSystemState = FrameWorkStates.STATE_SYSTEM_NEW_GAME;					}*/				//FUNCTION : ON GAME START		override public function systemNewGame():void { 			trace("system new game");			ScreenLevelIn(levelInScreen).isStarted = false;			ScoreboardCardQueen(scoreBoard).isStarted = false; //put the hearts back to start         	game.addEventListener(ScoreBoardUpdateEvent.UPDATE_TEXT,scoreBoardUpdateListener, false, 0, true);          	game.addEventListener(SoundEvent.PLAY_SOUND, soundEventListener,false, 0, true);         	game.addEventListener(SoundEvent.STOP_SOUND, soundEventListener,false, 0, true);         	game.addEventListener(Game.GAME_OVER, gameOverListener, false, 0, true);         	game.addEventListener(Game.NEW_LEVEL, newLevelListener, false, 0, true);         	game.addEventListener(Game.PAUSE, pauseListener, false, 0, true);         	game.newGame();			TweenMax.to(_gameBG, 0.6, {y:34, ease:Back.easeOut, onComplete:CardQueenGame(game).animateIn});			TweenMax.to(_gameShadow, 0.6, {alpha:1, overwrite:false, onStart:function changeShadow():void{_gameShadow.width = _gameBG.width; _gameShadow.x = _gameBG.x;}});			TweenMax.to(scoreBoard, 0.4, {y:35, delay:0.4, ease:Back.easeOut});			//TweenMax.to(_gameBG.grass, 0.3, {alpha:1, delay:0.6});						//wait for animation done of tiles before going to level in count down (listening for newLevelListener)			switchSystemState(FrameWorkStates.STATE_SYSTEM_WAIT);						Tracking.track(Tracking.L3_GAME_FOLLOWLADY_START);      	}  				//FUNCTION : ON LEVEL IN ("3...2...1...GO!")		override public function systemLevelIn():void {			trace("system level in screen");			levelInScreen.visible = true;			levelInScreen.alpha = 1;			levelInScreen.addEventListener(ButtonIdEvent.BUTTON_ID,okButtonClickListener); 			ScreenLevelIn(levelInScreen).startAnimation();         	         			switchSystemState(FrameWorkStates.STATE_SYSTEM_WAIT_FOR_CLOSE); //waits for animation done 			nextSystemState = FrameWorkStates.STATE_SYSTEM_GAME_PLAY; 		}				//FUNCTION : ON GAME OVER - SHOW HIGH SCORES / REPLAY, etc		override public function systemGameOver():void		{			trace("GAME OVER!!!!!!!!");			////TweenMax.delayedCall(1.5, CardQueenGame(game).destroy); //keep the game screen on for a bit, adding delay to everythign below						//NEW : GAME LISTENS FOR ANIMATION OUT OF CARDS BEFORE SHOWING HTE ENDSCREEN - ACCOUNT FOR VIDEO DELAYS			game.addEventListener(CardQueenEvent.GAMEOVER_ANIMATION_COMPLETE, onGameOverAnimationComplete); 						//moving the below			/*			gameOverScreen.addEventListener(ButtonIdEvent.BUTTON_ID, okButtonClickListener); 			gameOverScreen.visible = true;			TweenMax.to(_gameBG, 0.4, {y:-500, ease:Back.easeIn, delay:3});			TweenMax.to(_gameShadow, 0.3, {alpha:0, ease:Back.easeIn, delay:3});			TweenMax.to(scoreBoard, 0.4, {y:-500, ease:Back.easeIn, delay:3});			*/						ScreenHighScores(gameOverScreen).updateStaticText(); 						updateLeaderboard();						///TO TEST LOCALLY - SWITCH SHELLADAPTER.AS TO POINT TO TEMPLEADERBOARDCALLBACK AND UNCOMMENT THIS LINE:			//_model.leaderboardResults = _model.shell.leaderboardcallback(_model.dataToSend);				//moving		//TweenMax.to(gameOverScreen, 0.5, {y:(_gameHeight-gameOverScreen.height)/2, delay:3.6, ease:Back.easeOut, onComplete:ScreenHighScores(gameOverScreen).addEvents});	//moving		//TweenMax.to(_gameShadow, 0.5, {alpha:1, delay:3.6, onStart:function changeShadow():void{_gameShadow.width = gameOverScreen.width; _gameShadow.x = gameOverScreen.x;}});						switchSystemState(FrameWorkStates.STATE_SYSTEM_WAIT_FOR_CLOSE);						////change this based on what is selected from game screen			nextSystemState = FrameWorkStates.STATE_SYSTEM_NEW_GAME; //STATE_SYSTEM_INSTRUCTIONS - skip instructions					Tracking.track(Tracking.L3_GAME_FOLLOWLADY_END);		}				private function onGameOverAnimationComplete(e:CardQueenEvent):void {			game.removeEventListener(CardQueenEvent.GAMEOVER_ANIMATION_COMPLETE, onGameOverAnimationComplete); 						gameOverScreen.addEventListener(ButtonIdEvent.BUTTON_ID, okButtonClickListener); 			gameOverScreen.visible = true;						TweenMax.to(_gameBG, 0.4, {y:-500, ease:Back.easeIn});			TweenMax.to(_gameShadow, 0.3, {alpha:0, ease:Back.easeIn});			TweenMax.to(scoreBoard, 0.4, {y:-500, ease:Back.easeIn});						TweenMax.to(gameOverScreen, 0.5, {y:(_gameHeight-gameOverScreen.height)/2, delay:0.6, ease:Back.easeOut, onComplete:ScreenHighScores(gameOverScreen).addEvents});			TweenMax.to(_gameShadow, 0.5, {alpha:1, delay:0.6, onStart:function changeShadow():void{_gameShadow.width = gameOverScreen.width; _gameShadow.x = gameOverScreen.x;}});		}		//FUNCTION : HANDLE GAME OVER		override public function gameOverListener(e:Event):void		{         	switchSystemState(FrameWorkStates.STATE_SYSTEM_GAME_OVER);        		game.removeEventListener(ScoreBoardUpdateEvent.UPDATE_TEXT,scoreBoardUpdateListener);         	game.removeEventListener(LevelScreenUpdateEvent.UPDATE_TEXT, levelScreenUpdateListener);         	game.removeEventListener(SoundEvent.PLAY_SOUND, soundEventListener);          	game.removeEventListener(SoundEvent.STOP_SOUND, soundEventListener);          	game.removeEventListener(Game.GAME_OVER, gameOverListener);          	game.removeEventListener(Game.NEW_LEVEL, newLevelListener);          	game.removeEventListener(Game.PAUSE, pauseListener);      	}      	//FUNCTIO : ON SYSTEM PAUSE      	override public function systemPause():void		{      		trace(" SYSTEM PAUSING");      		paused = true;         	pauseScreen.visible = true;          	TweenMax.to(pauseScreen, 0.5, {scaleX:1, scaleY:1, ease:Back.easeOut, onComplete:function onPauseOut():void {ScreenPauseHelp(pauseScreen).addEvents(); pauseScreen.addEventListener(ButtonIdEvent.BUTTON_ID, okButtonClickListener, false, 0, true);}});         	                  	switchSystemState(FrameWorkStates.STATE_SYSTEM_WAIT_FOR_CLOSE);          	nextSystemState = FrameWorkStates.STATE_SYSTEM_GAME_PLAY;		}      	      	//FUNCTION : DESTROY -- KILL ALL LISTENERS IN THE GAME FROM THE SHELL		public function destroy():void {			trace("!!!!!! DESTROYING TUG OF WAR !!!!!!!");			if (gameTimer!=null) {				gameTimer.removeEventListener(TimerEvent.TIMER, runGame);				gameTimer.stop();			}						CardQueenGame(game).destroy();						// STOP ALL SOUNDS !!			game.removeEventListener(CardQueenEvent.GAMEOVER_ANIMATION_COMPLETE, onGameOverAnimationComplete); 			//instructionsScreen.removeEventListener(ButtonIdEvent.BUTTON_ID,okButtonClickListener); 			pauseScreen.removeEventListener(ButtonIdEvent.BUTTON_ID,okButtonClickListener);			game.removeEventListener(ScoreBoardUpdateEvent.UPDATE_TEXT,scoreBoardUpdateListener);          	game.removeEventListener(LevelScreenUpdateEvent.UPDATE_TEXT, levelScreenUpdateListener);         	game.removeEventListener(SoundEvent.PLAY_SOUND, soundEventListener);         	game.removeEventListener(SoundEvent.STOP_SOUND, soundEventListener);          	game.removeEventListener(Game.GAME_OVER, gameOverListener);         	game.removeEventListener(Game.NEW_LEVEL, newLevelListener);         	game.removeEventListener(Game.PAUSE, pauseListener);         	removeEventListener(EVENT_WAIT_COMPLETE, waitCompleteListener);         	(gameOverScreen as ScreenHighScores).removeEvents();         	gameOverScreen.removeEventListener(ButtonIdEvent.BUTTON_ID, okButtonClickListener);          //  ScreenInstructions(instructionsScreen).removeEvents();         //	instructionsScreen.removeEventListener(ButtonIdEvent.BUTTON_ID, okButtonClickListener);               	ScreenPauseHelp(pauseScreen).removeEvents();      		pauseScreen.removeEventListener(ButtonIdEvent.BUTTON_ID, okButtonClickListener);		}				public function updateLeaderboard():void{			trace("MAIN :: update leaderboard");			//listen for leaderboard data			_model.addEventListener(ZyrtecGameEvent.ON_LEADERBOARD_RESULT, _onLeaderboardResults);			_model.shell.leaderboardcallback(_model.dataToSend); //send the score results to the shell, the shell will call setLeaderboardData when the server returns the result		}				// =================================================		// ================ @Handlers		// =================================================				//FUNCTION : PLAY BUTTONS FROM VARIOUS SCREENS - HANDLE ANIMATION OF DIFFERENT SCREENS		override public function okButtonClickListener(e:ButtonIdEvent):void {			switch(e.id) {				case FrameWorkStates.STATE_SYSTEM_TITLE: //we're not using this					//removeChild(titleScreen); 					//titleScreen.removeEventListener(ButtonIdEvent.BUTTON_ID,okButtonClickListener); 					//switchSystemState(nextSystemState);					break; 								case FrameWorkStates.STATE_SYSTEM_INSTRUCTIONS: 				/*	instructionsScreen.removeEventListener(ButtonIdEvent.BUTTON_ID,okButtonClickListener); 					ScreenInstructions(instructionsScreen).removeEvents();							TweenMax.to(instructionsScreen, 0.6, {y:-instructionsScreen.height, ease:Back.easeIn, visible:false,  onComplete:switchSystemState, onCompleteParams:[nextSystemState]});					TweenMax.to(_gameShadow, 0.6, {alpha:0, delay:0.2});*/					break;								case FrameWorkStates.STATE_SYSTEM_GAME_OVER: 					gameOverScreen.removeEventListener(ButtonIdEvent.BUTTON_ID,okButtonClickListener);  					(gameOverScreen as ScreenHighScores).removeEvents();					TweenMax.to(gameOverScreen, 0.6, {y:-gameOverScreen.height, ease:Back.easeIn, visible:false, onComplete:switchSystemState, onCompleteParams:[nextSystemState]});               					TweenMax.to(_gameShadow, 0.6, {alpha:0, delay:0.2});					break; 								case FrameWorkStates.STATE_SYSTEM_PAUSE: 					paused = false;					pauseScreen.removeEventListener(ButtonIdEvent.BUTTON_ID,okButtonClickListener);					ScreenPauseHelp(pauseScreen).removeEvents();					TweenMax.to(pauseScreen, 0.6, {scaleX:0, scaleY:0, ease:Back.easeIn, visible:false, onComplete:function onResume():void {game.resumeGame(); switchSystemState(nextSystemState);}});             					break; 								case FrameWorkStates.STATE_SYSTEM_LEVEL_IN: 					levelInScreen.removeEventListener(ButtonIdEvent.BUTTON_ID,okButtonClickListener); 					TweenMax.to(levelInScreen, 0.1, {alpha:0, visible:false, onComplete:function startGameEvents():void {CardQueenGame(game).addEvents(); switchSystemState(nextSystemState);}});             					break; 			}		}				//FUNCTION : ON PAUSE CLICKED		private function onPauseClicked(e:Event):void { //need to prevent the end level screen from overlapping			CardQueenGame(game).removeEvents();			switchSystemState(FrameWorkStates.STATE_SYSTEM_PAUSE); 		}				//FUNCTION : SCOREBOARD UPDATE 		override public function scoreBoardUpdateListener(e:ScoreBoardUpdateEvent):void {			if(e.element=="lives" ) {				ScoreboardCardQueen(scoreBoard).updateLives(e.value);			} else {				scoreBoard.update(e.element, e.value);			}		}				//FUNCTION : ON LEADERBOARD RESULTS IN		private function _onLeaderboardResults($e:ZyrtecGameEvent):void{			_model.removeEventListener(ZyrtecGameEvent.ON_LEADERBOARD_RESULT, _onLeaderboardResults);			ScreenHighScores(gameOverScreen).updateLeaderboard();					}			}}