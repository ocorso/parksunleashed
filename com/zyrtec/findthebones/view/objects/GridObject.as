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
	public class GridObject extends Sprite
	{
		private var _objectsArray:Array;
		private var _id:uint;
		private var _className:String;
		private var _classRef:Class;
		private var _numObjs:int = 18;

	
		// =================================================
		// ================ @Constructor
		// =================================================
		public function GridObject()
		{
			_objectsArray= [];
			trace("lets get some schwaaag...");
			//pull in objs from library
			
			for (var i:int = 1; i < _numObjs +1; i++)
			{	
				_className = "Obj" + i;
				_classRef = getDefinitionByName(_className) as Class;
				_objectsArray[i] = new _classRef();
				_objectsArray[i].id = i; //1-18
				trace("_objectsArray[i].id: " + _objectsArray[i].id);
			}
		}
		
		// =================================================
		// ================ @Callable
		// =================================================
		
		/*public function addEvents():void {
			var i:uint;
			for (i=0; i<_objectsArray.length; i++){
			//	trace(_objectsArray[i] + " events added");
				_objectsArray[i].buttonMode = true;
				_objectsArray[i].addEventListener(MouseEvent.MOUSE_OVER, onObjRoll, false, 0, true);
				_objectsArray[i].addEventListener(MouseEvent.MOUSE_OUT, onObjRollOut, false, 0, true);
				_objectsArray[i].addEventListener(MouseEvent.CLICK, onObjClick, false, 0, true);
			}			
		}*/
		
	/*	public function removeEvents():void {
			this.buttonMode = false;
			this.removeEventListener(MouseEvent.ROLL_OVER,onObjRoll);
			this.removeEventListener(MouseEvent.ROLL_OUT,onObjRollOut);
			this.removeEventListener(MouseEvent.CLICK, onObjClick);
		
		}*/
		
		
		
		// =================================================
		// ================ @Handlers
		// =================================================
		/*
		private function onObjRoll(e:MouseEvent):void {  
			trace("over");
				
			
		}
		
		private function onObjRollOut(e:MouseEvent):void {  
			trace("out");
				
			
		}
		
		private function onObjClick(e:MouseEvent):void { 
			trace("object " + e.currentTarget.id + " clicked");;
				//dispatchEvent(new FindTheBonesEvent(FindTheBonesEvent.OBJ_CLICK));
			
		}*/
		
		// =================================================
		// ================ @Getters / Setters
		// =================================================
		/*public function get selected():Boolean { return _selected; };
		public function set selected(value:Boolean):void { _selected = value; };*/
			
		public function get id():uint { return _id; };
		public function set id(value:uint):void { _id = value; };
		
		public function get objectsArray():Array { return _objectsArray; };
		public function set objectsArray(value:Array):void { _objectsArray = value};
		
		
	}
}