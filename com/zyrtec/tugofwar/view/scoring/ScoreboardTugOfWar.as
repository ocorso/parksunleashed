package com.zyrtec.tugofwar.view.scoring
{
	import com.g2.gaming.framework.ScoreBoard;
	import com.zyrtec.tugofwar.view.scoring.ScoreBoxElement;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;

	public class ScoreboardTugOfWar extends ScoreBoard
	{
		//declare public display objects
		public var clock:MovieClip;
		public var level:MovieClip;
		public var pattern:MovieClip;
		public var bg:MovieClip;
		
		private var _textElements:Object;
		
		public function ScoreboardTugOfWar()
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