package com.zyrtec.pianoTuning.view.pianoKeyboard {
	import com.bigspaceship.utils.Out;
	import com.zyrtec.pianoTuning.events.PianoTuningEvent;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.utils.Timer;

	/**
	 * @author simontam
	 */
	public class PianoKeyboard extends MovieClip {
		public static const USER_MODE : String = "USER_MODE";		public static const SELFPLAY_MODE : String = "SELFPLAY_MODE";
		public var note0 : MovieClip;		public var note1 : MovieClip;		public var note2 : MovieClip;		public var note3 : MovieClip;		public var note4 : MovieClip;
		public var note5 : MovieClip;
		public var note6 : MovieClip;
		public var note7 : MovieClip;
		public var note8 : MovieClip;
		public var note9 : MovieClip;
		public var note10 : MovieClip;
		public var note11 : MovieClip;
		public var note12 : MovieClip;
		public var note13 : MovieClip;
		private var _userSequence : String = "";
		private const keyColorSequence:Array = [	0xff0000, //0
													0xff6600, //1
													0xffcc00, //2
													0x009900, //3
													
													0xcc3300, //4
													0xffff00, //5
													0xff0000, //6
													0xff6600, //7
													0x90d42d, //8
													0x0000ff, //9
													0x15890f, //10
													0x009900, //11
													
													0x99cc33, //12
													0xff2200, //13
													0x00ffff];//14

		public function PianoKeyboard() {
		}

		public function init() : void {
			var key:PianoKey;
			for (var i:int = 4; i < 11; i++) {
				key = getChildByName("note" + i) as PianoKey;
				key.init(i, keyColorSequence[i]);
			}
		}

		public function deactivateKeyboard() : void {
			var key:PianoKey;
			for (var i:int = 4; i < 11; i++) {
				key = this.getChildByName("note" + i) as PianoKey;
				key.deactivate();
			}
		}

		public function activateKeyboard() : void {
			Out.status(this, "activateKeyboard");
			var key:PianoKey;
			for (var i:int = 4; i < 11; i++) {
				key = this.getChildByName("note" + i) as PianoKey;
				key.activate();
			}
		}

		private function onPianoKeyClick(event : MouseEvent) : void {
			var key : String = String(event.target.name).substr(-1, 1);
			_userSequence += key;
//			if (_userSequence.length >= _numNotes) {
//				onActivationTimesUp();
//			}
//			dispatchEvent(new PianoTuningEvent(PianoTuningEvent.PIANO_KEY_CLICKED, key));
		}

		public function playNote(note:uint):void {// : uint, orderInSequence:uint) : void {
			Out.status(this, "playNote: " + note);
			var key:PianoKey = this.getChildByName("note" + String(note)) as PianoKey;
			key.doPlay(); //keyColorSequence[orderInSequence]);
		}
	}
}
