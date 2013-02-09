package managers
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import factories.MainFactory;
	
	import fl.transitions.Tween;
	import fl.transitions.easing.Strong;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.StageVideo;
	import flash.net.SharedObject;
	import flash.utils.Dictionary;
	
	import gameEvents.GameEvents;
	import gameEvents.targets.InterfaceListenerOwner;
	
	import managers.discriptions.LevelsDiscriptions;
	
	import singletons.MainConstants;
	
	import superClasses.Cursor;
	import superClasses.GameSetting;
	import superClasses.PlayerUnit;
	import superClasses.SerializationVO;
	import superClasses.UnitVO;

	public class ScreenManager
	{
		//--------------------------------------------------------------------------
		//
		//  Constants and Variables
		//
		//--------------------------------------------------------------------------
		//Constants
		public static const COMPANY_MODE:String = "companyMode";
		public static const OPERATION_MODE:String = "operationMode";
		
		
		//Private variables
		private var _view:MovieClip;
		private var _cursor:Cursor;
		private var _mcPopUp:MovieClip;
		private var _previousLabel:String;
		private var _dicriptionWindow:MovieClip;

		private var _currentLevelName:String;
		private var _currentMode:String;
		private var _currentLevel:MovieClip;
		private var _currentNumbLevel:int;
		private var _languageWindow:MovieClip;
		
		
		//Public variables
		public var serData:Object;
		
		
		public function ScreenManager(stage:Stage)
		{
			_view = new screens_mc();
			stage.addChild(_view);
			
			init();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters&setters
		//
		//--------------------------------------------------------------------------
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
	
		public function get cursor():Cursor
		{
			return _cursor;
		}

		public function set cursor(value:Cursor):void
		{
			_cursor = value;
		}

		public function get currentNumbLevel():int
		{
			return _currentNumbLevel;
		}

		public function set currentNumbLevel(value:int):void
		{
			_currentNumbLevel = value;
		}

		public function get currentMode():String
		{
			return _currentMode;
		}

		public function set currentMode(value:String):void
		{
			_currentMode = value;
		}

		public function get currentLevelName():String
		{
			return _currentLevelName;
		}

		public function set currentLevelName(value:String):void
		{
			_currentLevelName = value;
		}

		public function get currentLevel():MovieClip
		{
			return _currentLevel;
		}

		public function set currentLevel(value:MovieClip):void
		{
			_currentLevel = value;
		}


		public function get view():MovieClip
		{
			return _view;
		}

		public function set view(value:MovieClip):void
		{
			_view = value;
		}

		private function init():void
		{
			MainConstants.barrackManager = new BarrackManager();
			//var mySO:SharedObject = SharedObject.getLocal("Battle");
			//MainConstants.barrackManager.barrackList = mySO.data.serial.barrackList;
			cursor = new Cursor();
			view.addChild(cursor);
			(view.hint_mc as Sprite).mouseEnabled = false;
			InterfaceListenerOwner.Owner.addEventListener(GameEvents.LOAD_DATA, onLoadDataHandler);
			MainConstants.serializationManager.load();
			InterfaceListenerOwner.Owner.addEventListener(GameEvents.ON_LEVEL_FAIL, onlevelFailHandler);
			InterfaceListenerOwner.Owner.addEventListener(GameEvents.ON_LEVEL_WIN, onlevelWinHandler);
			_view.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Events handlers
		//
		//--------------------------------------------------------------------------
		protected function onLoadDataHandler(event:GameEvents):void
		{
			var data:Object = event.parameter;
			serData = data;
		}
		
		protected function onMouseDownHandler(event:MouseEvent):void
		{
			trace(event.target.name);
			switch ( event.target.name ) 
			{
				case "playLevel_btn":
					_finishLevel = false;
					if (_currentLevelName) onStartLevel(_currentLevelName);
					break;
				
				case "companyPlay_btn":
					view.gotoAndStop(COMPANY_MODE);
					var mySO:SharedObject = SharedObject.getLocal("Battle");
					if(mySO.data.serial.currentLevel == 1)	createLevelDiscriptionWindow("begin");
					_currentMode = COMPANY_MODE;
					initLevelMap();
					HelperManager.stateApplication = HelperManager.MAIN_VIEW;
					break;
				
				/*case "specOperationPlay_btn":
					view.gotoAndStop(OPERATION_MODE);
					_currentMode = OPERATION_MODE;
					initLevelMap(); 
					break;*/
				
				/*case "twoPlayersPlay_btn":
					view.gotoAndStop("levelsMap");
					_currentMode = event.target.name;
					break;*/
				
				
				case "help_me_btn":
					HelperManager.showHelp();
					break;
				
				case "close_helper_btn":
					HelperManager.hideHelp();
					break;
				
				case "stat_btn":
					view.gotoAndStop("stat");
					break;
				
				case "clearData_btn":
					MainConstants.serializationManager.clearData();
					break;
				
				case "shop_btn":
					HelperManager.achivementsHide();
					MainConstants.barrackManager.hide();
					showShopWindow();
					HelperManager.stateApplication = HelperManager.SHOP;
					break;
				
				case "language_btn":
					showLanguageWindow();
					break;
				
				case "english_btn":
					DictionaryManager.language = 0;
					hideLanguageWindow();
					break;
				
				case "russian_btn":
					DictionaryManager.language = 1;
					hideLanguageWindow();
					break;
				
				case "achivements_btn":
					closeShopWindow();
					HelperManager.achivementsHide();
					HelperManager.achivementsShow();
					HelperManager.stateApplication = HelperManager.BARRACK;
					
					break;
				case "barrack_btn":
					HelperManager.achivementsHide();
					closeShopWindow();
					MainConstants.barrackManager.hide();
					MainConstants.barrackManager.show();
					HelperManager.stateApplication = HelperManager.BARRACK;
					break;
				
				case "back_btn":
					HelperManager.achivementsHide();
					MainConstants.barrackManager.hide();
					closeShopWindow();
					var s:Object = MainConstants.serializationManager.serialData;
					view.score_tf.text = s.companyScore;
					HelperManager.stateApplication = HelperManager.MAIN_VIEW;
					break;
				
				case "mainMenu_btn":
					hideImmediatlyHint();
					view.gotoAndStop("menu");
					HelperManager.stateApplication = HelperManager.MAIN_VIEW;
					break;
				
				case "pause_btn":
					InterfaceListenerOwner.Owner.dispatchEvent(new GameEvents(GameEvents.ON_GLOBAL_PAUSE));
					createPopUp("pause");
					break;
				
				case "dicriptionClose_btn":
					removeDicriptionWindow();
					break;
				
				case "dicriptionCloseBegin_btn":
					_dicriptionWindow.parent.removeChild(_dicriptionWindow);
					_dicriptionWindow = null;
					HelperManager.stateApplication = HelperManager.MAIN_VIEW;
					break;
				
				case "popup_mapLevelsVictory_btn":
					removePopUp();
					s = MainConstants.serializationManager.serialData;
					
					if(currentMode == COMPANY_MODE)
					{
						s.companyLevelsStates[_currentNumbLevel - 1] = SerializationVO.PASSED;
						if(s.companyLevelsStates[_currentNumbLevel] == SerializationVO.CLOSED) s.companyLevelsStates[_currentNumbLevel] = SerializationVO.AVAILABLE;
					}
					else
						if(currentMode == OPERATION_MODE)
						{
							s.operationsLevelsStates[_currentNumbLevel - 1] = SerializationVO.PASSED;
							if(s.operationsLevelsStates[_currentNumbLevel] == SerializationVO.CLOSED) s.operationsLevelsStates[_currentNumbLevel] = SerializationVO.AVAILABLE;
						}  
					
					MainConstants.serializationManager.save();
					
					view.gotoAndStop(_currentMode);
					initLevelMap();
					hideImmediatlyHint();
					InterfaceListenerOwner.Owner.dispatchEvent(new GameEvents(GameEvents.ON_DISPOSE_ALL));
					break;
				
				case "popup_mapLevelsDefeated_btn":
					InterfaceListenerOwner.Owner.dispatchEvent(new GameEvents(GameEvents.ON_DISPOSE_ALL));
					removePopUp();
					view.gotoAndStop(_currentMode);
					initLevelMap();
					hideImmediatlyHint();
					break;
				
				
				case "popup_close_btn":
					removePopUp();
					InterfaceListenerOwner.Owner.dispatchEvent(new GameEvents(GameEvents.ON_GLOBAL_PAUSE));
					break;
				
				case "retry_btn":
					_finishLevel = false;
					restartLevel();
					break;
				
				case "barrackInGame_btn":
					if(MainConstants.chooseUnitManager) return;
					MainConstants.chooseUnitManager = new ChooseUnitManager();
					view.addChild(MainConstants.chooseUnitManager);
					HelperManager.stateApplication = HelperManager.CHOOSE_BARRACK;
					break;
				
				case "hideChooseUnitManager_btn":  
					view.removeChild(MainConstants.chooseUnitManager);
					MainConstants.chooseUnitManager = null;
					break;
				
				
				case "play_btn":
					hideImmediatlyHint();
					InterfaceListenerOwner.Owner.dispatchEvent(new GameEvents(GameEvents.ON_PLAY_BATTLE));
					MainConstants.game.finishSheltersList.length = 0;
					break;
				
				case "nextMap_btn":
					if(_currentMode == COMPANY_MODE && MainConstants.serializationManager.serialData.currentLevel == SerializationManager.TOTAL_COMPANY_LEVELS - 1) return; 
					if(_currentMode == OPERATION_MODE && MainConstants.serializationManager.serialData.currentLevel == SerializationManager.TOTAL_OPERATIONS_LEVELS - 1) return; 
					MainConstants.serializationManager.serialData.currentLevel++;
					((view.mapIconContaner_mc.getChildByName("levelState_mc") as MovieClip).getChildByName("placeMap_mc") as MovieClip).removeChild(_currentLevel);

					//buildNewLevel(MainConstants.companyLevelList[serData.currentLevel]);
					initLevelMap();
					break;
				
				case "previousMap_btn":
					if(MainConstants.serializationManager.serialData.currentLevel == 1) return; 
					MainConstants.serializationManager.serialData.currentLevel--;
					((view.mapIconContaner_mc.getChildByName("levelState_mc") as MovieClip).getChildByName("placeMap_mc") as MovieClip).removeChild(_currentLevel);
					//buildNewLevel(MainConstants.companyLevelList[serData.currentLevel]);
					initLevelMap();
					break;
			}
		} 
		
		
		private function showLevelProgress($data:int):void
		{
			var totalF:int = (view.levelProgress as MovieClip).totalFrames;
			var s:Object = MainConstants.serializationManager.serialData;
			var frames:int = int((totalF / 100) * (GameSetting.levelProgress[$data - 1] / 100) * s.levelsProgress[$data - 1]);
			trace((GameSetting.levelProgress[$data - 1] / 100) * s.levelsProgress[$data - 1]);
			trace(frames);
			if(!s.levelsProgress[$data - 1]) s.levelsProgress[$data - 1] = 0;
			
			TweenMax.to(view.levelProgress_tf, 1, {text:int((GameSetting.levelProgress[$data - 1] / 100) * s.levelsProgress[$data - 1]), ease:Linear.easeNone, repeat: 0});
			TweenMax.to(view.levelProgress, 1, {frame:frames, ease:Linear.easeNone, repeat: 0});
		}
		
		private function initLevelMap():void
		{
			var s:Object = MainConstants.serializationManager.serialData;
			
			if(currentMode == COMPANY_MODE)
			{
				view.score_tf.text = s.companyScore;
				buildNewLevel(MainConstants.companyLevelList[s.currentLevel]);
				(view.mapIconContaner_mc.getChildByName("levelState_mc") as MovieClip).gotoAndStop(s.companyLevelsStates[_currentNumbLevel - 1]);
				view.mapIconContaner_mc.discriptionMap_tf.text = LevelsDiscriptions.levelCompanyDiscriptions[_currentNumbLevel - 1];
				_currentLevelName = MainConstants.companyLevelList[serData.currentLevel];
				showLevelProgress(_currentNumbLevel);
			}
			if(currentMode == OPERATION_MODE)
			{
				buildNewLevel(MainConstants.operationsLevelList[s.currentLevel]);
				(view.mapIconContaner_mc.getChildByName("levelState_mc") as MovieClip).gotoAndStop(s.operationsLevelsStates[_currentNumbLevel - 1]);
				view.mapIconContaner_mc.discriptionMap_tf.text = LevelsDiscriptions.levelCompanyDiscriptions[_currentNumbLevel - 1];
				_currentLevelName = MainConstants.operationsLevelList[serData.currentLevel];
			}
			 
			//_currentLevel.height = 562;
			//_currentLevel.width = 658;
			
			((view.mapIconContaner_mc.getChildByName("levelState_mc") as MovieClip).getChildByName("placeMap_mc") as MovieClip).addChild(_currentLevel);
			
			if((view.mapIconContaner_mc.getChildByName("levelState_mc") as MovieClip).currentLabel == SerializationVO.CLOSED)
			{
				view.playLevel_btn.gotoAndStop("disable");
				(view.playLevel_btn as MovieClip).enabled = false;
			}
			else 
			{
				view.playLevel_btn.gotoAndStop("enable");
				(view.playLevel_btn as MovieClip).enabled = true;
			}
			
		}
		
		
		private function buildNewLevel(name:String):void
		{
			switch(name)
			{
				case "level_1":
					_currentLevel = new level1_mc();
					_currentNumbLevel = int(name.charAt(6));
					break;
				/*case "level_2":
					_currentLevel = new level2_mc();
					_currentNumbLevel = int(name.charAt(6));
					break;*/
				case "level_3":
					_currentLevel = new level3_mc();
					_currentNumbLevel = int(name.charAt(6));
					break;
				/*case "level_4":
					_currentLevel = new level4_mc();
					_currentNumbLevel = int(name.charAt(6));
					break;
				case "level_5":
					_currentLevel = new level5_mc();
					_currentNumbLevel = int(name.charAt(6));
					break;*/
			}
			
		}
		
		
		
		public function showLanguageWindow():void
		{
			_languageWindow = new languageMenu_mc();
			_languageWindow.buttonMode = true;
			_languageWindow.useHandCursor = true;
			_languageWindow.x = 650; _languageWindow.y = 20;
			view.addChild(_languageWindow);
		}
		
		public function hideLanguageWindow():void
		{
			view.removeChild(_languageWindow);
			_languageWindow = null;
		}
		
		public function showHint(hint:Array):void
		{
			if(!view.hint_mc.hint_tf) return;
			view.hint_mc.hint_tf.text = hint[DictionaryManager.language];
			view.hint_mc.gotoAndPlay(4);
		}
		
		
		public function hideImmediatlyHint():void
		{
			view.hint_mc.gotoAndStop(1);
		} 
		
		private function onStartLevel(levelName:String):void
		{
			if((view.mapIconContaner_mc.getChildByName("levelState_mc") as MovieClip).currentLabel == SerializationVO.CLOSED)
			{
				showHint(DictionaryManager.ThisMapNotAvailableYet);
				return;
			}
			
			
			if(MainConstants.barrackManager.barrackList.length == 0) 
			{
				showHint(DictionaryManager.YourBarracksHasNotSoldiers);
				return;
			}
			
			view.gotoAndStop("game");
			buildNewLevel(levelName);
			view.camera_mc.addChild(_currentLevel);
			_currentLevel.x = 0;
			_currentLevel.y = 0;
			MainConstants.currentLevel = _currentLevel;
			createLevelDiscriptionWindow(levelName);
			_currentLevelName = levelName;
			view.interface_mc.timeLine_mc.slider_mc.x = 0;
			
			MainConstants.chooseUnitManager = new ChooseUnitManager();
			view.addChild(MainConstants.chooseUnitManager);
			MainConstants.game.parseLevelForRespalms();
			MainConstants.granatesForRestart = MainConstants.serializationManager.serialData.granadeCount;
			MainConstants.minesForRestart = MainConstants.serializationManager.serialData.minesCount;
			MainConstants.selectedUnitsForRestart =  [];
		}
		
		
		private var _finishLevel:Boolean;
		public function onlevelFailHandler(e:GameEvents):void
		{
			_finishLevel = true;
			InterfaceListenerOwner.Owner.dispatchEvent(new GameEvents(GameEvents.ON_GLOBAL_PAUSE));
			createPopUp("fail");
		}
		
		public function onlevelWinHandler(e:GameEvents):void
		{
			_finishLevel = true;
			var s:Object = MainConstants.serializationManager.serialData;
			s.levelsProgress[MainConstants.screenManager.currentNumbLevel - 1] += MainConstants.game.killed;
			MainConstants.serializationManager.save();
			
			InterfaceListenerOwner.Owner.dispatchEvent(new GameEvents(GameEvents.ON_GLOBAL_PAUSE));
			createPopUp("win");
		}
		
		
		public function restartLevel():void
		{
			InterfaceListenerOwner.Owner.dispatchEvent(new GameEvents(GameEvents.ON_DISPOSE_ALL));
			removePopUp();
			buildNewLevel(currentLevelName);
			view.camera_mc.addChild(_currentLevel);
			_currentLevel.x = 0;
			_currentLevel.y = 0;
			MainConstants.currentLevel = _currentLevel;
			createLevelDiscriptionWindow(currentLevelName);
			returnUnitsToBarrack();
			MainConstants.serializationManager.serialData.minesCount = MainConstants.minesForRestart;
			MainConstants.serializationManager.serialData.granadeCount = MainConstants.granatesForRestart;
			MainConstants.serializationManager.save();
			MainConstants.selectedUnitsForRestart = [];
			MainConstants.game.parseLevelForRespalms();
			MainConstants.chooseUnitManager = new ChooseUnitManager();
			view.addChild(MainConstants.chooseUnitManager);
		}
		
		
		private function returnUnitsToBarrack():void
		{
			var arr:Array = MainConstants.selectedUnitsForRestart;
			for(var i:int = 0; i < arr.length; i++)
			{
				MainConstants.barrackManager.addUnit(arr[i]);
			}
		}
		
		
		private function showShopWindow():void
		{
			MainConstants.shopManager.show();
		}		
		
		
		private function closeShopWindow():void
		{
			MainConstants.shopManager.hide(); 
		}
		
		public function createLevelDiscriptionWindow(lev:String):void
		{
			_dicriptionWindow = MainFactory.createLevelDiscriptionWindow(lev, view);

			if(_dicriptionWindow.advices_tf) 
			{
				var pos:int = Math.random() * (DictionaryManager.advices.length - 1);
				_dicriptionWindow.advices_tf.text = DictionaryManager.advices[pos][DictionaryManager.language];
			}
		}
		
		private function removeDicriptionWindow():void
		{
			if (!_dicriptionWindow) return;
			_dicriptionWindow.parent.removeChild(_dicriptionWindow);
			_dicriptionWindow = null;
			InterfaceListenerOwner.Owner.dispatchEvent(new GameEvents(GameEvents.ON_NEW_LEVEL, {levelNumber:_currentLevelName}));
		}
		
		public function removePopUp():void
		{
			if(!_mcPopUp) return; 
			_mcPopUp.shtora.gotoAndPlay("remove");
		}
		
		public function createPopUp(type:String):void
		{
			_previousLabel = type;
			_mcPopUp = MainFactory.createPopUp(type, view, 400,  300);
		}
		
		
		
		private function blurScreen():void
		{
			var blur:BlurFilter = new BlurFilter();
			
			blur.blurX = 5;
			blur.blurY = 5;
			blur.quality = 2;
			
			var filterArray:Array = new Array(blur);
			(view.camera_mc as MovieClip).filters = filterArray;
		}
		
		private function unblurScreen():void
		{
			if(!view || !view.camera_mc) return;
			(view.camera_mc as MovieClip).filters = null;
		}
		
		
		public function dispose():void
		{
			if (_mcPopUp) removePopUp();
			(view.camera_mc as MovieClip).removeChild(MainConstants.currentLevel);
			MainConstants.currentLevel = null;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Logs
		//
		//--------------------------------------------------------------------------
	}
}