package com.zyrtec.model.vo
{
	import com.bigspaceship.utils.Out;
	import com.zyrtec.interfaces.IGameData;

	public dynamic class MiniGameData implements IGameData
	{
		/**
		 * 
		 * 		 * @param  gamedata: - Object
		 * 			{
		 *              uid: string user id
		 *              sid: string session id
		 *              cdn: string URL for CDN to retrieve files
		 *              hasDog: boolean asserting if user has dog for use in game
		 * 				isArcadeMode: bool, denotes whether the game is in the initial experience or not
		 * 			};
		 * **/
		
		protected var _uid			:String = "-1";
		protected var _sid			:String = "-1";
		protected var _gid			:String = "-1";
		protected var _name			:String = "";
		protected var _cdn			:String	= "";//http://c679303.r3.cf2.rackcdn.com/main/game/L1/
		protected var _isArcadeMode	:Boolean = false;
		protected var _shareURL		:String = "http://www.youtube.com/parksunleashed";
		protected var _badgeURL		:String = "http://c679303.r3.cf2.rackcdn.com/main/game/L1/assets/images/highFlyerBadge.jpg";
		
		public function MiniGameData($o:Object)
		{
			Out.warning(this, "ok, we got some gameData: ");
			if ($o.hasOwnProperty("badgeURL") && $o.badgeURL != null && $o.badgeURL != undefined) 		Out.debug(this, "badgeURL: "+ $o.badgeURL);
			if ($o.hasOwnProperty("uid") && $o.uid != null && $o.uid != undefined) 						this.uid 		= $o.uid;
			if ($o.hasOwnProperty("sid") && $o.sid != null && $o.sid != undefined)						this.sid 		= $o.sid;
			if ($o.hasOwnProperty("gid") && $o.gid != null && $o.gid != undefined)						this.gid 		= $o.gid;
			if ($o.hasOwnProperty("name") && $o.name != null && $o.name != undefined)					this.name 		= $o.name;
			if ($o.hasOwnProperty("cdn") && $o.cdn != null && $o.cdn != undefined)						this.cdn 		= $o.cdn;
			if ($o.hasOwnProperty("shareURL") && $o.shareURL != null && $o.shareURL != undefined) 		this.shareURL 	= $o.shareURL;
			if ($o.hasOwnProperty("badgeURL") && $o.badgeURL != null && $o.badgeURL != undefined) 		this.badgeURL 	= $o.badgeURL;
			
		}//end constructor

		public function get uid():String
		{
			return _uid;
		}

		public function set uid(value:String):void
		{
			_uid = value;
		}
		public function get sid():String
		{
			return _sid;
		}

		public function set sid(value:String):void
		{
			_sid = value;
		}


		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}
		public function get gid():String
		{
			return _gid;
		}

		public function set gid(value:String):void
		{
			_gid = value;
		}

		public function get cdn():String
		{
			return _cdn;
		}

		public function set cdn(value:String):void
		{
			_cdn = value;
		}

		public function get isArcadeMode():Boolean
		{
			return _isArcadeMode;
		}

		public function set isArcadeMode(value:Boolean):void
		{
			_isArcadeMode = value;
		}

		public function get shareURL():String
		{
			return _shareURL;
		}

		public function set shareURL(value:String):void
		{
			_shareURL = value;
		}
		
		public function get badgeURL():String
		{
			return _badgeURL;
		}
		
		public function set badgeURL(value:String):void
		{
			_badgeURL = value;
		}
		
		public function toString():String{
			Out.debug(this, "--------------------------------");
			Out.warning(this, "badgeURL : "		+badgeURL);	
			Out.warning(this, "cdn : "			+cdn);	
			Out.warning(this, "gid : "			+gid);	
			Out.warning(this, "isArcadeMode : "	+isArcadeMode);	
			Out.warning(this, "name : "			+name);	
			Out.warning(this, "shareURL : "		+shareURL);	
			Out.warning(this, "sid : "			+sid);	
			Out.warning(this, "uid : "			+uid);	
			Out.debug(this, "---------------------------------");
			
			return "MiniGameData.toString";
		}


	}//end class
}//end package