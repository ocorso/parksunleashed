package com.zyrtec.findthebones.view.objects
{
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	import com.zyrtec.findthebones.events.FindTheBonesEvent;
	
	import flash.display.*;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.getDefinitionByName;
	
	
	
	// =================================================
	// ================ @Class
	// =================================================
	public class Bones extends Sprite
	{
		private var _bonesArray:Array;
		private var _id:uint;
		private var _className:String;
		private var _classRef:Class;
		private var _numObjs:int = 5;

	
		// =================================================
		// ================ @Constructor
		// =================================================
		public function Bones()
		{
			_bonesArray= [];
			trace("lets get some boooones...");
			//pull in objs from library
			
			for (var i:int = 1; i < _numObjs +1; i++)
			{	
				_className = "Bone" + i;
				_classRef = getDefinitionByName(_className) as Class;
				_bonesArray[i] = new _classRef();
				_bonesArray[i].id = 50 + i; //1-18
				//trace("_wordsArray[i].id: " + _wordsArray[i].id);
			}
			
		}
		
		
		// =================================================
		// ================ @Getters / Setters
		// =================================================

		public function get id():uint { return _id; };
		public function set id(value:uint):void { _id = value; };
		
		public function get bonesArray():Array { return _bonesArray; };
		public function set bonesArray(value:Array):void { _bonesArray = value};
		
		
	}
}