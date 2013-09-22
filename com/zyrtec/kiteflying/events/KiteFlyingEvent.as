package com.zyrtec.kiteflying.events
{
	import flash.events.Event;
	
	public class KiteFlyingEvent extends Event
	{
		public var payload:Object;
		
		public function KiteFlyingEvent($type:String, $payload:Object = null, $bubbles:Boolean=false, $cancelable:Boolean=false)
		{
			super($type, $bubbles, $cancelable);
			payload = $payload;
			
		}
	}
}