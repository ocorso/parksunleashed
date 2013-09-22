package com.zyrtec.kiteflying.view.screens
{
	import com.bigspaceship.display.StandardInOut;
	import com.bigspaceship.utils.Out;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	
	import flash.display.MovieClip;
	
	public class Background extends StandardInOut
	{
		override protected function _onAnimateInStart():void{
			TweenMax.to(mc, 0.4, {y:45, delay:0.4, ease:Back.easeOut});
		}
		override protected function _onAnimateOutStart():void{

			TweenMax.to(mc, 0.4, {y:-mc.height, delay:0.4, ease:Back.easeOut});
		}
		public function Background($mc:MovieClip, $useWeakReference:Boolean=false)
		{
			super($mc, $useWeakReference);

		}//end constructor
		
	}
}