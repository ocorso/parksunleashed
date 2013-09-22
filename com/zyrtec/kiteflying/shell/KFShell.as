package com.zyrtec.kiteflying.shell
{

		import com.bigspaceship.utils.Out;
		import com.greensock.easing.*;
		import com.greensock.plugins.*;
		import com.zyrtec.interfaces.IMiniGame;
		import com.zyrtec.shell.MiniGameShell;
		
		import flash.display.MovieClip;
		import flash.events.Event;
		import flash.events.MouseEvent;
		import flash.net.URLRequest;
		import flash.net.navigateToURL;
		
		// =================================================
		// ================ @Class
		// =================================================
		public class KFShell extends MiniGameShell
		{
			
			public static const OFFICIAL_RULES_URL:String = "https://zyrtec.promo.eprize.com/lovetheparkteaser/rules";

			// =================================================
			// ================ @Constructor
			// =================================================
			public function KFShell()
			{
				
				super();
				_instructions = new KFInstructionsMC();
				_appFileName = "KiteFlyingApp.swf";
				Out.status(this, "KF Loader construct-o-lion eater");
				//addEventListener(Event.ADDED_TO_STAGE, onAddedToStage); //USE ONLY FOR TESTING, COMMENT OUT FOR DELIVERY
	
			}//end constructor
		
		}//end class
	
}//end package