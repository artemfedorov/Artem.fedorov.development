package game
{
	import Utils.KeyboardManager;
	import Utils.Utilities;
	
	import factories.MainFactory;
	
	import fl.motion.SimpleEase;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.Strong;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import gameEvents.GameEvents;
	import gameEvents.targets.InterfaceListenerOwner;
	
	import managers.DictionaryManager;
	import managers.ScreenManager;
	import managers.SheltersManager;
	
	import singletons.MainConstants;
	
	import superClasses.CheckPoint;
	import superClasses.Construction;
	import superClasses.EnemyUnit;
	import superClasses.GameSetting;
	import superClasses.IUnit;
	import superClasses.Mine;
	import superClasses.PlayerUnit;
	import superClasses.SerializationVO;
	import superClasses.ShelterVO;
	import superClasses.SimpleUnit;
	import superClasses.UnitVO;

	public class Game
	{
		//--------------------------------------------------------------------------
		//
		//  Constants and Variables
		//
		//--------------------------------------------------------------------------
		//Constants
		public static const FRAMES_PER_MOVE:int = 305;
		
		//Private variables
		private var _score:int;
		
		private var _steps:int;
		
		private var _killed:int = 0;
		private var _losses:int = 0;
		
		private var _doIcanPlayNextLevel:Boolean;
		private var _permitToEdit:Boolean = true;
		private var _timeOfMove:int = 0;
		
		
		private var _speedX:Number = 0;
		private var _speedY:Number = 0;
		private var _currentEditUnit:PlayerUnit;
		
		private var _sheltersManager:SheltersManager;
		private var _time:int;
		private var _isPause:Boolean = false;
		private var _keyboardManager:KeyboardManager;
		
		private var _buildingList:Vector.<Sprite> = new Vector.<Sprite>;
		private var _doorList:Vector.<Sprite> = new Vector.<Sprite>;

		private var _respalmList:Vector.<Sprite> = new Vector.<Sprite>;
		private var _constructionsList:Vector.<Construction> = new Vector.<Construction>;
		private var _airSupport:String = "";
		private var _listOurArmy:Vector.<SimpleUnit>;
		private var _listEnemyArmy:Vector.<SimpleUnit>;
		private var _listMines:Vector.<Mine> = new Vector.<Mine>;
		
		//Public variables
		public var currentEditCheckPoint:CheckPoint;
		public var followMode:Boolean = false;
		public var showMenuPlayer:PlayerUnit;
		public var unitInfoWindow:unitInfo_mc;
		public var whoTargetOfAirSupport:Boolean;
		
		public var finishSheltersList:Vector.<ShelterVO> = new Vector.<ShelterVO>;
		
		
		public function Game()
		{
			init();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters&setters
		//
		//--------------------------------------------------------------------------



		public function get listMines():Vector.<Mine>
		{
			return _listMines;
		}

		public function set listMines(value:Vector.<Mine>):void
		{
			_listMines = value;
		}

		public function get respalmList():Vector.<Sprite>
		{
			return _respalmList;
		}

		public function set respalmList(value:Vector.<Sprite>):void
		{
			_respalmList = value;
		}

		public function get steps():int
		{
			return _steps;
		}

		public function set steps(value:int):void
		{
			_steps = value;
			MainConstants.screenManager.view.interface_mc.step_tf.text = String(value);
		}

		public function get airSupport():String
		{
			return _airSupport;
		}

		public function set airSupport(value:String):void
		{
			_airSupport = value;
		}

		public function get permitToEdit():Boolean
		{
			return _permitToEdit;
		}

		public function set permitToEdit(value:Boolean):void
		{
			_permitToEdit = value;
		}

		public function get losses():int
		{
			return _losses;
		}

		public function set losses(value:int):void
		{
			_losses = value;
		}

		public function get killed():int
		{
			return _killed;
		}

		public function set killed(value:int):void
		{
			_killed = value;
		}

		public function get doIcanPlayNextLevel():Boolean
		{
			return _doIcanPlayNextLevel;
		}

		public function set doIcanPlayNextLevel(value:Boolean):void
		{
			_doIcanPlayNextLevel = value;
		}

		public function get score():int
		{
			return _score;
		}

		public function set score(value:int):void
		{
			_score = value;
			if(MainConstants.screenManager.currentMode == ScreenManager.COMPANY_MODE) MainConstants.serializationManager.serialData.companyScore = _score;
			if(MainConstants.screenManager.currentMode == ScreenManager.OPERATION_MODE) MainConstants.serializationManager.serialData.operationsScore = _score;
			
			MainConstants.serializationManager.save();
			MainConstants.screenManager.view.interface_mc.score_tf.text = score;
		}

		public function get keyboardManager():KeyboardManager
		{
			return _keyboardManager;
		}

		public function set keyboardManager(value:KeyboardManager):void
		{
			_keyboardManager = value;
		}

		public function get listEnemyArmy():Vector.<SimpleUnit>
		{
			return _listEnemyArmy;
		}

		public function set listEnemyArmy(value:Vector.<SimpleUnit>):void
		{
			_listEnemyArmy = value;
		}

		public function get listOurArmy():Vector.<SimpleUnit>
		{
			return _listOurArmy;
		}

		public function set listOurArmy(value:Vector.<SimpleUnit>):void
		{
			_listOurArmy = value;
		}

		public function get timeOfMove():int
		{
			return _timeOfMove;
		}

		public function set timeOfMove(value:int):void
		{
			_timeOfMove = value;
		}

		public function get currentEditUnit():PlayerUnit
		{
			return _currentEditUnit;
		}

		public function set currentEditUnit(value:PlayerUnit):void
		{
			if(_currentEditUnit) _currentEditUnit.hideInfo();
			_currentEditUnit = value;
			
			/*if(!value) return;
			for (var i:uint = 0; i < listOurArmy.length; i++)
				if ((listOurArmy[i] as  PlayerUnit)!= value) (listOurArmy[i] as  PlayerUnit).pathClipMode("inBack");
			value.pathClipMode("inFront");*/
		}

		public function get doorList():Vector.<Sprite>
		{
			return _doorList;
		}

		public function set doorList(value:Vector.<Sprite>):void
		{
			_doorList = value;
		}

		public function get buildingList():Vector.<Sprite>
		{
			return _buildingList;
		}

		public function set buildingList(value:Vector.<Sprite>):void
		{
			_buildingList = value;
		}

		public function get constructionsList():Vector.<Construction>
		{
			return _constructionsList;
		}

		public function set constructionsList(value:Vector.<Construction>):void
		{
			_constructionsList = value;
		}

		public function get sheltersManager():SheltersManager
		{
			return _sheltersManager;
		}

		public function set sheltersManager(value:SheltersManager):void
		{
			_sheltersManager = value;
		}

		public function get isPause():Boolean
		{
			return _isPause;
		}

		public function set isPause(value:Boolean):void
		{
			_isPause = value;
		}

		public function get time():int
		{
			return _time;
		}

		public function set time(value:int):void
		{
			_time = value;
		}

		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		private function init():void
		{
			//Инициализация игровых событий
			//InterfaceListenerOwner.Owner.addEventListener(GameEvents.LOAD_DATA, onLoadDataHandler);
			InterfaceListenerOwner.Owner.addEventListener(GameEvents.ON_DESTROY_UNIT, removeUnit);
			InterfaceListenerOwner.Owner.addEventListener(GameEvents.ON_GLOBAL_PAUSE, onPauseHandler);
			InterfaceListenerOwner.Owner.addEventListener(GameEvents.ON_NEW_LEVEL, onNewLevelHandler);
			InterfaceListenerOwner.Owner.addEventListener(GameEvents.ON_PLAY_BATTLE, onPlayBattleHandler);
			
			listOurArmy = new Vector.<SimpleUnit>;
			listEnemyArmy = new Vector.<SimpleUnit>;
		}
		
		private function initKeyboard():void
		{
			_keyboardManager = new KeyboardManager(MainConstants.screenManager.view);
			MainConstants.KeyManager = _keyboardManager;
		}
		
		public function dispose():void
		{
			destroyALLUnits();
			//InterfaceListenerOwner.Owner.removeEventListener(GameEvents.LOAD_DATA, onLoadDataHandler);
			InterfaceListenerOwner.Owner.removeEventListener(GameEvents.ON_DESTROY_UNIT, removeUnit);
			InterfaceListenerOwner.Owner.removeEventListener(GameEvents.ON_GLOBAL_PAUSE, onPauseHandler);
			InterfaceListenerOwner.Owner.removeEventListener(GameEvents.ON_NEW_LEVEL, onNewLevelHandler);
			InterfaceListenerOwner.Owner.removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
			InterfaceListenerOwner.Owner.removeEventListener(GameEvents.ON_PLAY_BATTLE, onPlayBattleHandler);
			//MainConstants.KeyManager.dispose();
			//MainConstants.KeyManager = null;
			
			
		}
		
		private function destroyALLUnits():void
		{
			for(var i:int = 0; i < listOurArmy.length; i++)
			{
				(listOurArmy[i] as PlayerUnit).die();
				//MainConstants.currentLevel.removeChild((listOurArmy[i] as PlayerUnit));
				_listOurArmy[i] = null;				
			}
			
			for(i = 0; i < listEnemyArmy.length; i++)
			{
				(listEnemyArmy[i] as EnemyUnit).die();
				//MainConstants.currentLevel.removeChild((listEnemyArmy[i] as EnemyUnit));
				_listEnemyArmy[i] = null;
			}
			listOurArmy = null;
			listEnemyArmy = null;
			_sheltersManager = null;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Events handlers
		//
		//--------------------------------------------------------------------------
		protected function onLoadDataHandler(event:GameEvents):void
		{
			var data:SerializationVO = event.parameter as SerializationVO;
			
		}
		
		public function findPlayerOfSoldier(mc:MovieClip):PlayerUnit
		{
			for (var i:uint = 0; i < listOurArmy.length; i++)
				if (((listOurArmy[i] as  PlayerUnit).skin.getChildByName("upPart_mc") as MovieClip) == mc) return (listOurArmy[i] as  PlayerUnit);
			
			return null;
		}
		
		public function hideInfo():void
		{
			if(!MainConstants.game.unitInfoWindow) return;
			MainConstants.currentLevel.removeChild(MainConstants.game.unitInfoWindow);
			MainConstants.game.unitInfoWindow = null;
		}
		
		public var setGranade:Boolean;
		protected function onMouseDownHandler(event:MouseEvent):void
		{
			if(setGranade) 
			{
				currentEditCheckPoint.setCoordinatesForGranade({x:MainConstants.currentLevel.mouseX, y:MainConstants.currentLevel.mouseY});
				setGranade = false;
				currentEditCheckPoint.hideMenuState();
				return;
			}
			if(event.target.name != "info_btn") hideInfo();
			if(!permitToEdit || followMode) return;
			if(currentEditCheckPoint)
			{
				switch (event.target.name)
				{
					case "standState_btn":
						currentEditCheckPoint.gotoAndStop("standState");
						currentEditCheckPoint.setState(SimpleUnit.STAND_STATE);
						currentEditCheckPoint.hideMenuState();
						break;
					
					case "downState_btn":
						currentEditCheckPoint.gotoAndStop("downState");
						currentEditCheckPoint.setState(SimpleUnit.DOWN_STATE);
						currentEditCheckPoint.hideMenuState();
						break;
					
					case "groundState_btn":
						currentEditCheckPoint.gotoAndStop("groundState");
						currentEditCheckPoint.setState(SimpleUnit.GROUND_STATE);
						currentEditCheckPoint.hideMenuState();
						break;
					
					case "changeAngle_btn":
						if(currentEditCheckPoint.fovMc) return;
						
						currentEditCheckPoint.fovMc = new MovieClip();
						MainConstants.currentLevel.addChild(currentEditCheckPoint.fovMc);
						currentEditCheckPoint.showFOV();
						//hideMenuState();
						currentEditCheckPoint.fovMc.addEventListener(MouseEvent.MOUSE_DOWN, currentEditCheckPoint.onStartChangeAngleHandler);
						break;
					
					case "useMine_btn":
						currentEditCheckPoint.initMine();
						currentEditCheckPoint.hideMenuState();
						break;
					
					case "useGranade_btn":
						currentEditCheckPoint.initGranade();
						break;
				}
				return;
			}
			
			if(event.target.name == "upPart_mc") 
			{
				MainConstants.screenManager.cursor.doLookFor("none");
				currentEditUnit = null;
				var player:PlayerUnit = findPlayerOfSoldier(event.target as MovieClip);
				if(!player) return;
				if (currentEditUnit != player) 
				{
					if(currentEditCheckPoint) currentEditCheckPoint.hideMenuState();
					player.showMenu();
				}
				return; 
			}
		
			if(!currentEditUnit) return;
			
				
			if(event.target.name == "checkPoint_mc" || currentEditCheckPoint) return;
			
			if(/*isCollisionForBody(MainConstants.currentLevel.mouseX, MainConstants.currentLevel.mouseY) && */currentEditUnit.isVisible(currentEditUnit.pathSheltersList[currentEditUnit.pathSheltersList.length - 1].x, currentEditUnit.pathSheltersList[currentEditUnit.pathSheltersList.length - 1].y,
				MainConstants.currentLevel.mouseX, MainConstants.currentLevel.mouseY))
			{
				var s:ShelterVO = new ShelterVO();
				s.x = MainConstants.currentLevel.mouseX;
				s.y = MainConstants.currentLevel.mouseY;
				currentEditUnit.addPathPointToList(s);
				s.index = currentEditUnit.pathSheltersList.length - 1;
				
				currentEditUnit.addCheckPoint(s, currentEditUnit);
				
				// Установка дефолтных углов на checkPoints
				if(s.index > 1)
				{
					var defaultAngle:int = Utilities.radiansToDegrees(Utilities.rotateTowards(s.x, s.y, currentEditUnit.pathSheltersList[s.index - 1].x, 
																						currentEditUnit.pathSheltersList[s.index - 1].y));
					currentEditUnit.checkPointList[s.index - 2].setAngle(defaultAngle);
					currentEditUnit.checkPointList[s.index - 2].rotation = defaultAngle;
				}
				else
				{
					defaultAngle = Utilities.radiansToDegrees( Utilities.rotateTowards(s.x, s.y, currentEditUnit.pathSheltersList[s.index - 1].x, 
						currentEditUnit.pathSheltersList[s.index - 1].y));
					currentEditUnit.pathAnglesList[s.index - 1] = defaultAngle;
					(currentEditUnit.skin.getChildByName("upPart_mc") as MovieClip).rotation = defaultAngle;
				}
				
				if(s.index == 1)
				{
					defaultAngle = Utilities.radiansToDegrees(Utilities.rotateTowards(s.x, s.y, currentEditUnit.pathSheltersList[s.index - 1].x, currentEditUnit.pathSheltersList[s.index - 1].y));
					currentEditUnit.checkPointList[s.index - 1].setAngle(defaultAngle);
					currentEditUnit.checkPointList[s.index - 1].rotation = defaultAngle;
				}
				
				currentEditUnit.showPath(currentEditUnit.pathSheltersList);
			}
			else
			{
				var body:MovieClip = new errorPlace_mc();
				body.x = MainConstants.currentLevel.mouseX;
				body.y = MainConstants.currentLevel.mouseY;
				MainConstants.currentLevel.addChild(body);
			}
		}
		
		
		
		private function isCollisionForBody(dx:int, dy:int):Boolean
		{
			var body:Sprite = new bodyTest_mc;
			MainConstants.currentLevel.addChild(body);
			body.x = dx;
			body.y = dy;
			for(var i:int = 0; i < _constructionsList.length; i++)
			{
				if (body.hitTestObject(_constructionsList[i].skin)) 
				{
					MainConstants.currentLevel.removeChild(body);
					body = null;
					return false;
				}
			}
			MainConstants.currentLevel.removeChild(body);
			body = null;
			return true;
		}
		
		
		
		public function removeUnit(event:GameEvents):void
		{
			var unit:IUnit = event.parameter as IUnit;
			
			if(MainConstants.game.listOurArmy.indexOf(unit) > -1)
			{
				MainConstants.game.listOurArmy.splice(MainConstants.game.listOurArmy.indexOf(unit), 1);
			}
			else 
			{
				buildNextEnemy();
				killed += (unit as EnemyUnit).PRICE;
				MainConstants.game.listEnemyArmy.splice(MainConstants.game.listEnemyArmy.indexOf(unit), 1);
			}
			
			//(unit as MovieClip).parent.removeChild((unit as MovieClip));
			//unit = null;
		}

		
		
		
		protected function onPlayBattleHandler(event:Event):void
		{
			if(!MainConstants.game.permitToEdit) return;
			resetSlider();
			if(showMenuPlayer) showMenuPlayer.hideMenu();
			steps++;
			MainConstants.screenManager.cursor.doLookFor("none");
			if(airSupport) letAirSupport(airSupport);
			
			if(currentEditCheckPoint) currentEditCheckPoint.hideMenuState();
			permitToEdit = false;
			if(listOurArmy.length == 0 || listEnemyArmy.length == 0) return;
			currentEditUnit = null;
			
			for(var i:int = 0; i < listOurArmy.length; i++)
				(listOurArmy[i] as PlayerUnit).onPlayBattleHandler();
			
			for(i = 0; i < listEnemyArmy.length; i++)
				(listEnemyArmy[i] as EnemyUnit).onPlayBattleHandler();
			InterfaceListenerOwner.Owner.addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
			
			InterfaceListenerOwner.Owner.dispatchEvent(new GameEvents(GameEvents.BEGIN_OF_MOVE));
		}
		
		
		
		private function letAirSupport(support:String):void
		{
			switch(support)
			{
				case "airSupport1_mc":
					_destructionRadius = 70;
					animateAirSupport(support);
					break;
				
				case "airSupport2_mc":
					_destructionRadius = 100;
					animateAirSupport(support);
					break;
				
				case "airSupport3_mc":
					_destructionRadius = 150;
					animateAirSupport(support);
					break;
			}
		}		
		
		
		
		
		private var _airBoat:MovieClip
		private var dxStart:int;
		private var dxEnd:int;
		private var _destructionRadius:int;
		
		private function animateAirSupport(support:String):void
		{
			dxStart = 150 + Math.random() * (MainConstants.currentLevel.width - 150);
			dxEnd = 150 + Math.random() * (MainConstants.currentLevel.width - 150);
			var explosionsTimer:Timer = new Timer(500, 5);
			explosionsTimer.addEventListener(TimerEvent.TIMER, createAnExplosion);
			var airMovingTimer:Timer = new Timer(16, 183); 
			airMovingTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onAirSupportComplete);
			airMovingTimer.addEventListener(TimerEvent.TIMER, moveAirBoatHandler);
			airMovingTimer.start();
			explosionsTimer.start();
			_airBoat = new airSupport_mc();
			_airBoat.name = support;
			MainConstants.currentLevel.addChild(_airBoat);
			_airBoat.x = dxStart;
			_airBoat.y = -50;
		}		
		
		
		
		protected function moveAirBoatHandler(event:TimerEvent):void
		{
			_airBoat.y += 4;
			_airBoat.x +=(dxEnd - dxStart) / 183;
		}		
		
		
		
		
		public function analyzeExplosion(dx:int, dy:int, radius:int, whoIsTarget:Boolean = true, owner:SimpleUnit = null):void
		{
			var d:Number;
			if(whoIsTarget)
				for(var i:int = 0; i < listEnemyArmy.length; i++)
				{
					d = Utilities.distanceBetweenTwoPoints((listEnemyArmy[i] as Sprite).x, (listEnemyArmy[i] as Sprite).y, dx, dy);
					if(d < radius)  {
						(listEnemyArmy[i] as SimpleUnit).setDamage(2000, owner);
						if(owner) owner.setAction("murderByBoom");
					}
				}
			else 
				for(i = 0; i < listOurArmy.length; i++)
				{
					d = Utilities.distanceBetweenTwoPoints((listOurArmy[i] as Sprite).x, (listOurArmy[i] as Sprite).y, dx, dy);
					if(d < radius)  (listOurArmy[i] as SimpleUnit).setDamage(2000, owner);
				}
			
			/*for(i = 0; i < constructionsList.length; i++)
			{
				d = Utilities.distanceBetweenTwoPoints(constructionsList[i].skin.x, constructionsList[i].skin.y, dx, dy);
				if(d < radius) 
				{
					constructionsList[i].skin.gotoAndStop("explosion");
					constructionsList.splice(i, 1);
					i = 0;
				}
			}*/
		}
		
		private function onAirSupportComplete(event:TimerEvent):void
		{
			MainConstants.currentLevel.removeChild(_airBoat);
			_airBoat = null;
			_airSupport = "";
		}
		
		private function createAnExplosion(event:TimerEvent):void
		{
			var boom:MovieClip = new explose_mc();
			MainConstants.currentLevel.addChild(boom);
			var dx:int = (_airBoat.x / 2) + Math.random() * (_airBoat.x - 100);
			var dy:int = (_airBoat.y / 2) + Math.random() * (_airBoat.y - 100);
			boom.x = dx;
			boom.y = dy;
			analyzeExplosion(dx, dy, _destructionRadius, whoTargetOfAirSupport);
		}
		
		
		protected function onPauseHandler(event:Event):void
		{
			if(_isPause) 
			{
				_isPause = false;
			}
			else 
			{
				_isPause = true;
			}
			
		}
		
		private function mineDetector():void
		{
			if(listMines.length == 0) return;
			
			for(var j:int = 0; j < listMines.length; j++)
			{	
				if (!listMines[j].active) continue;
				
				for(var i:int = 0; i < listOurArmy.length; i++)
					if(listMines[j].hitTestPoint((listOurArmy[i] as PlayerUnit).x, (listOurArmy[i] as PlayerUnit).y, true))
					{
						var boom:MovieClip = new explose_mc();
						boom.x = listMines[j].x;
						boom.y = listMines[j].y;
						MainConstants.currentLevel.addChild(boom);
						(listMines[j] as Mine).owner.setAction("murderByMine");
						(listOurArmy[i] as SimpleUnit).setDamage(2000, (listMines[j] as Mine).owner);
						MainConstants.currentLevel.removeChild(listMines[j]);
						listMines.splice(j, 1);
						return;
					}
				
				for(i = 0; i < listEnemyArmy.length; i++)
				 	if(listMines[j].hitTestPoint((listEnemyArmy[i] as EnemyUnit).x, (listEnemyArmy[i] as EnemyUnit).y, true))
					{
						boom = new explose_mc();
						boom.x = listMines[j].x;
						boom.y = listMines[j].y;
						MainConstants.currentLevel.addChild(boom);
						(listMines[j] as Mine).owner.setAction("murderByMine");
						(listEnemyArmy[i] as SimpleUnit).setDamage(2000, (listMines[j] as Mine).owner);
						MainConstants.currentLevel.removeChild(listMines[j]);
						listMines.splice(j, 1);
						return;
					}
			}
			
		}
		
		protected function onEnterFrameHandler(event:Event):void
		{
			mineDetector();
			
			for(var i:int = 0; i < listOurArmy.length; i++)
				(listOurArmy[i] as PlayerUnit).goToTarget();
			
			for(i = 0; i < listEnemyArmy.length; i++)
				(listEnemyArmy[i] as EnemyUnit).goToTarget();
			
			_timeOfMove++;
			
			if(_timeOfMove == FRAMES_PER_MOVE) 
			{
				for(i = 0; i < listOurArmy.length; i++)
					(listOurArmy[i] as PlayerUnit).endOfMove();
				
				for(i = 0; i < listEnemyArmy.length; i++)
					(listEnemyArmy[i] as EnemyUnit).endOfMove();
				_timeOfMove = 0;
				analyzeScoring();
				permitToEdit = true;
				InterfaceListenerOwner.Owner.dispatchEvent(new GameEvents(GameEvents.END_OF_MOVE));
				MainConstants.screenManager.showHint(DictionaryManager.EndOfMove);
				InterfaceListenerOwner.Owner.removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
				return;
			}
			animateSlider(_timeOfMove);
		}
		
		
		
		
		private function resetSlider():void
		{
			MainConstants.screenManager.view.interface_mc.timeLine_mc.slider_mc.x = 0;
		}
		
		
		
		private function animateSlider(value:int):void
		{
			var distance:Number = 130;//(MainConstants.screenManager.view.interface_mc.timeLine_mc as MovieClip).width;
			var d1:Number = FRAMES_PER_MOVE / 100;
			var d2:Number = distance / 100;
			var dx:Number = value / d1 * d2;
			MainConstants.screenManager.view.interface_mc.timeLine_mc.slider_mc.x = dx;
		}
		
		public function returnUnitsToBarrack():void
		{
			for(var i:int = 0; i < listOurArmy.length; i++)
			{
				(listOurArmy[i] as PlayerUnit).VO.battles++;
				MainConstants.barrackManager.addUnit((listOurArmy[i] as PlayerUnit).VO);
			}
		}
		
		
		public function checkOutcome():void
		{
			if(listEnemyArmy.length == 0)
			{
				doIcanPlayNextLevel = true;
				analyzeScoring();
				returnUnitsToBarrack();
				InterfaceListenerOwner.Owner.dispatchEvent(new GameEvents(GameEvents.ON_LEVEL_WIN));
			}
			else 
			{
				doIcanPlayNextLevel = false;
				trace("listOurArmy.length",listOurArmy.length);
				if(listOurArmy.length == 0) InterfaceListenerOwner.Owner.dispatchEvent(new GameEvents(GameEvents.ON_LEVEL_FAIL));
			}
		}
		

		
		private function updateSerialData():void
		{
			
		}
		
		
		
		private function analyzeScoring():void
		{
			score += killed * 10000 * (1 / steps);
		}
		
		
		private var lastEnemyIndex:int;
		
		

		
		private function buildLevelStartEnemies(level:int):void
		{
			var dx:int = MainConstants.currentLevel.enemyBarrack_mc.x;
			var dy:int = MainConstants.currentLevel.enemyBarrack_mc.y;
			for(lastEnemyIndex = 0; lastEnemyIndex < 5; lastEnemyIndex++)
			{
				var unit:SimpleUnit = MainFactory.createEnemyUnit(GameSetting.lvlEnemies[level][lastEnemyIndex], dx, dy, 0);
				unit.init(unit.VO);
				if(unit) listEnemyArmy.push(unit);
			}
		}
		
		public function buildNextEnemy():void
		{
			var a:Array = GameSetting.lvlEnemies;
			var dx:int = MainConstants.currentLevel.enemyBarrack_mc.x;
			var dy:int = MainConstants.currentLevel.enemyBarrack_mc.y;
			
			if(GameSetting.lvlEnemies[MainConstants.screenManager.currentNumbLevel][lastEnemyIndex])
			{
				var unit:SimpleUnit = MainFactory.createEnemyUnit(GameSetting.lvlEnemies[MainConstants.screenManager.currentNumbLevel][lastEnemyIndex++], dx, dy, 0);		
				unit.init(unit.VO);
				if(unit) listEnemyArmy.push(unit);
				
				MainConstants.screenManager.showHint(DictionaryManager.AttentionYourEnemyCalledSoldier);
			}
			
		}
		
		protected function onNewLevelHandler(event:Event):void
		{
			initSerializationData();
			
			//Инициализация событий мыши
			MainConstants.currentLevel.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
			
			initKeyboard();
			
			buildLevelStartEnemies(MainConstants.screenManager.currentNumbLevel);		
			
			parseLevelForConstructions();
			parseLevelForBuildings();
			parseLevelForDoors();
			sheltersManager = new SheltersManager();
			sheltersManager.parseLevelForShelters();
			sheltersManager.parseLevelForLastShelters();
			
			killed = 0;
			losses = 0;
			steps = 0;
		}
		
		private function initSerializationData():void
		{
			var data:Object = MainConstants.serializationManager.serialData;
			if(MainConstants.screenManager.currentMode == ScreenManager.COMPANY_MODE) score = data.companyScore;
			if(MainConstants.screenManager.currentMode == ScreenManager.OPERATION_MODE) score = data.operationsScore;
		}		
		
		
		private function parseLevelForBuildings():void
		{
			for (var i:uint = 0; i < MainConstants.currentLevel.numChildren; i++)
				if (MainConstants.currentLevel.getChildAt(i).name == "building1_mc"/* || MainConstants.currentLevel.getChildAt(i).name == "door_mc"*/)
				{
					_buildingList.push(MainConstants.currentLevel.getChildAt(i));
					(MainConstants.currentLevel.getChildAt(i)).visible = false;
				}
		}
		
		private function parseLevelForDoors():void
		{
			for (var i:uint = 0; i < MainConstants.currentLevel.numChildren; i++)
				if (MainConstants.currentLevel.getChildAt(i).name == "door_mc")
				{
					_doorList.push(MainConstants.currentLevel.getChildAt(i));
					_doorList[_doorList.length - 1].visible = false;
				}
		}
		
		public function parseLevelForRespalms():void
		{
			for (var i:uint = 0; i < MainConstants.currentLevel.numChildren; i++)
				if (MainConstants.currentLevel.getChildAt(i).name == "respalm_mc")
				{
					respalmList.push(MainConstants.currentLevel.getChildAt(i));
					respalmList[respalmList.length - 1].alpha = 0;
					respalmList[respalmList.length - 1].mouseEnabled = false;
				}
		}
		
		
		private function parseLevelForConstructions():void
		{
			for (var i:uint = 0; i < MainConstants.currentLevel.numChildren; i++)
				if (MainConstants.currentLevel.getChildAt(i).name == "construction_mc")
				{
					var cont:Construction = new Construction(MainConstants.currentLevel.getChildAt(i) as MovieClip);
					_constructionsList.push(cont);
					(MainConstants.currentLevel.getChildAt(i) as MovieClip).visible = false; trace("!");
				}
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Logs
		//
		//--------------------------------------------------------------------------
	}
}