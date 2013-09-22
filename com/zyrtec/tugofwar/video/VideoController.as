﻿package com.zyrtec.tugofwar.video{	import com.greensock.TweenMax;	import com.greensock.easing.*;	import com.greensock.plugins.*;	import com.theginbin.video.SimpleVideoDisplay;	import com.zyrtec.tugofwar.events.TugOfWarEvent;	import com.zyrtec.tugofwar.model.TOWModel;		import flash.display.MovieClip;	import flash.display.Sprite;	import flash.events.EventDispatcher;	import flash.events.IEventDispatcher;	import flash.geom.Point;		public class VideoController extends Sprite 	{		private var _videoBoy:VideoDogBoyObject;		private var _videoDog:VideoDogBoyObject;		private var _rope:MovieClip;				private var _videoCount:int=4; //number of videos to load		private var _bandanaXPos:Number;//check this value before playing a pattern and after an error to determine the game over				private var _model:TOWModel;				public function VideoController()		{			_model = TOWModel.getInstance();						_rope = new RopeMC();			_rope.x = 468;			_rope.y = 340;			_rope.alpha = 0;			addChild(_rope);						_videoBoy = new VideoDogBoyObject(_model.cdn+TOWModel.VIDEO_BOY_STILL_PATH, _model.cdn+TOWModel.VIDEO_BOY_BACKWARDS_PATH);			_videoDog = new VideoDogBoyObject(_model.cdn+TOWModel.VIDEO_DOG_STILL_PATH, _model.cdn+TOWModel.VIDEO_DOG_BACKWARDS_PATH);						_videoBoy.x = 235;			_videoBoy.y = 250;			_videoBoy.alpha = 0;			_videoBoy.type = "boy";			addChild(_videoBoy);						_videoDog.x = 544;			_videoDog.y = 288;			_videoDog.alpha = 0;			_videoDog.type = "dog";			addChild(_videoDog);					}				public function reset():void {			this.x = 0;			var point:Point=new Point(_rope.bandana.x,_rope.bandana.y);			point=localToGlobal(point);			_bandanaXPos = point.x;		}				public function addEvents():void {			if (_videoCount!=0) { //load em				_videoBoy.addEventListener(TugOfWarEvent.VIDEO_LOADED, onVideoLoaded);				_videoBoy.loadVideos();			} else { //play em				_videoDog.playLoop();				_videoBoy.playLoop();				_rope.gotoAndPlay(2);			}		}				public function removeEvents():void {			_videoBoy.removeEvents();			_videoDog.removeEvents();			_rope.gotoAndStop(1);		}				public function destroyVideos():void {			_videoBoy.destroy();			_videoDog.destroy();		}				public function playAction(type:String):void {			if (type=="boy") {				_videoBoy.playAction();				_rope.gotoAndPlay("BOY_PULL");				if (_model.isDebugMode) {					TweenMax.to(this, 1, {x:"-15"});				} else {					TweenMax.to(this, 1, {x:"-3"}); //-3				}			} else {				_videoDog.playAction();				_rope.gotoAndPlay("DOG_PULL");				if (_model.isDebugMode) {					TweenMax.to(this, 1, {x:"+100"});				} else {					TweenMax.to(this, 1, {x:"+20"}); //+10				}							}			updateBandana();			TweenMax.delayedCall(1, updateBandana);		}				private function onVideoLoaded(e:TugOfWarEvent):void {			_videoCount--;			trace("video count = "+_videoCount);			if (_videoCount == 0) { //done loading				_videoDog.removeEventListener(TugOfWarEvent.VIDEO_LOADED, onVideoLoaded);				TweenMax.to(_rope, 0.2, {alpha:1});				TweenMax.to(_videoDog, 0.2, {alpha:1});				TweenMax.to(_videoBoy, 0.2, {alpha:1});				_videoDog.playLoop();				_videoBoy.playLoop();			} else if (_videoCount == 2) { //done loading boy, now load dog				_videoBoy.removeEventListener(TugOfWarEvent.VIDEO_LOADED, onVideoLoaded);				_videoDog.addEventListener(TugOfWarEvent.VIDEO_LOADED, onVideoLoaded);				_videoDog.loadVideos();			}		}				private function updateBandana():void {			//convert local x to global			var point:Point=new Point(_rope.bandana.x,_rope.bandana.y);			point=localToGlobal(point);			_bandanaXPos = point.x;		//	trace("ROPE X POS = "+point.x);			//if rope is great than 70px -- dog wins			//if rope is less than -80px -- human wins			//if (_bandanaXPos >50) {				//_rope.bandana.gotoAndPlay("BLINK");				//TweenMax.to(_rope.bandana, 0.3, {glowFilter:{color:0xFF3333, alpha:0.7, blurX:10, blurY:10, strength:4}, yoyo:true, repeat:5});			//} //else {				//TweenMax.to(_rope.bandana, 0.3, {glowFilter:{color:0xFF3333, alpha:0, blurX:0, blurY:0, strength:0}, overwrite:true});			//}		}				public function get bandanaXPos():Number {			return _bandanaXPos;		}			}}