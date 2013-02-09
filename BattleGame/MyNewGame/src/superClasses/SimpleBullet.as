package superClasses
{
	import Utils.Utilities;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import gameEvents.GameEvents;
	import gameEvents.targets.InterfaceListenerOwner;
	
	import singletons.MainConstants;

	public class SimpleBullet
	{
		//--------------------------------------------------------------------------
		//
		//  Constants and Variables
		//
		//--------------------------------------------------------------------------
		//Constants
		
		//Private variables
		private var _skin:MovieClip = new bullet_mc();
		private var _enemy:SimpleUnit;
		private var _angle:Number;
		private var _speed:Number = 25;
		private var _enemyArmyList:Vector.<SimpleUnit>;
		private var _maxDistance:Number;
		
		//Public variables
		public var owner:SimpleUnit;
		
		public function SimpleBullet(enemy1:SimpleUnit, dx:int, dy:int, vec:Vector.<SimpleUnit>, imprecision:int)
		{
			_enemyArmyList = vec;
			MainConstants.currentLevel.addChild(_skin);
			_skin.x = dx;
			_skin.y = dy;
			_enemy = enemy1;
			if(imprecision != 0)
			var k:Number = Utilities.degreesToRadians(Math.random() * (10 + imprecision + .1) - (10 + imprecision));
			else k = 0;
			_angle = Utilities.rotateTowards(_skin.x, _skin.y, (_enemy as MovieClip).x, (_enemy as MovieClip).y) + Math.PI + k;
			skin.rotation = Utilities.radiansToDegrees(_angle);
			//_distance = Utilities.distanceBetweenTwoPoints(_skin.x, _skin.y, (_enemy as MovieClip).x, (_enemy as MovieClip).y);
			_skin.addEventListener(Event.ENTER_FRAME, update);
			InterfaceListenerOwner.Owner.addEventListener(GameEvents.END_OF_MOVE, onEndPfMoveHandler);
			InterfaceListenerOwner.Owner.addEventListener(GameEvents.BEGIN_OF_MOVE, onBeginPfMoveHandler);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Getters&setters
		//
		//--------------------------------------------------------------------------
		protected function onBeginPfMoveHandler(event:Event):void
		{
			if(!_skin.hasEventListener(Event.ENTER_FRAME)) _skin.addEventListener(Event.ENTER_FRAME, update);
		}		

		protected function onEndPfMoveHandler(event:Event):void
		{
			_skin.removeEventListener(Event.ENTER_FRAME, update);
		}		

		public function get maxDistance():Number
		{
			return _maxDistance;
		}

		public function set maxDistance(value:Number):void
		{
			_maxDistance = value;
		}

		public function get skin():MovieClip
		{
			return _skin;
		}
		
		public function set skin(value:MovieClip):void
		{
			_skin = value;
		}
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		private function destroy():void
		{
			_skin.removeEventListener(Event.ENTER_FRAME, update);
			InterfaceListenerOwner.Owner.removeEventListener(GameEvents.END_OF_MOVE, onEndPfMoveHandler);
			InterfaceListenerOwner.Owner.removeEventListener(GameEvents.BEGIN_OF_MOVE, onBeginPfMoveHandler);

			_skin.parent.removeChild(_skin);
			_skin = null;
		}
		//--------------------------------------------------------------------------
		//
		//  Events handlers
		//
		//--------------------------------------------------------------------------
		
		private var _flyDistance:Number = 0;
		protected function update(event:Event):void
		{
			_skin.x += _speed * Math.cos(_angle);
			_skin.y += _speed * Math.sin(_angle);
			
			_flyDistance += _speed;
			if(_flyDistance >= _maxDistance)
			{
				destroy();
				return;
			}
			
			for(var i:int = 0; i < MainConstants.game.constructionsList.length; i++)
			{
				if(MainConstants.game.constructionsList[i].skin.hitTestPoint(_skin.x, _skin.y, true))
				{
					destroy(); return;
				}
			}
			if(_enemyArmyList.length == 0) return;
			for(i = 0; i < _enemyArmyList.length; i++)
			{
				var uni:SimpleUnit = (_enemyArmyList[i] as SimpleUnit);
				var sk:MovieClip = uni.skin;
				
				var up:MovieClip = sk.getChildByName("upPart_mc") as MovieClip;

				if(up.hitTestPoint(_skin.x, _skin.y, true))
				{
					_enemyArmyList[i].setDamage(5, owner);
					owner.setAction("murderByBullet");
					destroy(); return;
				}
			}
		}
		//--------------------------------------------------------------------------
		//
		//  Logs
		//
		//--------------------------------------------------------------------------

		

	}
}