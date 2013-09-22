package com.zyrtec.cardqueen.video
{
	import com.zyrtec.cardqueen.events.CardQueenEvent;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	
	public class Card extends MovieClip
	{
		public var hit:MovieClip;
		private var _position:uint;
		
		public function Card()
		{
			super();
			TweenPlugin.activate([GlowFilterPlugin]);
		}
		
		public function addEvents():void {
			hit.buttonMode = true;
			hit.addEventListener(MouseEvent.CLICK, onCardClick);
			hit.addEventListener(MouseEvent.ROLL_OVER, onCardRoll);
			hit.addEventListener(MouseEvent.ROLL_OUT, onCardRollOut);
		}
		
		public function removeEvents():void {
			hit.buttonMode = false;
			hit.removeEventListener(MouseEvent.CLICK, onCardClick);
			hit.removeEventListener(MouseEvent.ROLL_OVER, onCardRoll);
			hit.removeEventListener(MouseEvent.ROLL_OUT, onCardRollOut);
		}
		
		public function onCardRoll(e:MouseEvent):void {
			TweenMax.to(this, 0.3, {glowFilter:{color:0x36ff00, alpha:1, blurX:10, blurY:10, strength:2}});
		}
		
		public function onCardRollOut(e:MouseEvent):void {
			TweenMax.to(this, 0.3, {glowFilter:{color:0x36ff00, alpha:0, blurX:0, blurY:0, strength:0}});
		}
		
		private function onCardClick(e:MouseEvent):void {
			this.dispatchEvent(new CardQueenEvent(CardQueenEvent.CARD_CLICKED, _position));
		}
		
		public function get position():uint {
			return _position;
		}
		
		public function set position(value:uint):void {
			_position = value;
		}
	}
}