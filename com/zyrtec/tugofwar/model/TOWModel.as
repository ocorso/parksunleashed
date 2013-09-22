﻿package com.zyrtec.tugofwar.model{	import com.bigspaceship.utils.Out;	import com.zyrtec.adapters.ShellAdapter;	import com.zyrtec.interfaces.IGameData;	import com.zyrtec.model.MiniGameModel;	import com.zyrtec.utils.EncryptUtils;		import flash.display.*;	import flash.events.*;		import net.ored.util.ORedUtils;	// =================================================	// ================ @Class	// =================================================	public class TOWModel extends MiniGameModel	{		public static const SHOW_FRIEND_BONUS:Boolean = false; //whether or not the game will offer an invite a friend bonus //mandatory for high scores screen				public static const VIDEO_BOY_STILL_PATH:String = "assets/flv/boy_still.flv";		public static const VIDEO_BOY_BACKWARDS_PATH:String = "assets/flv/boy_backwards.flv";		public static const VIDEO_DOG_STILL_PATH:String = "assets/flv/dog_still.flv";		public static const VIDEO_DOG_BACKWARDS_PATH:String = "assets/flv/dog_backwards.flv";				//custom display constants on scoreboard		public static const TIME:String = "time";	//	timer count		public static const LEVEL:String = "level";	//	levels		public static const PATTERN:String = "pattern";	//	patterns				private static var _instance:TOWModel=null;		// SINGLETON instance				//game specific		private var _hasFriendBonus:Boolean; //invite a friend bonus		private var _gameLevel:int=0;	 //game level		private var _wonGame:Boolean = false;				private var _isDebugMode:Boolean = false;//	end game on 1 error		// =================================================		// ================ @Constructor		// =================================================		public function TOWModel( event:SingletonEnforcer ):void		{					}		public static function getInstance():TOWModel		{			if (_instance == null) {				_instance = new TOWModel(new SingletonEnforcer());			}			return _instance;		}		// =================================================		// ================ @Callable		// =================================================		/*override public function setGameData($gameData:IGameData):void {			super.setGameData($gameData as TOWGameData);					}*/				public function track($id, $val):void{			shell.track(_uid, _sid, $id, $val);					}				// =================================================		// ================ @Workers		// =================================================		// =================================================		// ================ @Handlers		// =================================================				// =================================================		// ================ @Getters / Setters		// =================================================		override public function get dataToSend():Object{ 						var dataObj:Object = new Object();						dataObj.UserID = uid;			dataObj.GameID = gid;			dataObj.SessionID = sid;			dataObj.Stars = stars;						var customDataObj:Object = new Object();//data to encrypt						if (isRefreshScore || !this.wonGame) {				customDataObj.userTime = -1;			} else {				customDataObj.userTime = _score;			}			isRefreshScore = false;						//dataObj.Data = encryptor.encrypt(customDataObj);			dataObj.Data = customDataObj;						//Out.info(this, "here is ecrypted data: "+dataObj.Data);			Out.warning(this, "game ID: " + gid);						Out.info(this, "here is the object data to send : ");			ORedUtils.objectToString(dataObj);						Out.info(this, "here is the custom data objct : ");			ORedUtils.objectToString(customDataObj);						return dataObj;					}//end function				override public function get scoreToSend():Object{						var scoreToSend:Object 	= new Object();			scoreToSend.displayValue = this.displayScore+" min";						return scoreToSend;					}				public function get hasFriendBonus():Boolean	{	return _hasFriendBonus;	}		public function set hasFriendBonus(value:Boolean):void	{	_hasFriendBonus=value;	}				public function get wonGame():Boolean	{	return _wonGame;	}		public function set wonGame(value:Boolean):void	{	_wonGame=value;	}				public function get gameLevel():int	{	return _gameLevel;	}		public function set gameLevel(value:int):void	{	_gameLevel=value;	}				public function get isDebugMode():Boolean	{	return _isDebugMode;	}	}}// =================================================// ================ @Singleton // =================================================	class SingletonEnforcer {	}