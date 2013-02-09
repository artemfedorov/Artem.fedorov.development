package superClasses
{
	import flash.display.MovieClip;
	
	/**
	 * @Casino game base core
	 * @author - Artem Fedorov aka Timer
	 * @version - 
	 * 
	 * @langversion - ActionScript 3.0
	 * @playerversion - FlashPlayer 10.2
	 */
	
	
	
	
	public class UnitVO
	{
		//--------------------------------------------------------------------------
		//
		//  Constants and Variables
		//
		//--------------------------------------------------------------------------
		//Constants
		
		//Private variables		
		private var _myName:String;
		
		private var _type:String;
		private var _state:String;
		private var _life:int = 100;
		private var _accuracy:int;
		private var _selfTreat:int;
		
		private var _FOV:int;
		private var _rapidity:int;
		private var _armor:int;
		
		private var _price:int;
		
		private var _x:int;
		private var _y:int;
		private var _rotation:int;
		
		private var _damage:int; 
		
		//Public variables
		public var skin:MovieClip;
		
		public var battles:int;
		public var murder:int;

		// Constructor
		public function UnitVO(t:String)
		{
			type = t;
			init(type);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters&setters
		//
		//--------------------------------------------------------------------------

		public function get selfTreat():int
		{
			return _selfTreat;
		}

		public function set selfTreat(value:int):void
		{
			_selfTreat = value;
		}

		public function get myName():String
		{
			return _myName;
		}

		public function set myName(value:String):void
		{
			_myName = value;
		}

		public function get damage():int
		{
			return _damage;
		}

		public function set damage(value:int):void
		{
			_damage = value;
		}

		public function get price():int
		{
			return _price;
		}

		public function set price(value:int):void
		{
			_price = value;
		}

		public function get armor():int
		{
			return _armor;
		}

		public function set armor(value:int):void
		{
			_armor = value;
		}

		public function get rapidity():int
		{
			return _rapidity;
		}

		public function set rapidity(value:int):void
		{
			_rapidity = value;
		}

		public function get FOV():int
		{
			return _FOV;
		}

		public function set FOV(value:int):void
		{
			_FOV = value;
		}

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
		
		public function get accuracy():int
		{
			return _accuracy;
		}
		
		public function set accuracy(value:int):void
		{
			_accuracy = value;
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
		private function init(t:String):void
		{
			accuracy =  int(Math.random() * UnitsSetting.BASE_HP / 4);
			rapidity =  int(Math.random() * UnitsSetting.BASE_HP / 4);
			damage = 	int(Math.random() * UnitsSetting.BASE_HP / 4);
			selfTreat = int(Math.random() * UnitsSetting.BASE_HP / 4);
			armor = UnitsSetting.BASE_HP - (accuracy + rapidity + damage + selfTreat);
			FOV = 110;
		}
		//--------------------------------------------------------------------------
		//
		//  Logs
		//
		//--------------------------------------------------------------------------
		
		
		

	}
}