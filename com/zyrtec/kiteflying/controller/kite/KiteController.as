package com.zyrtec.kiteflying.controller.kite
{
	import com.bigspaceship.display.StandardButton;
	import com.greensock.TweenMax;
	import com.greensock.plugins.RemoveTintPlugin;
	import com.greensock.plugins.TintPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.zyrtec.kiteflying.model.KFModel;
	import com.zyrtec.kiteflying.view.ui.SmokeParticle;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.filters.DropShadowFilter;
	import flash.geom.ColorTransform;
	
	import net.ored.util.ORedUtils;
	
	public class KiteController extends EventDispatcher
	{
		public var view		:KiteMC;
		private var _y		:Number;
		private var _smoke	:KiteSmokeController;
		
		
		// =================================================
		// ================ @Callable
		// =================================================
		
		public function blinkColor($isGood:Boolean):void{
			TweenMax.to(view, 0.01, {removeTint:true, overwrite:true, onComplete:_blinkColor, onCompleteParams:[$isGood]});
		}
		// =================================================
		// ================ @Workers
		// =================================================
		private function _init():void
		{
			TweenPlugin.activate([RemoveTintPlugin, TintPlugin]);
			view.filters 	= [new DropShadowFilter(165,90,0x000000,.2,15,15)];
			_smoke 			= new KiteSmokeController();	
		}
		
		private function _blinkColor($isGood:Boolean):void{
			var tint:Number = $isGood ? 0x00ff00 : 0xff0000;
			TweenMax.to(view, 0.05, {colorTransform:{tint:tint, tintAmount:0.8, brightness:1.3}, yoyo:true, repeat:5, repeatDelay:.01});
		}
		// =================================================
		// ================ @Handlers
		// =================================================
		
		// =================================================
		// ================ @Animation
		// =================================================
		
		// =================================================
		// ================ @Getters / Setters
		// =================================================
		public function get smoke():KiteSmokeController
		{
			return _smoke;
		}

		public function set smoke(value:KiteSmokeController):void
		{
			_smoke = value;
		}

		public function get y():Number
		{
			return _y;
		}

		public function set y(value:Number):void
		{
			_y 				= value;
			view.y 			= value;
			smoke.view.y 	= value;
		}
		
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




		public function KiteController($mc:KiteMC)
		{
			view = $mc;
			_init();
		}
		
	}
}