package com.zyrtec.interfaces
{
	public interface IGameData
	{
		function toString():String;
		function get uid():String;
		function set uid(value:String):void;
		function get sid():String;
		function set sid(value:String):void;
		function get gid():String;
		function set gid(value:String):void;
		function get name():String;
		function set name(value:String):void;
		function get cdn():String;
		function set cdn(value:String):void;
		function get isArcadeMode():Boolean;
		function set isArcadeMode(value:Boolean):void;
		function get shareURL():String;
		function set shareURL(value:String):void;
		function get badgeURL():String;
		function set badgeURL(value:String):void;
	}
}	