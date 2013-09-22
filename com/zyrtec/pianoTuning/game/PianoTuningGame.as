﻿package com.zyrtec.pianoTuning.game {	import com.adobe.utils.StringUtil;	import com.bigspaceship.events.AnimationEvent;	import com.bigspaceship.utils.Out;	import com.carlcalderon.arthropod.Debug;	import com.g2.gaming.framework.Game;	import com.g2.gaming.framework.events.ScoreBoardUpdateEvent;	import com.g2.gaming.framework.events.SoundEvent;	import com.greensock.TweenMax;	import com.greensock.easing.*;	import com.greensock.plugins.*;	import com.theginbin.utils.BasicFrameTimer;	import com.theginbin.utils.TimeConverter;	import com.zyrtec.events.ZyrtecGameEvent;	import com.zyrtec.pianoTuning.controller.PianoTuningMain;	import com.zyrtec.pianoTuning.events.PianoTuningEvent;	import com.zyrtec.pianoTuning.model.PTModel;	import com.zyrtec.pianoTuning.model.SoundData;	import com.zyrtec.pianoTuning.view.pianoKeyboard.PianoKeyboard;	import com.zyrtec.pianoTuning.view.pianoKeyboard.Staff;	import com.zyrtec.pianoTuning.view.screens.DebugTool;		import flash.display.*;	import flash.events.*;	import flash.ui.Keyboard;	import flash.utils.Timer;	import flash.utils.getDefinitionByName;		import net.ored.util.StringUtils;
	// =================================================	// ================ @Class	// =================================================	public class PianoTuningGame extends Game {				//model		private var	_m 				: PTModel;						//display objs		private var _stageRef 		: Stage;		private var _clock 			: MovieClip;		private var _bonusPopup 	: MovieClip;		private var _plusOnePopup 	: MovieClip;		//bools		private var _isGameOver 	: Boolean = false;			//whether the game is over		private var _passedLevel 	: Boolean = false;			//whether they passed or failed the level, value read from Main		private var _isStarted 		: Boolean = false;			//whether timer has started running				//values for game			private var _gameWidth 		: int;		private var _gameHeight 	: int;		private var _gameLevel 		: int = 1;		private var _score 			: uint = 0;					// score aka Time		private var _levelScore 	: int;						//store level score		private var _levelScoresArr	: Array;					//store all level scores				//game specific vars		private var _numNotes		: Number = 0;				//number of notes played		private var _gameTime 		: String;					//running game play time		private var _btnSkipToEnd 	: BtnSkipToEnd;				// BtnSkipToEnd			private var _matchTimeStamps: Array						// Array containing timestamps of matches, used for win validation by server @see William		private var _keyboard 		: PianoKeyboard;		private var _notesPlayed 	: int;		private var _userResponse 	: String;		private var _tuneToMatch 	: String;		private var _staff 			: Staff;		private var _rightMessage 	: MovieClip;		private var _wrongMessage 	: MovieClip;		private var _tryAgainMessage: MovieClip;		private var _numClick 		: int;		private var _notesToPlay 	: Array;		private var _chancesLeft 	: uint = 0;		private var _replayMode 	: Boolean;		private var _betweenNotesTimer 	: Timer;		private var _userResponseTimer 	: Timer;		private var debugTool 		: DebugTool;		// ===============================================================================		// ================ @ REQUIRED GAME FUNCTIONS		// ===============================================================================		public function showElements():void{			_staff.visible 		= true;			_keyboard.visible	= true;		}		public function hideElements():void{						_staff.visible 		= false;			_keyboard.visible	= false;		}		//FUNCTION : NEW GAME - CALLED ONCE		override public function newGame() : void { 			Out.debug(this, "newGame");			_m.score 		= 0;			_levelScore 	= 0;			_isGameOver 	= false;			_isStarted 		= false;			_numNotes 		= 0;			_numClick 		= 0;			_notesToPlay 	= new Array();			_tuneToMatch	= "";			_m.numLives 	= 3;			_replayMode 	= false;			if (_keyboard == null) {				_keyboard = new PianoKeyboard();				_keyboard.init();				_keyboard.x = (587 - _keyboard.width) / 2; //260;				_keyboard.y = 155; //203;				_keyboard.visible = false;				addChild(_keyboard);			}			if (_staff == null) {				_staff = new Staff();				_staff.init();				_staff.x = (587 - _staff.width) / 2; //300;				_staff.y = _keyboard.y - 132; //50 + 33; //216 - 180 + 78;				_staff.visible = false;				addChild(_staff);			}						if (_rightMessage == null) {				var RightMessageClass : Class = getDefinitionByName("rightMessage") as Class;				_rightMessage = new RightMessageClass() as MovieClip;				_rightMessage.x = (567 - _rightMessage.width) / 2;				_rightMessage.y = -65; //(395 - _rightMessage.height) / 2;				_rightMessage.visible = false;				addChild(_rightMessage);			}						if (_wrongMessage == null) {				var WrongMessageClass : Class = getDefinitionByName("wrongMessage") as Class;				_wrongMessage = new WrongMessageClass() as MovieClip;				_wrongMessage.x = (567 - _wrongMessage.width) / 2 - 30;				_wrongMessage.y = -65; //(395 - _wrongMessage.height) / 2;				_wrongMessage.visible = false;				addChild(_wrongMessage);			}						if (_tryAgainMessage == null) {				var TryAgainMessageClass : Class = getDefinitionByName("tryAgainMessage") as Class;				_tryAgainMessage = new TryAgainMessageClass() as MovieClip;				_tryAgainMessage.x = (567 - _tryAgainMessage.width) / 2;				_tryAgainMessage.y = -65; //(395 - _wrongMessage.height) / 2;				_tryAgainMessage.visible = false;				addChild(_tryAgainMessage);			}         				//debug tool			if (debugTool == null) {				debugTool = new DebugTool();				debugTool.x = 500;				debugTool.y = 330;				//addChild(debugTool);			}          				//update the scoreboard			dispatchEvent(new ScoreBoardUpdateEvent(ScoreBoardUpdateEvent.UPDATE_TEXT, PianoTuningMain.TIME, "00:00:00"));        				showElements();		}//end function		private function playNextTune() : void {			Out.info(this, "playNextTune");						//_userResponseTimer.reset();			_userResponse 		= "";			_keyboard.deactivateKeyboard();			_notesPlayed 		= 0;			_numClick 			= 0;			_betweenNotesTimer	= new Timer(PTModel.TIME_BETWEEN_NOTES);			_betweenNotesTimer.addEventListener(TimerEvent.TIMER, playNextNote);					if (!_replayMode) {				var newNote :uint = Math.round(Math.random() * (10 - 4)) + 4;				_tuneToMatch += "*" + newNote;				_notesToPlay.push(newNote);			}			playNextNote();				}//end function 				private function playNextNote(event : TimerEvent = null) : void {			Out.status(this, "playNextNote ");						if (_notesPlayed < _notesToPlay.length) {				_keyboard.playNote(_notesToPlay[_notesPlayed]);				_staff.glowNote(_notesToPlay[_notesPlayed]);				_notesPlayed++;				if (_notesPlayed < _notesToPlay.length) {					_betweenNotesTimer.start();				} else {					_betweenNotesTimer.removeEventListener(TimerEvent.TIMER, playNextNote);					_betweenNotesTimer.stop();					prepareForResponse();				}			}//end if					}//end function		private function _createAndStartUserTimer():Timer{			Debug.log("_createAndStartUserTimer", Debug.LIGHT_BLUE);			_disposeUserTimer();			var t:Timer = new Timer(PTModel.USER_RESPONSE_TIME);			t.addEventListener(TimerEvent.TIMER, checkAnswer);			t.start();			return t;		}		private function _disposeUserTimer():void{						if (_userResponseTimer){				_userResponseTimer.reset();				_userResponseTimer.removeEventListener(TimerEvent.TIMER, checkAnswer);				_userResponseTimer = null;			}		}//end function				private function prepareForResponse() : void {			Out.info(this, "prepareForResponse ");			_keyboard.addEventListener(PianoTuningEvent.KEY_CLICK, onPianoKeyClick);			_keyboard.activateKeyboard();			_userResponseTimer = _createAndStartUserTimer();		}		private function onPianoKeyClick(event : PianoTuningEvent) : void {			Out.status(this, "onPianoKeyClick");			_staff.glowNote(event.data);			_numClick++;			_userResponseTimer = _createAndStartUserTimer();			_userResponse += "*" + String(event.data);			Out.debug(this, "_userResponse: " + _userResponse);			if (_numClick >= _notesToPlay.length) {				checkAnswer();			} else 				checkAnswerImmediately();		}		private function checkAnswerImmediately():void{			Out.status(this, "checkAnswerImmediately");			var isWrong:Boolean 					= false;			var userResponseVect:Vector.<String> 	= StringUtils.explode(_userResponse);			var tuneToMatchVect:Vector.<String>		= StringUtils.explode(_tuneToMatch);						for (var i:uint = 0; i < userResponseVect.length; i++){				if (userResponseVect[i] != tuneToMatchVect[i])	isWrong = true;			}//end if						Out.debug(this, "is Wrong: "+isWrong);			if (isWrong){				_userResponse = "";				_handleWrongAnswer();				_disposeUserTimer();				_keyboard.deactivateKeyboard();				//TweenMax.delayedCall(2, playNextTune);			}					}//end function				private function checkAnswer($e : TimerEvent = null) : void {			Out.status(this, "checkAnswer");			if ($e)	Out.warning(this, "we have an event");						_keyboard.removeEventListener(PianoTuningEvent.KEY_CLICK, onPianoKeyClick);			_keyboard.deactivateKeyboard();			_disposeUserTimer();			Out.debug(this, "_userResponse: " + _userResponse);			Out.debug(this, "_tuneToMatch:  " + _tuneToMatch);									//good			if (_userResponse == _tuneToMatch) {				_m.currentStreak++;				_replayMode = false;				_m.score += _notesToPlay.length;				updateScoreBoardNotes();				if (_m.currentStreak % 5 == 0) {					_m.currentStreak = 0;					TweenMax.delayedCall(1, showRightMessage);				} else {					TweenMax.delayedCall(3, playNextIfGameNotOver);				}			//bad			} else _handleWrongAnswer();		}//end function 				private function _handleWrongAnswer():void{			Out.status(this, "handleWrongAnswer");				_m.currentStreak = 0;				_m.numLives--;				updateScoreBoardLives();				_replayMode = true;				if (_m.numLives > 0) {					TweenMax.delayedCall(1, showWrongMessage);				} else _isGameOver = true;				dispatchEvent(new SoundEvent(SoundEvent.PLAY_SOUND, SoundData.SOUND_WRONG, false, 0, 0, 1));		}		private function showRightMessage() : void {			Out.status(this, "showRightMessage");			//			TweenMax.to(_rightMessage, 0.3, {alpha:1, ease:Back.easeOut, onComplete:fadeOutMessage, onCompleteParams:[_rightMessage]});			_rightMessage.visible = true;			var random : Number = Math.floor(Math.random() * 3);			_rightMessage.gotoAndPlay("msg" + random);			TweenMax.to(_rightMessage, 0.3, {alpha:1, ease:Back.easeOut});			TweenMax.delayedCall(2, fadeOutMessage, [_rightMessage]); 		}		private function showWrongMessage() : void {			Out.status(this, "showWrongMessage");			//			TweenMax.to(_wrongMessage, 0.3, {alpha:1, ease:Back.easeOut, onComplete:fadeOutMessage, onCompleteParams:[_wrongMessage]});			_wrongMessage.visible = true;			_wrongMessage.gotoAndPlay("msg1");			TweenMax.to(_wrongMessage, 0.3, {alpha:1, ease:Back.easeOut});			TweenMax.delayedCall(2, fadeOutMessage, [_wrongMessage]); 		}		private function fadeOutMessage(p_message : MovieClip) : void {			Out.status(this, "fadeOutMessage");			TweenMax.to(p_message, 0.2, {alpha:0, ease:Back.easeOut});			TweenMax.delayedCall(2, playNextIfGameNotOver, [p_message]); 		}		private function playNextIfGameNotOver(p_message : MovieClip = null) : void {			Out.status(this, "playNextIfGameNotOver");			if (p_message) {				p_message.visible = false;			}			if (_m.numLives > 0) {				playNextTune();			}		}		//FUNCTION : RESUME GAME		override public function resumeGame() : void {			Out.status(this, "resumeGame");			addEvents();		}		//FUNCTION : DESTROY LISTENERS		override public function destroy() : void {			Out.status(this, "destroy");			removeEvents();//			_model.stageRef.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);		}		// ===============================================================================		// ================ @ CUSTOM GAME FUNCTIONS		// ===============================================================================				// =================================================		// ================ @Callable		// =================================================				//FUNCTION : ANIMATE IN 		public function animateIn() : void {			Out.status(this, "animateIn");			_keyboard.visible = true;			//			_keyboard.addEventListener(AnimationEvent.COMPLETE, onPianoKeyboardAnimatedIn);			_staff.visible = true;			//			_staff.addEventListener(AnimationEvent.COMPLETE, onPianoKeyboardAnimatedIn);			onPianoKeyboardAnimatedIn(new AnimationEvent(AnimationEvent.COMPLETE));//			_tileHolder.animateIn();		}		//FUNCTION : ADD EVENTS		public function addEvents() : void {			Out.status(this, "addEvents");			debug(_m.isDebugMode);		}		public function kickOff() : void {			Out.status(this, "kickOff");			updateScoreBoardLives();			updateScoreBoardNotes();			addEvents();			TweenMax.delayedCall(2, playNextTune);		}		//FUNCTION : REMOVE EVENTS		public function removeEvents() : void {			Out.status(this, "removeEvents");		}		// =================================================		// ================ @Workers		// =================================================		//FUNCTION : CHECK FOR END GAME		private function checkforEndGame() : void { 			if (_isGameOver) {						Out.warning(this, "checkforEndGame: gameOver");				destroy();				dispatchEvent(new Event(GAME_OVER)); 			} //end if game's over		}		//FUNCTION : UPDATE SCOREBOARD Notes		private function updateScoreBoardNotes() : void {			Out.status(this, "updateScoreBoardNotes");			dispatchEvent(new ScoreBoardUpdateEvent(ScoreBoardUpdateEvent.UPDATE_TEXT, PianoTuningMain.TUNES_CORRECT, String(_m.score)));   		}		//FUNCTION : UPDATE SCOREBOARD Lives		private function updateScoreBoardLives() : void {			Out.status(this, "updateScoreBoardLives");			dispatchEvent(new ScoreBoardUpdateEvent(ScoreBoardUpdateEvent.UPDATE_TEXT, PianoTuningMain.LIVES, _m.numLives + ":" + PTModel.MAX_LIVES));   		}		//FUNCTION : DEBUG		private function debug(b : Boolean) : void { 			Out.status(this, "debug");			if (b) {				if (_btnSkipToEnd == null) {					_btnSkipToEnd = new BtnSkipToEnd;					_btnSkipToEnd.buttonMode = true;					addChild(_btnSkipToEnd)					_btnSkipToEnd.addEventListener(MouseEvent.CLICK, onSkipToEnd);				}			}		}		// =================================================		// ================ @Handlers		// ================================================		private function onPianoKeyboardAnimatedIn(e : AnimationEvent) : void {			Out.status(this, "onPianoKeyboardAnimatedIn");						_keyboard.removeEventListener(AnimationEvent.COMPLETE, onPianoKeyboardAnimatedIn);						this.dispatchEvent(new Event(Game.NEW_LEVEL));		}		//FUNCTION : ON CLOCK TIMER UP		private function onClockTimerUp(e : Event) : void {			_isGameOver = true;		}		//FUNCTION : ON SKIP TO END		private function onSkipToEnd(event : Event = null) : void { 			_isGameOver = true;			checkforEndGame();			//_tileHolder.clearTheBoard();		}		//FUNCTION : ON KEY DOWN - CHECK FOR P PAUSE		private function keyDownHandler(event : KeyboardEvent) : void {  			if (event.keyCode == Keyboard.P) {				removeEvents(); //prevent tile roll and click				_m.stageRef.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);				this.dispatchEvent(new Event(PAUSE));			}		}		// =================================================		// ================ @Core Handler		// =================================================				//FUNCTION : RUN GAME - CALLED ON EVERY FRAME OF TIMER		override public function runGame() : void { 						checkforEndGame();		}//end function				// =================================================		// ================ @Getters / Setters		// =================================================		public function get gameLevel() : int {			return _gameLevel;		}		// =================================================		// ================ @Constructor		// =================================================		public function PianoTuningGame(gameWidth : int, gameHeight : int) {			super();			TweenPlugin.activate([VisiblePlugin, TransformAroundPointPlugin, TransformAroundCenterPlugin, ShortRotationPlugin, GlowFilterPlugin]);						_gameWidth = gameWidth;			_gameHeight = gameHeight;						_m = PTModel.getInstance();			_stageRef = _m.stageRef;		}	}}