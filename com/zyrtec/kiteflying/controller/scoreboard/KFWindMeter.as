package com.zyrtec.kiteflying.controller.scoreboard
{
	import com.bigspaceship.display.StandardInOut;
	import com.bigspaceship.utils.Out;
	import com.zyrtec.kiteflying.view.screens.assets.scoreboard.KFWindMeterView;
	
	import flash.display.MovieClip;
	
	public class KFWindMeter extends StandardInOut
	{
		
		
		// =================================================
		// ================ @Callable
		// =================================================
		public function moveNeedle($n:Number):void{
			Out.status(this, "moveNeedle: "+$n.toString());
			
			//calc rotation based on percentage
			var rot:Number;
			if ($n == 0){
				Out.debug(this, "needle should be zero");
				rot = 33;
				KFWindMeterView(mc).rainbowMC.visible = false;
			}else rot = (180*$n)/100;
			KFWindMeterView(mc).needleMC.rotation = rot;
			
		}//end function
		
		// =================================================
		// ================ @Workers
		// =================================================
		
		// =================================================
		// ================ @Handlers
		// =================================================
		
		// =================================================
		// ================ @Animation
		// =================================================
		
		// =================================================
		// ================ @Getters / Setters
		// =================================================
		
		// =================================================
		// ================ @Interfaced
		// =================================================
		
		// =================================================
		// ================ @Core Handler
		// =================================================
		
		// =================================================
		// ================ @Overrides
		// =================================================
		override protected function _onAnimateInStart():void{
			KFWindMeterView(mc).rainbowMC.visible = true;
		}
		// =================================================
		// ================ @Constructor
		// =================================================

		public function KFWindMeter($mc:MovieClip, $useWeakReference:Boolean=false)
		{
			super($mc, $useWeakReference);
		}
	}
}