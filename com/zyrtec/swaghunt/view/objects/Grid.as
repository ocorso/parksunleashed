package com.zyrtec.swaghunt.view.objects
{
	import com.bigspaceship.events.AnimationEvent;
	import com.g2.gaming.framework.Game;
	import com.g2.gaming.framework.GameFramework;
	import com.g2.gaming.framework.events.ScoreBoardUpdateEvent;
	import com.g2.gaming.framework.events.SoundEvent;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	import com.zyrtec.swaghunt.controller.SwagHuntMain;
	import com.zyrtec.swaghunt.events.SwagHuntEvent;
	import com.zyrtec.swaghunt.game.SwagHuntGame;
	import com.zyrtec.swaghunt.model.SHModel;
	import com.zyrtec.swaghunt.model.SoundData;
	import com.zyrtec.swaghunt.view.objects.GridObject;
	import com.zyrtec.swaghunt.view.objects.Words;
	
	import flash.display.*;
	import flash.events.*;
	import flash.sampler.StackFrame;
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
		private var	_model:SHModel;		// Game Model (Singleton)
	//	private var _gridObjects:GridObject;
		private var _words:Words;
		private var tileOrder:Array;
		private var _levelObjArray:Array;
		private var _displayObjArray:Array;
		private var _objectsArray:Array;
		private var _wordsArray:Array;
		private var _popupx:int;
		private var _popupy:int;
		private var _id:uint;
		private var  _numMatchObjs = uint;
		private var _className:String;
		private var _classRef:Class;
		private var _objectsRemoved:Boolean;
		
		// =================================================
		// ================ @Constructor
		// =================================================
		public function Grid(numRows:uint, numCols:uint, totalObjects:uint){
			
			_model = SHModel.getInstance();
			_numRows = numRows;
			_numCols = numCols;
			_totalObjects = totalObjects;
			_objArray = [];
			_levelObjArray = [];
			_wordsArray = [];
			
			
			
			createObjects();
		}
	
		// =================================================
		// ================ @Callable
		// =================================================
		
		//FUNCTION : CREATE OBJECTS
		public function createObjects():void 
		{
				_objectsArray= [];
				//    trace("lets get some schwaaag...");
				//pull in objs from library
				
				for (var n:int = 1; n < _totalObjects +1; n++)
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
		
			_words = new Words();
			_wordsArray = _words.wordsArray;
			_wordsArray.splice(0,1); //pop of empty first element
		//	//    trace("words array: " + _wordsArray);
		
				_wordXnum = new WordXNumber();
			
			
		}
		
		//FUNCTION : COLLECT OBJECT(S) TO MATCH
		public function getMatchObjects(_gameLevel:int, _levelForMatches:int):void
		{
						//    trace("game _levelForMatches: " + _levelForMatches);
			_levelForMatches--;		//to make up for first element being 0
			//get random object
			_matchObject   = _objArray[_levelForMatches];
			_matchObjectID = _objArray[_levelForMatches].id;
//			trace("_matchObject: " + _matchObject);
			//    trace("_matchObjectID: " + _matchObjectID);		
																			
			_levelObjArray = _objArray.slice();						//remove chosen obj from that array and create new array from it
			_levelObjArray.splice(_levelForMatches,1);
																	////    trace("_levelObjArray: " + _levelObjArray);
			
		}
	
		//FUNCTION : COLLECT OTHER OBJECTS FILL GRID
		public function getLevelObjects(_gameLevel:int):void
		{	
			
			//get total num of objects to be displayed in grid
				var _numOtherObjs:uint;
			
				/*if(_gameLevel<7){
					_numOtherObjs = 17;
				}else if((_gameLevel > 6) && (_gameLevel < 13)){
					_numOtherObjs = 17;
				}else if((_gameLevel > 12) && (_gameLevel < 19)) {
					_numOtherObjs = 17;
				}*/
			
				
				_displayObjArray = [];
			if(_gameLevel < 18){	
				//get random objs to throw in display array multiple times to confuse player
				
					var _randomNum = new Number();
					var _randomNum2 = new Number();
					var _randomNum3 = new Number();
					_randomNum = Math.floor(Math.random() * (17 - 1 + 1) + 1);
					_randomNum2 = Math.floor(Math.random() * (17 - 1 + 1) + 1);
					_randomNum3 = Math.floor(Math.random() * (17 - 1 + 1) + 1);
					
					if ((_randomNum == _matchObjectID) && (_randomNum < 17)){
						_randomNum++;
						
					}else if((_randomNum == _matchObjectID) && (_randomNum == 17)){
						_randomNum--;
					}
					if ((_randomNum2 == _matchObjectID) && (_randomNum2 < 17)){
						_randomNum2++;
						
					}else if((_randomNum2 == _matchObjectID) && (_randomNum2 == 17)){
						_randomNum2--;
					}
					if ((_randomNum3 == _matchObjectID) && (_randomNum3 < 17)){
						_randomNum3++;
						
					}else if((_randomNum3 == _matchObjectID) && (_randomNum3 == 17)){
						_randomNum3--;
					}
					
					
					var _newObjCopy:Array = [];
					var _newObjCopy2:Array = [];
					var _newObjCopy3:Array = [];
					
					var r:int;
					for (r=0; r<3; r++){
						_className = "Obj" + _randomNum;
						_classRef = getDefinitionByName(_className) as Class;
						_newObjCopy[r] = new _classRef();
						_displayObjArray.unshift(_newObjCopy[r]);
					}
					for (r=0; r<2; r++){
						_className = "Obj" + _randomNum2;
						_classRef = getDefinitionByName(_className) as Class;
						_newObjCopy2[r] = new _classRef();
						_displayObjArray.unshift(_newObjCopy2[r]);
					}
						_className = "Obj" + _randomNum2;
						_classRef = getDefinitionByName(_className) as Class;
						_newObjCopy3[r] = new _classRef();
						_displayObjArray.unshift(_newObjCopy3[r]);
//					trace("_displayObjArray: " + _displayObjArray);
						
					//give wrong objects an id of below 50 
					for (i = 0; i<_displayObjArray.length; i++){
						_displayObjArray[i].id = 20+i;
					////    trace("_displayObjArray[i]: " + _displayObjArray[i] + "_displayObjArray[i].id: " + _displayObjArray[i].id);
					}
					
//					trace("_displayObjArray.length: " + _displayObjArray.length);
			}
				/*if (_gameLevel < 7){
					for (r=0; r<4; r++){
						_displayObjArray.push(_levelObjArray[_randomNum]);
					}
					_displayObjArray.push(_levelObjArray[_randomNum2]);
				}else if ((_gameLevel > 6) && (_gameLevel < 13)){
					for (r=0; r<3; r++){
						_displayObjArray.push(_levelObjArray[_randomNum]);
					}
					_displayObjArray.push(_levelObjArray[_randomNum2]);
				}*/
				/*for (r=0; r< _numOtherObjs; r++){
					_randomNum = (Math.floor(Math.random() * ((16-r) - 1 + 1)) + 1); 	//random number = Math.floor(Math.random() * (max - min + 1)) + min
					_displayObjArray.push(_levelObjArray[_randomNum]);
					//    trace("_objArray[" + _randomNum+ "]: " + _objArray[_randomNum]);
				}*/
				//if 18, push 17 objs in and no spacers
				//if(_gameLevel > 18){
				//	_numOtherObjs = 17;
				//}
			
				//add x number of match objects
				if(_gameLevel < 6){
					_numMatchObjs= 3;
					//_numMatchObjs = Math.floor(Math.random() * (3 - 2 + 1)) + 2; 
					////    trace("_gameLevel: " + _gameLevel + "num match objs: " + _numMatchObjs); 
				}else if((_gameLevel > 5) && (_gameLevel < 10)){
					_numMatchObjs = 2;
					//_numMatchObjs = Math.floor(Math.random() * (2 - 1 + 1)) + 1;
					////    trace("_gameLevel: " + _gameLevel + "num match objs: " + _numMatchObjs); 
				}else if(_gameLevel > 9){
					_numMatchObjs = 1;
					////    trace("_gameLevel: " + _gameLevel + "num match objs: " + _numMatchObjs); 
				}
				
				//add objects to match
				var i:uint;
				var _newObjCopy4:Array = [];
				for (i = 0; i<_numMatchObjs; i++){
					_className = "Obj" + _matchObjectID;
					_classRef = getDefinitionByName(_className) as Class;
					_newObjCopy4[i] = new _classRef();
					_displayObjArray.unshift(_newObjCopy4[i]);
				}
				//give match an id of above 50 
				for (i = 0; i<_numMatchObjs; i++){
					_displayObjArray[i].id = 50+i;
					////    trace("_displayObjArray[i]: " + _displayObjArray[i] + "_displayObjArray[i].id: " + _displayObjArray[i].id);
				}
				
				_numOtherObjs = 18 - _displayObjArray.length;
				trace("_numOtherObjs: " + _numOtherObjs);
				
				for (r=0; r< _numOtherObjs; r++){
					_displayObjArray.push(_levelObjArray[r]);
					//    trace("_objArray[" + r+ "]: " + _objArray[r]);
				}
			
				trace("_displayObjArray: " + _displayObjArray);

			//**add empty mc's to help space out the grid when laying out objs
//			var _currentTotalObjs:int = _numMatchObjs + _numOtherObjs;
				//    trace("current total num of objects: " + _currentTotalObjs);
//			var _numEmptyMCs:int = _totalObjects - _currentTotalObjs;
				//    trace("current total num of EmpytMCs: " + _numEmptyMCs);
			//if there is at least one empty mc:
			/*if(_numEmptyMCs>0){
				for(i=0; i<_numEmptyMCs; i++)
				{
					var blankMC:MovieClip = new MovieClip();
					blankMC.width = 70;
					blankMC.height = 70;
					_displayObjArray.unshift(blankMC);
				}
				// give empty mc's id's 
				for (i = 0; i<_numEmptyMCs; i++){
					_displayObjArray[i].id = 25+i;
					////    trace("_displayObjArray[i]: " + _displayObjArray[i] + "_displayObjArray[i].id: " + _displayObjArray[i].id);
				}
			}*/
			shuffle(_displayObjArray);
			////    trace("-----> _displayObjArray in get level objs: " + _displayObjArray);
						////    trace("~~~~_wordsArray in getlevelobjs: " + _wordsArray);
						////    trace("~~~~_matchObjectID in getlevelobjs: " + _matchObjectID);
		
				_wordXnum.x = 285;
				_wordXnum.y = 10;
				_wordXnum.mouseEnabled = false;
				_wordXnum.scaleX = 0;
				_wordXnum.scaleY = 0;
				_wordXnum.alpha = 0;
				addChild(_wordXnum);
//				trace("created new wordxnum");
				
			//get matching number
			switch (_numMatchObjs){
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
			} 
					
			//get matching wordsfrom word array:
			for(i=0; i<_wordsArray.length; i++){
				//    trace("_wordsArray[i]: " + _wordsArray[i]);
				//if its ID number matches the word
				if(_wordsArray[i].id == _matchObjectID){
					_objName = _wordsArray[i];
//					_wordXnum.addChild(_objName);
					addChild(_objName);
					_objName.alpha = 0;
					_objName.scaleX = 0;
					_objName.scaleY = 0;
					_objName.x = 317;
					_objName.y = 10;
				}else{
					//_wordsArray[i].visible = false;
				}	
			}
				TweenMax.delayedCall(.25, placeObjects, [_gameLevel]);
		}
			
		//FUNCTION : ANIMATE IN
		public function animateIn(_gameLevel:int):void
		{
			shuffle(_displayObjArray);
			TweenMax.to(_objName, 1, {delay: .5, scaleX:1, scaleY:1, alpha:1, ease:Elastic.easeOut});
			_wordXnum.visible = true;
			TweenMax.to(_wordXnum, 1, {delay: .5, scaleX:1, scaleY:1, alpha:1, ease:Elastic.easeOut});
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
			shuffle(_displayObjArray);

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
						_displayObjArray[j].y = 100 + 100 * objy;
						addChild(_displayObjArray[j]);
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
						//	//    trace(_objectsArray[i] + " events added");
						_displayObjArray[i].buttonMode = true;
						_displayObjArray[i].addEventListener(MouseEvent.CLICK, onObjClick, false, 0, true);
					}
				
		}
		//FUNCTION: REMOVE EVENTS
		public function removeEvents():void
		{
				var i:uint;
				for (i=0; i<_displayObjArray.length; i++){
					//	//    trace(_objectsArray[i] + " events added");
					_displayObjArray[i].buttonMode = true;
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
						TweenMax.to(_displayObjArray[i], .5, {delay:.25, x:555, ease:Circ.easeOut, onComplete:intoBox, onCompleteParams:[_displayObjArray[i]]});
						

						
					//if the choice was incorrect, animate the element
					}else if (!correct){
						_displayObjArray[i].gotoAndPlay("incorrect");
					}
				}	
			}
			TweenMax.delayedCall(.5, resetAfterClick, [correct]);
		}
		
		private function intoBox(mc:MovieClip):void{
			TweenMax.to(mc, .3, {y:365, alpha:0, ease:Circ.easeIn});
//			dispatchEvent(new SoundEvent(SoundEvent.PLAY_SOUND, SoundData.SOUND_DROP,false,0, 0, 1));	//drop sound

		}
			
			
			
		//FUNCTION: CLEAR OBJECTS OFF THE BOARD
		public function clearObjects(_objectsPresent:Boolean):void
		{	//    trace("clearObjects objName: " + _objName);
			var i:int;
			//if(_objectsPresent){
//				TweenMax.killTweensOf(_wordXnum);
//				TweenMax.killTweensOf(_objName);
				removeChild(_wordXnum);
				removeChild(_objName);
				for (i= 0; i<(_displayObjArray.length); i++){	
//					TweenMax.killTweensOf(_displayObjArray[i]); 
					removeChild(_displayObjArray[i]);
				}
			//}
			_objectsRemoved = true;
		}
		
		
		public function clearLevelObjects():void
		{
			TweenMax.to(_wordXnum, 1, {delay:1, scaleX:0, scaleY:0, alpha:0, ease:Elastic.easeOut});
			TweenMax.to(_objName, 1, {delay:1, scaleX:0, scaleY:0, alpha:0, ease:Elastic.easeOut});
			var i:uint;
			for (i= 0; i<(_displayObjArray.length); i++){	
				TweenMax.to(_displayObjArray[i], 1.5, {delay:1, scaleX:0, scaleY:0, alpha:0, ease:Elastic.easeOut});
			}
			_objectsRemoved = true;
		}
		
		public function resetAfterClick(correct:Boolean):void
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
		
		//FUNCTION: SHUFFLE OBJECTS IN ARRAY
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
			
			////    trace("in onObjClick... object " + e.currentTarget.id + " clicked");;
			dispatchEvent(new SwagHuntEvent(SwagHuntEvent.OBJECT_CLICK, e.currentTarget.id));
			//dispatchEvent(new SwagHuntEvent(SwagHuntEvent.SELECTED_OBJECT, e.currentTarget));
			var i:int;
			var clickedObj:MovieClip ;
		 	for(i=0; i<_displayObjArray.length; i++){
				if(_displayObjArray[i].id == e.currentTarget.id){
					_clickedObjElementNum = _displayObjArray[i].id;
					//    trace("clicked object ID is " + _clickedObjElementNum);
					clickedObj = _displayObjArray[i];
					
				}else{ 
					////    trace("whoops no name for clicked obj");
				}
			}
		}
		
		//FUNCTION : ON ANIMATED IN COMPLETE
		private function onAnimatedInComplete(e:AnimationEvent=null) { 
			TweenMax.delayedCall(0.5, this.dispatchEvent, [new AnimationEvent(AnimationEvent.COMPLETE)]);
			//this.dispatchEvent(new AnimationEvent(AnimationEvent.COMPLETE));
		}
		
		//FUNCTION : ON TILE CLICKED
		private function onObjectClicked(e:SwagHuntEvent):void {
			
			dispatchEvent(new SwagHuntEvent(SwagHuntEvent.OBJECT_CLICK, e.currentTarget.id));
		}
		
		
		
		
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