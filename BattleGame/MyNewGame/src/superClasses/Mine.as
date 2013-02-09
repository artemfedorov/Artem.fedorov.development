package superClasses
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.messaging.AbstractConsumer;
	
	/**
	 * @author - Artem Fedorov aka Timer
	 * @version - 
	 * 
	 * @langversion - ActionScript 3.0
	 * @playerversion - FlashPlayer 10.2
	 */
	
	
	
	
	public class Mine extends mine_mc
	{
		//--------------------------------------------------------------------------
		//
		//  Constants and Variables
		//
		//--------------------------------------------------------------------------
		//Constants
		
		//Private variables
		
		//Public variables
		public var active:Boolean = false;
		// Constructor
		public var owner:SimpleUnit;
		public function Mine()
		{
			var timerActivate:Timer = new Timer(5000, 1);
			timerActivate.addEventListener(TimerEvent.TIMER_COMPLETE, onActivateHandler);
			timerActivate.start();
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
		protected function onActivateHandler(event:TimerEvent):void
		{
			active = true;
			this.gotoAndStop("active");			
		}
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