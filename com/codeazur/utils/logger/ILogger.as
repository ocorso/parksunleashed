package com.codeazur.utils.logger
{
	public interface ILogger
	{
		function log(message:String, params:Array):void;
		function info(message:String, params:Array):void;
		function warning(message:String, params:Array):void;
		function error(message:String, params:Array):void;
	}
}