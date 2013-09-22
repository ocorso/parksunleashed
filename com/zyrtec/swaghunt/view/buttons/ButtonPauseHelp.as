package com.zyrtec.swaghunt.view.buttons
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;

	public class ButtonPauseHelp extends MovieClip
	{
		public var txtPause:MovieClip;
		
		public function ButtonPauseHelp()
		{
			super();
			gotoAndStop("OFF");
		}
		
		public function addEvents():void {
			this.buttonMode = true;
			//this.addEventListener(MouseEvent.CLICK,onPauseClick, false, 0, true);
			this.addEventListener(MouseEvent.ROLL_OVER,onPauseRoll, false, 0, true);
			this.addEventListener(MouseEvent.ROLL_OUT,onPauseRollOut, false, 0, true);
		}
		
		public function removeEvents():void {
			this.buttonMode = false;
			//this.removeEventListener(MouseEvent.CLICK,onPauseClick);
			this.removeEventListener(MouseEvent.ROLL_OVER,onPauseRoll);
			this.removeEventListener(MouseEvent.ROLL_OUT,onPauseRollOut);
			gotoAndStop("OFF");
			TweenMax.to(this, 0.4, {scaleX:1, scaleY:1, ease:Back.easeOut});
		}
		
		private function onPauseClick(e:MouseEvent):void {  
			//removeEvents();
         	//dispatchEvent(new Event("PAUSE")); 
      	} 
      	
      	private function onPauseRoll(e:MouseEvent):void {  
      		gotoAndStop("OVER");
      		TweenMax.to(this, 0.4, {scaleX:1.05, scaleY:1.05, ease:Back.easeOut});
      	}
      	
      	private function onPauseRollOut(e:MouseEvent):void {  
      		gotoAndStop("OFF");
      		TweenMax.to(this, 0.4, {scaleX:1, scaleY:1, ease:Back.easeOut});
      	}
		
	}
}