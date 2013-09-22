package com.zyrtec.baseballmemory.view.screens.instructions
{
	import flash.display.MovieClip;
	
	public class QuizView extends MovieClip
	{
		public var errorMessage:MovieClip;
		public var btnNext:MovieClip;
		public var btnDone:MovieClip;
		public var btnSubmit:MovieClip;
		public var question1:MovieClip;
		public var question2:MovieClip;
		public var btnSkip:MovieClip;
		public var txtResults:MovieClip;
		
		protected var _answerArray:Array;
		
		public function QuizView()
		{
			_answerArray = new Array();			
		}
		
		public function get answerArray():Array {
			return _answerArray;
		}
	}
}