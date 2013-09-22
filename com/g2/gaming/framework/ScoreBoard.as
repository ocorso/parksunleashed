package com.g2.gaming.framework
{
	import flash.display.MovieClip;

	public class ScoreBoard extends MovieClip
	{
		private var _textElements:Object;
		
		public function ScoreBoard()
		{
			init();
		}
		
		private function init():void {
			_textElements = {};
		}
		
		public function createTextElement(key:String, obj:*):void {
			_textElements[key] = obj;
			addChild(obj);
		}
		
		public function update(key:String, value:String):void {
			var tempElement:SideBySideScoreElement = _textElements[key];
				tempElement.setContentText(value);
		}
		
	}
}