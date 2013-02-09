package managers
{
	import factories.MainFactory;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	import singletons.MainConstants;
	
	import superClasses.GameSetting;
	import superClasses.UnitVO;
	
	/**
	 * @Casino game base core
	 * @author - Artem Fedorov aka Timer
	 * @version - 
	 * 
	 * @langversion - ActionScript 3.0
	 * @playerversion - FlashPlayer 10.2
	 */
	
	
	
	
	public class BarrackManager
	{
		//--------------------------------------------------------------------------
		//
		//  Constants and Variables
		//
		//--------------------------------------------------------------------------
		//Constants
		
		//Private variables
		private var _window:MovieClip;
		
		private var _capacity:int = 7;
		
		private var _barrackList:Array = [];
		
		//Public variables
		
		// Constructor
		public function BarrackManager()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters&setters
		//
		//--------------------------------------------------------------------------

		public function get capacity():int
		{
			return _capacity;
		}

		public function set capacity(value:int):void
		{
			_capacity = value;
		}

		public function get barrackList():Array
		{
			return _barrackList;
		}

		public function set barrackList(value:Array):void
		{
			_barrackList = value;
		}
		
		public function get window():MovieClip
		{
			return _window;
		}
		
		public function set window(value:MovieClip):void
		{
			_window = value;
		}
		//--------------------------------------------------------------------------
		//
		//  Events handlers
		//
		//--------------------------------------------------------------------------


		protected function onClickHandler(event:MouseEvent):void
		{
			if(event.target.name == "sellUnit_btn") sellUnit(findUnitVOBySkin(event.target.parent));
			if(event.target.name == "name_btn") changeName(findUnitVOBySkin(event.target.parent), event.target.parent.name_tf.text);
			if(event.target.name == "plusRapidity_btn" || event.target.name == "plusDamage_btn" || event.target.name == "plusArmor_btn" || event.target.name == "plusAccuracy_btn") increaseProperty(findUnitVOBySkin(event.target.parent), event.target.name);
			if(event.target.name == "scroller_mc") 
			{
				window.addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
				window.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
			}
		}		
		
		private function changeName(unit:Object, newName:String):void
		{
			unit.myName = newName;
			MainConstants.serializationManager.serialData.barrackList = barrackList;
			MainConstants.serializationManager.save();
		}
		
		private function increaseProperty(unit:Object, type:String):void
		{
			switch(type)
			{
				case "plusRapidity_btn":
					if(unit.armor == 0 && unit.accuracy == 0) return;
					unit.rapidity++;
					if(unit.armor > unit.accuracy) 
					{
						if(unit.armor > 0) unit.armor--;
					}
					else 
					{
						if(unit.accuracy > 0) unit.accuracy--;
					}
					break;
				
				case "plusArmor_btn":
					if(unit.rapidity == 0 && unit.accuracy == 0 && unit.damage == 0) return;
					unit.armor++;
					if(unit.rapidity > unit.accuracy) 
					{
						if(unit.rapidity > 0)unit.rapidity--;
					}
					else 
					{
						if(unit.accuracy > 0) unit.accuracy--;
					}
					break;
				
				case "plusAccuracy_btn":
					if(unit.rapidity == 0 && unit.armor == 0 && unit.damage == 0) return;
					unit.accuracy++;
					if(unit.rapidity > unit.armor) 
					{
						if(unit.rapidity > 0)unit.rapidity--;
					}
					else 
					{
						if(unit.armor > 0) unit.armor--;
					}
					break;
				
				case "plusDamage_btn":
					if(unit.rapidity == 0 && unit.armor == 0 && unit.accuracy == 0) return;
					unit.damage++;
					if(unit.rapidity > unit.armor) 
					{
						if(unit.rapidity > 0)unit.rapidity--;
					}
					else 
					{
						if(unit.armor > 0) unit.armor--;
					}
					break;
			}
			
			
			unit.skin.damage_tf.text = unit.damage;
			unit.skin.armor_tf.text = unit.armor;
			unit.skin.accuracy_tf.text = unit.accuracy;
			unit.skin.rapidity_tf.text = unit.rapidity;
			unit.skin.selfTreat_tf.text = unit.selfTreat;
			
			MainConstants.serializationManager.serialData.barrackList = barrackList;
			MainConstants.serializationManager.save();
		}		
		
		protected function onMouseMoveHandler(event:MouseEvent):void
		{
			var height:Number = (_barrackList.length - 3) * 130;
			window.scroller_mc.y = window.mouseY;
			if(window.scroller_mc.y > 472) window.scroller_mc.y = 472;
			if(window.scroller_mc.y < 138)window.scroller_mc.y = 138;
			if(_barrackList.length <= 3) return;
			window.backItems_mc.y = 95 + (height / 100) * ((window.scroller_mc.y - 138) / 3.34) * -1; 
		}
		
		protected function onMouseUpHandler(event:MouseEvent):void
		{
			window.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			window.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
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
		
		public function addUnit(unit:Object):void
		{
			barrackList.push(unit);
			MainConstants.serializationManager.serialData.barrackList = barrackList;
			MainConstants.serializationManager.save();
		}
		
		
		public function sellUnit(unit:Object):void
		{
			var o:Object = MainConstants.serializationManager.serialData;
			o.companyScore += unit.price;
			window.score_tf.text = o.companyScore;
			window.backItems_mc.removeChild(unit.skin);
			unit.skin = null;
			barrackList.splice(barrackList.indexOf(unit), 1);
			MainConstants.serializationManager.serialData.barrackList = barrackList;
			MainConstants.serializationManager.save();
			hide();
			show();
			showUnits();
		}
		
		
		private function showUnits():void
		{
			var o:Object = MainConstants.serializationManager.serialData;
			barrackList = MainConstants.serializationManager.serialData.barrackList;
			window.mineCount_tf.text = o.minesCount;
			window.granadeCount_tf.text = o.granadeCount;
			if(barrackList.length == 0) return;
			
			var dy:int = 0;
			var dx:int = 0;
			
			for(var i:int = 0; i < barrackList.length; i++)
			{
				if(barrackList[i].type == "shopMine_btn") continue;
				var mc:MovieClip = new barrackUnit_mc();
				mc.gotoAndStop(barrackList[i].type);
				mc.type_tf.text = barrackList[i].type;
				mc.FOV_tf.text = barrackList[i].FOV;
				
				mc.armor_tf.text = barrackList[i].armor;
				mc.rapidity_tf.text = barrackList[i].rapidity;
				mc.accuracy_tf.text = barrackList[i].accuracy;
				mc.selfTreat_tf.text = barrackList[i].selfTreat;
				mc.damage_tf.text = barrackList[i].damage;
				
				mc.price_tf.text = barrackList[i].price;
				mc.progress_tf.text = barrackList[i].murder;
				mc.battles_tf.text = barrackList[i].battles;
				mc.name_tf.text = barrackList[i].myName;
				mc.x = dx; mc.y = dy;
				mc.name = "barrackUnit";//barrackList[i].type;
				
				dy += 130; 
				window.backItems_mc.addChild(mc);
				barrackList[i].skin = mc;
			}
		}

		 
		public function changeBarrackCapacity(c:int):void
		{
			var o:Object = MainConstants.serializationManager.serialData;
			capacity = 	c;
			o.barrackCapasity = capacity;
			MainConstants.serializationManager.save();
		}
		
		
		public function show():void 
		{
			var o:Object = MainConstants.serializationManager.serialData;
			capacity = 	o.barrackCapasity;
			window = MainFactory.createBarrackWindow(MainConstants.screenManager.view);
			window.score_tf.text = o.companyScore;
			window.capacity_tf.text = String(capacity);
			showUnits();
			window.addEventListener(MouseEvent.MOUSE_DOWN, onClickHandler);
			window.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutHandler);
			window.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverHandler);
		}
		
		protected function onMouseOverHandler(event:MouseEvent):void
		{
			if(event.target.name && event.target.name == "barrackUnit")
				event.target.filters = [new GlowFilter(0xCBF3FF, .5)];
			else if(event.target.parent.name == "barrackUnit")
				event.target.parent.filters = [new GlowFilter(0xCBF3FF, .5)];
		}
		
		protected function onMouseOutHandler(event:MouseEvent):void
		{
			if(event.target.name && event.target.name == "barrackUnit")
				event.target.filters = null;
			else if(event.target.parent.name == "barrackUnit")
				event.target.parent.filters = null;
		}		
		
		public function hide():void
		{
			if (!window) return;
			window.removeEventListener(MouseEvent.MOUSE_DOWN, onClickHandler);
			window.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOutHandler);
			window.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOverHandler);
			window.parent.removeChild(window);
			window = null;
		}
		//--------------------------------------------------------------------------
		//
		//  Logs
		//
		//--------------------------------------------------------------------------
		
		
	}
}