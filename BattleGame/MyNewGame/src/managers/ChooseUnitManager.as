package managers
{
	import factories.MainFactory;
	
	import fl.motion.easing.Elastic;
	import fl.transitions.Tween;
	import fl.transitions.easing.Strong;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import singletons.MainConstants;
	
	import superClasses.GameSetting;
	import superClasses.IUnit;
	import superClasses.PlayerUnit;
	import superClasses.SimpleUnit;
	import superClasses.UnitVO;
	
	/**
	 * @author - Artem Fedorov aka Timer
	 * @version - 
	 * 
	 * @langversion - ActionScript 3.0
	 * @playerversion - FlashPlayer 10.2
	 */
	
	
	
	
	public class ChooseUnitManager extends barrackInGame_mc
	{
		//--------------------------------------------------------------------------
		//
		//  Constants and Variables
		//
		//--------------------------------------------------------------------------
		//Constants
		
		//Private variables
		private var _barrackList:Array = [];
		
		private var _selectedUnits:Array = [];
		private var _tweenX:Tween;
		//Public variables
		
		// Constructor
		public function ChooseUnitManager()
		{
			x = -this.width;
			show();
			addEventListener(MouseEvent.CLICK, onClickHandler);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters&setters
		//
		//--------------------------------------------------------------------------
		
		public function get barrackList():Array
		{
			return _barrackList;
		}
		
		public function set barrackList(value:Array):void
		{
			_barrackList = value;
		}
		//--------------------------------------------------------------------------
		//
		//  Events handlers
		//
		//--------------------------------------------------------------------------
		
		
		protected function onClickHandler(event:MouseEvent):void
		{
			trace(event.target.name);
			switch(event.target.name)
			{
				case "selectUnit_btn":
					selectUnit(findUnitVOBySkin(event.target.parent));
					break;
				
				case "takeOut_btn":
					takeOut();
					break;
			}
		}		
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		private function findUnitVOBySkin(mc:MovieClip):Object
		{
			barrackList = MainConstants.serializationManager.serialData.barrackList ;
			for(var i:int = 0; i < barrackList.length; i++)
			{ 
				if(barrackList[i].skin == mc) 
				{
					return barrackList[i];
				}
			}
			return null;
		}

		
		private function selectUnit(unit:Object):void
		{
			if(unit.skin.selection_mc.currentLabel == "unSelected")
			{
				_selectedUnits.push(unit);
				unit.skin.selection_mc.gotoAndStop("selected");
			}
			else 
			{
				unit.skin.selection_mc.gotoAndStop("unSelected");
				if(_selectedUnits.indexOf(unit) > -1) _selectedUnits.splice(_selectedUnits.indexOf(unit), 1);
			}
		}
		
		private function isFreeRespalm(s:Sprite):Boolean
		{
			var list:Vector.<SimpleUnit> = MainConstants.game.listOurArmy;
			for(var j:int = 0; j < list.length; j++)
				if(s.hitTestObject(list[j] as Sprite))  
					return false;
			return true;
		}
		
		private function findFreeRespalm():Sprite
		{
			var list:Vector.<Sprite> = MainConstants.game.respalmList;
			for(var i:int = 0; i < list.length; i++)
				if(isFreeRespalm(list[i])) return list[i];

			return null;
		}
		
		private function saveUnitForRestart(item:Object):void
		{
			var arr:Array = MainConstants.selectedUnitsForRestart;
			arr.push(item);
		}
		
		public function takeOut():void
		{
			var playerUnit:SimpleUnit;
				barrackList = MainConstants.serializationManager.serialData.barrackList ;
			for(var i:int = 0; i < _selectedUnits.length; i++)
			{ 
				if(MainConstants.game.listOurArmy.length == GameSetting.MAX_UNIT_IN_BATTLE)
				{
					MainConstants.screenManager.showHint(DictionaryManager.YouAlreadyUseMaximumAmountUnits);	
					return;
				}
				
				if((_selectedUnits[i].type as String).substr(0, 10) != "airSupport")
				{
					saveUnitForRestart(_selectedUnits[i]);
					var s:Sprite = findFreeRespalm();
					playerUnit = MainFactory.createUnit(_selectedUnits[i].type, s.x, s.y, 0);
					playerUnit.init(_selectedUnits[i]);
					MainConstants.game.listOurArmy.push(playerUnit);
					
					barrackList.splice(barrackList.indexOf(_selectedUnits[i]), 1);
					
					removeChild(_selectedUnits[i].skin);
					_selectedUnits[i].skin = null;
					_selectedUnits.splice(i, 1);
					
					MainConstants.serializationManager.serialData.barrackList = barrackList;
					MainConstants.serializationManager.save();
					i = -1;
				}	
				else
				{
					if(MainConstants.game.airSupport == "")
					{
						saveUnitForRestart(_selectedUnits[i]);
						MainConstants.game.whoTargetOfAirSupport = true;
						MainConstants.game.airSupport = _selectedUnits[i].type;
						barrackList.splice(barrackList.indexOf(_selectedUnits[i]), 1);
						
						removeChild(_selectedUnits[i].skin);
						_selectedUnits[i].skin = null;
						_selectedUnits.splice(i, 1);
						
						MainConstants.serializationManager.serialData.barrackList = barrackList;
						MainConstants.serializationManager.save();
						i = -1;
					}
					else 
					{
						MainConstants.screenManager.showHint(DictionaryManager.YouAlreadyUseAirSupport);	
					}
				}
				
			}
			MainConstants.game.permitToEdit = true;
		} 
		
		
		private function showUnits():void
		{
			barrackList = MainConstants.serializationManager.serialData.barrackList;
			if(barrackList.length == 0) return;
			
			var dy:int = 50;
			var dx:int = 200;
			for(var i:int = 0; i < barrackList.length; i++)
			{ 
				var mc:MovieClip = new chooseUnit_mc();
				mc.gotoAndStop(barrackList[i].type);
				mc.type_tf.text = barrackList[i].type;
				mc.FOV_tf.text = barrackList[i].FOV;
				mc.armor_tf.text = barrackList[i].armor;
				mc.rapidity_tf.text = barrackList[i].rapidity;
				mc.price_tf.text = barrackList[i].price;
				mc.progress_tf.text = barrackList[i].murder;
				mc.battles_tf.text = barrackList[i].battles;
				mc.x = dx; mc.y = dy;
				mc.name = barrackList[i].type;
				dx += 100;
				if(dx == 700) {dy += 170; dx = 200}
				addChild(mc);
				barrackList[i].skin = mc;
			}
		}
		
		
		public function show():void 
		{
			HelperManager.stateApplication = HelperManager.CHOOSE_BARRACK;
			showUnits();
			_tweenX = new Tween(this, "x", Strong.easeOut, -this.width, 0, 1, true);
			_tweenX.start();
		}
		
		
		public function hide():void
		{
			removeEventListener(MouseEvent.CLICK, onClickHandler);
		}
		//--------------------------------------------------------------------------
		//
		//  Logs
		//
		//--------------------------------------------------------------------------
		
		
	}
}