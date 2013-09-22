package com.zyrtec.findthebones.model
{
	import com.zyrtec.interfaces.IGameData;
	import com.zyrtec.model.vo.MiniGameData;

	public dynamic class FTBGameData extends MiniGameData implements IGameData
	{
		
		public function FTBGameData($o:Object)
		{
			super($o);
		}
	}
}