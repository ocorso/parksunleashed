package com.zyrtec.kiteflying.view.ui
{
	import com.bigspaceship.utils.Out;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.zyrtec.kiteflying.events.KiteFlyingEvent;
	import com.zyrtec.kiteflying.model.KFModel;
	import com.zyrtec.kiteflying.utils.ParticleHelper;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;

	public class Particle extends EventDispatcher
	{ 
		
		public var xVel					:	Number; 		// the x and y velocity of the particle
		public var yVel					:	Number;
		public var drag					:	Number = .96; 	// the drag factor between 0 and 1, where 1 is no drag, and 0 is max drag. 
		public var fade					:	Number = 0;		// the fade factor, works as a multiplier. 
		public var shrink				:	Number = 1;		// another multiplier that changes the size. 
		// If < 1 then the particle graphic shrinks, >1 and the particle grows. 
		public var gravity				:	Number = .7;	// the amount of gravity to add to the yVelocity every frame. 
		 													// If < 0 then gravity goes upwards. 
		public var clip:DisplayObject;					// display object for the particle
		public var pType				:	String = KFModel.PARTICLE_TYPES[0];
		public var track				:	Number = 0;
		public var pCode				:	String = "P01";
		private var _yVelTemp			:	Number = 0;
		private var _didCross			:	Boolean = false;
		private var _orig				:	Boolean = true;
		public function Particle ( spriteclass : Class, targetclip : DisplayObjectContainer, xpos : Number, ypos : Number)
		{
			
			// instantiate a new particle graphic
			clip = new spriteclass(); 
			clip.visible = false;
			clip.name = "p"+new Date().getMilliseconds().toString();
			// and add it to the stage
			targetclip.addChild(clip); 
			
			// and set its position
			clip.x = xpos;
			clip.y = ypos;
			
		}
		
		public function setVel(xvel:Number, yvel:Number)
		{
			xVel = xvel;
			yVel = yvel;
		}
		
		public function setScale(newscale:Number)
		{
			clip.scaleX = clip.scaleY = newscale;
		}
		
		public function update()
		{
			// add the velocity to the particle's position... 
			clip.x = ParticleHelper.findXOffset(track, clip.y);
			clip.y += yVel;
			
			// apply drag
			xVel*=drag;
			yVel*=drag;
			
			//check to see if this little guy has crossed the threshold
			if (clip.y > KFModel.GOALLINE_Y && !_didCross){

				// fade out
				TweenMax.to(clip, .3, {autoAlpha:0});
				
				//create payload to pass along
				var pl:Object 	= new Object();
				pl.xPos			= clip.x;	//where are we ?
				pl.pType		= pType;	//are we good or bad?
				pl.pCode		= pCode;	//code for matching
				pl.clipName		= clip.name;//pass along the name
				dispatchEvent(new KiteFlyingEvent(KFModel.PARTICLE_COLLISION, pl));
				
				_didCross = true;
			}//end if we've crossed the line!
			
			// scale
			clip.scaleX = clip.scaleY = ParticleHelper.getScale(clip.y);
			
			if (_orig){
				_orig = false;
				clip.visible = true;
			}
			// gravity
			yVel+=gravity;
			
			
		}//end function
		
		public function destroy():void
		{
			clip.parent.removeChild(clip); 
			
		}
	}
}