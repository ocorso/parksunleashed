// =================================================
// ================ @Time Converter -
// @usage - utility to convert a value in milliseconds into a time code format
// =================================================
package com.theginbin.utils
{
	public class TimeConverter
	{
		public function TimeConverter()
		{
		}
		
		//FUNCTION : CONVERT TIME FROM MILLISECONDS (ex. usage - dateObject.getTime();, video duration, or any millisecond number)
		public function convertTime(time:Number, minUnit:String):String { 
			var convertedTime:String="";
			var ms:Number = time; //milliseconds
			var s:Number= Math.floor(ms/1000); //seconds
			var m:Number= Math.floor(s/60); //minutes
			ms %=1000; //use the modulo operator to keep it displaying in the correct range
			s%=60;
			m%=60;
			
			switch (minUnit) {
				case "minutes":
					convertedTime = (m<10?"0"+m.toString():m.toString()); //displays "01"
				break;
				
				case "seconds":
					convertedTime = (m<10?"0"+m.toString():m.toString())+":"+(s<10?"0"+s.toString():s.toString()); //displays "01:30"
				break;
				
				case "milliseconds":
					var msTxt:String = ms.toString();
					if (msTxt.length >= 3) msTxt = msTxt.substr(0,2); //just grab the first 2 digits
					convertedTime = (m<10?"0"+m.toString():m.toString())+":"+(s<10?"0"+s.toString():s.toString())+":"+(ms<10?"0"+msTxt:msTxt);//displays "01:30:45"
				break;
			}
			
			return convertedTime;
		}
		
		public function convertMillisecondsToHours(time:Number):String {
			var convertedTime:String="";
			var ms:Number = time; //milliseconds
			var s:Number= Math.floor(ms/1000); //seconds
			var m:Number= Math.floor(s/60); //minutes
			var h:Number = Math.floor(m/60); //hours
			ms %=1000; //use the modulo operator to keep it displaying in the correct range
			s%=60;
			m%=60;
			h%=60;
			
			var msTxt:String = ms.toString();
			if (msTxt.length >= 3) msTxt = msTxt.substr(0,2); //just grab the first 2 digits
			convertedTime = (h<10?"0"+h.toString():h.toString())+":"+(m<10?"0"+m.toString():m.toString())+":"+(s<10?"0"+s.toString():s.toString())+":"+(ms<10?"0"+msTxt:msTxt);//displays "10:01:30:45"
			
			return convertedTime;
		}
	}
}