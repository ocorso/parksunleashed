package com.zyrtec.dogmatch.view.circles
{
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	import com.zyrtec.dogmatch.controller.DogMatchMain;
	import com.zyrtec.dogmatch.events.DogMatchEvent;
	
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.utils.getDefinitionByName;
		
	// =================================================
	// ================ @Class
	// =================================================
	public class Owners extends Sprite
	{
		private var _gameWidth:int = 940;
		private var _gameHeight:int = 600;
		private var _randomNum:Number;
		private var _numOwners:int = 18;
		private var _id:uint;
		private var _ownerArray:Array;
		private var _className:String;
		private var _classRef:Class;
		
		private var _DogMatchMain:DogMatchMain;
		
		
		
		// =================================================
		// ================ @Constructor
		// =================================================
		public function Owners()
		{
			_ownerArray= [];
			trace("grab the owners...");
			//pull in dogs from library
			for (var i:int = 1; i < _numOwners +1; i++)
			{	
				_className = "Owner" + i;
				_classRef = getDefinitionByName(_className) as Class;
				_ownerArray[i] = new _classRef();
				_ownerArray[i].id = i; //1-18
				//trace("_ownerArray[i].id: " + _ownerArray[i].id);
			}
		}
		
		// =================================================
		// ================ @Callable
		// =================================================
		
		
		
		
		// =================================================
		// ================ @Workers   aka private funcs
		// =================================================
		
		
		
		
		// =================================================
		// ================ @Getters / Setters
		// =================================================
		/*public function get selected():Boolean { return _selected; };
		public function set selected(value:Boolean):void { _selected = value; };*/
		
		public function get id():uint { return _id; };
		public function set id(value:uint):void { _id = value; };
		
		public function get ownerArray():Array { return _ownerArray; };
		public function set ownerArray(value:Array):void { _ownerArray = value};
		
		
	}
}