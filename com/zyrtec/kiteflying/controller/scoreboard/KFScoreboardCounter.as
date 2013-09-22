package com.zyrtec.kiteflying.controller.scoreboard
{
	import com.bigspaceship.display.StandardInOut;
	import com.bigspaceship.utils.Out;
	import com.zyrtec.kiteflying.view.screens.assets.scoreboard.KFScoreboardCounterView;
	
	import flash.display.MovieClip;
	import flash.text.TextField;

	public class KFScoreboardCounter extends StandardInOut
	{
		
		
		// =================================================
		// ================ @Callable
		// =================================================
		public function setScore($s:String):void{
			//Out.status(this, "setScore: " +$s);
			mc.scoreMC.tf.text 			= $s;
		}
		public function setHiScore($s:String):void{
			//Out.status(this, "setScore: " +$s);
			mc.hiScoreMC.tf.text 			= $s;
		}
		
		// =================================================
		// ================ @Constructor
		// =================================================

		public function KFScoreboardCounter($mc:MovieClip)
		{
			super($mc);
		}
	}
}