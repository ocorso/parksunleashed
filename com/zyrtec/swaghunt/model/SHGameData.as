package com.zyrtec.swaghunt.model
{
	import com.zyrtec.interfaces.IGameData;
	import com.zyrtec.model.vo.MiniGameData;

	public dynamic class SHGameData extends MiniGameData implements IGameData
	{
		
		public function SHGameData($o:Object)
		{
			super($o);
		}
	}
}