package com.zyrtec.pianoTuning.view.screens {	import flash.text.TextField;	import flash.events.Event;
	import fl.controls.Slider;	import flash.display.MovieClip;	/**	 * @author simontam	 */	public class DebugTool extends MovieClip {		public var debugTimeBetweenNotes:Slider;		public var debugDelay:Slider;		public var secondsTF:TextField;		public var delayTF : TextField;
		public function DebugTool() {			this.addEventListener(Event.ENTER_FRAME, updateTextField);		}		private function updateTextField(event : Event) : void {			secondsTF.text = String(debugTimeBetweenNotes.value);			delayTF.text = String(debugDelay.value);
		}
	}}