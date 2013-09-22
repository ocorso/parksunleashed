package com.zyrtec.pianoTuning.view.pianoKeyboard {
	import com.greensock.easing.Back;
	import com.greensock.TweenMax;

	import flash.display.MovieClip;

	/**
	 * @author simontam
	 */
	public class Staff extends MovieClip {
		public var noteOnStaff0 : MovieClip;

		public function Staff() {
		}

		public function init() : void {
		}
		
		public function glowNote(noteIndex:uint):void {
			var note:MovieClip = this.getChildByName("noteOnStaff" + noteIndex) as MovieClip;
			TweenMax.to(note, 0.3, {alpha:1, ease:Back.easeOut});
//			TweenMax.to(note, .5, {glowFilter:{color:0xff9933, alpha:0.9, blurX:10, blurY:10}, onComplete:fadeOutGlow});  
		}
		
		private function fadeOutGlow(noteGlowing:MovieClip):void {
			TweenMax.to(noteGlowing, .2, {glowFilter:{color:0xff9933, alpha:0, blurX:15, blurY:15, strength:3}});  
			TweenMax.to(noteGlowing, 0.2, {alpha:0, ease:Back.easeOut});
		}
	}
}