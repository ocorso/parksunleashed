﻿package com.zyrtec.baseballmemory.model{	import com.zyrtec.interfaces.IGameData;	import com.zyrtec.model.vo.MiniGameData;	public dynamic class BMGameData extends MiniGameData implements IGameData	{				public var showQuiz:Boolean = false;		public var hasDogBonus:Boolean = false;		public var hasFriendBonus:Boolean = false;				public function BMGameData($o:Object)		{			super($o);			if ($o.hasOwnProperty("showQuiz") && $o.showQuiz != null && $o.showQuiz != undefined) this.showQuiz = $o.showQuiz;						if ($o.hasOwnProperty("hasDogBonus") && $o.hasDogBonus != null && $o.hasDogBonus != undefined) this.hasDogBonus = $o.hasDogBonus;						if ($o.hasOwnProperty("hasFriendBonus") && $o.hasFriendBonus != null && $o.hasFriendBonus != undefined) this.hasFriendBonus = $o.hasFriendBonus;		}	}}