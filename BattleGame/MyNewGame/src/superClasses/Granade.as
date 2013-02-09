package superClasses
{
	import Utils.Utilities;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import singletons.MainConstants;

	public class Granade extends granade_mc
	{
		private var _unitOwner:SimpleUnit;
		private var _speed:Number = 10;
		private var _dx:Number;
		private var _dy:Number;
		private var _angle:Number;
		private var _maxDistance:Number = 200;
		public var owner:Boolean = true;
		private var _trace:MovieClip;
		
		public function Granade()
		{
		}
		
		public function get unitOwner():SimpleUnit
		{
			return _unitOwner;
		}

		public function set unitOwner(value:SimpleUnit):void
		{
			_unitOwner = value;
		}

		public function flyTo($x:Number, $y:Number):void
		{
			_angle = Utilities.rotateTowards($x, $y, x, y);
			this.rotation = Utilities.radiansToDegrees(_angle);
			this.addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function drawTrace($x:Number, $y:Number, $rot:Number):void
		{
			_trace =  new granadeTrace();
			this.parent.addChild(_trace);
			_trace.x = $x;
			_trace.y = $y;
			_trace.rotation = $rot;
			
		}
		protected function update(event:Event):void
		{
			x += Math.cos(_angle) * _speed;
			y += Math.sin(_angle) * _speed;
			drawTrace(x, y, rotation);
			_maxDistance -= _speed;
			if(_maxDistance < 0) boom();
			
		}
		
		private function boom():void
		{
			this.removeEventListener(Event.ENTER_FRAME, update);
			var boom:MovieClip = new explose_mc();
			MainConstants.currentLevel.addChild(boom);
			boom.x = x;
			boom.y = y;
			MainConstants.game.analyzeExplosion(x, y, GameSetting.radiusExplosion100, owner, unitOwner);
			this.gotoAndStop("destroy");
		}
	}
}