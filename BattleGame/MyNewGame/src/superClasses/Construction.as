package superClasses
{
	
	/**
	 * @Casino game base core
	 * @author - Artem Fedorov aka Timer
	 * @version - 
	 * 
	 * @langversion - ActionScript 3.0
	 * @playerversion - FlashPlayer 10.2
	 */
	
	
	import Utils.Utilities;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import singletons.MainConstants;
	
	
	
	public class Construction
	{
		//--------------------------------------------------------------------------
		//
		//  Constants and Variables
		//
		//--------------------------------------------------------------------------
		//Constants
		
		//Private variables
		private var _skin:MovieClip;	
		//Public variables
		public var x1:int;
		public var y1:int;
		
		public var x2:int;
		public var y2:int;
		
		public var x3:int;
		public var y3:int;
		
		public var x4:int;
		public var y4:int;
		
		public var ang:Number;
		
		
		
		// Constructor
		public function Construction(mc:MovieClip)
		{
			_skin = mc;
			ang = Utilities.degreesToRadians(_skin.rotation);
			init();
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters&setters
		//
		//--------------------------------------------------------------------------
		//--------------------------------------------------------------------------
		//
		//  Events handlers
		//
		//--------------------------------------------------------------------------
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		private function init():void
		{			(MainConstants.currentLevel.enemyLayer_mc as Sprite).graphics.beginFill(0x00FF00, 1);
			(MainConstants.currentLevel.enemyLayer_mc as Sprite).graphics.lineStyle(2,0xFFFFFF , 1);
			/*x1 = (skin.x - skin.width / 2) * (Math.cos(ang) + Math.PI);
			y1 = (skin.y - skin.height / 2) * (Math.sin(ang) + Math.PI);
			
			x2 = (skin.x + skin.width / 2) * (Math.cos(ang) + Math.PI);
			y2 = (skin.y - skin.height / 2) * (Math.sin(ang) + Math.PI);
			
			x3 = (skin.x + skin.width / 2) * (Math.cos(ang) + Math.PI);
			y3 = (skin.y + skin.height / 2) * (Math.sin(ang) + Math.PI);
				
			x4 = (skin.x - skin.width / 2) * (Math.cos(ang) + Math.PI);
			y4 = (skin.y + skin.height / 2) * (Math.sin(ang) + Math.PI);*/
			
			
			
			var p1:Point = skin.localToGlobal(new Point(skin.p1.x, skin.p1.y));
		    var p2:Point = skin.localToGlobal(new Point(skin.p2.x, skin.p2.y));
			var p3:Point = skin.localToGlobal(new Point(skin.p3.x, skin.p3.y));
			var p4:Point = skin.localToGlobal(new Point(skin.p4.x, skin.p4.y));
			x1 = p1.x;
			y1 = p1.y;
			
			x2 = p2.x;
			y2 = p2.y;
			
			x3 = p3.x;
			y3 = p3.y;
			
			x4 = p4.x;
			y4 = p4.y;
			
			
			/*(MainConstants.currentLevel.enemyLayer_mc as Sprite).graphics.moveTo(p1.x, p1.y);
			(MainConstants.currentLevel.enemyLayer_mc as Sprite).graphics.lineTo(p2.x, p2.y);
			
			(MainConstants.currentLevel.enemyLayer_mc as Sprite).graphics.moveTo(p2.x, p2.y);
			(MainConstants.currentLevel.enemyLayer_mc as Sprite).graphics.lineTo(p3.x, p3.y);
			
			(MainConstants.currentLevel.enemyLayer_mc as Sprite).graphics.moveTo(p3.x, p3.y);
			(MainConstants.currentLevel.enemyLayer_mc as Sprite).graphics.lineTo(p4.x, p4.y);
			
			(MainConstants.currentLevel.enemyLayer_mc as Sprite).graphics.moveTo(p4.x, p4.y);
			(MainConstants.currentLevel.enemyLayer_mc as Sprite).graphics.lineTo(p1.x, p1.y);*/
		}
		//--------------------------------------------------------------------------
		//
		//  Logs
		//
		//--------------------------------------------------------------------------
		
		
		public function get skin():MovieClip
		{
			return _skin;
		}

		public function set skin(value:MovieClip):void
		{
			_skin = value;
		}

	}
}