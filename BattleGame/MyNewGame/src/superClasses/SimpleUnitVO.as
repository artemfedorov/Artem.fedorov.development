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
	
	
	
	
	public class SimpleUnitVO
	{
		//--------------------------------------------------------------------------
		//
		//  Constants and Variables
		//
		//--------------------------------------------------------------------------
		//Constants
		
		//Private variables
		private var _type:String;
		private var _state:String;
		private var _life:int;
		private var _weapon:String;
		
		private var _x:int;
		private var _y:int;
		private var _rotation:int;
		
		//Public variables
		
		// Constructor
		public function SimpleUnitVO()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters&setters
		//
		//--------------------------------------------------------------------------
		public function get rotation():int
		{
			return _rotation;
		}
		
		public function set rotation(value:int):void
		{
			_rotation = value;
		}
		
		public function get y():int
		{
			return _y;
		}
		
		public function set y(value:int):void
		{
			_y = value;
		}
		
		public function get x():int
		{
			return _x;
		}
		
		public function set x(value:int):void
		{
			_x = value;
		}
		
		public function get weapon():String
		{
			return _weapon;
		}
		
		public function set weapon(value:String):void
		{
			_weapon = value;
		}
		
		public function get life():int
		{
			return _life;
		}
		
		public function set life(value:int):void
		{
			_life = value;
		}
		
		public function get state():String
		{
			return _state;
		}
		
		public function set state(value:String):void
		{
			_state = value;
		}
		
		public function get type():String
		{
			return _type;
		}
		
		public function set type(value:String):void
		{
			_type = value;
		}
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