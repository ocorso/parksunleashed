package com.zyrtec.dogmatch.view.scoring
{
	import com.g2.gaming.framework.ScoreBoard;
	import com.zyrtec.dogmatch.view.scoring.ScoreBoxElement;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;

	public class ScoreboardDogMatch extends ScoreBoard
	{
		//declare public display objects
		public var clock:MovieClip;
		public var score:MovieClip;
		public var lives:MovieClip;
		public var bg:MovieClip;
		public var pairs:MovieClip;
		
		private var _textElements:Object;
		
		public function ScoreboardDogMatch()
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
		
		public function updateLives(value:String):void{
			lives.gotoAndStop(int(value));
			
		}
	}
}


