 package
{
	import Utils.Utilities;
	
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import game.Game;
	
	import gameEvents.GameEvents;
	import gameEvents.targets.InterfaceListenerOwner;
	
	import managers.ScreenManager;
	import managers.SerializationManager;
	import managers.ShopManager;
	
	import singletons.MainConstants;
	
	[SWF(width="800", height="600", backgroundColor="#FFFFFF", frameRate="31")]
	
	public class MyNewGame extends Sprite
	{
		//--------------------------------------------------------------------------
		//
		//  Constants and Variables
		//
		//--------------------------------------------------------------------------
		//Constants
		
		//Private variables
		private var _game:Game;
		private var _serialManager:SerializationManager;
		//Public variables
		
		public function MyNewGame()
		{
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
		private function init():void
		{
			var shop:ShopManager = new ShopManager();
			MainConstants.shopManager = shop;
			_serialManager = new SerializationManager();
			_game = new Game();
			MainConstants.game = _game;
			MainConstants.screenManager = new ScreenManager(stage);
			InterfaceListenerOwner.Owner.addEventListener(GameEvents.ON_DISPOSE_ALL, onDisposeAllHandler);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Events handlers
		//
		//--------------------------------------------------------------------------				
		protected function onDisposeAllHandler(event:Event):void
		{
			MainConstants.game.dispose();
			MainConstants.game = null;
			_game = new Game();
			MainConstants.game = _game;
			MainConstants.screenManager.dispose();
		}
		//--------------------------------------------------------------------------
		//
		//  Logs
		//
		//--------------------------------------------------------------------------
	}
}