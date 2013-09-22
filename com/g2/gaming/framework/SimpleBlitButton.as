package com.g2.gaming.framework
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class SimpleBlitButton extends Sprite
	{
		public static const OFF:int = 1; 
     	 public static const OVER:int = 2; 
 
      	private var _offBackGroundBD:BitmapData; 
      	private var _overBackGroundBD:BitmapData; 
 
      	private var _positionOffset:Number; 
 
      	private var _buttonBackGroundBitmap:Bitmap; 
      	private var _buttonTextBitmapData:BitmapData; 
      	private var _buttonTextBitmap:Bitmap;
      
		public function SimpleBlitButton(x:Number,y:Number,width:Number,height:Number,text:String, offColor:uint,overColor:uint, textformat:TextFormat,positionOffset:Number=0)
		{
			_positionOffset = positionOffset; 
         	this.x = x; 
         	this.y = y; 
 
         	//background 
         	_offBackGroundBD = new BitmapData(width, height,false, offColor); 
          
         	_overBackGroundBD = new BitmapData(width, height,false, overColor); 
          
         	_buttonBackGroundBitmap = new Bitmap(_offBackGroundBD); 
 
        	 //text 
         	var tempText:TextField = new TextField(); 
         	tempText.text = text; 
         	tempText.setTextFormat(textformat); 
 
         	_buttonTextBitmapData  = new BitmapData(tempText.textWidth+positionOffset, tempText.textHeight+positionOffset, true, 0x00000000); 
          
         	_buttonTextBitmapData.draw(tempText); 
         	_buttonTextBitmap = new Bitmap(_buttonTextBitmapData); 
         	_buttonTextBitmap.x = ((_buttonBackGroundBitmap.width - int(tempText.textWidth))/2)-_positionOffset; 
    
         	_buttonTextBitmap.y = ((_buttonBackGroundBitmap.height -int(tempText.textHeight))/2)-_positionOffset; 
          	addChild(_buttonBackGroundBitmap); 
         	addChild(_buttonTextBitmap); 
         	this.buttonMode = true; 
         	this.useHandCursor = true;
		}
		
		public function changeBackGroundColor(typeval:int):void {   
         	if (typeval == SimpleBlitButton.OFF) { 
            	_buttonBackGroundBitmap.bitmapData = _offBackGroundBD; 
         	}else { 
            	_buttonBackGroundBitmap.bitmapData = _overBackGroundBD; 
         	} 
      	} 
	}
}