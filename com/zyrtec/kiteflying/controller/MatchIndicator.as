package com.zyrtec.kiteflying.controller
{
	import com.bigspaceship.utils.Out;
	import com.greensock.TweenMax;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.plugins.VisiblePlugin;
	import com.zyrtec.kiteflying.events.KiteFlyingEvent;
	import com.zyrtec.kiteflying.model.KFModel;
	
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class MatchIndicator extends EventDispatcher
	{
		private var _m		:KFModel;
		public var view		:MovieClip;
		public var extra	:MovieClip;
		private var _timer	:Timer;
		private const __I	:Number = 800;
		// =================================================
		// ================ @Callable
		// =================================================
		public function showRound($n:Number):void{
			
			Out.status(this, "round "+$n);
			view.gotoAndStop(KFModel.LABEL_ROUND);
			
		}//end function
		
		public function showStreak($type:String):void{
			
			Out.status(this, "show streak: "+ $type);
			switch($type){
				case KFModel.STREAK_TYPES[0] : extra = new Double();
					break;
				case KFModel.STREAK_TYPES[1] : extra = new FourTime();
					break;
				case KFModel.STREAK_TYPES[1] : extra = new EightTimes();
					break;
			}
			view.gotoAndStop(KFModel.LABEL_STREAK);
			
			view.addChild(extra);
			view.visible = true;
			_timer.start();
		}
		// =================================================
		// ================ @Workers
		// =================================================
		private function _init():void
		{
			_m		= KFModel.getInstance();
			TweenPlugin.activate([VisiblePlugin]);
			TweenPlugin.activate([AutoAlphaPlugin]);
			
			_timer	= new Timer(__I);
			_timer.addEventListener(TimerEvent.TIMER, _animateOut);
			
			view.alpha		= 0;
			view.visible 	= false;
		}
		
		// =================================================
		// ================ @Handlers
		// =================================================
		// =================================================
		// ================ @Animation
		// =================================================
		public function animateIn($e:KiteFlyingEvent = null):void{
			var label:String = KFModel.LABEL_PREFIX+_m.currentMatchCode;
			view.gotoAndStop(label);
			TweenMax.to(view, .2,{autoAlpha:1, onComplete:_timer.start});
		}
		private function _animateOut($e:TimerEvent):void{	
			
			_timer.reset();
			TweenMax.to(view, .3,{autoAlpha:0});

			if (extra) {
				view.removeChild(extra);
				extra = null;
			}
		}
		
		// =================================================
		// ================ @Getters / Setters
		// =================================================
		
		// =================================================
		// ================ @Interfaced
		// =================================================
		
		// =================================================
		// ================ @Core Handler
		// =================================================
		
		// =================================================
		// ================ @Overrides
		// =================================================
		
		// =================================================
		// ================ @Constructor
		// =================================================
		public function MatchIndicator($mc:MovieClip, target:IEventDispatcher=null)
		{
			super(target);
			view 	= $mc;
			_init();
		}
	}
}