package com.zyrtec.kiteflying.model
{
	import com.bigspaceship.utils.MathUtils;
	import com.g2.gaming.framework.events.LevelScreenUpdateEvent;
	import com.zyrtec.kiteflying.model.vo.KFLevel;

	public class KFLevels
	{
		public static function create():Vector.<KFLevel>{
			
			var l:Vector.<KFLevel> = new Vector.<KFLevel>();

	// =================================================
	// ================ @Level1
	// =================================================

			var l1:KFLevel 	= new KFLevel("level1");
			l1.matches		= new <String>[					
									'3',//first thing to match
									'0',//2nd thing
									'2',//3rd thing
									'1'//4th thing to match
								];
			l1.sequences 	= 	[	//sequence while first thing to match
									[	'S31::S22::S23', 
										'S01::S02::S33', 
										'S31::S12::S13'],
									//sequence while 2nd thing to match
									[	'S31::S02::D33', 
										'D01::D22::S23', 
										'D21::S32::P03'],
									//sequence while 3rd thing to match
									[	'D21::D02::P03', 
										'S01::D22::P13', 
										'P31::D22::S13'],
									//sequence while 4th thing to match
									[	'D11::D22::S23', 
										'S21::P02::D13', 
										'P31::P12::P23']
								];	
			l.push(l1);

	// =================================================
	// ================ @Level2
	// =================================================

			var l2:KFLevel 	= new KFLevel("level2");
			l2.matches		= new <String>[					
									'D',//first thing to match
									'P'//2nd thing
								];
			l2.sequences 	= 	[	//sequence while first thing to match
									[	'S31::D32::004', 
										'D31::004::S33', 
										'004::D12::S13',
										'D01::P02::004',
										'S21::004::D23',
										'P11::D22::S13'],
									//sequence while 2nd thing to match
									[	'004::D32::P33', 
										'P31::S32::D13', 
										'S31::D12::P13',
										'D01::P12::S03',
										'D11::S02::P03',
										'P21::S22::D23']
		
								];	
			l.push(l2);
			
	// =================================================
	// ================ @Level3
	// =================================================

			var l3:KFLevel 	= new KFLevel("level3");
			l3.matches		= new <String>[					
									'S',//first thing to match
									'D'//2nd thing
								];
			l3.sequences 	= 	[	//sequence while first thing to match
									[	'S31::D32::004', 
										'D31::S32::D33', 
										'S31::D32::P33',
										'P01::S32::P03',
										'S01::D32::P33',
										'P31::D12::S03'],
									//sequence while 2nd thing to match
									[	'S11::D12::P13', 
										'S21::S02::D13', 
										'S11::D02::S03',
										'D01::P32::S33',
										'P11::P32::D33',
										'P21::P22::D23',
										'D11::P12::P13',		
										'S31::S32::D33',
										'S01::P02::D03']
								];	
			l.push(l3);

	// =================================================
	// ================ @Level4
	// =================================================

			var l4:KFLevel 	= new KFLevel("level4");
			l4.matches		= new <String>[					
									'P3',//first thing to match
									'S1',//2nd thing
									'D0'								
								];
			l4.sequences 	= 	[	//sequence while first thing to match
									[	'P31::S02::004', 
										'004::S22::P33', 
										'P31::004::D13',
										'P01::P32::004',
										'P31::P22::004',
										'P21::P32::P13'],
									//sequence while 2nd thing to match
									[	'S11::004::S03', 
										'D11::004::S13', 
										'S11::D12::P13',
										'S01::D12::S13',
										'P11::S12::S33',
										'S31::S02::S13',
										'S11::S22::S03',		
										'D11::S22::S13',
										'S11::D12::P23'],
									//sequence while 3rd thing to match
									[	'D21::S02::D03', 
										'S01::D02::P03', 
										'P01::D02::S03',
										'S01::D02::D33',
										'D21::S22::D03',
										'D01::P32::S33']
								];	
			l.push(l4);


	// =================================================
	// ================ @Level5
	// =================================================

			var l5:KFLevel 	= new KFLevel("level5");
			l5.matches		= new <String>[					
									'D0',//first thing to match
									'S2',//2nd thing
									'S0'//3rd thing
								];
			l5.sequences 	= 	[	//sequence while first thing to match
									[	'P01::S02::D03', 
										'D01::D22::S13', 
										'D21::D02::S33',
										'D31::D12::D03',
										'D21::D02::D13',
										'D01::S12::P33',
										'P01::S02::D03',		
										'D01::S02::D13',
										'P01::D02::D23'],
									//sequence while 2nd thing to match
									[	'P21::D22::S23', 
										'S31::S22::S03', 
										'S21::S12::D03',
										'P21::S12::S23'],
									//sequence while 3rd thing to match
									[	'D21::S02::D03', 
										'S01::D02::P03', 
										'P01::P02::S03',
										'S01::D02::D03',
										'D21::S02::P23',//not here
										'S01::P32::S33']//nope
								];	
			l.push(l5);
			return l;

		}//end function
		
		public static function generateRandomLevel($n:Number):KFLevel{
			var l:KFLevel	= new KFLevel("level"+$n.toString());
			var m1:String	= KFModel.PARTICLE_CODES_TO_MATCH[MathUtils.getRandomInt(7,18)];
			var m2:String	= KFModel.PARTICLE_CODES_TO_MATCH[MathUtils.getRandomInt(7,18)];
			var m3:String	= KFModel.PARTICLE_CODES_TO_MATCH[MathUtils.getRandomInt(7,18)];
			l.matches		= new <String>[m1,m2,m3];
			l.sequences		=	[ 	_generateSequence(m1),
									_generateSequence(m2),
									_generateSequence(m3)
								];
			
			return l;
		}//end static function
		
		private static function _getRandomCodeThatDoesntMatch($m):String{
			var c:String = KFModel.PARTICLE_CODES_TO_MATCH[MathUtils.getRandomInt(7,18)];
			return c==$m ? _getRandomCodeThatDoesntMatch($m) : c;
		}
		
		private static function _generateSequence($m:String):Array{
			var seq:Array = new Array();
			
			for(var i:uint = 0; i<4; i++){
				var s:Vector.<String> 	= new Vector.<String>(3);//what will be the line spew'ed particles
				var mLoc:int 			= MathUtils.getRandomInt(0,2);//track
				var m:String 			= $m + (mLoc+1).toString();//assign a track to match
				s[mLoc]					= m;//make sure match appears in every line of spew'ed particles
				
				for (var ii:int = 0; ii<=2;ii++){
					if (ii != mLoc){
						var c:String = _getRandomCodeThatDoesntMatch($m);
						s[ii] = c + (ii+1).toString();
					}//end if
				}//end for filling up 
				seq.push(s.join("::"));
			}//end for making 4 strings in sequence
			return seq;
		}//end function
		
	}//end class
		
}//end package