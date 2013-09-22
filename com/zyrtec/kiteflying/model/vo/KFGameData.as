package com.zyrtec.kiteflying.model.vo
{
	import com.zyrtec.kiteflying.model.KFModel;
	import com.zyrtec.model.vo.MiniGameData;
	
	public dynamic class KFGameData extends MiniGameData
	{
		protected var _highScore:Number;
		
		public function KFGameData($o:Object)
		{
			super($o);
			if ($o.hasOwnProperty("highScore") && $o.highScore != null && $o.highScore != undefined) this.highScore = $o.highScore;
			else highScore = KFModel.DEFAULT_MAX_SCORE;
		}
		public function get highScore():Number{
			return _highScore as Number;
		}
		public function set highScore($hs):void{
			_highScore = $hs as Number;
		}
	}
}