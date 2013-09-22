package com.zyrtec.kiteflying.events
{
	import com.zyrtec.kiteflying.model.vo.KFScoreboardValueObject;
	
	import flash.events.Event;
	
	public class KFScoreboardUpdateEvent extends Event
	{
		public var payload:KFScoreboardValueObject;
		
		public function KFScoreboardUpdateEvent(type:String, $pl:KFScoreboardValueObject, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			payload = $pl;
		}
	}
}