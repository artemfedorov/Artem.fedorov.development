
package gameEvents
{
	import flash.events.Event;
	
	public class GameEvents extends Event
	{
		//--------------------------------------------------------------------------
		//
		//  Constants and Variables
		//
		//--------------------------------------------------------------------------
		//Constants
		public static const ON_DESTROY_UNIT:String = "OnDestroyUnit";
		public static const ON_NEW_LEVEL:String = "OnNewLevel";
		public static const ON_DISPOSE_ALL:String = "OnDisposeAll";
		public static const BEGIN_CONTACT:String = "BeginContact";
		public static const ON_GLOBAL_PAUSE:String = "OnGlobalPause";
		public static const ON_LEVEL_FAIL:String = "OnLevelFail";
		public static const ON_LEVEL_WIN:String = "OnLevelWin";
		public static const ON_PLAY_BATTLE:String = "OnPlayBattle";
		public static const LOAD_DATA:String = "LoadData";
		public static const END_OF_MOVE:String = "EndOFMove";
		public static const BEGIN_OF_MOVE:String = "BeginOfMove";
		
		//Private variables
		
		//Public variables
		public var parameter:Object;
		
		public function GameEvents(type:String, params:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			parameter = params;
			super(type, bubbles, cancelable);
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