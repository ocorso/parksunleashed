package com.g2.gaming.framework
{
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	
	public class SoundManager
	{
		private var _soundsArray:Array;
		private var _soundTrackChannel:SoundChannel = new SoundChannel();
		private var _soundChannelsArray:Array;
		private var _soundMute:Boolean = false;
		private var _tempSoundTransform:SoundTransform = new SoundTransform();
		private var _muteSoundTransform:SoundTransform = new SoundTransform();
		private var _tempSound:Sound;
		
		public function SoundManager()
		{
			_soundsArray = new Array();
			_soundChannelsArray = new Array();
		}
		
		public function addSound(soundName:String, sound:Sound):void {
			_soundsArray[soundName] = sound;
		}
		
		public function playSound(soundName:String, isSoundTrack:Boolean=false, loops:int=1, offset:Number=0, volume:Number = 1):void {
			//trace(soundName, isSoundTrack, loops, offset, volume);
			_tempSoundTransform.volume = volume;
			_tempSound = _soundsArray[soundName];
			Sound(_tempSound).addEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler);
			Sound(_tempSound).addEventListener(Event.COMPLETE, onCompleteHandler);
			if(isSoundTrack) {
				if (_soundTrackChannel!=null) {
					_soundTrackChannel.stop();
				}
				try {
					_soundTrackChannel = _tempSound.play(offset,loops);
				} catch (e:Error) {
					trace("******* sound error");
				}
				_soundTrackChannel.soundTransform = _tempSoundTransform;
			} else {
				try {
					_soundChannelsArray[soundName] = _tempSound.play(offset,loops);
				} catch (e:Error) {
					trace("***** sound error");
				}
				_soundChannelsArray[soundName].soundTransform = _tempSoundTransform;
			}
		//	trace("************************ "+_tempSound.url);
		}
		
		public function stopSound(soundName:String, isSoundTrack:Boolean = false):void {
			if (isSoundTrack) {
				_soundTrackChannel.stop();
			} else {
				_soundChannelsArray[soundName].stop();
			}
		}
		
		public function muteSound():void {
			if (_soundMute) {
				_soundMute=false;
				_muteSoundTransform.volume=1;
				flash.media.SoundMixer.soundTransform=_muteSoundTransform;
			} else {
				_muteSoundTransform.volume=0;
				_soundMute = true;
				flash.media.SoundMixer.soundTransform=_muteSoundTransform;
			}
		}
		
		private function onIOErrorHandler(event:IOErrorEvent):void {
			trace("SOUND ioErrorHandler: " + event);
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler);
		}
		
		private function onCompleteHandler(event:Event):void {
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler);
			event.target.removeEventListener(Event.COMPLETE, onCompleteHandler);
		}

	}
}