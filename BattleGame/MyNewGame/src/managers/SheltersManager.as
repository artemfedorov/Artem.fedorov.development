package managers
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import singletons.MainConstants;
	
	import superClasses.ShelterVO;
	
	/**
	 * @Casino game base core
	 * @author - Artem Fedorov aka Timer
	 * @version - 
	 * 
	 * @langversion - ActionScript 3.0
	 * @playerversion - FlashPlayer 10.2
	 */
	
	
	
	
	public class SheltersManager
	{
		//--------------------------------------------------------------------------
		//
		//  Constants and Variables
		//
		//--------------------------------------------------------------------------
		//Constants
		private static const NUMBER_OF_SHELTERS:int = 150;
		
		//Private variables
		private var _sheltersList:Vector.<ShelterVO> = new Vector.<ShelterVO>;
		private var _lastSheltersList:Vector.<ShelterVO> = new Vector.<ShelterVO>;
		//Public variables
		
		// Constructor
		public function SheltersManager()
		{
			//init();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters&setters
		//
		//--------------------------------------------------------------------------
		//--------------------------------------------------------------------------
		//
		//  Events handlers
		//
		//--------------------------------------------------------------------------
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------

		public function get lastSheltersList():Vector.<ShelterVO>
		{
			return _lastSheltersList;
		}

		public function set lastSheltersList(value:Vector.<ShelterVO>):void
		{
			_lastSheltersList = value;
		}

		private function init():void
		{
			for(var i:int = 0; i <= NUMBER_OF_SHELTERS; i++)
			{
				var dx:int = Math.random() * MainConstants.currentLevel.width;
				var dy:int = Math.random() * MainConstants.currentLevel.height;
				var s:MovieClip = new shelter1_mc();
				MainConstants.currentLevel.addChild(s);
				s.x = dx;
				s.y = dy;
				s.name = "shelter_mc";
			}
		}
		
		
		public function get sheltersList():Vector.<ShelterVO>
		{
			return _sheltersList;
		}

		public function set sheltersList(value:Vector.<ShelterVO>):void
		{
			_sheltersList = value;
		}

		public function addShelter(mc:Sprite):ShelterVO
		{
			var shelter:ShelterVO = new ShelterVO();
			shelter.x = mc.x;
			shelter.y = mc.y;
			_sheltersList.push(shelter);
			return shelter;
		}
		
		public function addLastShelter(mc:Sprite):ShelterVO
		{
			var shelter:ShelterVO = new ShelterVO();
			shelter.x = mc.x;
			shelter.y = mc.y;
			_lastSheltersList.push(shelter);
			return shelter;
		}
		
		public function addShelterVO(s:ShelterVO):void
		{
			_sheltersList.push(s);
		}
		
		
		private function ifInsideTheBuilding(s:DisplayObject):Sprite
		{
			for(var i:int = 0; i < MainConstants.game.buildingList.length; i++)
			{
				if(s.hitTestObject(MainConstants.game.buildingList[i])) return MainConstants.game.buildingList[i];
			}
			return null;
		}
		
		public function parseLevelForShelters():void
		{
			for (var i:uint = 0; i < MainConstants.currentLevel.numChildren; i++)
				if (MainConstants.currentLevel.getChildAt(i).name == "wp_mc")
				{
					var shelter:ShelterVO = addShelter(MainConstants.currentLevel.getChildAt(i) as Sprite);
					var b:Sprite = ifInsideTheBuilding(MainConstants.currentLevel.getChildAt(i));
					if(b) shelter.building = b;
				}
		}
		
		public function parseLevelForLastShelters():void
		{
			for (var i:uint = 0; i < MainConstants.currentLevel.numChildren; i++)
				if (MainConstants.currentLevel.getChildAt(i).name == "shelter_mc" || MainConstants.currentLevel.getChildAt(i).name == "wp_mc")
				{
					var shelter:ShelterVO = addLastShelter(MainConstants.currentLevel.getChildAt(i) as Sprite);
					var b:Sprite = ifInsideTheBuilding(MainConstants.currentLevel.getChildAt(i));
					if(b) shelter.building = b;
					MainConstants.currentLevel.removeChildAt(i);
					i = 0;
				}
		}
		//--------------------------------------------------------------------------
		//
		//  Logs
		//
		//--------------------------------------------------------------------------
		
		
	}
}