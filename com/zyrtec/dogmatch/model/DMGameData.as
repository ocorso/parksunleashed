package com.zyrtec.dogmatch.model
{
	import com.zyrtec.interfaces.IGameData;
	import com.zyrtec.model.vo.MiniGameData;

	public dynamic class DMGameData extends MiniGameData implements IGameData
	{
		
		public function DMGameData($o:Object)
		{
			super($o);
		}
	}
}