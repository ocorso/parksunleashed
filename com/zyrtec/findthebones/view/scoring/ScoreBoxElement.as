﻿package com.zyrtec.findthebones.view.scoring{	import flash.display.MovieClip;		public class ScoreBoxElement extends MovieClip	{		public var valueBox:MovieClip;				public function ScoreBoxElement()		{		}				public function setContentText(str:String):void {			if (str.indexOf(":") > 0) { //separate the string of the clock so it won't look funky				var numArray:Array = str.split( ":" );				valueBox.txtMin.text = numArray[0];				valueBox.txtSec.text = numArray[1];				valueBox.txtMs.text = numArray[2];			} else {				valueBox.txt.text = str;			}		}	}}