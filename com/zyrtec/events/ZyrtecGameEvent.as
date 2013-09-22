package com.zyrtec.events
{
	import flash.events.Event;
	
	// =================================================
	// ================ @Class
	// =================================================
	public class ZyrtecGameEvent extends Event
	{
		public static const LOG_IN:String = "logIn";
		public static const SIGN_UP:String = "signUp";
		public static const PLAY_AGAIN:String = "playAgain";
		public static const BACK_TO_PARK:String = "backtoPark";
		public static const FACEBOOK_SHARE:String = "facebookShare";
		public static const ON_LEADERBOARD_RESULT:String = "leaderboardResultsIn";
		
		public var data:*
		
		// =================================================
		// ================ @Constructor
		// =================================================
		public function ZyrtecGameEvent(type:String, data:*=null){
			super(type);
			this.data = data;
		}
		
		// =================================================
		// ================ @Callable
		// =================================================
		override public function clone():Event {
			return new ZyrtecGameEvent(this.type);
		} 
	}
}