package com.codeazur.utils.logger.impl
{
	import com.codeazur.utils.logger.ILogger;

	public class NullLoggerImpl implements ILogger
	{
		public function log(message:String, params:Array):void {}
		public function info(message:String, params:Array):void {}
		public function warning(message:String, params:Array):void {}
		public function error(message:String, params:Array):void {}
	}
}