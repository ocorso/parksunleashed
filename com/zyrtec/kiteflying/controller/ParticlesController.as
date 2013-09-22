﻿package com.zyrtec.kiteflying.controller{	import com.bigspaceship.utils.Out;	import com.zyrtec.kiteflying.events.KiteFlyingEvent;	import com.zyrtec.kiteflying.model.KFModel;	import com.zyrtec.kiteflying.model.vo.KFLevel;	import com.zyrtec.kiteflying.utils.ParticleHelper;	import com.zyrtec.kiteflying.view.ui.Particle;		import flash.display.Sprite;	import flash.events.Event;	import flash.events.EventDispatcher;	import flash.events.IEventDispatcher;	import flash.events.MouseEvent;		import net.ored.util.ORedUtils;
		public class ParticlesController extends EventDispatcher	{		private var _m					:KFModel;		public var particles			:Vector.<Particle>;		public var view					:Sprite;		public var maxParticles			:Number = 3; //default number of particles		public var spawnRate			:Number = 1000;//1 second = default spawn rate		public var _currentLevel		:KFLevel;				private var _pCount				:Number = 0;//frame counter util				private var _sCount				:Number = 0;//what sequence of particles to send down		private var _mCount				:Number = 0;//what to match		private var _isRandom			:Boolean = false;//sets to true once we've been through all sequences		private var _doChangeCode		:Boolean = false;													// =================================================		// ================ @Callable		// =================================================		private var _gravity:Number;		public function update():void{						view.visible = true;			_pCount++;			var seconds_since_start:Number = (_pCount*KFModel.FRAME_RATE) / 1000;			if (seconds_since_start > KFModel.SPAWN_RATE && particles.length<maxParticles){				//update model now that its time to send another round.				if (_doChangeCode){					_doChangeCode = false;					_m.currentMatchCode = _currentLevel.matches[mCount];				}				//SEND DOWN ANOTHER PARTICLE[S]				_spawnParticle(_currentLevel.sequences[mCount][sCount]);								//go to next particle in the current phase sequence				sCount++;										_pCount = 0;//reset seconds clock							}//end if its time to spawn a particle						// go through the vector of particles ...			//either destroy or update particle			for(var i:* in particles){				var p:Particle 	= particles[i];				if (p.clip.alpha == 0){ _disposeParticle(p,i);				}else  					p.update();			}					}//end function 				public function reset():void{						Out.status(this, "reset");			_currentLevel	= _m.levels[0];			_sCount 		= 0;			mCount			= 0;			_pCount			= 0;						while(particles.length > 0){				var p:Particle = particles.shift();				p.removeEventListener(KFModel.PARTICLE_COLLISION, _pDidCross);				p.destroy();				p = null;							}			particles		= new Vector.<Particle>();				}//end function				public function changeGravity($e:KiteFlyingEvent):void{			_gravity = $e.payload.newGravity;			particles.forEach(_setGravity);					}//end function		public function changeMaxParticles($e:KiteFlyingEvent):void{			Out.debug(this, "maxParticles: "+$e.payload.maxParticles);			maxParticles = $e.payload.maxParticles;								}//end function		// =================================================		// ================ @Workers		// =================================================					private function _init():void{						_m			= KFModel.getInstance();			particles 	= new Vector.<Particle>();			view 		= new Sprite();		}//end function				private function _spawnParticle($whatKind:String = ""):void{			Out.info(this, "spawnParticles: "+$whatKind);			var exploded:Array		= $whatKind.split("::");			for each (var i:String in exploded){				var p:Particle 	= ParticleHelper.particleFactory(view,i);				p.addEventListener(KFModel.PARTICLE_COLLISION, _pDidCross,false,0,true);				particles.push(p);							}//end for each					}//end function				private function _createRandomParticles():void		{			//keep the number of particles at the max number			while(particles.length < maxParticles){								// make a new particle				var particle:Particle = ParticleHelper.particleFactory(view);				particle.addEventListener(KFModel.PARTICLE_COLLISION, _pDidCross,false,0,true);								// and add it to the particle vector... 				particles.push(particle);							}//end while					}//end function		private function _disposeParticle(p:Particle, i:int, vector:Vector.<Particle>= null):void		{			//Out.debug(this, "deleting particle");					particles.splice(i,1);					p.removeEventListener(KFModel.PARTICLE_COLLISION, _pDidCross);					p.destroy();					p = null;					}//end function				private function _setGravity(p:Particle, i:int, vector:Vector.<Particle>= null):void{	p.gravity = _gravity;}				// =================================================		// ================ @Handlers		// =================================================		private function _pDidCross($e:KiteFlyingEvent){			//Out.status(this, "dispatched: "+ $e.payload.pType);			dispatchEvent(new KiteFlyingEvent(KFModel.CHECK_COLLISION, $e.payload));		}				// =================================================		// ================ @Animation		// =================================================				// =================================================		// ================ @Getters / Setters		// =================================================		public function set level($newLevel:KFLevel){ 						//Out.status(this, "levelChange");			_currentLevel 	= $newLevel;			_mCount			= 0;			_sCount			= 0;		}//end setter			public function get mCount():Number
		{
			return _mCount;
		}		public function set mCount(value:Number):void
		{			//if we're done with all sequences in current level, let the game know			if (_mCount == _currentLevel.sequences.length -1){				dispatchEvent(new KiteFlyingEvent(KFModel.GAMEPLAY_LEVEL_CHANGE));
			}else _mCount = value;		}
		public function get sCount():Number
		{
			return _sCount;		}
		public function set sCount(value:Number):void		{			//if we're done with current match phase, let the game know			if (_sCount == _currentLevel.sequences[mCount].length - 1) {				_sCount = 0;				mCount++;				_doChangeCode = true;			}else{				_sCount = value;			}//end else
		}//end function							// =================================================		// ================ @Constructor		// =================================================		public function ParticlesController($level:KFLevel, target:IEventDispatcher=null)		{			super(target);			level = $level;			_init();		}			}//end class}//end package