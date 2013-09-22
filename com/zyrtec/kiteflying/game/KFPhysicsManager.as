package com.zyrtec.kiteflying.game
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2DistanceJoint;
	import Box2D.Dynamics.Joints.b2DistanceJointDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import com.bigspaceship.utils.Out;
	import com.zyrtec.kiteflying.model.KFModel;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	public class KFPhysicsManager extends Sprite
	{
	
		/**
		 *   30 pixels	=		1 meter
		 * friction 	=	how things slide
		 * restitution	= 	how bouncy
		 * density		=	permanent and locked in space	
		 */		
		// world creation
		public var world			:b2World;
		private var _worldScale		:int = 30;
		
		// the Kite Body
		public var kb			:b2Body;//kite body
		private var _kw			:b2Body;//kite weight/balancer/what keeps it upright
		
		// force to apply to the player
		public var force			:b2Vec2;
		
		// variables to store whether the keys are pressed or not
		// true = pressed;
		// false = unpressed
		public var left,right,up,down:Boolean=false;
		
		
		// =================================================
		// ================ @Callable
		// =================================================
		public function init():void{
			world	= new b2World(new b2Vec2(0,KFModel.GRAVITY),true);
			
			// calling the debug draw function
			debug_draw();
			
			// drawing the boundaries
			draw_box(0,			400,		800,	10,	false,"ground");
			draw_box(-400,		150,		10,		500,false,"left");
			draw_box(400,		150,		10,		500,false,"right");
			draw_box(0,			-100,		800,	10,	false,"roof");
			
			// adding the player at 250,200
			add_player(250,200);
			
		}//end function
		
		
		
		
		// function to be executed at every frame
		public function update(e:Event = null):void {
			
			// setting the force to null
			force=new b2Vec2(0,0);
			// according to the key(s) pressed, add the proper vector force
			if (left) {
				force.Add(new b2Vec2(-10,0));
			}
			if (right) {
				force.Add(new b2Vec2(10,0));
			}
			if (up) {
				force.Add(new b2Vec2(0,-20));
			}
			if (down) {
				force.Add(new b2Vec2(0,5));
			}
			// if there is any force, then apply it
			if (force.x||force.y) {
				kb.ApplyForce(force,kb.GetWorldCenter());
			}
			world.Step(1/30,10,10);
			world.ClearForces();
			world.DrawDebugData();
			
		}//end function update
		
		// =================================================
		// ================ @Workers
		// =================================================
		
		// simple function to draw a box
		public function draw_box(px,py,w,h,d,ud):void {
			
			//create body definition
			var my_body:b2BodyDef		= new b2BodyDef();
			
			//set position, i think this is the center point.
			my_body.position.Set(px/_worldScale, py/_worldScale);
			
			//set as dynamic if necessary 
			if (d) 	my_body.type=b2Body.b2_dynamicBody; 
			
			//make a new poly shape (4 vertices = box)
			var my_box:b2PolygonShape 	= new b2PolygonShape();
			
			//i think this makes the dimensions of the box
			my_box.SetAsBox(w/2/_worldScale, h/2/_worldScale);
			
			//create fixture
			var my_fixture:b2FixtureDef = new b2FixtureDef();
			my_fixture.shape			= my_box;
			
			//have the world create a body for us
			var world_body:b2Body		= world.CreateBody(my_body);
			
			//tag the new body
			world_body.SetUserData(ud);
			
			//give the body the "my_box" shape via the fixture
			world_body.CreateFixture(my_fixture);
			
		}
		
		// function to add the player
		public function add_player(px,py):void {
			
			//create kite proper
			var my_body:b2BodyDef		= new b2BodyDef();
			my_body.position.Set(px/_worldScale, py/_worldScale);
			my_body.type				= b2Body.b2_dynamicBody;
			kb							= world.CreateBody(my_body);
			
			//create kite weight
			var w_body:b2BodyDef		= new b2BodyDef();
			w_body.position.Set(px/_worldScale, (py)/_worldScale);
			w_body.type					= b2Body.b2_dynamicBody;
			_kw							= world.CreateBody(w_body);
			
			//create joint between kite and the kite's weight
			var jDef:b2DistanceJointDef	= new b2DistanceJointDef();
			jDef.Initialize(kb, _kw, kb.GetWorldCenter(), _kw.GetWorldCenter());
			//var j:b2DistanceJoint		= world.CreateJoint(jDef)  as b2DistanceJoint;
			
			var boxDef:b2PolygonShape 	= new b2PolygonShape();
			var fd:b2FixtureDef = new b2FixtureDef();
			fd.shape = boxDef;
			fd.density = 2.0;
			boxDef.SetAsBox(20 / _worldScale, 20 / _worldScale);
			_kw.CreateFixture(fd);
			boxDef.SetAsBox(2 / _worldScale, 30 / _worldScale);
			kb.CreateFixture(fd);

			var my_circle:b2CircleShape = new b2CircleShape(10/_worldScale);
			var my_circle2:b2CircleShape = new b2CircleShape(20/_worldScale);
			var my_fixture:b2FixtureDef = new b2FixtureDef();
			var my_fixture2:b2FixtureDef = new b2FixtureDef();
			my_fixture.shape			= my_circle;
			my_fixture2.shape			= my_circle2;
			kb.CreateFixture(my_fixture);
			//kb.CreateFixture(my_fixture2);
			
		}//end function 
		
		// debug draw
		public function debug_draw():void {
			
			var debug_draw:b2DebugDraw 	= new b2DebugDraw();
			var debug_sprite:Sprite		= new Sprite();
			addChild(debug_sprite);
			debug_draw.SetSprite(debug_sprite);
			debug_draw.SetDrawScale(_worldScale);
			debug_draw.SetFlags(b2DebugDraw.e_shapeBit);
			world.SetDebugDraw(debug_draw);
			
		}
		// =================================================
		// ================ @Handlers
		// =================================================
		
		// according to the key pressed, set the proper variable to "true"
		public function on_key_down(e:KeyboardEvent):void {
			
			switch (e.keyCode) {
				case 37 :
					left=true;
					break;
				case 38 :
					up=true;
					break;
				case 39 :
					right=true;
					break;
				case 40 :
					down=true;
					break;
				default : Out.debug(this, e.keyCode);
			}
		}
		// according to the key released, set the proper variable to "false"
		public function on_key_up(e:KeyboardEvent):void {
			
			switch (e.keyCode) {
				case 37 :
					left=false;
					break;
				case 38 :
					up=false;
					break;
				case 39 :
					right=false;
					break;
				case 40 :
					down=false;
					break;
			}
		}
		// =================================================
		// ================ @Animation
		// =================================================
		
		// =================================================
		// ================ @Getters / Setters
		// =================================================
		public function get kiteX():Number { return kb.GetPosition().x * _worldScale;}
		public function get kiteY():Number { return kb.GetPosition().y * _worldScale;}
		public function get kiteRot():Number { return Math.floor(kb.GetAngle() * _worldScale);}
		
		// =================================================
		// ================ @Interfaced
		// =================================================
		
		// =================================================
		// ================ @Core Handler
		// =================================================
		
		// =================================================
		// ================ @Overrides
		// =================================================
		
	}
}