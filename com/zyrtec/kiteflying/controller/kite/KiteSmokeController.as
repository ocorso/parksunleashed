package com.zyrtec.kiteflying.controller.kite
{
	import com.bigspaceship.utils.MathUtils;
	import com.greensock.TweenLite;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.zyrtec.kiteflying.model.KFModel;
	import com.zyrtec.kiteflying.utils.ParticleHelper;
	import com.zyrtec.kiteflying.view.ui.SmokeParticle;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	
	public class KiteSmokeController extends EventDispatcher
	{
		public var view					:Sprite;
		private var _isVisible			:Boolean = false;
		private var _game				:DisplayObjectContainer;
		
		// arrays in which to store our _smoke
		private var _smoke1 			:Vector.<SmokeParticle>; 
		private var _smoke2 			:Vector.<SmokeParticle>; 
		
		private var _x					:Number = 0;
		private var _y					:Number = 0;

		
		private const __MAX_SMOKE		:Number = 40;
		// =================================================
		// ================ @Callable
		// =================================================
		public function update($g:DisplayObjectContainer, $x:Number, $y:Number = 0):void{
			_game 	= $g;
			_x		= $x;
			_y		= $y;
			_emitSmoke1();
			_emitSmoke2();
			
		}//end function
		
		public function fadeOut():void{
			
			_smoke1.forEach(_fadeOutEach);	
			_smoke2.forEach(_fadeOutEach);
			isVisible = false; 	
			
		}//end function 
		

		// =================================================
		// ================ @Workers
		// =================================================
		private function _emitSmoke1(){
			
			var p:SmokeParticle;
			_smoke1.forEach(_updateEach); 
			p 				= ParticleHelper.createSmokeParticle(_game, _x+KFModel.COLLISION_AREA_WIDTH/4, _y+view.y-KFModel.SUPER_POWER_UP_Y_CHANGE); 
			p.side			= "left";
			p.xVel 			= 0; 
			p.yVel 			= 0; 
			p.drag 			= 0.97; 
			p.gravity 		= -0.4;
			p.clip.scaleX 	= p.clip.scaleY = MathUtils.getRandomNumber(0.3, 0.5); 
			p.clip.visible	= isVisible;
			p.shrink 		= 1.06;
			p.fade 			= 0.02; 
			_smoke1.push(p); 
			while(_smoke1.length>__MAX_SMOKE)
			{
				p 			= _smoke1.shift();
				p.destroy();
			}

		}//end function 
		private function _emitSmoke2(){
			
			_smoke2.forEach(_updateEach); 
			var xPos:Number 		= _x-KFModel.COLLISION_AREA_WIDTH/4;
			var p:SmokeParticle		= ParticleHelper.createSmokeParticle(_game, xPos, _y+view.y-KFModel.SUPER_POWER_UP_Y_CHANGE); 
			p.side					= "right";
			p.xVel 					= 0; 
			p.yVel 					= 0; 
			p.drag 					= 0.97; 
			p.gravity 				= -0.4;
			p.clip.scaleX 			= p.clip.scaleY = MathUtils.getRandomNumber(0.3, 0.5); 
			p.shrink 				= 1.06;
			p.fade 					= 0.02; 
			_smoke2.push(p); 
			
			while(_smoke2.length>__MAX_SMOKE){
				p 					= _smoke2.shift();
				p.destroy();
			}

		}//end function 
		
		// =================================================
		// ================ @Handlers
		// =================================================
		private function _updateEach($p:SmokeParticle, $i:int, $vect:Vector.<SmokeParticle>):void{ $p.update();}
		private function _fadeOutEach($p:SmokeParticle, $i:int, $vect:Vector.<SmokeParticle>):void{ TweenLite.to($p.clip, .2, {autoAlpha:0});}
		private function _fadeInEach($p:SmokeParticle, $i:int, $vect:Vector.<SmokeParticle>):void{ TweenLite.to($p.clip, 0, {autoAlpha:1});}
	
		// =================================================
		// ================ @Animation
		// =================================================
		
		// =================================================
		// ================ @Getters / Setters
		// =================================================

		public function get isVisible():Boolean
		{
			return _isVisible;
		}

		public function set isVisible(value:Boolean):void
		{
			_isVisible = value;
			if (value) {
				_smoke1.forEach(_fadeInEach);
				_smoke2.forEach(_fadeInEach);
			}
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

		public function KiteSmokeController()
		{
			view 			= new Sprite();
			_smoke1 		= new Vector.<SmokeParticle>();
			_smoke2 		= new Vector.<SmokeParticle>();
			
		}//end constructor
	}//end class
}//end package