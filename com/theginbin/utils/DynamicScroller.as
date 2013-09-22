/*
Dynamic Scroller Util
author: gina@theginbin.com
*/

package com.theginbin.utils {
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	
	public class DynamicScroller extends MovieClip {
		
		public var track_mc:MovieClip;
		public var handle_mc:MovieClip;
		
		private var _objectToScroll:*;
		private var _maskClip:MovieClip;
		private var _mask:Sprite;
		private var _xPadding:Number;
		private var _yPadding:Number;
		private var _scrolling:Boolean; //whether autoscroll is active
		private var _minScroll:Number;
		private var _maxScroll:Number;
		private var _dragging:Boolean;
		private var _aspectRatio:Number;
		private var _maxDragPos:Number;
		private var _autoMask:Boolean;
		private var _hit:Sprite; //hit state for handle in case it's very thin
		
		//CONSTRUCTOR
		public function DynamicScroller() {
			_xPadding = 0;
			_yPadding = 0;
			this.visible = false; //SHOW/HIDE IS DEFAULT, will only appear if there is something to scroll (set to true if scroller should remain on screen always)
			_dragging = false;
		}
		
		//FUNCTION : CREATE MASK OVER CONTENT
		private function setMask():void {
			if (_autoMask) { //create a mask
				if (_mask) {
					removeChild(_mask);
					_mask = null;
				}
				_mask = new Sprite();
				_mask.graphics.beginFill(0xFFFFFF, 1);
				_mask.graphics.drawRect(0, 0, _objectToScroll.width+95, track_mc.height);
				_mask.graphics.endFill();
				_mask.x -= _objectToScroll.width+90; // SPACE B/W OBJECT AND SCROLLBAR, adjust accordingly
				_mask.y = 0;
				addChild(_mask);
				
				_objectToScroll.mask = _mask;
			} else {
				_objectToScroll.mask = _maskClip; //pre-defined external mask
			}
			showHideScroll();
		}
		
		//FUNCTION : SHOW/HIDE SCROLLER
		private function showHideScroll():void {
			if (_objectToScroll.height > this.height) {
				this.visible = true;
			} else {
				this.visible = false;
			}
			initScroll();
		}
		
		//FUNCTION : SET INIT SCROLL VALUES & EVENTS
		private function initScroll():void {
			//readjust height of hit state first so it doesn't affect resize of handle on reset
			if(_hit != null) {
				_hit.height = 0;
			}
			//UNCOMMENT THIS LINE TO ADJUST THE SCROLL HANDLE HEIGHT BASED ON THE HEIGHT OF THE SCROLLING OBJECT (adjust the minimum height value accordingly)
			//handle_mc.height = 500 * ((this.height + _yPadding)/_objectToScroll.height);
			_minScroll = _objectToScroll.y;
			_maxScroll = _objectToScroll.height - (this.height) + _yPadding; //adding 80 to height to compensate for gradiated mask covering up text
			_maxDragPos = this.height-(handle_mc.height + _yPadding*2);
			_aspectRatio = _maxDragPos / _maxScroll;
			
			if (_hit == null) {
				_hit = new Sprite();
				_hit.graphics.beginFill(0xFFFFFF, 0);
				_hit.graphics.drawRect(-10, 0, handle_mc.width+20, handle_mc.height);
				_hit.graphics.endFill();
			} else {
				_hit.height = handle_mc.height;
			}
			handle_mc.buttonMode = true;
			handle_mc.addChild(_hit);
			handle_mc.addEventListener(MouseEvent.MOUSE_DOWN, onHandleDown);
			track_mc.buttonMode = true;
			track_mc.addEventListener(MouseEvent.CLICK, onTrackClick);
		}
		
		//FUNCTION : START DRAGGING
		private function onHandleDown(event:MouseEvent=null):void {
			if (_scrolling) {
				stopAutoScroll();
			}
			_dragging = true;
			stage.addEventListener(MouseEvent.MOUSE_UP, onHandleUp);				
			this.addEventListener(Event.ENTER_FRAME, onHandleMove);
			handle_mc.startDrag(false, new Rectangle(_xPadding, _yPadding, 0, _maxDragPos));
		}
		
		//FUNCTION : STOP DRAGGING
		private function onHandleUp(event:MouseEvent=null):void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, onHandleUp);
			this.removeEventListener(Event.ENTER_FRAME, onHandleMove);
			
			handle_mc.stopDrag();
			_dragging = false;
		}
		
		//FUNCTION : MOVE CONTENT ON DRAG HANDLE
		private function onHandleMove(event:Event = null):void {
			var distDrag:Number = Math.round((handle_mc.y - _yPadding) / _aspectRatio);

			if (_dragging) {
				//_objectToScroll.y = _minScroll - distDrag; //FOR NO EASING, but seriously who doesn't want some easing
				var draggy:Number = _minScroll - distDrag;
				TweenLite.to(_objectToScroll, 1.3, {y:draggy, ease:Quart.easeOut});
			}
			
		}
		
		//FUNCTION : MOVE CONTENT ON CLICK TRACK PAD
		private function onTrackClick(event:MouseEvent = null):void {
			if (_scrolling) {
				stopAutoScroll();
			}
			_dragging = true;
			if ((track_mc.mouseY - ((handle_mc.height - _yPadding)/2)) <= _yPadding) {
				handle_mc.y = _yPadding;
			} else if (track_mc.mouseY >= _maxDragPos) {
				handle_mc.y = this.height-(handle_mc.height + _yPadding);
			} else {
				 handle_mc.y = track_mc.mouseY - ((handle_mc.height - _yPadding)/2);
			}
			onHandleMove();
		}
		
		//FUNCTION : AUTO SCROLL
		private function scrollObject(event:Event):void {
			// speed autoScrolling moves
			handle_mc.y += 0.5;
			
			var distDrag:Number = Math.round((handle_mc.y - _yPadding) / _aspectRatio);

			if (_scrolling) {
				_objectToScroll.y = _minScroll - distDrag;
			}

			if (handle_mc.y >= _maxDragPos) {
				stopAutoScroll();
			}
			
		}
		
		//FUNCTION : ENABLE AUTO-SCROLL CONTENT
		private function enableAutoScroll(event:TimerEvent):void {
			_scrolling = true;
			this.addEventListener(Event.ENTER_FRAME, scrollObject);
		}
		
		//FUNCTION : CUE TIMED DELAY OF AUTO-SCROLL
		public function startAutoScroll():void {
			var timer:Timer = new Timer(1500, 1);
			timer.addEventListener(TimerEvent.TIMER, enableAutoScroll);
			timer.start();
		}
		
		//FUNCTION : DISABLE AUTO-SCROLL CONTENT
		public function stopAutoScroll():void {
			_scrolling = false;
			this.removeEventListener(Event.ENTER_FRAME, scrollObject);
		}
		
		//FUNCTION : RESET HANDLE AND CONTENT POSITIONING
		public function resetScroller():void { //function to reset handle and content to start position (e.g. after closing/opening a dropdown menu)
			if (objectToScroll != null) {
				handle_mc.y = _yPadding;
				objectToScroll.y = _minScroll;
				if (_autoMask) {
					removeChild(_mask);
					_mask = null;
				}
			}
		}
		
		//GET / SET VARS
		public function get xPadding():Number {
			return _xPadding;
		}
		
		public function set xPadding(value:Number):void {
			_xPadding = value;
		}
		
		public function get yPadding():Number {
			return _yPadding;
		}
		
		public function set yPadding(value:Number):void {
			_yPadding = value;
		}
		
		public function set maskClip(value:MovieClip):void {
			_maskClip = value;
		}
		
		public function get objectToScroll():* {
			return _objectToScroll;
		}
		
		public function set objectToScroll(value:*):void {
			_objectToScroll = value;
			if (_maskClip == null) {
				_autoMask = true;
			} else {
				_autoMask = false;
			}
			setMask();
		}
	}
}