package com.codeazur.utils.logger.impl
{
	import com.codeazur.utils.logger.ILogger;
	
	import flash.events.*;
	import flash.net.XMLSocket;

	public class SOSMaxLoggerImpl implements ILogger
	{
		protected var queue:Array;
		protected var ready:Boolean;
		protected var socket:XMLSocket;
		
		public function SOSMaxLoggerImpl(ip:String = "localhost", port:int = 4444) {
			initialize(ip, port);
		}
		
		public function log(message:String, params:Array):void {
			sendMessage("system", message, params);
		}
		
		public function info(message:String, params:Array):void {
			sendMessage("info", message, params);
		}
		
		public function warning(message:String, params:Array):void {
			sendMessage("warning", message, params);
		}
		
		public function error(message:String, params:Array):void {
			sendMessage("error", message, params);
		}
		
		protected function sendMessage(level:String, message:String, params:Array, isQueued:Boolean = false):void {
			if (socket) {
				if (ready) {
					try {
						socket.send(formatMessage(level, message, params));
					} catch(e:Error) {
					}
				} else {
					queue.push(new QueueItem(level, message, params));
				}
			}
			if(!isQueued && (socket == null || !ready)) {
				trace(formatTraceMessage(level, message, params));
			}
		}

		protected function formatMessage(level:String, message:String, params:Array):String {
			if (params && params.length > 0) { message += ", " + params.join(", "); }
			return "!SOS<showMessage key=\"" + level + "\"><![CDATA[" + message + "]]></showMessage>\n";
		}
		
		protected function formatTraceMessage(level:String, message:String, params:Array):String {
			if (params && params.length > 0) { message += ", " + params.join(", "); }
			switch(level) {
				case "warning":
					message = "--- WARNING --- " + message;
					break;
				case "error":
					message = "### ERROR ### " + message;
					break;
			}
			return message;
		}
		
		protected function initialize(ip:String, port:int):void {
			queue = [];
			ready = false;
			socket = new XMLSocket();
			socket.addEventListener(Event.CONNECT, connectHandler);
			socket.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
			try {
				socket.connect(ip, port);
			} catch (error:SecurityError) {
				handleError("SecurityError in Logger: " + error);
			}
		}
		
		protected function connectHandler(event:Event):void {
			ready = true;
			while (queue.length > 0) {
				var item:QueueItem = queue.shift() as QueueItem;
				sendMessage(item.level, item.message, item.params, true);
			}       
		}
		
		protected function errorHandler(event:ErrorEvent):void {
			handleError("Error in Logger: " + event);
		}
		
		protected function handleError(message:String):void {
			trace(message);
			try {
				socket.close();
			} catch (e:Error) {
			}
			socket = null;
			queue = null;           
		}
	}
}

class QueueItem
{
	public var level:String;
	public var message:String;
	public var params:Array;

	public function QueueItem(level:String, message:String, params:Array) {
		this.level = level;
		this.message = message;
		this.params = params;
	}
}
