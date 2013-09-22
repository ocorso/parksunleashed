package com.zyrtec.pianoTuning.view.scoring {
	import com.bigspaceship.utils.Out;
	import com.g2.gaming.framework.ScoreBoard;
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.zyrtec.pianoTuning.controller.PianoTuningMain;
	
	import flash.display.MovieClip;
	import flash.text.TextField;

	public class PTScoreboard extends ScoreBoard {
		//declare public display objects
		public var clock : MovieClip;
		public var pairs : MovieClip;
		public var bg : MovieClip;
		public var playerToBeat:TextField;		public var scoreToBeat:TextField;

		private var _textElements : Object;

		public function PTScoreboard() {
			//super();
		}

		override public function createTextElement(key : String, obj : *) : void {
			if (_textElements == null) {
				_textElements = {};
			}
			_textElements[key] = obj;
		}

		override public function update(key : String, value : String) : void {
			var tempElement;
			if (key == PianoTuningMain.LIVES) {
				Out.warning(this, "update LIVES: "+value);
				tempElement = LifeMeterElement(_textElements[key]);
				tempElement.setLives(value);
				tempElement.x = (this.width - tempElement.width) / 2;
				if (value!="3:3")	TweenMax.to(this, 0.25, {glowFilter:{color:0xff0000, alpha:1, blurX:30, blurY:30}, ease:Cubic.easeInOut, yoyo:true, repeat:1});
			} else if (key == PianoTuningMain.TUNES_CORRECT) {
				Out.debug(this, "update TUNES_CORRECT");
				tempElement = ScoreBoxElement(_textElements[key]);
				tempElement.setContentText(value);
				if (int(value) != 0) TweenMax.to(this, 0.25, {glowFilter:{color:0x00ff00,  alpha:1, blurX:30, blurY:30}, ease:Cubic.easeInOut, yoyo:true, repeat:1, repeatDelay:.01});;
			} else if (key == PianoTuningMain.PLAYER_TO_BEAT) {
				TextField(_textElements[key]).text = value;
			} else if (key == PianoTuningMain.SCORE_TO_BEAT) {
				TextField(_textElements[key]).text = value;
			}
		}
	}
}