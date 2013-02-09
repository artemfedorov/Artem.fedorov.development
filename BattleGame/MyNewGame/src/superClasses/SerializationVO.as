package superClasses
{
	
	/**
	 * @Casino game base core
	 * @author - Artem Fedorov aka Timer
	 * @version - 
	 * 
	 * @langversion - ActionScript 3.0
	 * @playerversion - FlashPlayer 10.2
	 */
	
	
	
	
	public class SerializationVO
	{
		//--------------------------------------------------------------------------
		//
		//  Constants and Variables
		//
		//--------------------------------------------------------------------------
		//Constants
		public  static const PASSED:String 	 = "Passed";
		public  static const AVAILABLE:String = "Available";
		public  static const CLOSED:String 	 = "Closed";
		
		//Private variables
		
		//Public variables
		public var currentLevel:int = 1;
		
		public var companyScore:int;
		public var operationsScore:int;
		
		public var rankAvaliable:uint;
		
		public var companyLevelsScores:Array = [];
		public var companyLevelsStates:Array = [];
		
		public var barrackCapasity:int = 7;
		public var barrackList:Array = [];
		
		public var levelsProgress:Array = [];
		public var operationsLevelsScores:Array = [];
		public var operationsLevelsStates:Array = [];
		
		public var achievements:Array = [];
		
		public var granadeCount:int;
		public var minesCount:int;
		
		public var awards:Array = [];
		
		// Constructor
		public function SerializationVO()
		{
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
		//--------------------------------------------------------------------------
		//
		//  Logs
		//
		//--------------------------------------------------------------------------
		
		
	}
}