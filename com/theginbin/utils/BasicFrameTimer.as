// =================================================
// ================ @Countdown timer class - frame-based
//The constructor will accept in a parameter that represents the frame rate our game is set to run at. 
//A single second of time will be based on this number rather than 1,000 real milliseconds. 
//If the frame rate speeds up or slows down, our frame-based second will do the same.
//This will allow players on all machines a fair attempt at the game.
// =================================================
package com.theginbin.utils
{
	import flash.events.*;
	import flash.utils.getTimer;
	
	// =================================================
	// ================ @Class
	// =================================================
	public class BasicFrameTimer extends EventDispatcher
	{
		public static const TIME_IS_UP:String = "timesup"; //dispatched when done counting
		
		private var _isCountUp:Boolean = false; //whether timer should count up
		private var _min:int = 0; //minimum seconds of counter
		private var _max:int = 0; //maximum seconds of counter
		private var _seconds:uint; //how many seconds have passed - use this number to display a game clock timer
		private var _milliseconds:uint; //how many milliseconds have passed
		private var _frameCount:uint; //used to count up until it is equal to the passed in framesPerSecond
		private var _framesPerSecond:uint; //rate of game fps
		private var _pauseTime:uint=0; //amount of time lapsed per pause
		private var _totalPauseTime:uint=0; //amount of total time that lapsed during a pause -- need to exclude this time when using getTimer
		
		private var _isStarted:Boolean = false; //whether timer has started
		
		private var _startTime:Number=0; // hold the start of the movie, so can subtract this amount before starting the real game timer
		
		// =================================================
		// ================ @Constructor
		// =================================================
		public function BasicFrameTimer(framesPerSecond:uint, minTime:uint, maxTime:uint, isCountUp:Boolean=false) {			
			_framesPerSecond = framesPerSecond;
			_min = minTime;
			_max = maxTime;
			_isCountUp = isCountUp;
			
			if (_isCountUp) { //for frame-based counting
				_seconds = _min;
			} else {
				_seconds = _max;
			}
		}
		
		// =================================================
		// ================ @Callable
		// =================================================
		//FUNCTION : START TIMER
		public function start():void {
			_frameCount = 0;
			_startTime = getTimer(); //for milliseconds counting	
			_isStarted = true;
		}
		
		//FUNCTION : STOP TIMER
		public function stop():void {
			_isStarted = false;
		}
		
		//FUNCTION : RESET TIMER
		public function reset():void { 
			if (_isCountUp) {
				_seconds = _min;
			} else {
				_seconds = _max;
			}
			_pauseTime = 0;
			_totalPauseTime = 0;
		}
		
		//FUNCTION : UPDATE TIMER - CALL ON GAME LOOP - BASED ON 1 SECOND PER FRAME OF MOVIE
		public function update():void {
			_frameCount++;
			if (_isStarted) {
				if (_frameCount > _framesPerSecond) {
					_frameCount=0;
					if (_isCountUp) {
						_seconds++;
						if (_seconds == _max) {
							stop();
							trace("frame timer time is up");
							dispatchEvent(new Event(BasicFrameTimer.TIME_IS_UP));
						}
					} else {
						_seconds--;
						if (_seconds == _min) {
							stop();
							dispatchEvent(new Event(BasicFrameTimer.TIME_IS_UP));
						}
					}
				}
			}
		}
		
		//FUNCTION : UPDATE TIMER BASED ON MILLISECOND CLOCK
		public function updateByMilliseconds():void {
			if (_isStarted) {
				var elapsedTime:Number = getTimer()-(_startTime+_totalPauseTime);
				if (_isCountUp) {
					_milliseconds = elapsedTime;
					if (_milliseconds >= _max) {
						stop();
						//dispatchEvent(new Event(BasicFrameTimer.TIME_IS_UP));
					}
				} else {
					_milliseconds = _max-elapsedTime;
				}
			}
		}
		
		//FUNCTION : START RECORD START OF PAUSE TIME
		public function startPauseTime() {
			_pauseTime = getTimer();
			//trace("pauseeeeeeee "+_pauseTime);
		}
		
		//FUNCTION : STOP RECORD START OF PAUSE TIME
		public function stopPauseTime() {
			_totalPauseTime += (getTimer()-_pauseTime);
			//trace("unpauseeeeeeee "+_pauseTime);
		}
		
		// =================================================
		// ================ @Getters / Setters
		// =================================================
		//FUNCTION : GET SECONDS
		public function get seconds():uint {
			return _seconds;
		}
		
		//FUNCTION : GET MILLISECONDS
		public function get milliseconds():uint {
			return _milliseconds;
		}
		
		//FUNCTION : GET IS_STARTED BOOL
		public function get isStarted():Boolean {
			return _isStarted;
		}
	}
}