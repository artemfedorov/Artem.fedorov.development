package superClasses
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.sampler.startSampling;
	import flash.ui.Mouse;
	
	import singletons.MainConstants;
	
	/**
	 * @Casino game base core
	 * @author - Artem Fedorov aka Timer
	 * @version - 
	 * 
	 * @langversion - ActionScript 3.0
	 * @playerversion - FlashPlayer 10.2
	 */
	
	
	
	
	public class Cursor extends cursors_mc
	{
		//--------------------------------------------------------------------------
		//
		//  Constants and Variables
		//
		//--------------------------------------------------------------------------
		//Constants
		
		//Private variables
		
		//Public variables
		
		// Constructor
		public function Cursor()
		{
			this.mouseEnabled = false;
			this.mouseChildren = false;
			doLookFor("none");
			this.addEventListener(Event.ADDED_TO_STAGE, initHandler);
		}
		
		protected function initHandler(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, initHandler);
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
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
		protected function onMouseMoveHandler(event:MouseEvent):void
		{
			x = MainConstants.screenManager.view.mouseX;
			y = MainConstants.screenManager.view.mouseY;
		}
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		public function doLookFor(look:String):void
		{
			/*if(look != "none") Mouse.hide();
			else Mouse.show();
			*/
			gotoAndStop("none");
		}
		//--------------------------------------------------------------------------
		//
		//  Logs
		//
		//--------------------------------------------------------------------------
		
		
	}
}