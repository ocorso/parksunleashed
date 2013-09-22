package com.g2.gaming.framework
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class SideBySideScoreElement extends Sprite
	{
		private var _label:TextField = new TextField();
      	private var _content:TextField = new TextField(); 
      	private var _bufferWidth:Number; //number of pixels separating elements
      
		public function SideBySideScoreElement(x:Number, y:Number, bufferWidth:Number, labelText:String,labelTextFormat:TextFormat, labelWidth:Number, contentText:String, contentTextFormat:TextFormat)
		{
			this.x = x;
			this.y = y;
			_bufferWidth = bufferWidth;
			_label.autoSize; //may need to add as parameter
			_label.defaultTextFormat = labelTextFormat;
			_label.text = labelText;
			
			_content.autoSize;
			_content.defaultTextFormat = contentTextFormat;
			_content.text = contentText;
			
			_label.x = 0;
			_content.x = labelWidth+bufferWidth;
			
			addChild(_label);
			addChild(_content);
		}
		
		public function setLabelText(str:String):void {
			_label.text = str;
		}
		
		public function setContentText(str:String):void {
			_content.text = str;
		}
		
	}
}