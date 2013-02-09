package superClasses
{
	import Utils.Utilities;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	import gameEvents.GameEvents;
	
	import singletons.MainConstants;
	
	/**
	 * @Casino game base core
	 * @author - Artem Fedorov aka Timer
	 * @version - 
	 * 
	 * @langversion - ActionScript 3.0
	 * @playerversion - FlashPlayer 10.2
	 */
	
	
	
	
	public class GUnit extends SimpleUnit
	{
		//--------------------------------------------------------------------------
		//
		//  Constants and Variables
		//
		//--------------------------------------------------------------------------
		//Constants
		
		//Private variables
		private var _visibleSheltersList:Vector.<ShelterVO> = new Vector.<ShelterVO>;
		private var _visibleEnemiesList:Vector.<PlayerUnit> = new Vector.<PlayerUnit>;
		private var _currentShelter:ShelterVO;
		
		private var _maxMoveDistance:int 
		//Public variables
		
		// Constructor
		public function GUnit()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		// 
		//  Getters&setters
		//
		//--------------------------------------------------------------------------
		public function get visibleEnemiesList():Vector.<PlayerUnit>
		{
			
			return _visibleEnemiesList;
		}

		public function set visibleEnemiesList(value:Vector.<PlayerUnit>):void
		{
			_visibleEnemiesList = value;
		}
		//--------------------------------------------------------------------------
		//
		//  Events handlers
		//
		//--------------------------------------------------------------------------


		override protected function onPlayBattleHandler(event:GameEvents):void
		{
			_visibleSheltersList = findVisibleShelters();
			var indexNewShelter:int = Math.random() * (_visibleSheltersList.length - 1);
			_currentShelter = _visibleSheltersList[indexNewShelter];
			while(_visibleSheltersList[indexNewShelter].busy)
			{
				indexNewShelter = Math.random() * (_visibleSheltersList.length - 1);
				_currentShelter = _visibleSheltersList[indexNewShelter];
			}
			this.addEventListener(Event.ENTER_FRAME, goToTarget);
		}
		
		private function goToTarget(e:Event):void
		{
			var angle:Number = Utilities.rotateTowards(x, y, _currentShelter.x, _currentShelter.y) + Math.PI;
			this.x += 2 * Math.cos(angle);
			this.y += 2 * Math.sin(angle);
			if(isGotPoint(_currentShelter.x, _currentShelter.y, 2)) this.removeEventListener(Event.ENTER_FRAME, goToTarget);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		private function isGotPoint(dx:int, dy:int, dist:int):Boolean
		{
			if(Utilities.distanceBetweenTwoPoints(x, y, dx, dy) <=dist) return true;
			return false;
		}
		
		private function isVisible(dx:int, dy:int):Boolean
		{
			MainConstants.currentLevel.test_mc.x = x;
			MainConstants.currentLevel.test_mc.y = y;
			var angle:Number = Utilities.rotateTowards(x, y, dx, dy) + Math.PI;
			
			for(var i:int = 1; i < 500; i++)
			{
				MainConstants.currentLevel.test_mc.x = x + i * Math.cos(angle);
				MainConstants.currentLevel.test_mc.y = y + i * Math.sin(angle);
				
				for(var j:uint = 0; j < MainConstants.game.constructionsList.length; j++)
				{
					if(MainConstants.currentLevel.test_mc.hitTestObject(MainConstants.game.constructionsList[j].skin)) return false;
				}
			}
			return true;
		}
		
		private function findVisibleShelters():Vector.<ShelterVO>
		{
			var vec:Vector.<ShelterVO> = new Vector.<ShelterVO>;
			for(var i:int = 0; i < MainConstants.game.sheltersManager.sheltersList.length; i++)
			{
				if(isVisible(MainConstants.game.sheltersManager.sheltersList[i].x, MainConstants.game.sheltersManager.sheltersList[i].y)) vec.push(MainConstants.game.sheltersManager.sheltersList[i]);
			}
			return vec;
		}
		
		private function distanceToNearestShelter():int
		{
			var vec:Vector.<ShelterVO> = new Vector.<ShelterVO>;
			var dist:int = 2000;
			var d:int;
			vec = findVisibleShelters();
			
			for(var i:int = 0; i < vec.length; i++)
			{
				d = Utilities.distanceBetweenTwoPoints(x, y, vec[i].x, vec[i].y);
				if(d < dist) dist = d;
			}
			return dist;
		}
		
		private function findVisibleEnemies():Vector.<PlayerUnit>
		{
			var vec:Vector.<PlayerUnit> = new Vector.<PlayerUnit>;
			for(var i:int = 0; i < MainConstants.game._listOurArmy.length; i++)
			{
				if(isVisible(MainConstants.game._listOurArmy[i].x, MainConstants.game._listOurArmy[i].y)) vec.push(MainConstants.game._listOurArmy[i]);
			}
			return vec;
		}
		//--------------------------------------------------------------------------
		//
		//  Logs
		//
		//--------------------------------------------------------------------------
		
		
	}
}