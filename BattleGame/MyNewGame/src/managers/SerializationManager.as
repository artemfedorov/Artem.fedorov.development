package managers
{
	import flash.net.SharedObject;
	
	import gameEvents.GameEvents;
	import gameEvents.targets.InterfaceListenerOwner;
	
	import singletons.MainConstants;
	
	import superClasses.GameSetting;
	import superClasses.SerializationVO;
	import superClasses.UnitVO;
	import superClasses.UnitsSetting;

	public class SerializationManager
	{
		//--------------------------------------------------------------------------
		//
		//  Constants and Variables
		//
		//--------------------------------------------------------------------------
		//Constants
		public static const TOTAL_COMPANY_LEVELS:int = 6;
		public static const TOTAL_OPERATIONS_LEVELS:int = 6;
		//Private variables
		
		//Public variables
		public var serialData:Object;
		
		
		public function SerializationManager()
		{
			MainConstants.serializationManager = this;
			serialData = {};
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
		public function clearData():void
		{
			var mySO:SharedObject = SharedObject.getLocal("Battle");
			mySO.clear();
			mySO.data.serial = null;
			MainConstants.serializationManager = this;
			serialData = {};
			load();
		}
		
		public function load():void
		{
			var mySO:SharedObject = SharedObject.getLocal("Battle");
			if(!mySO.data.serial)
			{
				var data:SerializationVO = new SerializationVO();
				data.rankAvaliable = 1;
				data.levelsProgress = [];
				data.achievements = [];
				data.operationsScore = GameSetting.beginScore;
				data.companyScore = GameSetting.beginScore;
				data.companyLevelsStates.push(SerializationVO.AVAILABLE);
				data.operationsLevelsStates.push(SerializationVO.AVAILABLE);
				for(var i:int = 2; i <= TOTAL_COMPANY_LEVELS; i++)
				{
					data.companyLevelsStates.push(SerializationVO.CLOSED);
					data.companyLevelsScores.push(0);
				}
				for(i = 2; i <= TOTAL_OPERATIONS_LEVELS; i++)
				{
					data.operationsLevelsStates.push(SerializationVO.CLOSED);
					data.operationsLevelsScores.push(0);
				}
				
				initBarrack(data);
				mySO.data.serial = data;
				mySO.flush();
			}
			serialData = mySO.data.serial;
			InterfaceListenerOwner.Owner.dispatchEvent(new GameEvents(GameEvents.LOAD_DATA, serialData));
		}
		
		
		private function initBarrack(d:Object):void
		{
			var unit:Object = new UnitVO("private_mc");
			unit.price = GameSetting.privatePrice;
			unit.myName = HelperManager.generateName();
			d.barrackList.push(unit);
			
			unit = new UnitVO("private_mc");
			unit.price = GameSetting.privatePrice;
			unit.myName = HelperManager.generateName();
			d.barrackList.push(unit);
			MainConstants.barrackManager.barrackList = d.barrackList;
			MainConstants.serializationManager.save();
		}
		
		public function save():void
		{
			var mySO:SharedObject = SharedObject.getLocal("Battle");
			mySO.clear();
			mySO.data.serial = serialData;
			mySO.flush();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Events handlers
		//
		//--------------------------------------------------------------------------
		//--------------------------------------------------------------------------
		//
		//  Logs
		//
		//--------------------------------------------------------------------------
	}
}