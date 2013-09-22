package com.zyrtec.pianoTuning.view.scoring {
	import flash.display.Sprite;
	import flash.utils.getDefinitionByName;
	import flash.display.MovieClip;

	/**
	 * @author simontam
	 */
	public class LifeMeterElement extends MovieClip {
		private var _lifeHolder : Sprite;

		public function LifeMeterElement() {
			_lifeHolder = new Sprite();
			this.addChild(_lifeHolder);
		}

		public function setLives(str : String) : void {
			var LifeClass : Class = getDefinitionByName("life") as Class;
			var life : MovieClip;
			
			if (str.indexOf(":") > 0) {
				var lifeArray : Array = str.split(":");
				trace("LifeMeterElement setLives " + lifeArray[1]); 
				clear();
				for (var i : int = 0;i < int(lifeArray[1]);i++) {
					life = new LifeClass() as MovieClip;
					if (i > int(lifeArray[0]) - 1) {
						life.gotoAndPlay("dead");
					}
					life.x = i * (life.width + 3);
					life.y = -2;
					_lifeHolder.addChild(life);
				}
			}
		}

		private function clear() : void {
			while (_lifeHolder.numChildren > 0) {
				_lifeHolder.removeChildAt(0);
			}
		}
	}
}
