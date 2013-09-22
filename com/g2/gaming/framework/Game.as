package com.g2.gaming.framework
{
	import flash.display.MovieClip;

	public class Game extends MovieClip ///SUPER CLASS FOR ALL GAMES
	{
		public static const GAME_OVER:String = "game over";
		public static const NEW_LEVEL:String = "new level";
		public static const PAUSE:String = "pause";
		
		public function Game()
		{
			super();
		}
		
		public function newGame():void {}
		
		public function newLevel():void {}
		
		public function runGame():void {}
		
		public function resumeGame():void {}
		
		public function destroy():void {}
	}
}