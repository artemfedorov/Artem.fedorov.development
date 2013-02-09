
package singletons
{
	
	import Utils.KeyboardManager;
	
	import flash.display.MovieClip;
	
	import game.Game;
	
	import managers.ScreenManager;
	import managers.SerializationManager;
	import managers.ShopManager;
	import managers.BarrackManager;
	import managers.ChooseUnitManager;
	import managers.HelperManager;

	public class MainConstants
	{
		//--------------------------------------------------------------------------
		//
		//  Constants and Variables
		//
		//--------------------------------------------------------------------------
		//Constants
		
		//Private variables
		
		//Public variables
		public static var companyLevelList:Array = ["0", "level_1", "level_2", "level_3", "level_4", "level_5"];
		public static var operationsLevelList:Array = ["0", "level_1", "level_2", "level_3", "level_4", "level_5"];

		public static  var screenManager:ScreenManager;
		public static  var game:Game;
		public static  var currentLevel:MovieClip;
		public static var KeyManager:KeyboardManager;
		public static var serializationManager:SerializationManager;
		public static var shopManager:ShopManager;
		public static var barrackManager:BarrackManager;
		public static var chooseUnitManager:ChooseUnitManager;
		public static var selectedUnitsForRestart:Array;
		public static var minesForRestart:int;
		public static var granatesForRestart:int;
		public static var helper:HelperManager;
		
		public function MainConstants()
		{
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