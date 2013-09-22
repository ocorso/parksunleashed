package com.zyrtec.pianoTuning.view.screens.instructions
{
	import com.zyrtec.pianoTuning.events.PianoTuningEvent;
	
	import com.theginbin.ui.RollOverButton;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	// =================================================
	// ================ @Class
	// =================================================
	public class Quiz extends EventDispatcher
	{
		private var _quizMC:MovieClip; //holds the graphics
		private var _totalCorrect:uint // total correct answers
		private var _questionTotal:uint;// total number of bonus questions offered 
		private var _currentQuestion:int;// current question
		private var _questionArray:Array;// array of questions
		private var _result:int;// 0:none	1:correct	2:incorrect
		
		// =================================================
		// ================ @Constructor
		// =================================================
		public function Quiz(quizClip:MovieClip) {
			_quizMC = quizClip;
			TweenPlugin.activate([VisiblePlugin, TransformAroundPointPlugin, TransformAroundCenterPlugin, ShortRotationPlugin]);
		}
		
		// =================================================
		// ================ @Callable
		// =================================================
		public function init():void {
			_quizMC.errorMessage.visible=false;
			_quizMC.btnNext.visible=false;
			_quizMC.btnDone.visible=false;
			_quizMC.btnNext.alpha=0;
			_quizMC.btnDone.alpha=0;
			_quizMC.btnSubmit.alpha = 1;
			_quizMC.btnSubmit.visible = true;
			
			_questionArray=[_quizMC.question1, _quizMC.question2];
			
			_questionArray[0].id=0;
			_questionArray[0].answer="24";//ANSWER 1
			
			_questionArray[1].id=1;
			_questionArray[1].answer="Liuidel";//ANSWER 2: Li-q-uid-G-el
			
			_questionTotal=_questionArray.length;
			_currentQuestion=0;
			_totalCorrect = 0;
			
			for each (var clip:MovieClip in _questionArray) {
				if (clip.id != _currentQuestion) {
					clip.visible = false;
					clip.alpha = clip.alpha = 0;
				} else {
					clip.visible = true;
				}
				Question(clip).clearFields();
			}
			
			_quizMC.btnSkip.visible = true;
			_quizMC.btnSkip.alpha = 1;
			
			showQuestion();
		}
		
		public function addEvents():void {
			RollOverButton(_quizMC.btnSubmit).addEvents();
			_quizMC.btnSubmit.addEventListener(MouseEvent.CLICK, onSubmitClick);
			
			RollOverButton(_quizMC.btnSkip).addEvents();
			_quizMC.btnSkip.addEventListener(MouseEvent.CLICK, onSkipClick);
			
			for each (var clip:MovieClip in _questionArray) {
				if (clip.id == _currentQuestion) {
					Question(clip).addEvents();
					clip.addEventListener(PianoTuningEvent.QUESTION_ANSWERED, onQuestionAnswered); //handle them pressing enter to submit
				}
			}
		}
		
		public function removeEvents():void {
			RollOverButton(_quizMC.btnNext).removeEvents();
			_quizMC.btnNext.removeEventListener(MouseEvent.CLICK, onNextClick);
			RollOverButton(_quizMC.btnSubmit).removeEvents();
			_quizMC.btnSubmit.removeEventListener(MouseEvent.CLICK, onSubmitClick);
			RollOverButton(_quizMC.btnSkip).removeEvents();
			_quizMC.btnSkip.removeEventListener(MouseEvent.CLICK, onSkipClick);
			RollOverButton(_quizMC.btnDone).removeEvents();
			_quizMC.btnDone.removeEventListener(MouseEvent.CLICK, onNextClick);
			
			//remove question events
			for each (var clip:MovieClip in _questionArray) {
				Question(clip).removeEvents();
				clip.removeEventListener(PianoTuningEvent.QUESTION_ANSWERED, onQuestionAnswered);
			}
		}
		
		// =================================================
		// ================ @Workers
		// =================================================
		
		private function showQuestion():void {
			_quizMC.errorMessage.visible=false;
			if (_currentQuestion<_questionTotal) {
				TweenMax.to(_quizMC.txtResults, 0.3, {alpha:0, onComplete:_quizMC.txtResults.gotoAndStop, onCompleteParams:["START"]});
				TweenMax.to(_quizMC.txtResults, 0.3, {alpha:1, delay:0.3});
				//show question - set it up ----- animate in and listen for question answered (submitted with enter button)
				for each (var clip:MovieClip in _questionArray) {
					if (clip.id != _currentQuestion) {
						TweenMax.to(clip, 0.3, {alpha:0, visible:false});
					} else {
						clip.visible = true;
						TweenMax.to(clip, 0.3, {alpha:1, delay:0.3, onComplete:addEvents});
					}
				}
			} else {// no more questions
				this.dispatchEvent(new PianoTuningEvent(PianoTuningEvent.QUIZ_COMPLETE));
			}
		}
		
		// =================================================
		// ================ @Handlers
		// =================================================
		
		private function onSkipClick(e:MouseEvent):void {
			Question(_questionArray[_currentQuestion]).removeEvents();
			_currentQuestion++;
			showQuestion();
		}
		
		private function onSubmitClick(e:MouseEvent=null):void {
			RollOverButton(_quizMC.btnSubmit).removeEvents();
			_quizMC.btnSubmit.removeEventListener(MouseEvent.CLICK, onSubmitClick);
			_quizMC.errorMessage.visible=false;
			
			var result:uint = _questionArray[_currentQuestion].checkAnswer();
			trace("RESULT = "+result);
			switch (result) {
				case 0:  //error
					_quizMC.errorMessage.visible=true;
					RollOverButton(_quizMC.btnSubmit).addEvents();
					_quizMC.btnSubmit.addEventListener(MouseEvent.CLICK, onSubmitClick);
					break;
				case 1: //correct
					TweenMax.to(_quizMC.txtResults, 0.3, {alpha:0, onComplete:_quizMC.txtResults.gotoAndStop, onCompleteParams:["CORRECT"]});
					Question(_questionArray[_currentQuestion]).removeEvents();
					_totalCorrect++;
					break;
				case 2: //wrongo
					TweenMax.to(_quizMC.txtResults, 0.3, {alpha:0, onComplete:_quizMC.txtResults.gotoAndStop, onCompleteParams:["WRONG"]});
					Question(_questionArray[_currentQuestion]).removeEvents();
					Question(_questionArray[_currentQuestion]).showCorrectAnswer();
					break;
			}
			
			if (result==1 || result==2) {TweenMax.to(_quizMC.btnSkip, 0.3, {alpha:0, visible:false});
				RollOverButton(_quizMC.btnSkip).removeEvents();
				_quizMC.btnSkip.removeEventListener(MouseEvent.CLICK, onSkipClick);
				TweenMax.to(_quizMC.btnSkip, 0.3, {alpha:0, visible:false});
				TweenMax.to(_quizMC.txtResults, 0.3, {alpha:1, delay:0.3});
				TweenMax.to(_quizMC.btnSubmit, 0.3, {alpha:0, visible:false});
				if (_currentQuestion<(_questionTotal-1)) {//if question is second to last change this to btn Done
					_quizMC.btnNext.addEventListener(MouseEvent.CLICK, onNextClick);
					_quizMC.btnNext.visible = true;
					TweenMax.to(_quizMC.btnNext, 0.3, {alpha:1, onComplete:RollOverButton(_quizMC.btnNext).addEvents});
				} else {
					_quizMC.btnDone.addEventListener(MouseEvent.CLICK, onNextClick);
					_quizMC.btnDone.visible = true;
					TweenMax.to(_quizMC.btnDone, 0.3, {alpha:1, onComplete:RollOverButton(_quizMC.btnDone).addEvents});
				}
			}
		}
		
		private function onNextClick(e:MouseEvent):void {
			RollOverButton(_quizMC.btnNext).removeEvents();
			_quizMC.btnNext.removeEventListener(MouseEvent.CLICK, onNextClick);
			
			_currentQuestion++;
			
			if (_currentQuestion<_questionTotal) {
				TweenMax.to(_quizMC.btnNext, 0.3, {alpha:0, visible:false});
				TweenMax.to(_quizMC.btnDone, 0.3, {alpha:0, visible:false});
				
				_quizMC.btnSkip.addEventListener(MouseEvent.CLICK, onSkipClick);
				_quizMC.btnSkip.visible = true;
				TweenMax.to(_quizMC.btnSkip, 0.3, {alpha:1, onComplete:RollOverButton(_quizMC.btnSkip).addEvents});
				
				_quizMC.btnSubmit.addEventListener(MouseEvent.CLICK, onSubmitClick);
				_quizMC.btnSubmit.visible = true;
				TweenMax.to(_quizMC.btnSubmit, 0.3, {alpha:1, onComplete:RollOverButton(_quizMC.btnSubmit).addEvents});
			}
			
			showQuestion();
		}
		
		private function onShowError(e:PianoTuningEvent):void {
			_quizMC.errorMessage.visible=true;
		}
		
		private function onQuestionAnswered(e:PianoTuningEvent):void { 
			e.target.removeEventListener(PianoTuningEvent.QUESTION_ANSWERED, onQuestionAnswered);
			onSubmitClick();
		}
		
		// =================================================
		// ================ @Getters / Setters
		// =================================================
		public function get totalCorrect():uint { return _totalCorrect; };
	}
}