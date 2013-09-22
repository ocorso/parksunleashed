package com.zyrtec.tugofwar.view.screens
{
	import com.g2.gaming.framework.BasicScreen;
	import com.g2.gaming.framework.events.ButtonIdEvent;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;

	import com.theginbin.ui.RollOverButton;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class ScreenBase extends BasicScreen
	{
		public var btnPlay:MovieClip;

		public function ScreenBase(id:int=0, addBitmapBackground:Boolean=false, width:Number=0, height:Number=0, isTransparent:Boolean=false, color:uint=0)
		{
			super(id, addBitmapBackground, width, height, isTransparent, color);
		}

		public function addEvents():void
		{
			if (btnPlay!=null) {
				RollOverButton(btnPlay).addEvents();
				btnPlay.addEventListener(MouseEvent.CLICK,onPlayButtonClick, false, 0, true); 
			}
		}

		public function removeEvents():void
		{		
			if (btnPlay!=null) {	
				RollOverButton(btnPlay).removeEvents();		
          		btnPlay.removeEventListener(MouseEvent.CLICK,onPlayButtonClick); 
   			}
		}

      	private function onPlayButtonClick(e:MouseEvent):void
		{  
      		removeEvents();
         	dispatchEvent(new ButtonIdEvent(ButtonIdEvent.BUTTON_ID, this.id)); 
      	}

	}
}