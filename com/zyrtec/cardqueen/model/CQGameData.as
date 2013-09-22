package com.zyrtec.cardqueen.model
{
	import com.zyrtec.interfaces.IGameData;
	import com.zyrtec.model.vo.MiniGameData;

	public dynamic class CQGameData extends MiniGameData implements IGameData
	{
		
		public function CQGameData($o:Object)
		{
			super($o);
		}
	}
}