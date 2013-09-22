package com.zyrtec.baseballmemory.view.scoring
{
	import com.g2.gaming.framework.ScoreBoard;
	import com.zyrtec.baseballmemory.view.scoring.ScoreBoxElement;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;

	public class ScoreboardBaseballMemory extends ScoreBoard
	{
		//declare public display objects
		public var clock:MovieClip;
		public var pairs:MovieClip;
		public var bg:MovieClip;
		
		private var _textElements:Object;
		
		public function ScoreboardBaseballMemory()
		{
			//super();
		}
		
		override public function createTextElement(key:String, obj:*):void {
			if (_textElements == null) {
				_textElements = {};
			}
			_textElements[key] = obj;
		}
		
		override public function update(key:String, value:String):void {
			var tempElement:ScoreBoxElement = ScoreBoxElement(_textElements[key]);
			tempElement.setContentText(value);
		}
		
	}
}