package com.zyrtec.interfaces
{
	import com.bigspaceship.events.AnimationEvent;
	
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.text.TextFormat;

	public interface IScreen extends IEventDispatcher
	{
		function createDisplayText(text:String, width:Number, location:Point, textFormat:TextFormat):void;
		function createOkButton(text:String,location:Point, width:Number,height:Number, textFormat:TextFormat, offColor:uint=0x000000, overColor:uint=0xff0000, positionOffset:Number=0):void;
		function setDisplayText(text:String):void;

		function addEvents($ae:AnimationEvent = null):void;
		function removeEvents($ae:AnimationEvent = null):void;
		
		function animateIn():void;
		function animateOut():void;
		
		function get id():int;
		function set id(value:int):void;
	}
}