﻿package com.g2.gaming.framework.events{	import flash.events.Event;	public class ButtonIdEvent extends Event	{		public static const BUTTON_ID:String = "button id";       	public var id:int;      		public function ButtonIdEvent(type:String, id:int, bubbles:Boolean=false, cancelable:Boolean=false)		{			super(type, bubbles, cancelable);			this.id = id;		}				override public function clone():Event {			return new ButtonIdEvent(type, id, bubbles, cancelable);		}			}}