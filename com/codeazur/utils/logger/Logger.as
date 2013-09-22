package com.codeazur.utils.logger
{
	import com.codeazur.utils.logger.impl.NullLoggerImpl;
	import com.codeazur.utils.logger.impl.TraceLoggerImpl;

	public class Logger
	{
		private var impl:ILogger;
		private static var _instance:Logger;
		
		public function Logger(_:X) {
			if(!_) { throw(new Error("Don't do this!")); }
			impl = new TraceLoggerImpl();
		}
		
		public static function set implementation(loggerImplementation:ILogger):void {
			Logger.instance.impl = loggerImplementation ? loggerImplementation : new NullLoggerImpl();
		}
		
		public static function log(message:String, ...params):void {
			Logger.instance.impl.log(message, params);
		}
		
		public static function info(message:String, ...params):void {
			Logger.instance.impl.info(message, params);
		}

		public static function warning(message:String, ...params):void {
			Logger.instance.impl.warning(message, params);
		}
		
		public static function error(message:String, ...params):void {
			Logger.instance.impl.error(message, params);
		}
		
		private static function get instance():Logger {
			if(_instance == null) { _instance = new Logger(new X()); }
			return _instance;
		}
	}
}

class X {}
