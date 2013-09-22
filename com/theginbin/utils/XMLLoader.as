package com.theginbin.utils {
	
	import com.theginbin.events.XMLLoaderEvent;
	
	import flash.errors.*;
	import flash.events.*;
	import flash.net.*;
	
	public class XMLLoader extends EventDispatcher{

		private var _loader:URLLoader;
		private var _url:String;
		private var _data:XML;
		private var _message:String;

		///FUNCTION : CONSTRUCTOR
		public function XMLLoader (){
			//trace("XMLLoader");
			
			_loader = new URLLoader();
			_loader.dataFormat = URLLoaderDataFormat.TEXT;
			_loader.addEventListener(Event.COMPLETE, completeHandler);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);			
		};
		
		///FUNCTION : LOAD XML PATH
		public function load (url:String):void{
			//trace("XMLLoader: load");
			_url = url;
			_loader.load(new URLRequest(_url));
		};
		
		/////////////////////
		////EVENT HANDLERS////////
		///////////////////
		
		///FUNCTION : ON XML LOAD COMPLETE
		private function completeHandler(event:Event):void{
			//trace("XMLLoader: completeHandler");
			
			try {
				_data = new XML( event.target.data );
				
			} catch ( event:TypeError ) {
				// Downloaded text could not be converted to XML instance
				trace("!!! XMLLoader: "+ event.message);
				return;
			}
			
			this.dispatchEvent(new XMLLoaderEvent(XMLLoaderEvent.COMPLETE));
		}
		
		///FUNCTION : HANDLE LOAD ERROR
		private function ioErrorHandler(event:Event):void{
			//trace("XMLLoader: ioErrorHandler");
			
			_message = "!!! XMLLoader: IO ERROR loading "+ _url;
		
			this.dispatchEvent(new XMLLoaderEvent(XMLLoaderEvent.ERROR));
		}
		
		///FUNCTION : HANDLE SECRUITY ERROR
		private function securityErrorHandler(event:Event):void{
			//trace("XMLLoader: securityErrorHandler");
			
			_message = "!!! XMLLoader: SECURITY ERROR loading "+ _url;
			this.dispatchEvent(new XMLLoaderEvent(XMLLoaderEvent.ERROR));
		}
		
		///GETTERS / SETTERS
		public function set data(value:XML):void { 
			_data = value;
		};
		
		public function get data():XML {
			return _data; 
		};
		
		public function set message(value:String):void { 
			_message = value; 
		};
		
		public function get message():String { 
			return _message; 
		};
	};
};