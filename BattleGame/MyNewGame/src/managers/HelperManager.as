package managers
{
	import factories.MainFactory;
	
	import flash.display.MovieClip;
	
	import singletons.MainConstants;
	
	import superClasses.UnitsSetting;

	public class HelperManager
	{
		public static var MAIN_VIEW:String 			= "MainView";
		public static var CHOOSE_BARRACK:String	 	= "ChooseBarrack";
		public static var SHOP:String 				= "Shop";
		public static var BARRACK:String 			= "Barrack";
		public static var IN_GAME:String 			= "InGame";
		public static var PLAYER_MENU:String 		= "PlayerMenu";
		public static var CHECKPOINT_MENU:String 	= "CheckpointMenu";
		
		private static var _view:MovieClip;
		private static var _stateApplication:String;
		
		public function HelperManager()
		{
		}

		public static function get stateApplication():String
		{
			return _stateApplication;
		}

		public static function set stateApplication(value:String):void
		{
			_stateApplication = value;
		}
		
		
		public static function showHelp():void
		{
			if(_view) return;
			_view = MainFactory.createHelperWindow(_stateApplication, MainConstants.screenManager.view);
		}
		
		public static function hideHelp():void
		{
			_view.parent.removeChild(_view);
			_view = null;		
		}
		
		public static var window:MovieClip;
		public static function achivementsShow():void
		{
			var o:Object = MainConstants.serializationManager.serialData;
			window = MainFactory.createAchivementWindow(MainConstants.screenManager.view);
			window.score_tf.text = o.companyScore;
		}
		public static function achivementsHide():void
		{
			if (!window) return;
			window.parent.removeChild(window);
			window = null;
		}
		
		public static function generateName():String
		{
			return UnitsSetting.names[int(Math.random() * UnitsSetting.names.length)];	
		}
		
		
	}
}