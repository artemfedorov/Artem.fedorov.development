package superClasses
{
	import Utils.Utilities;
	
	import flash.display.MovieClip;
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
	
	
	
	
	public class EnemyUnit extends SimpleUnit implements IUnit
	{
		//--------------------------------------------------------------------------
		//
		//  Constants and Variables
		//
		//--------------------------------------------------------------------------
		//Constants
		public  const PRICE:int = 1;/* 1..10*/
		
		private static const RADIUS_LOCATION:uint = 500;
		
		//Private variables
		private var _visibleSheltersList:Vector.<ShelterVO> = new Vector.<ShelterVO>;
		private var _visibleEnemiesList:Vector.<PlayerUnit> = new Vector.<PlayerUnit>;
		
		private var _state:String;
		private var _currentEnemyAngle:Number;
		
		private var _maxMoveDistance:int = 100; 
		//Public variables
		
		// Constructor
		public function EnemyUnit()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		// 
		//  Getters&setters
		//
		//--------------------------------------------------------------------------

		public function get state():String
		{
			return _state;
		}

		public function set state(value:String):void
		{
			//if(value == _state) return;
			_state = value;
			switch (_state)
			{
				case "STRIKE":
							strike();
						break;
				
				case "LOOKING_FOR_ENEMY": findAnEnemy();
						break;
			}
		}

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


		override public function onPlayBattleHandler():void
		{
			state = "IDLE";
			permitToMove = true;
			reset();
			decisionMaking();
			pathAnglesList = settingAngles(pathSheltersList);
			specifiedAngles();
			settingStates();
			granadesList = settingGranates();
			if(pathSheltersList.length > 1)
			{
				//showPath(pathSheltersList);
				//trace(pathAnglesList);
				currentPathPointIndex = 0;
				nextShelter = pathSheltersList[currentPathPointIndex];
				currentVelosity = pathStateList[currentPathPointIndex];
				//(this.getChildByName("soldier_mc") as MovieClip).play(); 
				permitToMove = true;
				angleAttack = pathAnglesList[0];
				(this.skin.getChildByName("upPart_mc") as MovieClip).rotation = angleAttack;
				(this.skin.getChildByName("downPart_mc") as MovieClip).rotation = angleAttack;
				angle = Utilities.degreesToRadians(angleAttack);
				super.onPlayBattleHandler();
			} 
			else permitToMove = false;

		}
		
		
		public function goToTarget():void 
		{
			//1. Если нет врага то искать врага если есть враг то стрелять в него
			if(currentEnemy && !(currentEnemy as PlayerUnit).parent) currentEnemy = null;
			if(!currentEnemy || !isInFOV(_currentEnemyAngle)) state = "LOOKING_FOR_ENEMY";
			else 
			{
				if(yesOrNo(rapidity))
				{
					if(isVisibleNew(x, y, (currentEnemy as MovieClip).x, (currentEnemy as MovieClip).y)) 
					{
						state = "STRIKE";
					}
					else state = "LOOKING_FOR_ENEMY";
				}
			}
			if(permitToMove) move();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		override public function init($vo:Object = null):void
		{
			super.init($vo);
			skin = new bot1_mc();
			this.addChild(skin);
			skin.name = "upPart_mc";
			endOfMove();
			var nFrame:uint = Math.random() * 90;
			(this.skin.getChildByName("upPart_mc") as MovieClip).gotoAndPlay(110 + nFrame);//idleState
			(this.skin.getChildByName("downPart_mc") as MovieClip).gotoAndPlay(82 + nFrame);//idleState
			
			FOV = GameSetting.standartFOV;
			rapidity = GameSetting.middleRapidity;
			(this.getChildByName("upPart_mc") as MovieClip).stop();
			this.life_tf.text = String(life); 
		}
		
		
		private function findAnEnemy():void
		{
			for(var i:uint = 0; i < MainConstants.game.listOurArmy.length; i++)
			{
				if(isVisibleNew(this.x, this.y, (MainConstants.game.listOurArmy[i] as PlayerUnit).x, (MainConstants.game.listOurArmy[i] as PlayerUnit).y)) 
				{
					currentEnemy = MainConstants.game.listOurArmy[i];
					_currentEnemyAngle = Utilities.radiansToDegrees(Utilities.rotateTowards((currentEnemy as Sprite).x, (currentEnemy as Sprite).y, this.x, this.y));
					
					
					return;
				}
			}
			state = "IDLE";
			currentEnemy = null;
		}
		
		override public function endOfMove():void
		{
			(skin.diff_mc.getChildByName("onFinishMove_mc") as MovieClip).play();
			state = "END_OF_MOVE";
			finishShelter = null;
			super.endOfMove();
		}
		
		
		
		
		
		/*Поиск видимых укрытий*/
		private function findVisibleShelters(vec:Vector.<ShelterVO>, fromPoint:Point):Vector.<ShelterVO>
		{
			var resVec:Vector.<ShelterVO> = new Vector.<ShelterVO>;
			for(var i:int = 0; i < vec.length; i++)
			{
				if(isVisible(fromPoint.x, fromPoint.y, vec[i].x, vec[i].y)) 
					resVec.push(vec[i]);
			}
			return resVec;
		}
		
		/*Поиск видимых и уникальных укрытий*/
		private function findVisibleAndUniqueShelters(vec:Vector.<ShelterVO>, fromPoint:ShelterVO, vecCompare:Vector.<ShelterVO>):Vector.<ShelterVO>
		{
			var resVec:Vector.<ShelterVO> = new Vector.<ShelterVO>;
			for(var i:int = 0; i < vec.length; i++)
			{
				if(isVisible(fromPoint.x, fromPoint.y, vec[i].x, vec[i].y) && isUniqueShelter(vec[i], vecCompare) && !vec[i].building) 
					resVec.push(vec[i]);
			}
			return resVec;
		}
		
		private function findUnvisibleSheltersForEnemyInRadius(playerUnit:SimpleUnit, r:int):Vector.<ShelterVO>
		{
			var vec:Vector.<ShelterVO> = new Vector.<ShelterVO>;
			var vec2:Vector.<ShelterVO> = findUnvisibleSheltersForEnemy(playerUnit);
			var d:Number;
			
			for(var i:int = 0; i < vec2.length; i++)
			{
				d = Utilities.distanceBetweenTwoPoints((playerUnit as Sprite).x, (playerUnit as Sprite).y, vec2[i].x, vec2[i].y)
				if(d <= r && isUniqueShelter(vec2[i], MainConstants.game.finishSheltersList)) 
					vec.push(vec2[i]);
			}
			return vec;
		}
		
		/*Поиск невидимых укрытий для данного врага*/
		private function findUnvisibleSheltersForEnemy(playerUnit:SimpleUnit):Vector.<ShelterVO>
		{
			var vec:Vector.<ShelterVO> = new Vector.<ShelterVO>;
			for(var i:int = 0; i < MainConstants.game.sheltersManager.lastSheltersList.length; i++)
			{
				if(!isVisible((playerUnit as Sprite).x, (playerUnit as Sprite).y, MainConstants.game.sheltersManager.lastSheltersList[i].x, MainConstants.game.sheltersManager.lastSheltersList[i].y)) 
					vec.push(MainConstants.game.sheltersManager.lastSheltersList[i]);
			}
			return vec;
		}
		
		/*Нaйти ближайшую точку из данного вектора*/
		private function findNearestShelter(vec:Vector.<ShelterVO>, fromPoint:Point):ShelterVO
		{
			var shelter:ShelterVO;
			var dist:int = 20000;
			var d:int;
			
			for(var i:int = 0; i < vec.length; i++)
			{
				d = Utilities.distanceBetweenTwoPoints(fromPoint.x, fromPoint.y, vec[i].x, vec[i].y);
				if(d < dist) {dist = d; shelter = vec[i]}
			}
			return shelter;
		}
		
		
		
		/*Дистанция до ближайшего видимого укрытия*/
		private function distanceToNearestShelter():Object
		{
			var vec:Vector.<ShelterVO> = new Vector.<ShelterVO>;
			var shelter:ShelterVO;
			var dist:int = 2000;
			var d:int;
			vec = findVisibleShelters(MainConstants.game.sheltersManager.sheltersList, new Point(this.x, this.y));
			
			for(var i:int = 0; i < vec.length; i++)
			{
				d = Utilities.distanceBetweenTwoPoints(x, y, vec[i].x, vec[i].y);
				if(d < dist) { dist = d; shelter = vec[i]}
			}
			return {d:dist, s:shelter};
		}
		
		
		/*Поиск видимых врагов*/
		private function findVisibleEnemies():Vector.<PlayerUnit>
		{
			var vec:Vector.<PlayerUnit> = new Vector.<PlayerUnit>;
			for(var i:int = 0; i < MainConstants.game.listOurArmy.length; i++)
			{
				if(isVisible(x, y, (MainConstants.game.listOurArmy[i] as Sprite).x, (MainConstants.game.listOurArmy[i] as Sprite).y)) vec.push(MainConstants.game.listOurArmy[i]);
			}
			return vec;
		}
		
		
		/*сколько осталось пройти  */
		private function howManyDistanceLeft():int
		{
			var d:int;
			for(var i:int = 0; i < pathSheltersList.length - 1; i++)
			{
				d += Utilities.distanceBetweenTwoPoints(pathSheltersList[i].x, pathSheltersList[i].y, pathSheltersList[i + 1].x, pathSheltersList[i + 1].y);
			}
			return _maxMoveDistance - d;	
		}
		
		/*Выбор случайного противника*/
		private function chooseRandomEnemy():SimpleUnit
		{
			var pUnit:SimpleUnit;
			var i:int = Math.random() * MainConstants.game.listOurArmy.length - 1;
			pUnit = MainConstants.game.listOurArmy[i];
			return pUnit;
		}
		
		
			
			// 2. Состояние: бег, ходьба, вприсядку, ползком
			// 3. Укрытие или точка на карте?
		
		// Нахожусь ли внутри здания?
		private function ifInsideTheBuilding():Sprite
		{
			for(var i:int = 0; i < MainConstants.game.buildingList.length; i++)
			{
				if(MainConstants.game.buildingList[i].hitTestPoint(this.x, this.y, true)) return MainConstants.game.buildingList[i];
			}
			return null;
		}
		
		
		
		private function findTheNearestDoor(s:ShelterVO, b:Sprite):Sprite
		{
			var vec:Vector.<Sprite> = new Vector.<Sprite>;
			var door:Sprite;
			var d:Number;
			var dist:Number = 20000;
			
			for(var i:int = 0; i < MainConstants.game.doorList.length; i++)
			{
				if(b.hitTestObject(MainConstants.game.doorList[i])) vec.push(MainConstants.game.doorList[i]);
			}
			for(i = 0; i < vec.length; i++)
			{
				d = Utilities.distanceBetweenTwoPoints(s.x, s.y, vec[i].x, vec[i].y);
				if(d < dist) {dist = d; door = vec[i]}
			}
			door.scaleX = 2;
			return door;
		}
		
		private var _myOwnEnemy:SimpleUnit;
		public var finishShelter:ShelterVO;
		
		private function decisionMaking():void
		{
			var subFinishShelter:ShelterVO;
			var doorOfFinishShelter:ShelterVO;
			var door:Sprite;
			var beginShelter:ShelterVO = new ShelterVO();
			var beginShelter1:ShelterVO = new ShelterVO();
			_myOwnEnemy = chooseRandomEnemy();
			
			beginShelter = new ShelterVO();
			beginShelter.x = this.x;
			beginShelter.y = this.y;
			beginShelter1 = findNearestShelter(MainConstants.game.sheltersManager.sheltersList, new Point(this.x, this.y));
			addPathPointToList(beginShelter);
			
			//1. Найти конечную точку невидимую для врага 
			var vec:Vector.<ShelterVO> = findUnvisibleSheltersForEnemyInRadius(_myOwnEnemy, RADIUS_LOCATION);
			if(vec.length < MainConstants.game.listEnemyArmy.length)
			{
				var i:int = Math.random() * vec.length - 1;
				finishShelter = vec[i];
			}
			else
			{
				do
				{
					i = Math.random() * vec.length - 1;
					finishShelter = vec[i];
				}
				while(!isUniqueShelter(finishShelter, MainConstants.game.finishSheltersList))
			}
			subFinishShelter = finishShelter;
			MainConstants.game.finishSheltersList.push(finishShelter);
			
			
			//1.1. Если я нахожусь внутри здания, то найти выход из него
			var building:Sprite = ifInsideTheBuilding();
			if(finishShelter.building != building)
			{
				if(building) 
				{
					door = findTheNearestDoor(finishShelter, building);
					var doorShelter:ShelterVO = new ShelterVO();
					doorShelter.x = door.x; doorShelter.y = door.y;
					addPathPointToList(doorShelter);
				}
				// 1.2 Если конечная точка внутри помещения, то найти ближайший вход в него
				if(finishShelter.building) 
				{
					if(doorShelter)	door = findTheNearestDoor(doorShelter, finishShelter.building);
					else door = findTheNearestDoor(beginShelter, finishShelter.building);
					doorOfFinishShelter = new ShelterVO();
					doorOfFinishShelter.x = door.x; doorOfFinishShelter.y = door.y;
					subFinishShelter = doorOfFinishShelter;
				}
			}
			
			
			//2. Если точка пока не видна, то найти ближайшую из видимых точек к конечной точке
			while(!isVisible(pathSheltersList[pathSheltersList.length - 1].x, pathSheltersList[pathSheltersList.length - 1].y, subFinishShelter.x, subFinishShelter.y))
			{
				var vec1:Vector.<ShelterVO> = findVisibleAndUniqueShelters(MainConstants.game.sheltersManager.sheltersList, 
																						pathSheltersList[pathSheltersList.length - 1], pathSheltersList);
				if(vec1.length == 0) 
				{
					pathSheltersList.length = 0;
					return;
				}
				var shelter1:ShelterVO = findNearestShelter(vec1, new Point(subFinishShelter.x, subFinishShelter.y));
				addPathPointToList(shelter1);
				if(pathSheltersList.length > 25) 
				{
					pathSheltersList.length = 0;
					return;
				}
			}
			
			if(doorOfFinishShelter)
			{
				addPathPointToList(doorOfFinishShelter);
			}
			addPathPointToList(finishShelter);
		}
		
		
		public function settingGranates():Array
		{ 
			var coordinates:Object;
			var resVec:Array = [];
			
			for(var i:int = 0; i < pathSheltersList.length; i++)
			{
				if(yesOrNo(15) && pathStateList[i] != GROUND_STATE)
				{
					var dist:Number = 100 + Math.random() * 300;
					coordinates = {};
					coordinates.x = x + dist * Math.cos((skin.getChildByName("upPart_mc").rotation + 180));
					coordinates.y = y + dist * Math.sin((skin.getChildByName("upPart_mc").rotation + 180));
					
					resVec.push(coordinates);
				}
				else resVec.push(null);
				
			}
			return resVec;
		}
		
		
		private function settingStates():void
		{
			var state:Number;
			for(var i:int = 0; i < pathSheltersList.length; i++)
			{
				//Если первая точка внутри здания, то выходить пригнувшись
				if(i == 0 && pathSheltersList[i].building) 
				{
					state = DOWN_STATE;
					addPathStatesToList(state);
					return;
				} 
				
				if(i == pathSheltersList.length - 1 && pathSheltersList[i].building) 
				{
					if(yesOrNo(50)) state = DOWN_STATE;
						else state = GROUND_STATE;
					addPathStatesToList(state);
					return;
				} 

				if(yesOrNo(50)) state = STAND_STATE;
				else state = DOWN_STATE;
				addPathStatesToList(state);
			}
		}
		
		//Логика управления состояниями
		
		private function specifiedAngles():void
		{
			//TODO:
			// 1. Если есть враги которые видят меня,  
			var angle:Number;
			for(var i:int = 0; i < pathSheltersList.length; i++)
			{
				if(i == pathAnglesList.length - 1 && pathSheltersList[i].building) 
				{
					angle = getAngleToNearestDoorOfBuildingFromInsideOf(pathSheltersList[i], pathSheltersList[i].building);
					pathAnglesList[i] = angle;
				} 
				else 
				{
					
					if(i == pathSheltersList.length - 1) 
					{
						var enemy:SimpleUnit = chooseRandomEnemy();
						angle = Utilities.radiansToDegrees(Utilities.rotateTowards(pathSheltersList[i].x, pathSheltersList[i].y, (enemy as Sprite).x, (enemy as Sprite).y) + Math.PI);
						pathAnglesList[i] = angle;	
					}
				}
			}
		}
		
		
		private function getAngleToNearestDoorOfBuildingFromInsideOf(shelter:ShelterVO, building:Sprite):int
		{
			var door:Sprite = findTheNearestDoor(shelter, building);
			var angle:int = Utilities.rotateTowards(shelter.x, shelter.y, door.x, door.y) + Math.PI;
			return Utilities.radiansToDegrees(angle);
		}
		//--------------------------------------------------------------------------
		//
		//  Logs
		//
		//--------------------------------------------------------------------------
		
		
	}
}