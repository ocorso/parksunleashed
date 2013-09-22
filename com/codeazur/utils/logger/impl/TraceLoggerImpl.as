package com.codeazur.utils.logger.impl
{
	import com.codeazur.utils.logger.ILogger;

	public class TraceLoggerImpl implements ILogger
	{
		public function log(message:String, params:Array):void {
			trace(message, params);
		}
		
		public function info(message:String, params:Array):void {
			trace(message, params);
		}
		
		public function warning(message:String, params:Array):void {
			trace("WARNING", message, params);
		}
		
		public function error(message:String, params:Array):void {
			trace("### ERROR ###", message, params);
		}
	}
}