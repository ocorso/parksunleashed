package com.zyrtec.kiteflying.view.screens.assets.scoreboard
{
	import com.zyrtec.kiteflying.view.screens.assets.scoreboard.KFScoreboardCounterView;
	import com.zyrtec.kiteflying.view.screens.assets.scoreboard.KFWindMeterView;
	
	import flash.display.MovieClip;
	
	public class KFScoreboardView extends MovieClip
	{
		public var currentScoreMC:KFScoreboardCounterView;
		public var windMeterMC:KFWindMeterView;
		
		public function KFScoreboardView()
		{
			super();
		}
	}
}