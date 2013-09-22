package com.zyrtec.dogmatch.video
{
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	import com.theginbin.video.SimpleVideoDisplay;
	import com.zyrtec.dogmatch.events.DogMatchEvent;
	import com.zyrtec.dogmatch.model.DMModel;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class VideoController extends Sprite //TO DO : ADD THE ROPE TO THIS CLIP SINCE IT IS PART OF THIS ACTION
	{
		private var _videoBoy:VideoDogBoyObject;
		private var _videoDog:VideoDogBoyObject;
		private var _rope:MovieClip;
		
		private var _videoCount:int=4; //number of videos to load
		
		private var _model:DMModel;
		
		public function VideoController()
		{
			_model = DMModel.getInstance();
			
			_rope = new RopeMC();
			_rope.x = 468;
			_rope.y = 340;
			addChild(_rope);
			
			_videoBoy = new VideoDogBoyObject(DMModel.VIDEO_BOY_STILL_PATH, DMModel.VIDEO_BOY_BACKWARDS_PATH);
			_videoDog = new VideoDogBoyObject(DMModel.VIDEO_DOG_STILL_PATH, DMModel.VIDEO_DOG_BACKWARDS_PATH);
			
			_videoBoy.x = 235;
			_videoBoy.y = 250;
			addChild(_videoBoy);
			
			_videoDog.x = 544;
			_videoDog.y = 288;
			addChild(_videoDog);
		
		}
		
		public function addEvents():void {
			_videoBoy.addEventListener(DogMatchEvent.VIDEO_LOADED, onVideoLoaded);
			_videoBoy.loadVideos();
		}
		
		public function removeEvents():void {
			
		}
		
		public function playAction(type:String):void {
			if (type=="boy") {
				_videoBoy.playAction();
				_rope.gotoAndPlay("BOY_PULL");
				TweenMax.to(this, 1, {x:"-10"});
			} else {
				_videoDog.playAction();
				_rope.gotoAndPlay("DOG_PULL");
				TweenMax.to(this, 1, {x:"+10"});
			}
		}
		
		private function onVideoLoaded(e:DogMatchEvent):void {
			_videoCount--;
			trace("video count = "+_videoCount);
			if (_videoCount == 0) { //done loading
				_videoDog.removeEventListener(DogMatchEvent.VIDEO_LOADED, onVideoLoaded);
				_videoDog.playLoop();
				_videoBoy.playLoop();
			} else if (_videoCount == 2) { //done loading boy, now load dog
				_videoBoy.removeEventListener(DogMatchEvent.VIDEO_LOADED, onVideoLoaded);
				_videoDog.addEventListener(DogMatchEvent.VIDEO_LOADED, onVideoLoaded);
				_videoDog.loadVideos();
			}
		}
	
		
	}
}