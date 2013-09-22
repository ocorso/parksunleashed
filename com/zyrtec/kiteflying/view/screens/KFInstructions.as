package com.zyrtec.kiteflying.view.screens
{
	import com.bigspaceship.events.AnimationEvent;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	

	public class KFInstructions extends KFAbstractScreen
	{
		
		public function KFInstructions($mc:ScreenInstructionsMC, id:int=0, addBitmapBackground:Boolean=false, width:Number=0, height:Number=0, isTransparent:Boolean=false, color:uint=0)
		{
			super(id, addBitmapBackground, width, height, isTransparent, color);
			view = $mc;
			addChild(view);
			btnPlay = view.btnPlay;
		}
		
		override public function addEvents($ae:AnimationEvent = null):void {
			if (btnPlay!=null) {
				btnPlay.addEventListener(MouseEvent.CLICK,onPlayButtonClick, false, 0, true); 
			}
		}
		
		override public function removeEvents($ae:AnimationEvent = null):void {		
			if (btnPlay!=null) {	
				btnPlay.removeEventListener(MouseEvent.CLICK,onPlayButtonClick); 
			}
			
		}
		

	}
}