package com.zyrtec.pianoTuning.view.pianoKeyboard {
	import com.zyrtec.pianoTuning.model.SoundData;
	import com.g2.gaming.framework.events.SoundEvent;

	import flash.geom.ColorTransform;

	import com.zyrtec.pianoTuning.events.PianoTuningEvent;
	import flash.events.Event;
	import com.greensock.easing.Back;
	import com.greensock.TweenMax;

	import flash.events.MouseEvent;
	import flash.display.MovieClip;

	/**
	 * @author simontam
	 */
	public class PianoKey extends MovieClip {
		private var index : int;
		private var color : Number;

		public function PianoKey() {
//			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function init(p_index:int, color:Number):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			this.alpha = 0;
			this.index = p_index;
			this.color = color;
			deactivate();
		}

		public function deactivate() : void {
			this.removeEventListener(MouseEvent.CLICK, onPianoKeyClick);
			this.buttonMode = false;
		}

		private function onPianoKeyClick(event : MouseEvent) : void {
			trace("PianoKey onPianoKeyClick ");
			doPlay();
			dispatchEvent(new PianoTuningEvent(PianoTuningEvent.KEY_CLICK, String(this.index), true));
		}

		public function activate() : void {
			this.addEventListener(MouseEvent.CLICK, onPianoKeyClick);
			this.buttonMode = true;
		}

		public function doPlay():void { //color:Number) : void {
		trace("PianoKey doPlay ");
			var colorTransform:ColorTransform = this.transform.colorTransform;
			colorTransform.color = color;
			this.transform.colorTransform = colorTransform;
			TweenMax.to(this, 0.3, {alpha:1, ease:Back.easeIn});
			TweenMax.delayedCall(0.5, fade);//randomly play a hooray
			dispatchEvent(new SoundEvent(SoundEvent.PLAY_SOUND, "note" + index, false, 0, 0, 1, true));		}
		
		private function fade():void {
			TweenMax.to(this, 0.15, {alpha:0, ease:Back.easeIn});
		}
	}
}
