package com.zyrtec.kiteflying.utils
{
	import com.bigspaceship.utils.Out;
	import com.zyrtec.kiteflying.model.KFModel;

	public class MatchHelper
	{
		/**
		 * 		this function determines if we score points
		 * 		or if windPower decreases
		 * 
		 * @param $c			code of particle
		 * @param $m			current code to match
		 * @return 				whether or not we score or lose power 
		 * 
		 */		
		public static function isHitGood($c:String, $m:String):Boolean{

			var isGood:Boolean 	= false;
			var pType:String	= $c.charAt(0);
			var pColor:String	= $c.charAt(1);

			//Out.debug(new Object(), "particle code slice: "+ $c.slice(0,2));
			//Out.debug(new Object(), "match: "+$m);
			//single variable match (either color OR type)
			if ($m.length == 1 && ($m == pColor || $m == pType)){
				isGood = true;
			}else if ($m.length == 2 && $m == $c.slice(0,2)) {
				
					isGood = true;
			}
			
			
			return isGood;
			
		}//end static function
		
		public static function isCollision($pX:Number, $kX:Number):Boolean{
			return ( 	($pX < ($kX + KFModel.COLLISION_AREA_WIDTH/2)	) 
				&& 	($pX > ($kX - KFModel.COLLISION_AREA_WIDTH/2)	));
		}
		
	}//end class

}//end package 