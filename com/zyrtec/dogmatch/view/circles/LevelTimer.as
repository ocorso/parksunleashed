package com.zyrtec.dogmatch.view.circles
{
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	import com.leebrimelow.drawing.Wedge;
	import com.zyrtec.dogmatch.events.DogMatchEvent;
	import com.zyrtec.dogmatch.game.DogMatchGame;
	import com.theginbin.utils.BasicFrameTimer;
	import com.theginbin.utils.TimeConverter;
	import flash.utils.Timer;
	import flash.display.*;
	import flash.events.*;
	import flash.utils.getDefinitionByName;
	
	
	public class LevelTimer extends Sprite
	{
		private var _className:String;
		private var _classRef:Class;
		private var _isInPlay:Boolean; 							//you would make this true only when you were ready to start the timer
		private var _countdownTimerClip:MovieClip; 				//class in library
		private var _powerMask:Sprite;
		private var _powerRadius:int; 							//radius of the circle aka how big the mask should be
		private var _powerStartAngle:int; 						//start of the arc, 360 degrees is fully complete
		private var _powerEndAngle:int;							// end of arc is 0
		private var _powerCount:Number; 						//the fullness of the mask, change this value for start position: 360 is full, 270 is 3/4 full, 180 is half, 90 is 3/4 left
		private var _powerMeterSpeed:Number; 					//this is going to be equal to TIME  ////a power speed of 0.167 is equal to 1 second of time on the circle (60 seconds/ 360 degrees = 0.166)
		private var _gameLevel:int;
		private var holder:Sprite;
		private var _game:DogMatchGame;
		private var _levelTimerStarted:Boolean;
		private var paused:Boolean;

		public function LevelTimer(gameLevel)
		{
			_gameLevel = gameLevel;	
			_className = "CountdownTimer";
			_classRef = getDefinitionByName(_className) as Class;
			_countdownTimerClip = new _classRef;
			paused = false;
			_powerMask = new Sprite();
		}	

		
		 public function init():void
		 {
			 _powerRadius=220; 
			 _powerStartAngle=360; 
			 _powerEndAngle=0;
			 _powerCount=360; 
			_countdownTimerClip.mouseEnabled=false;
			_countdownTimerClip.mouseChildren=false;
			holder = new Sprite();										//set up power meter inside aimer
			holder.rotation=90;
			holder.scaleX=-1;
			_countdownTimerClip.addChild(holder);
			holder.addChild(_powerMask);
			_countdownTimerClip.circle.mask=_powerMask; 				//masking the circle inside the movieclip
																		//_countdownTimerClip.addEventListener(Event.ENTER_FRAME, updateCountdownMeter); //call updateCountdownMeter() in the runGame function	 
			_powerMask.graphics.clear();
			_powerMask.graphics.beginFill(0xFF0000, 1);
			Wedge.draw(_powerMask, 0, 0, _powerRadius, _powerCount, _powerStartAngle);
			_powerMask.graphics.endFill();				
		 }		 
		 
		//FUNCTION: RESET LEVEL TIMER
		public function resetLevelTimer(level:int):void{
			/*trace("reset level timer");
			_gameLevel = levelArray[0];*/
			_gameLevel = level;
			//trace("game level in reset timer: " + _gameLevel);
			_powerMask.graphics.clear();
			_powerMask.graphics.beginFill(0xFF0000, 1);
			Wedge.draw(_powerMask, 0, 0, _powerRadius, _powerCount, _powerStartAngle);
			_powerMask.graphics.endFill();
			
			_levelTimerStarted = true; 
			_powerCount=360; 
			//_powerMeterSpeed = .95; 									// .95 = 15 sec   //.48 = 30 sec
			if (_gameLevel <=6){
			_powerMeterSpeed = .95;  //15 secs
			//trace(" powermeterspeed: " + _powerMeterSpeed);
			}else if (_gameLevel > 5 && _gameLevel <= 12){
			_powerMeterSpeed = 1.15;  // ~11 secs
		//	trace(" powermeterspeed: " + _powerMeterSpeed);
			
			}else if (_gameLevel > 10 && _gameLevel <= 18){
			_powerMeterSpeed =1.9;  // ~7-8 secs
			//trace(" powermeterspeed: " + _powerMeterSpeed);
			
			}else {
		//	trace("currentLevel's screwed up, timer cant access it")
			}
			
		}
		public function startLevelTimer():void{
			
			_levelTimerStarted = true;
			var _paused:Boolean = false;
			
		}
		public function stopLevelTimer():void{
			_levelTimerStarted = false; 
		
		}
		//FUNCTION: UPDATE COUNTDOWN CIRCLE
		public function updateCountdownMeter(_paused:Boolean):void {
		
			if (_levelTimerStarted) {
				_powerMask.graphics.clear();
				_powerMask.graphics.beginFill(0xFF0000, 1);
				Wedge.draw(_powerMask, 0, 0, _powerRadius, _powerCount, _powerStartAngle);
				_powerMask.graphics.endFill();
				_powerCount -= _powerMeterSpeed;
				
				if (_powerCount < 0)  {
					_powerMask.graphics.clear();
					_levelTimerStarted = false; 						//STOP CALLING THIS, time's up
					trace("TIME's UP!");
					dispatchEvent(new DogMatchEvent(DogMatchEvent.LEVEL_TIME_UP));	// call event _levelTimeUp in dogmatchgame
				}
				if (_paused) {
					trace("level timer paused");
					_levelTimerStarted = false;
				}		
			}
		}
		
		
		// =================================================
		// ================ @Getters / Setters
		// =================================================
		
		public function get countdownTimerClip():MovieClip { return _countdownTimerClip };
		public function set countdownTimerClip(value:MovieClip):void { _countdownTimerClip = value };
		
	}
}