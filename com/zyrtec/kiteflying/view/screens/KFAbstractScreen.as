package com.zyrtec.kiteflying.view.screens
{
	import com.bigspaceship.display.StandardInOut;
	import com.bigspaceship.events.AnimationEvent;
	import com.g2.gaming.framework.BasicScreen;
	import com.g2.gaming.framework.events.ButtonIdEvent;
	import com.greensock.easing.*;
	import com.theginbin.ui.RollOverButton;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import com.zyrtec.interfaces.IScreen;
	
	public class KFAbstractScreen extends BasicScreen implements IScreen
	{
		protected var _view:MovieClip;
		public var std:StandardInOut;
		
		public var btnPlay:MovieClip;
		
		public function KFAbstractScreen(id:int=0, addBitmapBackground:Boolean=false, width:Number=0, height:Number=0, isTransparent:Boolean=false, color:uint=0)
		{
			super(id, addBitmapBackground, width, height, isTransparent, color);
		}
		
		public function addEvents($ae:AnimationEvent = null):void {
			if (btnPlay!=null) {
				RollOverButton(btnPlay).addEvents();
				btnPlay.addEventListener(MouseEvent.CLICK,onPlayButtonClick, false, 0, true); 
			}
		}
		
		public function removeEvents($ae:AnimationEvent = null):void {		
			if (btnPlay!=null) {	
				RollOverButton(btnPlay).removeEvents();		
				btnPlay.removeEventListener(MouseEvent.CLICK,onPlayButtonClick); 
			}
			
		}
		public function animateIn():void{}
		public function animateOut():void{}
		
		protected function onPlayButtonClick(e:MouseEvent):void {  
			removeEvents();
			dispatchEvent(new ButtonIdEvent(ButtonIdEvent.BUTTON_ID, this.id)); 
			
		} 

		public function get view():MovieClip
		{
			return _view;
		}

		public function set view(value:MovieClip):void
		{
			_view = value;
		}
		
		
	}
}