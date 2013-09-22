package com.zyrtec.kiteflying.model.vo
{
	public class KFScoreboardValueObject
	{
		private var _windPower		:int = 50;
		private var _currentScore	:Number = 0;
		private var _maxScore		:Number = 0;
		
		public function KFScoreboardValueObject($wp:int, $cs:Number, $ms:Number)
		{
			_windPower 		= $wp;
			_currentScore 	= $cs;
			_maxScore		= $ms;
		}

		public function get windPower():int
		{
			return _windPower;
		}

		public function set windPower(value:int):void
		{
			_windPower = value;
		}

		public function get currentScore():Number
		{
			return _currentScore;
		}

		public function set currentScore(value:Number):void
		{
			_currentScore = value;
		}

		public function get maxScore()
		{
			return _maxScore;
		}

		public function set maxScore(value):void
		{
			_maxScore = value;
		}


	}
}