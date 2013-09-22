package com.zyrtec.findthebones.view.objects
{
	import com.bigspaceship.events.AnimationEvent;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	import com.zyrtec.findthebones.events.FindTheBonesEvent;
	import com.zyrtec.findthebones.game.FindTheBonesGame;
	import com.zyrtec.findthebones.model.FTBModel;
	import com.zyrtec.findthebones.view.objects.Bones;
	import com.zyrtec.findthebones.view.objects.GridObject;
	
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.utils.*;
	
	// =================================================
	// ================ @Class
	// =================================================	
	public class Grid extends Sprite
	{
		private var _objArray:Array;
		private var _myDelay:Timer;
		private var _numRows:uint;
		private var _numCols:uint;
		private var _totalObjects:uint = 18;
		private var _objectID:uint;
	//	private var _gameLevel:int;
		private var _matchObjectID:uint;
		private var _matchObject:MovieClip;  //object to match
		private var _objName:MovieClip;  //name of obj mc
		private var _wordXnum:MovieClip;	//mc holding the objName and x and the number
		private var _clickedObjElementNum:int;
		private var	_model:FTBModel;		// Game Model (Singleton)
	//	private var _gridObjects:GridObject;
		private var _bones:Bones;
		private var tileOrder:Array;
		private var _levelObjArray:Array;
		private var _displayObjArray:Array;
		private var _objectsArray:Array;
		private var _bonesArray:Array;
		private var _popupx:int;
		private var _popupy:int;
		private var _id:uint;
		private var  _numMatchObjs = uint;
		private var _className:String;
		private var _classRef:Class;
		private var _objectsRemoved:Boolean;
		private var _totalOtherObjects:int;
		
		// =================================================
		// ================ @Constructor
		// =================================================
		public function Grid(numRows:uint, numCols:uint, totalObjects:uint){
			
			_model = FTBModel.getInstance();
			
			_numRows = numRows;
			_numCols = numCols;
			_totalObjects = totalObjects;
			_totalOtherObjects =  17;
			_objArray = [];
			_levelObjArray = [];
			_bonesArray = [];
			
			/*
			if (_wordXnum == null) {
				_wordXnum = new WordXNumber();
				_wordXnum.x = 285;
				_wordXnum.y = 10;
				_wordXnum.mouseEnabled = false;
				_wordXnum.scaleX = 0;
				_wordXnum.scaleY = 0;
				_wordXnum.alpha = 0;
				addChild(_wordXnum);
			}*/
			createObjects();
		}
	
		// =================================================
		// ================ @Callable
		// =================================================
		
		//FUNCTION : CREATE OBJECTS
		public function createObjects():void 
		{
				_objectsArray= [];
				//    trace("lets get some bones...");
				//pull in objs from library
				
				for (var n:int = 1; n < _totalOtherObjects +1; n++)
				{	
					_className = "Obj" + n;
					_classRef = getDefinitionByName(_className) as Class;
					_objectsArray[n] = new _classRef();
					_objectsArray[n].id = n; //1-18
					////    trace("_objectsArray[n].id: " + _objectsArray[n].id);
				}
									
			/*_gridObjects= new GridObject;*/
			_objArray = _objectsArray.slice();
			_objArray.splice(0,1);	
			shuffle(_objArray); //to randomize new game
		
			_bones = new Bones();
			_bonesArray = _bones.bonesArray;
			//_bonesArray.splice(0,1); //pop of empty first element
		//	//    trace("words array: " + _bonesArray);
			
		
			
			_wordXnum = new WordXNumber();
			_wordXnum.x = 285;
			_wordXnum.y = 10;
			_wordXnum.mouseEnabled = false;
			_wordXnum.scaleX = 0;
			_wordXnum.scaleY = 0;
			_wordXnum.alpha = 0;
			addChild(_wordXnum);
			
		}
		
		//FUNCTION : COLLECT OBJECT(S) TO MATCH
		public function getMatchObjects(_gameLevel:int, _levelForMatches:int):void
		{
			//_levelForMatches--;		//to make up for first element being 0
			//get random object
			
			var _randomNum:Number;
			_randomNum = Math.floor(Math.random() * (5 - 1 + 1) + 1);
			_matchObject   = _bonesArray[_randomNum];
			_matchObjectID = _bonesArray[_randomNum].id;
			    trace("_matchObject: " + _matchObject);
			    trace("_matchObjectID: " + _matchObjectID);		
			
			_displayObjArray = [];																
			//_levelObjArray = _objArray.slice();						//remove chosen obj from that array and create new array from it
			_displayObjArray = _objArray.slice();		
			_displayObjArray.push(_matchObject);
			//remove chosen obj from that array and create new array from it
		///	_levelObjArray.splice(4,1);
																	////    trace("_levelObjArray: " + _levelObjArray);
			
		}
	
		//FUNCTION : COLLECT OTHER OBJECTS FILL GRID
		public function getLevelObjects(_gameLevel:int):void
		{	
			
			//get total num of objects to be displayed in grid
			var _numOtherObjs:uint = 17;
			
			shuffle(_displayObjArray);
			
			//get matching number
			/*switch (_numMatchObjs){
				case 1:
					_wordXnum.one_mc.visible = true;
					_wordXnum.two_mc.visible = false;
					_wordXnum.three_mc.visible = false;
					break;
				case 2:
					_wordXnum.one_mc.visible = false;
					_wordXnum.two_mc.visible = true;
					_wordXnum.three_mc.visible = false;					
					break;
				case 3:
					_wordXnum.one_mc.visible = false;
					_wordXnum.two_mc.visible = false;
					_wordXnum.three_mc.visible = true;			
					break;
			} */

				TweenMax.delayedCall(.25, placeObjects, [_gameLevel]);
		}
			
		//FUNCTION : ANIMATE IN
		public function animateIn(_gameLevel:int):void
		{
			shuffle(_displayObjArray);
			if(_gameLevel == 1){
				TweenMax.to(_wordXnum, 1, {delay: .5, scaleX:1, scaleY:1, alpha:1, ease:Elastic.easeOut});
			}
			var i:uint;
			for (i= 0; i<(_displayObjArray.length); i++){	
				TweenMax.to(_displayObjArray[i], .75, {delay:(1 + (.05 * i)), scaleX:1, scaleY:1, alpha:1, ease:Elastic.easeOut});
			}
			if(_gameLevel > 1){
				addEvents();
			}
			_objectsRemoved = false;

		}
	
		//FUNCTION: PLACE OBJECTS	
		public function placeObjects(_gameLevel:int):void
		{
			////    trace("in placeobj's: " + _levelObjArray);
			shuffle(_displayObjArray);
			////    trace("_displayObjArray: " + _displayObjArray);

			var i:uint;
			for (i= 0; i<(_displayObjArray.length); i++){	
				_displayObjArray[i].alpha = 0;
				_displayObjArray[i].scaleX = 0;
				_displayObjArray[i].scaleY = 0;
			}
			
			var j:int = 0;
			for (var objy:int = 0; objy < _numRows; objy++) {
				for (var objx:int = 0; objx <_numCols; objx++) {
					if (j < (_displayObjArray.length)) { 
						_displayObjArray[j].x = 100 + 75 * objx;
							////    trace(_displayObjArray[j] + ".x = " + _displayObjArray[j].x);
						_displayObjArray[j].y = 100 + 100 * objy;
							////    trace(_displayObjArray[j] + ".y = " + _displayObjArray[j].y);
						addChild(_displayObjArray[j]);
							////    trace("_displayObjArray["+j+"]: " + _displayObjArray[j]);
							////    trace("_levelObjArray.length = " +_levelObjArray.length);
						j++;
					}
				}
			}
				animateIn(_gameLevel);
		}
		
		//FUNCTION: ADD EVENTS
		public function addEvents():void
		{	
					var i:uint;
					for (i=0; i<_displayObjArray.length; i++){
						_displayObjArray[i].buttonMode = true;
						//_displayObjArray[i].addEventListener(MouseEvent.MOUSE_OVER, onObjRoll, false, 0, true);
						//_displayObjArray[i].addEventListener(MouseEvent.MOUSE_OUT, onObjRollOut, false, 0, true);
						_displayObjArray[i].addEventListener(MouseEvent.CLICK, onObjClick, false, 0, true);
					}
				
		}
		//FUNCTION: REMOVE EVENTS
		public function removeEvents():void
		{
				var i:uint;
				for (i=0; i<_displayObjArray.length; i++){
					_displayObjArray[i].buttonMode = true;
					//_displayObjArray[i].removeEventListener(MouseEvent.MOUSE_OVER, onObjRoll, false, 0, true);
					//_displayObjArray[i].removeEventListener(MouseEvent.MOUSE_OUT, onObjRollOut, false, 0, true);
					_displayObjArray[i].removeEventListener(MouseEvent.CLICK, onObjClick);
				}
			}
		
		//FUNCTION : MAKE OBJECT REACT TO INTERACTION
		public function objectRxn(objIDNum:int, correct:Boolean):void 
		{
			//    trace("obj clicked is: obj" + objIDNum);
			_clickedObjElementNum= objIDNum;
			var i:int;
			//for all elements in the array
			for(i=0; i<_displayObjArray.length; i++){
				//if its ID number matches the one clicked
				if(_displayObjArray[i].id == objIDNum){
					//if the choice was correct, animate the element
					if (correct){
						removeClickability(_displayObjArray[i]);	
						_displayObjArray[i].gotoAndStop("correct");
						_popupx = _displayObjArray[i].x;
						_popupy = _displayObjArray[i].y - 20;
						TweenMax.to(_displayObjArray[i], .25, {delay:.25, scaleX:0, scaleY:0, alpha:0, ease:Circ.easeIn});
						
					//if the choice was incorrect, animate the element
					}else if (!correct){
						_displayObjArray[i].gotoAndPlay("incorrect");
					}
				}	
			}
			TweenMax.delayedCall(.5, resetAfterClick, [correct]);
		}
		//FUNCTION: CLEAR OBJECTS OFF THE BOARD
		public function clearObjects(gameOver:Boolean):void
		{	
//				TweenMax.to(_wordXnum, 1, {delay:1, scaleX:0, scaleY:0, alpha:0, ease:Elastic.easeOut});
			
			/*var i:uint;
			for (i= 0; i<(_displayObjArray.length); i++){	
				TweenMax.to(_displayObjArray[i], 1, {delay:1, scaleX:0, scaleY:0, alpha:0, ease:Elastic.easeOut});
			}*/
			
			removeChild(_wordXnum);
			var i:int;
			for (i= 0; i<(_displayObjArray.length); i++){	
				//	TweenMax.killTweensOf(_displayObjArray[i]); 
				removeChild(_displayObjArray[i]);
			}
			_objectsRemoved = true;
		}
		//FUNCTION CLEAR THE LEVELS OBJECTS
		public function clearLevelObjects():void
		{
			var i:uint;
			for (i= 0; i<(_displayObjArray.length); i++){	
				TweenMax.to(_displayObjArray[i], 1, {delay:1, scaleX:0, scaleY:0, alpha:0, ease:Elastic.easeOut});
			}
			_objectsRemoved = true;
		}
			
		public function resetAfterClick(correct:Boolean): void
		{
			////    trace("_clickedObjElementNum in resetAfterClick: " + _clickedObjElementNum);
			var i:int;
			//for all elements in the array
			for(i=0; i<_displayObjArray.length; i++){
				//if its ID number matches the one clicked
				if(_displayObjArray[i].id == _clickedObjElementNum){
					//if the choice was correct, animate the element
					_displayObjArray[i].gotoAndStop("off");
					_popupx = 0;
					_popupy = 0;
				}	
			}
		}
		
		//FUNCTION: FTBUFFLE OBJECTS IN ARRAY
		private static function shuffle(a:Array):void 
		{
			var l:int=a.length;
			var i:int=0;
			var rand:int;
			for(i;i<l;i++)
			{
				var tmp:* =a[int(i)];
				rand=int(Math.random()*l);
				a[int(i)]=a[rand];
				a[int(rand)]=tmp;
			}
		}
	
		// =================================================
		// ================ @Handlers
		// =================================================
		
		
		private function onObjRoll(e:MouseEvent):void {  
			////    trace("over: " + e.currentTarget);
			/*var i:int;
			for(i=0; i<_displayObjArray.length; i++){
				if(_displayObjArray[i].id == e.currentTarget.id){
					_displayObjArray[i].gotoAndPlay("over");
				}else{ 
					////    trace("whoops no name for clicked obj");
				}
			}*/
		}
		
		private function onObjRollOut(e:MouseEvent):void {  
			////    trace("out");
			/*var i:int;
			for(i=0; i<_displayObjArray.length; i++){
				if(_displayObjArray[i].id == e.currentTarget.id){
					_displayObjArray[i].gotoAndPlay("out");
				}else{ 
					////    trace("whoops no name for clicked obj");
				}
			}*/
		}
		
		private function removeClickability(mc:MovieClip):void{
			//    trace("mc in remove clickness: " + mc);
			mc.removeEventListener(MouseEvent.CLICK, onObjClick);
			mc.buttonMode = true;
		}
		
		private function onObjClick(e:MouseEvent):void 
		{ 
			trace("in onObjClick... object " + e.currentTarget.id + " clicked");;
			dispatchEvent(new FindTheBonesEvent(FindTheBonesEvent.OBJECT_CLICK, e.currentTarget.id));
			//dispatchEvent(new FindTheBonesEvent(FindTheBonesEvent.SELECTED_OBJECT, e.currentTarget));
			var i:int;
			var clickedObj:MovieClip ;
		 	for(i=0; i<_displayObjArray.length; i++){
				if(_displayObjArray[i].id == e.currentTarget.id){
					_clickedObjElementNum = _displayObjArray[i].id;
					//    trace("clicked object ID is " + _clickedObjElementNum);
					clickedObj = _displayObjArray[i];
					}else{ 
				}
			}
			
		}
		
		//FUNCTION : ON ANIMATED IN COMPLETE
		private function onAnimatedInComplete(e:AnimationEvent=null) { 
			TweenMax.delayedCall(0.5, this.dispatchEvent, [new AnimationEvent(AnimationEvent.COMPLETE)]);
			//this.dispatchEvent(new AnimationEvent(AnimationEvent.COMPLETE));
		}
		
		//FUNCTION : ON TILE CLICKED
		private function onObjectClicked(e:FindTheBonesEvent):void {
			
			dispatchEvent(new FindTheBonesEvent(FindTheBonesEvent.OBJECT_CLICK, e.currentTarget.id));
		}
	
		public function get wordXnum():MovieClip { return _wordXnum};
		public function set wordXnum(value:MovieClip):void { _wordXnum = value};
		
		public function get objectsRemoved():Boolean { return _objectsRemoved};
		public function set objectsRemoved(value:Boolean):void { _objectsRemoved = value};

		public function get popupy():int { return _popupy};
		public function set popupy(value:int):void { _popupy = value};
		
		public function get popupx():int { return _popupx};
		public function set popupx(value:int):void { _popupx = value};
		
		public function get clickedObjElementNum():int { return _clickedObjElementNum};
		public function set clickedObjElementNum(value:int):void { _clickedObjElementNum = value};
		
		public function get matchObjectID():uint { return _matchObjectID};
		public function set matchObjectID(value:uint):void { _matchObjectID = value};
		
		public function get numMatchObjs():uint { return _numMatchObjs};
		public function set numMatchObjs(value:uint):void { _numMatchObjs = value};
	}
}