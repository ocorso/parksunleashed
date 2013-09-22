package com.zyrtec.dogmatch.video
{
	import com.theginbin.events.MediaEvent;
	import com.theginbin.video.SimpleVideoDisplay;
	import com.zyrtec.dogmatch.events.DogMatchEvent;
	
	import flash.display.Sprite;
	
	public class VideoDogBoyObject extends Sprite
	{
		private var _pathLoop:String;
		private var _pathAction:String;
		private var _videoLoop:SimpleVideoDisplay;
		private var _videoAction:SimpleVideoDisplay;
		private var _isLooping:Boolean; 
		private var _videoCount:int; //sequence the load of the videos
		
		public function VideoDogBoyObject(pathLoop:String, pathAction:String)
		{
			_pathLoop = pathLoop;
			_pathAction = pathAction;
			_videoCount = 0;
		}
		
		public function loadVideos():void {
			if (_videoCount==0) {
				_videoLoop = new SimpleVideoDisplay();	
				//_videoLoop.setVideoSize(900, 850);
				addChild(_videoLoop);
			//	_videoLoop.setBuffer(2);
				_videoLoop.addEventListener(MediaEvent.BUFFER_FULL, onBufferFull);
				_videoLoop.addEvents();
				_videoLoop.visible = false;
				_videoLoop.url = _pathLoop;
			} else {
				_videoAction = new SimpleVideoDisplay();	
				//_videoAction.setVideoSize(1080, 700);
				addChild(_videoAction);
			//	_videoAction.setBuffer(2);
				_videoAction.addEventListener(MediaEvent.BUFFER_FULL, onBufferFull);
				//_videoAction.addEventListener(MediaEvent.BUFFER_FULL, onBufferFull);
				_videoAction.addEvents();
				_videoAction.visible = false;
				_videoAction.url = _pathAction;
			}
		}
		
		public function playLoop():void {
			_isLooping = true;
			_videoLoop.visible = true;
			_videoLoop.addEventListener(MediaEvent.COMPLETE, onLoopComplete);
			_videoLoop.seek(0);
			_videoLoop.play(); 
		}
		
		public function playAction():void {
			_isLooping = false;
			_videoLoop.visible = false;
			_videoAction.visible = true;
			_videoAction.addEventListener(MediaEvent.COMPLETE, onActionComplete);
			_videoAction.seek(0);
			_videoAction.play(); 
		}
		
		public function addEvents():void {

		}
		
		public function removeEvents():void {
			
		}
		
		///FUNCTION : ON BUFFER FULL - hide controls, enable rollover show/hide controls
		private function onBufferFull(event:MediaEvent):void {
			trace("***************&&&&&&&&&& BUFFER FULL WORK &&&&&&&&&&&&&&");
			if (_videoCount==0) {
				_videoLoop.removeEventListener(MediaEvent.BUFFER_FULL, onBufferFull);
				_videoCount++;
				//_videoLoop.seek(0);
				_videoLoop.pause();
				this.dispatchEvent(new DogMatchEvent(DogMatchEvent.VIDEO_LOADED));
				loadVideos();
			} else {
				//_videoAction.removeEventListener(MediaEvent.BUFFER_FULL, onBufferFull);
				_videoAction.removeEventListener(MediaEvent.BUFFER_FULL, onBufferFull);
				//_videoAction.seek(0);
				_videoAction.pause();
				this.dispatchEvent(new DogMatchEvent(DogMatchEvent.VIDEO_LOADED));
			}
			
		}
		
		/// FUNCTION : HANDLE LOOP VIDEO COMPLETE
		private function onLoopComplete(event:MediaEvent):void {
			if (_isLooping) {
				_videoLoop.seek(0);
				_videoLoop.play(); //resumes
			}
		}
		
		/// FUNCTION : HANDLE ACTION VIDEO COMPLETE
		private function onActionComplete(event:MediaEvent):void {
			_videoAction.removeEventListener(MediaEvent.COMPLETE, onActionComplete);
			_videoAction.visible = false;
			_isLooping = true;
			playLoop();
		}
		
		public function set isLooping(value:Boolean):void { _isLooping = value; };
	}
}