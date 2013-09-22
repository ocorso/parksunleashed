package com.zyrtec.cardqueen.video
{
	import com.theginbin.video.SimpleVideoDisplay;
	
	import flash.display.Sprite;
	
	public class CardVideoObject extends SimpleVideoDisplay
	{
		private var _videoPath:String;
		
		public function CardVideoObject(videoPath:String)
		{
			super();
			_videoPath = videoPath;
		}
		
		public function playVideo():void {
			this.url = _videoPath;
		}
	}
}