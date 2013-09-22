package com.zyrtec.kiteflying.events
{
	import flash.events.Event;
	
	public class PauseEvent extends Event
	{
		public static const PAUSE	:String = "pause";
		
		public function PauseEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}