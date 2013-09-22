package com.zyrtec.pianoTuning.view.screens
{
	import com.bigspaceship.events.AnimationEvent;
	import com.g2.gaming.framework.BasicScreen;
	import com.g2.gaming.framework.events.ButtonIdEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class ScreenLevelIn extends BasicScreen
	{
		public function ScreenLevelIn(id:int=0, addBitmapBackground:Boolean=false, width:Number=0, height:Number=0, isTransparent:Boolean=false, color:uint=0)
		{
			super(id, addBitmapBackground, width, height, isTransparent, color);
		}
		
		public function startAnimation():void {
			this.visible = true;
			this.addEventListener(AnimationEvent.COMPLETE, onAnimationComplete, false, 0, true);
			this.gotoAndPlay(2);
		}
		
		private function onAnimationComplete(e:AnimationEvent):void {
			this.gotoAndStop(1);
			this.removeEventListener(AnimationEvent.COMPLETE, onAnimationComplete);
			dispatchEvent(new ButtonIdEvent(ButtonIdEvent.BUTTON_ID, this.id)); 
		}
		
	}
}