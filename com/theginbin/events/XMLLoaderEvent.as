package com.theginbin.events{

	import flash.events.Event;
    
    public class XMLLoaderEvent extends Event 
    {
        public static const COMPLETE:String = "XMLLoaderCompleteEvent";
		public static const ERROR:String = "XMLLoaderErrorEvent";
     
        public var message:String;
        
        public function XMLLoaderEvent(message:String = "XML loader event.")
        {
            super(message);
            this.message = message;
        }

	    public override function clone():Event
	    {
	        return new XMLLoaderEvent(message);
	    }

	    public override function toString():String
	    {
	        return formatToString("XMLLoaderEvent", "type", "bubbles", "cancelable", "eventPhase", "message");
	    }

    }
}