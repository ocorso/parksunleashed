package com.zyrtec.pianoTuning.model
{
	import com.bigspaceship.utils.Out;
	import com.zyrtec.interfaces.IGameData;
	import com.zyrtec.model.vo.MiniGameData;

	public dynamic class PTGameData extends MiniGameData implements IGameData
	{
		
		public var showQuiz			:Boolean = false;
		public var hasDogBonus		:Boolean = false;
		public var hasFriendBonus	:Boolean = false;		public var numLives			:uint;
		
		public function PTGameData($o:Object)
		{
			super($o);
			this.numLives = $o.numLives;
		}

	}
}