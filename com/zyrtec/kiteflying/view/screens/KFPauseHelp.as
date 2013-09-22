package com.zyrtec.kiteflying.view.screens
{
	import com.g2.gaming.framework.BasicScreen;
	import com.g2.gaming.framework.events.ButtonIdEvent;
	import com.zyrtec.interfaces.IScreen;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class KFPauseHelp extends KFAbstractScreen implements IScreen
	{
		public function KFPauseHelp(id:int=0, addBitmapBackground:Boolean=false, width:Number=0, height:Number=0, isTransparent:Boolean=false, color:uint=0)
		{
			super(id, addBitmapBackground, width, height, isTransparent, color);
		}
		
	}
}