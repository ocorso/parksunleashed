package com.zyrtec.kiteflying.view.screens.assets
{
	import com.zyrtec.model.MiniGameModel;
	import com.zyrtec.view.Leaderboard;
	
	import flash.display.MovieClip;
	
	public class KFLeaderboard extends Leaderboard
	{
		public function KFLeaderboard(leaderboardClipMC:MovieClip, gameModel:MiniGameModel)
		{
			super(leaderboardClipMC, gameModel);
		}
	}
}