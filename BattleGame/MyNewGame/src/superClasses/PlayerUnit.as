package superClasses
{
	import Utils.Utilities;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import gameEvents.GameEvents;
	
	import managers.DictionaryManager;
	
	import singletons.MainConstants;

	public class PlayerUnit extends SimpleUnit implements IUnit
	{  
		//--------------------------------------------------------------------------
		//
		//  Constants and Variables
		//
		//--------------------------------------------------------------------------
		//Constants
		private static const SET_TARGET_POINT:String = "SetTargetPoint";
		
		//Private variables
		
		private var _menu_mc:MovieClip;
		private var _currentEnemyAngle:Number;
		private var _state:String;
		
		//Public variables
		
		
		
		// Constructor		
		public function PlayerUnit()
		{
			super();
			/*settingStates();
			initAngles();
			(this.getChildByName("upPart_mc") as MovieClip).stop();*/
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
			_state = value;
			switch (_state)
			{
				case "STRIKE":
					 strike();
					break;

				case "LOOKING_FOR_ENEMY": 
					findAnEnemy();
					break;
				
				case SET_TARGET_POINT:
					var s:ShelterVO = new ShelterVO();
					s.x = this.x;
					s.y = this.y;
					addPathPointToList(s);
					
					s.index = pathSheltersList.length - 1;
					addPathAngleToList((this.skin.getChildByName("upPart_mc") as MovieClip).rotation);
					MainConstants.game.currentEditUnit = this;
					
					break;
			}
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
			skin.diff_mc.mouseEnabled = false;
			skin.diff_mc.gotoAndStop("red");
			this.addChild(skin);
			skin.name = "upPart_mc";
			endOfMove();
			var nFrame:uint = Math.random() * 90;
			(this.skin.getChildByName("upPart_mc") as MovieClip).gotoAndPlay(110 + nFrame);//idleState
			(this.skin.getChildByName("downPart_mc") as MovieClip).gotoAndPlay(82 + nFrame);//idleState
			
			settingStates();
			initAngles();
			(this.getChildByName("upPart_mc") as MovieClip).stop();
			this.life_tf.text = String(life); 
		}
		
		
		override public function destroy():void
		{
			
		}

		
		private function findAnEnemy():void
		{
			for(var i:uint = 0; i < MainConstants.game.listEnemyArmy.length; i++)
			{
				if(isVisible(this.x, this.y, (MainConstants.game.listEnemyArmy[i] as EnemyUnit).x, (MainConstants.game.listEnemyArmy[i] as EnemyUnit).y)) 
				{
					currentEnemy = MainConstants.game.listEnemyArmy[i];
					_currentEnemyAngle = Utilities.radiansToDegrees(Utilities.rotateTowards((currentEnemy as Sprite).x, (currentEnemy as Sprite).y, this.x, this.y));
					
					return;
				}
			}
			state = "IDLE";
			currentEnemy = null;
		}
		
		
		public function showMenu():void
		{
			hideInfo();
			if(MainConstants.game.showMenuPlayer)
				MainConstants.game.showMenuPlayer.hideMenu();
			MainConstants.game.showMenuPlayer = this;
			_menu_mc = new unitMenu_mc();
			this.parent.addChild(_menu_mc);
			_menu_mc.x = x;
			_menu_mc.y = y;
			_menu_mc.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownMenuHandler);
		}
		
		public function hideMenu():void
		{
			if(_menu_mc)
			{
				MainConstants.game.showMenuPlayer = null;
				_menu_mc.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownMenuHandler);
				this.parent.removeChild(_menu_mc);
			}
			_menu_mc = null;
		}
		
		
		/*Поиск видимых и уникальных укрытий*/
		private function findVisibleAndUniqueShelters(vec:Vector.<ShelterVO>, fromPoint:ShelterVO, vecCompare:Vector.<ShelterVO>):Vector.<ShelterVO>
		{
			var resVec:Vector.<ShelterVO> = new Vector.<ShelterVO>;
			for(var i:int = 0; i < vec.length; i++)
			{
				if(isVisible(fromPoint.x, fromPoint.y, vec[i].x, vec[i].y) && isUniqueShelter(vec[i], vecCompare)) 
					resVec.push(vec[i]);
			}
			return resVec;
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
		
		public function initAngles():void
		{ 
			var angle:Number;
			var resVec:Array = [];
			
			for(var i:int = 1; i < 100; i++)
				resVec.push(angle);
			pathAnglesList = resVec;
		}
		
		
		override public function endOfMove():void
		{
			hidePath();
			state = "END_OF_MOVE";
			currentEnemy = null;
			permitToMove = false;
			reset();
			settingStates();
			initAngles();
			super.endOfMove();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Events handlers
		
		//
		//--------------------------------------------------------------------------
		protected function onMouseDownMenuHandler(event:MouseEvent):void
		{
			hideInfo();
			switch(event.target.name)
			{
				case "close_btn":
					hideMenu();
					break;
				
				case "path_btn":
					_menu_mc.addEventListener(MouseEvent.MOUSE_UP, onPathDrawingModeHandler);
					break;
				
				case "follow_btn":
					MainConstants.game.followMode = true;
					MainConstants.screenManager.showHint(DictionaryManager.FollowModeIsON);
					MainConstants.currentLevel.addEventListener(MouseEvent.MOUSE_UP, onFollowModeHandler);
					hideMenu();
					break;
				
				case "info_btn":
					showInfo();
					break;
			}
		}
		
		public function hideInfo():void
		{
			if(!MainConstants.game.unitInfoWindow) return;
			MainConstants.currentLevel.removeChild(MainConstants.game.unitInfoWindow);
			MainConstants.game.unitInfoWindow = null;
		}
		
		private function showInfo():void
		{
			hideMenu();
			hideInfo();
			MainConstants.game.unitInfoWindow = new unitInfo_mc();
			MainConstants.currentLevel.addChild(MainConstants.game.unitInfoWindow);
			MainConstants.game.unitInfoWindow.x = x + 50;
			MainConstants.game.unitInfoWindow.y = y - 100;
			MainConstants.game.unitInfoWindow.progress_tf.text = VO.murder;
			MainConstants.game.unitInfoWindow.type_tf.text = VO.type;
			MainConstants.game.unitInfoWindow.FOV_tf.text = VO.FOV;
			MainConstants.game.unitInfoWindow.rapidity_tf.text = VO.rapidity;
			MainConstants.game.unitInfoWindow.armor_tf.text = VO.armor;
			MainConstants.game.unitInfoWindow.price_tf.text = VO.price;
		}
		
		
		
		protected function onFollowModeHandler(event:MouseEvent):void
		{
			MainConstants.screenManager.cursor.doLookFor("pathDraw");
			MainConstants.currentLevel.removeEventListener(MouseEvent.MOUSE_UP, onFollowModeHandler);
			MainConstants.currentLevel.addEventListener(MouseEvent.MOUSE_DOWN, onSelectLeaderHandler);
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
		
		private function findVisibleShelterNearPoint(s:ShelterVO):ShelterVO
		{
			var resShelter:ShelterVO = new ShelterVO();
			var visShelters:Vector.<ShelterVO> = findVisibleShelters(MainConstants.game.sheltersManager.lastSheltersList, new Point(pathSheltersList[pathSheltersList.length - 1].x, pathSheltersList[pathSheltersList.length - 1].y));		
			resShelter = findNearestShelter(visShelters, new Point(pathSheltersList[pathSheltersList.length - 1].x, pathSheltersList[pathSheltersList.length - 1].y));
			return resShelter;
		}
		
		
		protected function onSelectLeaderHandler(event:MouseEvent):void
		{
			if(event.target.name != "upPart_mc")
			{
				MainConstants.screenManager.showHint(DictionaryManager.FollowModeIsCanceled);
				MainConstants.currentLevel.removeEventListener(MouseEvent.MOUSE_DOWN, onSelectLeaderHandler);
				MainConstants.game.followMode = false;
				MainConstants.screenManager.cursor.doLookFor("none");
				return;
			}
				reset();
				
				var leader:PlayerUnit = MainConstants.game.findPlayerOfSoldier(event.target as MovieClip);
				if(leader == this) return;
				if(!isVisible(this.x, this.y, leader.x, leader.y))
				{
					MainConstants.game.followMode = false;
					MainConstants.screenManager.cursor.doLookFor("none");
					MainConstants.screenManager.showHint(DictionaryManager.TheyMustSeeEachOther);
					MainConstants.currentLevel.removeEventListener(MouseEvent.MOUSE_DOWN, onSelectLeaderHandler);
					return;
				}
				
				if(leader.pathSheltersList.length == 0) 
				{
					MainConstants.game.followMode = false;
					MainConstants.screenManager.cursor.doLookFor("none");
					MainConstants.screenManager.showHint(DictionaryManager.TheUnitHasNotPathPointsYet);
					MainConstants.currentLevel.removeEventListener(MouseEvent.MOUSE_DOWN, onSelectLeaderHandler);
					return;
				}
				
				//Найти первую видимую точку
				var beginLeaderShelterIndex:int
				
				var s:ShelterVO = new ShelterVO();
				s.x = x; s.y = y;

				for(var i:int = leader.pathSheltersList.length - 1; i > -1; i--)
					if(isVisible(x, y, leader.pathSheltersList[i].x, leader.pathSheltersList[i].y)) 
					{
						beginLeaderShelterIndex = i;
						i = -1;
					}
				
				pathSheltersList.push(s);
				
				for(i = beginLeaderShelterIndex; i < leader.pathSheltersList.length; i++)
					pathSheltersList.push(leader.pathSheltersList[i]);
				
				pathSheltersList.push(findVisibleShelterNearPoint(pathSheltersList.pop()));
				
				settingStates();
				pathAnglesList = settingAngles(pathSheltersList);

				MainConstants.game.followMode = false;
				MainConstants.screenManager.cursor.doLookFor("none");
				MainConstants.currentLevel.removeEventListener(MouseEvent.MOUSE_DOWN, onSelectLeaderHandler);
				
				showPath(pathSheltersList);
		}		
		
		
		protected function onPathDrawingModeHandler(event:MouseEvent):void
		{
			reset();
			settingStates();
			initAngles();
			_menu_mc.removeEventListener(MouseEvent.MOUSE_UP, onPathDrawingModeHandler);
			hideMenu();
			hidePath();
			MainConstants.screenManager.cursor.doLookFor("pathDraw");
			state = SET_TARGET_POINT;
		}		
		
		
		
		override public function onPlayBattleHandler():void
		{
			state = "IDLE";
			if(pathSheltersList.length > 1)
			{
				permitToMove = true;
				nextShelter = pathSheltersList[0];
				currentPathPointIndex = 0;
				//(this.getChildByName("upPart_mc") as MovieClip).play();
				angle = Utilities.rotateTowards(pathSheltersList[currentPathPointIndex].x, pathSheltersList[currentPathPointIndex].y, x, y);
				(this.skin.getChildByName("downPart_mc") as MovieClip).rotation = pathAnglesList[currentPathPointIndex];
				angleAttack = (this.skin.getChildByName("downPart_mc") as MovieClip).rotation;
				currentVelosity = pathStateList[currentPathPointIndex];
				saveMove();
			} 
   			else 
			{
				angle = Utilities.degreesToRadians(this.pathAnglesList[0]);
				permitToMove = false;
			}
		}
	
		
		
		
		private var _pathShelterList:Vector.<ShelterVO> = new Vector.<ShelterVO>;
		private var _pathAngleList:Array;
		private var _pathStateList:Vector.<Number>;
		private var _minesList:Array;
		
		
		public function analizeAchievements():void
		{
			
		}

		
		private function saveMove():void
		{
			_pathAngleList 	= [];
			_minesList 		= [];
			_pathShelterList = new Vector.<ShelterVO>;
			_pathStateList	 = new Vector.<Number>;
			
			_pathShelterList = pathSheltersList;
			_pathAngleList	 = pathAnglesList;
			_pathStateList	 = pathStateList;
			_minesList		 = minesList;
			
			var arrMove:Array = [];
			var rec:Array = [];
			
			arrMove.push(_pathShelterList, _pathAngleList, _pathStateList, _minesList);
			
			rec.push(arrMove);
			
		}		
		
		
		
		public function goToTarget():void
		{
			//1. Если нет врага то искать врага если есть враг то стрелять в него
			if(currentEnemy && !(currentEnemy as EnemyUnit).parent) currentEnemy = null;
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
		
		
		
		
		public function pathClipMode(mode:String):void
		{
			switch(mode)
			{
				case "inBack":
					pathMc.alpha = 0.5;
					break;
				
				case "inFront":
					pathMc.alpha = 1;
					break;
			}
		}
		
		public function addCheckPoint(s:ShelterVO, player:PlayerUnit):void
		{
			var checkPoint:CheckPoint = new CheckPoint(s, player);
			pathMc.addChild(checkPoint);
			checkPoint.name = "checkPoint_mc";
			checkPoint.x = s.x; checkPoint.y = s.y;
			checkPointList.push(checkPoint);
			
			var defaultAngle:int = Utilities.radiansToDegrees(Utilities.rotateTowards(s.x, s.y, pathSheltersList[s.index - 1].x, pathSheltersList[s.index - 1].y));
			checkPoint.setAngle(defaultAngle);
			checkPoint.rotation = defaultAngle;
			
		}
		
		
		private function settingStates():void
		{
			for(var i:int = 0; i < 100; i++)
			{
				addPathStatesToList(DOWN_STATE);
			}
		}
		//--------------------------------------------------------------------------
		//
		//  Logs
		//
		//--------------------------------------------------------------------------
	}
}