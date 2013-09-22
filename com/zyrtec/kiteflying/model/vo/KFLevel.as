package com.zyrtec.kiteflying.model.vo
{
	import com.bigspaceship.utils.Out;

	public class KFLevel extends Object
	{
		public var id:String;
		public var matches	:Vector.<String>;
		public var sequences:Array;
		
		public function KFLevel($id:String)
		{
			super();
			id = $id;
		}
		public function toString():String{
			Out.debug(this, "--------------------------");
			Out.info(this, id);
			Out.debug(this, "--------------------------");
			Out.status(this, "matches:");
			for each(var e:* in matches)	Out.debug(this, e);
			Out.debug(this, "--------------------------");
			Out.status(this, "sequences:");
			for (var c:* in sequences){
				Out.info(this, "seq "+c)
				for each (var i:* in sequences[c])
					Out.debug(this, i);
				
			}//
			Out.debug(this, "--------------------------");
			return id;
		}
	}
}