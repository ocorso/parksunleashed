package com.theginbin.utils {
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	import flash.display.Loader;
	import flash.display.DisplayObject;
	import flash.net.URLRequest;
	
	import flash.system.Security;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import com.theginbin.events.AssetLoaderEvent;
	
	
	public dynamic class AssetLoader extends EventDispatcher {
		
		private var _loader:Loader;
		private var _request:URLRequest;
		private var _context:LoaderContext 
		
		public var percent:Number;
		public var asset:Object;
		
		public function AssetLoader(){
			_loader = new Loader();
			_request = new URLRequest();
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handleMissingFile);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, getProgress);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
		}
		
		public function loadAsset(s:String):void {
			this.dispatchEvent(new AssetLoaderEvent(AssetLoaderEvent.LOAD_STARTED));
			//trace(s);
			_request.url = s;
			try {
				_loader.load(_request);
			} catch(e:Error){
				trace("ASSET LOADER COULD NOT LOAD URL");
			}
		}
		
		private function getProgress(p:ProgressEvent):void {
			percent = Math.round((p.bytesLoaded/p.bytesTotal)*100);
			dispatchEvent(new AssetLoaderEvent(AssetLoaderEvent.GET_PERCENT, percent));
		}
		
		private function loadComplete(e:Event):void {
			asset = e.target;
			dispatchEvent(new AssetLoaderEvent(AssetLoaderEvent.ASSET_LOADED, asset));
		}
	
		private function handleMissingFile(event:IOErrorEvent):void {
			trace("MISSING FILE ERROR")
		}
		
		public function killLoad():void {
			try {
				_loader.close();
			} catch(e:Error) {
				//trace("ERROR")
			}
		}
	}
}