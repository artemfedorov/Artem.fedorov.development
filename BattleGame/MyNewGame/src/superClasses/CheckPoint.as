package superClasses
{
	import Utils.Utilities;
	
	import flash.display.GradientType;
	import flash.display.MovieClip;
	import flash.display.SpreadMethod;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.net.SharedObject;
	import flash.utils.Timer;
	
	import mx.messaging.AbstractConsumer;
	
	import singletons.MainConstants;
	
	/**
	 * @author - Artem Fedorov aka Timer
	 * @version - 
	 * 
	 * @langversion - ActionScript 3.0
	 * @playerversion - FlashPlayer 10.2
	 */
	
	
	
	
	public class CheckPoint extends checkPoint_mc
	{
		//--------------------------------------------------------------------------
		//
		//  Constants and Variables
		//
		//--------------------------------------------------------------------------
		//Constants
		
		//Private variables
		private var _moveMode:Boolean = false;
		
		private var _fovMc:MovieClip;
		private var _menuState:MovieClip;
		
		
		private var _oldX:Number;
		private var _oldY:Number;
		private var _shelterLink:ShelterVO;
		private var _player:PlayerUnit;
		private var _menuStateTimer:Timer;
		//Public variables
		
		// Constructor
		public function CheckPoint(s:ShelterVO, p:PlayerUnit)
		{
			_player = p;
			_shelterLink = s;
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
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

		public function get fovMc():MovieClip
		{
			return _fovMc;
		}

		public function set fovMc(value:MovieClip):void
		{
			_fovMc = value;
		}

		protected function onMouseDownHandler(event:MouseEvent):void
		{ 
			if(!MainConstants.game.permitToEdit || _menuState) return;
			_menuStateTimer = new Timer(800, 1);
			_menuStateTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerHandler);
			_menuStateTimer.start();
			
			_moveMode = true;
			this.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			
			_oldX = x;
			_oldY = y;
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
		}
		
		protected function onTimerHandler(event:TimerEvent):void
		{
			if(!_menuStateTimer) return;
				
			else
			{
				_menuStateTimer.reset();
				_menuStateTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerHandler);
				_menuStateTimer = null;
			}
			
			_player.parent.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
			_moveMode = false;	
			showMenuState();
		}
		
		protected function onMouseMoveHandler(event:MouseEvent):void
		{
			if(_menuStateTimer)
			{
				_menuStateTimer.reset();
				_menuStateTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerHandler);
				_menuStateTimer = null;
			}
			
			this.x = _player.parent.x + _player.parent.mouseX;
			this.y = _player.parent.y + _player.parent.mouseY;
			_shelterLink.x = x;
			_shelterLink.y = y;
			_player.showPath(_player.pathSheltersList);
			
			if(_shelterLink.index == 1)
			{
				var defaultAngle:Number = Utilities.radiansToDegrees(Utilities.rotateTowards(_shelterLink.x, _shelterLink.y, _player.pathSheltersList[_shelterLink.index - 1].x, 
					_player.pathSheltersList[_shelterLink.index - 1].y));
				_player.pathAnglesList[_shelterLink.index - 1] = defaultAngle;
				(_player.skin.getChildByName("upPart_mc") as MovieClip).rotation = defaultAngle;
			}
		}
		
		protected function onMouseUpHandler(event:MouseEvent):void
		{
			if(_menuStateTimer)
			{
				_menuStateTimer.reset();
				_menuStateTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerHandler);
				_menuStateTimer = null;
			}
			
			_moveMode = false;
			
			if(_shelterLink.index < _player.pathSheltersList.length - 1) 
			{
				if(!_player.isVisible(_shelterLink.x, _shelterLink.y, _player.pathSheltersList[_shelterLink.index - 1].x, _player.pathSheltersList[_shelterLink.index - 1].y) ||
				   !_player.isVisible(_shelterLink.x, _shelterLink.y, _player.pathSheltersList[_shelterLink.index + 1].x, _player.pathSheltersList[_shelterLink.index + 1].y))
				{
					this.x = _oldX;
					this.y = _oldY;
					_shelterLink.x = _oldX;
					_shelterLink.y = _oldY;
					_player.showPath(_player.pathSheltersList);
					
					var defaultAngle:Number = Utilities.radiansToDegrees(Utilities.rotateTowards(_shelterLink.x, _shelterLink.y, _player.pathSheltersList[_shelterLink.index - 1].x, 
						_player.pathSheltersList[_shelterLink.index - 1].y));
					_player.pathAnglesList[_shelterLink.index - 1] = defaultAngle;
					(_player.skin.getChildByName("upPart_mc") as MovieClip).rotation = defaultAngle;
				}
			}
			else 
				if(!_player.isVisible(_shelterLink.x, _shelterLink.y, _player.pathSheltersList[_shelterLink.index - 1].x, _player.pathSheltersList[_shelterLink.index - 1].y))
				{
					this.x = _oldX;
					this.y = _oldY;
					_shelterLink.x = _oldX;
					_shelterLink.y = _oldY;
					_player.showPath(_player.pathSheltersList);
					
						defaultAngle = Utilities.radiansToDegrees(Utilities.rotateTowards(_shelterLink.x, _shelterLink.y, _player.pathSheltersList[_shelterLink.index - 1].x, 
						_player.pathSheltersList[_shelterLink.index - 1].y));
					_player.pathAnglesList[_shelterLink.index - 1] = defaultAngle;
					(_player.skin.getChildByName("upPart_mc") as MovieClip).rotation = defaultAngle;
				}
			
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			
			
		}
		
		/*protected function onMenuStateMouseDownHandler(event:MouseEvent):void
		{
			switch (event.target.name)
			{
				case "standState_btn":
					this.gotoAndStop("standState");
					setState(SimpleUnit.STAND_STATE);
					hideMenuState();
					break;
				
				case "downState_btn":
					this.gotoAndStop("downState");
					setState(SimpleUnit.DOWN_STATE);
					hideMenuState();
					break;
				
				case "groundState_btn":
					this.gotoAndStop("groundState");
					setState(SimpleUnit.GROUND_STATE);
					hideMenuState();
					break;
				
				case "changeAngle_btn":
					_fovMc = new MovieClip();
					MainConstants.currentLevel.addChild(_fovMc);
					showFOV();
					
			}
		}*/
		
		
		protected function onFinishChangeAngleHandler(event:MouseEvent):void
		{
			hideFOV();
			//hideMenuState();
			//showMenuState();
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, onFinishChangeAngleHandler);
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onChangeAngleHandler);
		}
		
		public function onStartChangeAngleHandler(event:MouseEvent):void
		{
			this.stage.addEventListener(MouseEvent.MOUSE_UP, onFinishChangeAngleHandler);
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, onChangeAngleHandler);
		}	
		
		protected function onChangeAngleHandler(event:MouseEvent):void
		{
			this.rotation = Utilities.radiansToDegrees(Utilities.rotateTowards(x, y, MainConstants.currentLevel.mouseX, MainConstants.currentLevel.mouseY) + Math.PI);
			setAngle(this.rotation);
			showFOV();
		}
		
		public function setAngle(angle:Number):void
		{ 
			_player.pathAnglesList[_shelterLink.index] = angle;
		}
		
		public function setState(state:Number):void
		{
			_player.pathStateList[_shelterLink.index] = state;
		}
		
		
		public function initMine():void
		{
			var ser:Object = MainConstants.serializationManager.serialData;
			
			if(_player.minesList[_shelterLink.index])
			{
				_player.minesList[_shelterLink.index] = false;
				ser.minesCount++;
				MainConstants.serializationManager.save();
			}
			else  
			{
				if(ser.minesCount > 0) 
				{
					_player.minesList[_shelterLink.index] = true;
					ser.minesCount--;
					MainConstants.serializationManager.save();
				}
				
			}
		}
		
		public function initGranade():void
		{
			var ser:Object = MainConstants.serializationManager.serialData;
			
			if(_player.granadesList[_shelterLink.index])
			{
				_player.granadesList[_shelterLink.index] = null;
				ser.granadeCount++;
				MainConstants.serializationManager.save();
			}
			else  
			{
				if(ser.granadeCount > 0) 
				{
					MainConstants.game.setGranade = true;
					ser.granadeCount--;
					MainConstants.serializationManager.save();
				}
				
			}
		}
		
		public function setCoordinatesForGranade(o:Object):void
		{
			_player.granadesList[_shelterLink.index] = o;
		}
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		public function hideFOV():void
		{
			_fovMc.removeEventListener(MouseEvent.MOUSE_DOWN, onStartChangeAngleHandler);
			_fovMc.graphics.clear();
			MainConstants.currentLevel.removeChild(_fovMc);
			_fovMc = null;
		}
		
		
		public function showFOV():void
		{
			_fovMc.graphics.clear();
			_fovMc.graphics.lineStyle(1, 0xFF0000, 0);
			
			var firstPoint:Point = new Point(); 
			
			firstPoint.x = x + 800 * Math.cos(Utilities.degreesToRadians(this.rotation - 60));
			firstPoint.y = y + 800 * Math.sin(Utilities.degreesToRadians(this.rotation - 60));
			
			var secondPoint:Point = new Point(); 
			_fovMc.graphics.moveTo(x,y);
			secondPoint.x = x + 800 * Math.cos(Utilities.degreesToRadians(this.rotation + 60));
			secondPoint.y = y + 800 * Math.sin(Utilities.degreesToRadians(this.rotation + 60));
			
			var vertices:Vector.<Number> = new Vector.<Number>;
			vertices.push(x, y, firstPoint.x, firstPoint.y, secondPoint.x, secondPoint.y);
			
			var fillType:String = GradientType.LINEAR;
			var colors:Array = [0xFF0000, 0x0000FF];
			var alphas:Array = [0, .5];
			var ratios:Array = [0, 0xFF];
			var matr:Matrix = new Matrix();
			matr.createGradientBox(x + 200, y + 200, Utilities.degreesToRadians(this.rotation + 180), 10, 10);
			var spreadMethod:String = SpreadMethod.PAD;
			_fovMc.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);
			
			_fovMc.graphics.drawTriangles(vertices);
		}
		
		
		private function showMenuState():void
		{
			_menuState = new changeState_mc();
			if(MainConstants.serializationManager.serialData.minesCount > 0 || _player.minesList[_shelterLink.index])
				_menuState.useMine_btn.gotoAndStop("show");
			else _menuState.useMine_btn.gotoAndStop("hide");
			if(MainConstants.serializationManager.serialData.granadeCount > 0 || _player.granadesList[_shelterLink.index])
				_menuState.useGranade_btn.gotoAndStop("show");
			else _menuState.useGranade_btn.gotoAndStop("hide");
			_menuState.mouseEnabled = false;
			MainConstants.currentLevel.addChild(_menuState);
			_menuState.x = this.x;
			_menuState.y = this.y - 30;
			
			if(MainConstants.game.currentEditCheckPoint && MainConstants.game.currentEditCheckPoint != this) 
				MainConstants.game.currentEditCheckPoint.hideMenuState();
			MainConstants.game.currentEditCheckPoint = this;
		}
		
		
		public function hideMenuState():void
		{
			if(!_fovMc && MainConstants.game.currentEditCheckPoint == this) MainConstants.game.currentEditCheckPoint = null;
			if(!_menuState) return;
			_menuState.parent.removeChild(_menuState);
			_menuState = null;
		}
		
		public function destroy():void
		{
			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
		}
		//--------------------------------------------------------------------------
		//
		//  Logs
		//
		//--------------------------------------------------------------------------
		
		
	}
}