package managers
{
	import factories.MainFactory;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	import singletons.MainConstants;
	
	import superClasses.GameSetting;
	import superClasses.PlayerUnit;
	import superClasses.SimpleUnit;
	import superClasses.UnitVO;
	import superClasses.UnitsSetting;
	
	/**
	 * @Casino game base core
	 * @author - Artem Fedorov aka Timer
	 * @version - 
	 * 
	 * @langversion - ActionScript 3.0
	 * @playerversion - FlashPlayer 10.2
	 */
	
	
	
	
	public class ShopManager
	{
		//--------------------------------------------------------------------------
		//
		//  Constants and Variables
		//
		//--------------------------------------------------------------------------
		//Constants
		
		//Private variables
		
		//Public variables
		private var _shopWindow:MovieClip;
		// Constructor
		public function ShopManager()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters&setters
		//
		//--------------------------------------------------------------------------
		public function get shopWindow():MovieClip
		{
			return _shopWindow;
		}
		
		public function set shopWindow(value:MovieClip):void
		{
			_shopWindow = value;
		}
		//--------------------------------------------------------------------------
		//
		//  Events handlers
		//
		//--------------------------------------------------------------------------
		protected function onShopClickHandler(event:MouseEvent):void
		{
			var vec:Vector.<PlayerUnit> = new Vector.<PlayerUnit>;
			var bList:Array = MainConstants.barrackManager.barrackList;
			switch(event.target.name)
			{
				case "explosives_btn": 
					mouseOverOutRemoves();
					_shopWindow.gotoAndStop("explosives");
					mouseOverOutInit();
					shopWindow.score_tf.text = MainConstants.serializationManager.serialData.companyScore;
					break;
				case "airsupport_btn": 
					mouseOverOutRemoves();
					_shopWindow.gotoAndStop("airsupports");
					mouseOverOutInit();
					shopWindow.score_tf.text = MainConstants.serializationManager.serialData.companyScore;
					break;
				case "warrior_btn": 
					mouseOverOutRemoves();
					_shopWindow.gotoAndStop("warriors");
					mouseOverOutInit();
					shopWindow.score_tf.text = MainConstants.serializationManager.serialData.companyScore;
					break;
				
				case "private_mc":
				case "corporal_mc":
				case "sergeant_mc":
				case "capitain_mc":
				case "lieutenant_mc":
				case "major_mc":
				case "lieutenantColonell_mc":
				case "colonel_mc":
				case "airSupport1_mc":
				case "airSupport2_mc":
				case "airSupport3_mc":
				case "granate_btn":
				case "mine_btn":
					
					if( event.target.name == "granate_btn")
					{
						
						o = MainConstants.serializationManager.serialData;
						trace("RANK ",o.rankAvaliable);
						//if(o.rankAvaliable < 5) return;
						if(o.companyScore < GameSetting.granadePrice) return;
						o.companyScore -= GameSetting.granadePrice;
						shopWindow.score_tf.text = o.companyScore;
						
						o.granadeCount++;
						MainConstants.serializationManager.save();
						return;
					}
					if( event.target.name == "mine_btn")
					{
						var o:Object = MainConstants.serializationManager.serialData;
						trace("RANK ",o.rankAvaliable);
						//if(o.rankAvaliable < 5) return;
						if(o.companyScore < GameSetting.minePrice) return;
						o.companyScore -= GameSetting.minePrice;
						shopWindow.score_tf.text = o.companyScore;
						
						o.minesCount++;
						MainConstants.serializationManager.save();
						return;
					}
					
					if(bList.length < MainConstants.barrackManager.capacity)
					{
						buyItem(event.target.name);
					}
					else MainConstants.screenManager.showHint(DictionaryManager.YourBarrackCompleted);
					
					break;
				
				default:
				{
					break;
				}
			}
		}
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		public function buyItem(item:String):void
		{
			if (!checkForRank(item))
			{
				MainConstants.screenManager.createLevelDiscriptionWindow("rankLimit");
				return;
			}
			var o:Object = MainConstants.serializationManager.serialData;
			var unit:Object = new UnitVO(item);
			switch(item)
			{
				case "private_mc":
					if(o.companyScore < GameSetting.privatePrice) return; 
					unit.price = GameSetting.privatePrice;
					o.companyScore -= GameSetting.sergeantPrice;
					shopWindow.score_tf.text = o.companyScore;
					break;
				
				case "corporal_mc":
					if(o.companyScore < GameSetting.corporalPrice) return; 
					unit.price = GameSetting.corporalPrice;
					o.companyScore -= GameSetting.sergeantPrice;
					shopWindow.score_tf.text = o.companyScore;
					break;
				/*
				case "sergeant_mc":
					if(o.companyScore < GameSetting.sergeantPrice) return;
					unit.price = GameSetting.sergeantPrice;
					unit.fireRange = UnitsSetting.middleROF;
					o.companyScore -= GameSetting.sergeantPrice;
					shopWindow.score_tf.text = o.companyScore;
					break;
				
				case "capitain_mc":
					if(o.companyScore < GameSetting.capitainPrice) return;
					unit.price = GameSetting.capitainPrice;
					unit.fireRange = UnitsSetting.UsualROF;
					o.companyScore -= GameSetting.capitainPrice;
					shopWindow.score_tf.text = o.companyScore;
					break;
				
				case "lieutenant_mc":
					if(o.companyScore < GameSetting.lieutenantPrice) return;
					unit.price = GameSetting.lieutenantPrice;
					unit.fireRange = UnitsSetting.UsualROF;
					o.companyScore -= GameSetting.lieutenantPrice;
					shopWindow.score_tf.text = o.companyScore;
					break;
				
				case "major_mc":
					if(o.companyScore < GameSetting.majorPrice) return;
					unit.price = GameSetting.majorPrice;
					unit.fireRange = UnitsSetting.UsualROF;
					o.companyScore -= GameSetting.majorPrice;
					shopWindow.score_tf.text = o.companyScore;
					break;
				
				case "lieutenantColonell_mc":
					if(o.companyScore < GameSetting.lieutenantColonellPrice) return;
					unit.price = GameSetting.lieutenantColonellPrice;
					unit.fireRange = UnitsSetting.UsualROF;
					o.companyScore -= GameSetting.lieutenantColonellPrice;
					shopWindow.score_tf.text = o.companyScore;
					break;
				
				case "colonel_mc":
					if(o.companyScore < GameSetting.colonelPrice) return;
					unit.price = GameSetting.colonelPrice;
					unit.fireRange = UnitsSetting.maximumROF;
					o.companyScore -= GameSetting.colonelPrice;
					shopWindow.score_tf.text = o.companyScore;
					break;
				*/
				case "airSupport1_mc":
					if(o.companyScore < GameSetting.airSupport1Price) return;
					unit.price = GameSetting.airSupport1Price;
					o.companyScore -= GameSetting.airSupport1Price;
					shopWindow.score_tf.text = o.companyScore;
					break;
				
				case "airSupport2_mc":
					if(o.companyScore < GameSetting.airSupport2Price) return;
					unit.price = GameSetting.airSupport2Price;
					o.companyScore -= GameSetting.airSupport2Price;
					shopWindow.score_tf.text = o.companyScore;
					break;
				
				case "airSupport3_mc":
					if(o.companyScore < GameSetting.airSupport3Price) return;
					unit.price = GameSetting.airSupport3Price;
					o.companyScore -= GameSetting.airSupport3Price;
					shopWindow.score_tf.text = o.companyScore;
					break;
			}
			
				unit.myName = HelperManager.generateName();
				MainConstants.barrackManager.addUnit(unit);
				MainConstants.serializationManager.save();
		}
		
		
		private function checkForRank($rank:String):Boolean
		{
			var o:Object = MainConstants.serializationManager.serialData;
			var limit:uint = o.rankAvaliable;
			var i:int = GameSetting.ranks.indexOf($rank);
			return (i > limit) ? false : true;
		}
		
		private function setAvaliableUnitsLimit():void
		{
			var o:Object = MainConstants.serializationManager.serialData;
			var limit:uint = o.rankAvaliable;
			var barrackList:Array = MainConstants.serializationManager.serialData.barrackList;
			for (var unit:int = 0; unit < barrackList.length; unit++)
			{
				var i:int = GameSetting.ranks.indexOf(barrackList[unit].type);
				if(i > limit) 
				{
					limit = i;
					MainConstants.serializationManager.serialData.rankAvaliable = limit;
					MainConstants.serializationManager.save();
				}
			}
		}
		
		public function show():void
		{
			var o:Object = MainConstants.serializationManager.serialData;
			setAvaliableUnitsLimit();
			shopWindow = MainFactory.createShopWindow(MainConstants.screenManager.view);
			shopWindow.score_tf.text = o.companyScore;
			shopWindow.addEventListener(MouseEvent.CLICK, onShopClickHandler);
			shopWindow.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutHandler);
			shopWindow.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverHandler);
		}
		
		private function mouseOverOutInit():void
		{
			var i:uint;
			while(i < shopWindow.numChildren)
			{
				if(shopWindow.getChildAt(i).name && shopWindow.getChildAt(i).name == "shopItem")
				{
					shopWindow.getChildAt(i).addEventListener(MouseEvent.MOUSE_OUT, onMouseOutHandler);
					shopWindow.getChildAt(i).addEventListener(MouseEvent.MOUSE_OVER, onMouseOverHandler);
				}
				i++;
			}
		}
		
		private function mouseOverOutRemoves():void
		{
			var i:uint;
			while(i < shopWindow.numChildren)
			{
				if(shopWindow.getChildAt(i).name && shopWindow.getChildAt(i).name == "shopItem")
				{
					shopWindow.getChildAt(i).removeEventListener(MouseEvent.MOUSE_OUT, onMouseOutHandler);
					shopWindow.getChildAt(i).removeEventListener(MouseEvent.MOUSE_OVER, onMouseOverHandler);
				}
				i++;
			}
		}
		
		private var _mouseItem:MovieClip;
		protected function onMouseOverHandler(event:MouseEvent):void
		{
			if(event.target == _mouseItem || event.target.name != "shopItem") return;
				if(_mouseItem) _mouseItem.filters = null;
				event.target.filters = [new GlowFilter(0xCBF3FF, .5)];
				_mouseItem = event.target as MovieClip;
		}
		
		protected function onMouseOutHandler(event:MouseEvent):void
		{
				//event.target.filters = null;
		}		
		
		public function hide():void
		{
			if (!shopWindow) return;
			shopWindow.removeEventListener(MouseEvent.CLICK, onShopClickHandler);
			shopWindow.parent.removeChild(shopWindow);
			shopWindow = null;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Logs
		//
		//--------------------------------------------------------------------------
		
		
	}
}