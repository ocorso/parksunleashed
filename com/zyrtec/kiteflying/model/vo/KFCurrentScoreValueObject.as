package com.zyrtec.kiteflying.model.vo
{
	public class KFCurrentScoreValueObject
	{
		public var total:Number;
		
		private var _ones		:Number = 0;
		private var _tens		:Number = 0;
		private var _hundreds	:Number = 0;
		private var _thousands	:Number = 0;
		
		public function KFCurrentScoreValueObject($n:Number = 0)
		{
			total = $n;
		}

		public function get ones():Number
		{
			return total % 10;
		}

		public function get tens():Number
		{
			var n:Number = total - thousands*1000 - hundreds*100;
			return Math.floor(n / 10) ;
		}


		public function get hundreds():Number
		{
			return Math.floor((total - thousands*1000)/100);
		}

		public function get thousands():Number
		{
			return Math.floor(total/1000);
		}

	}
}