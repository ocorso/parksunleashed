package com.zyrtec.kiteflying.controller.scoreboard
{
	import com.bigspaceship.display.StandardInOut;
	import com.bigspaceship.events.AnimationEvent;
	import com.bigspaceship.tween.easing.Cubic;
	import com.bigspaceship.utils.Out;
	import com.bigspaceship.utils.SimpleSequencer;
	import com.g2.gaming.framework.ScoreBoard;
	import com.g2.gaming.framework.SideBySideScoreElement;
	import com.greensock.TweenMax;
	import com.zyrtec.interfaces.IScreen;
	import com.zyrtec.kiteflying.events.KFScoreboardUpdateEvent;
	import com.zyrtec.kiteflying.events.KiteFlyingEvent;
	import com.zyrtec.kiteflying.model.KFModel;
	import com.zyrtec.kiteflying.model.vo.KFCurrentScoreValueObject;
	import com.zyrtec.kiteflying.model.vo.KFScoreboardValueObject;
	import com.zyrtec.kiteflying.view.screens.assets.scoreboard.KFScoreboardCounterView;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextFormat;
	
	public class KFScoreboardController extends ScoreBoard implements IScreen
	{
		private var _m				:KFModel;
		private var _mc				:ScoreboardMC;
		private var _sc				:KFScoreboardCounter;
		private var _wm				:KFWindMeter;
		
		private var _ss				:SimpleSequencer;
		
		private var _curScore		:KFCurrentScoreValueObject;
		
		// =================================================
		// ================ @Callable
		// =================================================
		public function createDisplayText(text:String, width:Number, location:Point, textFormat:TextFormat):void{}
		public function createOkButton(text:String,location:Point, width:Number,height:Number, textFormat:TextFormat, offColor:uint=0x000000, overColor:uint=0xff0000, positionOffset:Number=0):void{}
		public function setDisplayText(text:String):void{}
		
		public function addEvents($ae:AnimationEvent = null):void{}
		public function removeEvents($ae:AnimationEvent = null):void{}

		public function get id():int{ return -1;}
		public function set id(value:int):void{}
		
		
		// =================================================
		// ================ @Workers
		// =================================================
		private function _init():void{
			
			_m			= KFModel.getInstance();
			_m.addEventListener(KFModel.UPDATE_SCOREBOARD, _updateUI);
			_m.addEventListener(KFModel.WINDPOWER_CHANGE, _adjustWindmeter);
			
			_sc			= new KFScoreboardCounter(mc.scoreCounterMC);
			_sc.setScore("0");
			_sc.setHiScore("1000");
			
			_wm			= new KFWindMeter(mc.windMeterMC);
			
			_curScore	= new KFCurrentScoreValueObject();
			
		}//end function
		
		private function _parseScore($s:Number):void{
			
			_sc.setScore($s.toString());
			_sc.setHiScore(_m.maxScore.toString());
			
		}//end function

		// =================================================
		// ================ @Handlers
		// =================================================
		public function _updateUI($e:KFScoreboardUpdateEvent):void {
			Out.status(this, "_updateUI");
			_parseScore($e.payload.currentScore);
			if (_wm.state == AnimationEvent.IN)	_wm.moveNeedle($e.payload.windPower);
			
		}//end function
		
		private function _adjustWindmeter($e:KiteFlyingEvent = null):void
		{	
			Out.status(this, "_adjustWindmeter");
			if (_wm.state == AnimationEvent.IN)	_wm.moveNeedle($e.payload.windPower);
			TweenMax.to(_sc.mc, 0.25, {glowFilter:{color:0xff0000, alpha:1, blurX:30, blurY:30}, ease:Cubic.easeInOut, yoyo:true, repeat:1});
			
		}//end function
		
		// =================================================
		// ================ @Animation
		// =================================================
		public function animateIn():void{
			Out.status(this, "animateIn");
			if(_ss) _disposeSequencer();
			_ss = new SimpleSequencer("scoreboard animateInSeq");
			_ss.addEventListener(Event.COMPLETE, _sequencerInCompleteHandler);
			_ss.addStep(0, _sc,_sc.animateIn, AnimationEvent.IN);
			_ss.addStep(1,_wm, _wm.animateIn, AnimationEvent.IN);
			_ss.start();
		
		}//end function
		
		public function animateOut():void{
			if(_ss) _disposeSequencer();
			_ss = new SimpleSequencer("scoreboard animateOutSeq");
			_ss.addEventListener(Event.COMPLETE, _sequencerOutCompleteHandler);
			_ss.addStep(0,_wm, _wm.animateOut, AnimationEvent.OUT);
			_ss.addStep(1, _sc,_sc.animateOut, AnimationEvent.OUT);
			_ss.start();
		
		}//end function
		
		private function _sequencerInCompleteHandler($e:Event):void{
			
			Out.status(this, "seq In complete handler");
			_ss.removeEventListener(Event.COMPLETE, _sequencerInCompleteHandler);
			dispatchEvent(new AnimationEvent(AnimationEvent.IN));
			
		}//end function
		
		private function _sequencerOutCompleteHandler($e:Event):void{
			
			Out.status(this, "seq Out complete handler");
			_ss.removeEventListener(Event.COMPLETE, _sequencerOutCompleteHandler);
			dispatchEvent(new AnimationEvent(AnimationEvent.OUT));
			
		}//end function
		
		// =================================================
		// ================ @Getters / Setters
		// =================================================
		public function get mc():ScoreboardMC{ 
			return _mc; 
		}
		// =================================================
		// ================ @Interfaced
		// =================================================
		
		// =================================================
		// ================ @Core Handler
		// =================================================
		private function _disposeSequencer():void{
			//
			_ss = null;
		}
		// =================================================
		// ================ @Overrides
		// =================================================
		
		// =================================================
		// ================ @Constructor
		// =================================================

		public function KFScoreboardController($mc:ScoreboardMC)
		{
			super();
			_mc = $mc;
			addChild(mc);
			_init();
		}//end constructor
	}//end class
}//end package