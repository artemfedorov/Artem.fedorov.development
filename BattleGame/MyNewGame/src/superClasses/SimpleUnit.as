package superClasses
{
	
	/**
	 * @author - Artem Fedorov aka Timer
	 * @version - 
	 * 
	 * @langversion - ActionScript 3.0
	 * @playerversion - FlashPlayer 10.2
	 */
	
	
	import Utils.Utilities;
	
	import ViewComponents.WayPoint;
	
	import factories.MainFactory;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.sampler.NewObjectSample;
	import flash.utils.Timer;
	
	import gameEvents.GameEvents;
	import gameEvents.targets.InterfaceListenerOwner;
	
	import mx.effects.Move;
	
	import singletons.MainConstants;
	
	
	
	public class SimpleUnit extends simpleBot_mc
	{
		//--------------------------------------------------------------------------
		//
		//  Constants and Variables
		//
		//--------------------------------------------------------------------------
		//Constants
		public static const GROUND_STATE:Number = 1;
		public static const DOWN_STATE:Number = 2;
		public static const STAND_STATE:Number = 4;
		public static const IDLE_STATE:Number = 0;
		public static const DOING_MINE:Number = 111;
		public static const GRANADE:Number = 222;
		
		
		
		//Private variables
		private var _selfTreat:int;
		private var _accuracy:int;
		private var _damage:int;
		private var _rapidity:int;
		private var _armor:int;
		private var _FOV:int;
		
		
		private var _angleAttack:int;
		
		private var _pathMc:Sprite;
		private var _speed:Number = STAND_STATE;
		private var _maxDistance:int = 100;
		
		private var _pathDistance:int;
		private var _life:int = 100;
		
		private var _weapon:String;
		
		private var _fireRange:int;
		private var _position:int = 1; 
		private var _lastPointX:int;
		private var _lastPointY:int;
		private var _type:String;
		private var _angle:Number;
		private var _currentVelosity:Number;
		private var _currentShelter:ShelterVO;
		private var _currentPathPointIndex:int;
		
		private var _permitToMove:Boolean = false;
		
		private var _pathAnglesList:Array = [];
		private var _checkPointList:Vector.<CheckPoint> = new Vector.<CheckPoint>;
		private var _pathStateList:Vector.<Number> = new Vector.<Number>;
		private var _pathSheltersList:Vector.<ShelterVO> = new Vector.<ShelterVO>;
		
		private var _listWayPoints:Vector.<WayPoint>;
		
		//Public variables
		public var VO:Object /*UnitVO*/;
		public var skin:bot1_mc;
		public var granadesList:Array = [];
		public var minesList:Array = [];

		protected var totalIterations:int;
		protected var currentIteration:int;
		
		
		
		
		// Constructor
		public function SimpleUnit()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters&setters
		//
		//--------------------------------- -----------------------------------------

		public function get accuracy():int
		{
			return _accuracy;
		}

		public function set accuracy(value:int):void
		{
			_accuracy = value;
		}

		public function get damage():int
		{
			return _damage;
		}

		public function set damage(value:int):void
		{
			_damage = value;
		}

		public function get selfTreat():int
		{
			return _selfTreat;
		}

		public function set selfTreat(value:int):void
		{
			_selfTreat = value;
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

		public function get checkPointList():Vector.<CheckPoint>
		{
			return _checkPointList;
		}

		public function set checkPointList(value:Vector.<CheckPoint>):void
		{
			_checkPointList = value;
		}

		public function get currentVelosity():Number
		{
			return _currentVelosity;
		}

		private var _upDifferent:Boolean;
		public function set currentVelosity(value:Number):void
		{
			if(_currentVelosity == value || !this.skin.upPart_mc) return;
			
			if(value == GRANADE)
			{
				_currentVelosity = value;
				(this.skin.getChildByName("upPart_mc") as MovieClip).gotoAndPlay("granade");
				(this.skin.getChildByName("upPart_mc") as MovieClip).rotation = _granadeAngle;
				return;
			}
			
			if(value == DOING_MINE)
			{
				if(_currentVelosity == GROUND_STATE)
				{
					if(!_upDifferent)
					(this.skin.getChildByName("upPart_mc") as MovieClip).gotoAndPlay("mine");
					(this.skin.getChildByName("downPart_mc") as MovieClip).alpha = 0;  
				}
				else
				{
					if(!_upDifferent)
					(this.skin.getChildByName("upPart_mc") as MovieClip).gotoAndPlay("groundStateToMine");
					(this.skin.getChildByName("downPart_mc") as MovieClip).alpha = 0;  
				}
				return;
			}
			
			if(value == IDLE_STATE || _currentPathPointIndex == pathSheltersList.length - 1 || pathSheltersList.length == 0)
			{
				if(_currentVelosity != GROUND_STATE && value == GROUND_STATE)
				{
					if(!_upDifferent)
					(this.skin.getChildByName("upPart_mc") as MovieClip).gotoAndPlay("groundStateToIdleGround");
					(this.skin.getChildByName("downPart_mc") as MovieClip).alpha = 0;   
				}
				else if(_currentVelosity == GROUND_STATE && (value == GROUND_STATE || value == IDLE_STATE))
				{
					if(!_upDifferent)
					(this.skin.getChildByName("upPart_mc") as MovieClip).gotoAndPlay("idleGround");
					(this.skin.getChildByName("downPart_mc") as MovieClip).alpha = 0;  
				}
				else if(_currentVelosity == GROUND_STATE && value != GROUND_STATE)
				{
					if(!_upDifferent)
					(this.skin.getChildByName("upPart_mc") as MovieClip).gotoAndPlay("groundToIdle");
					(this.skin.getChildByName("downPart_mc") as MovieClip).alpha = 0;  
				}
				else if(_currentVelosity != GROUND_STATE && value != GROUND_STATE)
				{
					var nFrame:uint = Math.random() * 90;
					if(!_upDifferent)
					(this.skin.getChildByName("upPart_mc") as MovieClip).gotoAndPlay(110 + nFrame);
					(this.skin.getChildByName("downPart_mc") as MovieClip).gotoAndPlay(82 + nFrame);
				}
				_currentVelosity = IDLE_STATE;
				
				return;
			}
			else
			{
				(this.skin.getChildByName("downPart_mc") as MovieClip).alpha = 1;
				switch(value)
				{
					case DOWN_STATE:
						if(_currentVelosity == GROUND_STATE)
						{
							if(!_upDifferent)
							(this.skin.getChildByName("upPart_mc") as MovieClip).gotoAndPlay("groundToDown");
							(this.skin.getChildByName("downPart_mc") as MovieClip).gotoAndPlay("groundToDown");
						}
						else
						{
							if(!_upDifferent)
							(this.skin.getChildByName("upPart_mc") as MovieClip).gotoAndPlay("downState");
							(this.skin.getChildByName("downPart_mc") as MovieClip).gotoAndPlay("downState");
						}
						break;
					
					case STAND_STATE:
						if(_currentVelosity == GROUND_STATE)
						{
							if(!_upDifferent)
							(this.skin.getChildByName("upPart_mc") as MovieClip).gotoAndPlay("groundToStand");
							(this.skin.getChildByName("downPart_mc") as MovieClip).gotoAndPlay("groundToStand");
						}
						else
						{
							if(!_upDifferent)
							(this.skin.getChildByName("upPart_mc") as MovieClip).gotoAndPlay("standState");
							(this.skin.getChildByName("downPart_mc") as MovieClip).gotoAndPlay("standState");
						}
						break;
					
					case GROUND_STATE:
						(this.skin.getChildByName("downPart_mc") as MovieClip).alpha = 0;   
						if(!_upDifferent)
						(this.skin.getChildByName("upPart_mc") as MovieClip).gotoAndPlay("groundState");
						(this.skin.getChildByName("downPart_mc") as MovieClip).stop();
						break;
				}
			}
			
			_currentVelosity = value;
		}

		public function get pathStateList():Vector.<Number>
		{
			return _pathStateList;
		}

		public function set pathStateList(value:Vector.<Number>):void
		{
			_pathStateList = value;
		}

		public function get pathAnglesList():Array
		{
			return _pathAnglesList;
		}

		public function set pathAnglesList(value:Array):void
		{
			_pathAnglesList = value;
		}

		public function get angleAttack():int
		{
			return _angleAttack;
		}

		public function set angleAttack(value:int):void
		{
			_angleAttack = value;
		}

		public function get position():int
		{
			return _position;
		}

		public function set position(value:int):void
		{
			_position = value;
		}

		public function get speed():Number
		{
			return _speed;
		}

		public function set speed(value:Number):void
		{
			_speed = value;
		}

		public function get permitToMove():Boolean
		{
			return _permitToMove;
		}

		public function set permitToMove(value:Boolean):void
		{
			if(_permitToMove == value) return;
			_permitToMove = value;
			if(!value) (skin.diff_mc.getChildByName("onFinishMove_mc") as MovieClip).play();
		}

		public function get currentPathPointIndex():int
		{
			return _currentPathPointIndex;
		}

		public function set currentPathPointIndex(value:int):void
		{
			_currentPathPointIndex = value;
		}

		public function get nextShelter():ShelterVO
		{
			return _currentShelter;
		}

		public function set nextShelter(value:ShelterVO):void
		{
			_currentShelter = value;
		}

		public function get angle():Number
		{
			return _angle;
		}

		public function set angle(value:Number):void
		{
			_angle = value;
		}

		public function get pathMc():Sprite
		{
			return _pathMc;
		}

		public function set pathMc(value:Sprite):void
		{
			_pathMc = value;
		}

		public function get pathSheltersList():Vector.<ShelterVO>
		{
			return _pathSheltersList;
		}

		public function set pathSheltersList(value:Vector.<ShelterVO>):void
		{
			_pathSheltersList = value;
		}

		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
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
			if(_life <= 0) 
			{
				die();
				trace("My life ", _life);
				MainConstants.game.checkOutcome();
			}
		}
		//--------------------------------------------------------------------------
		//
		//  Events handlers
		//
		//--------------------------------------------------------------------------
		
		
		protected function onMouseMoveHandler(event:MouseEvent):void
		{
			if(Utilities.distanceBetweenTwoPoints(_lastPointX, _lastPointY, MainConstants.currentLevel.mouseX, MainConstants.currentLevel.mouseY) + 
				pathDistance()  > _maxDistance) return;
			(parent as MovieClip).graphics.clear();
			MainConstants.currentLevel.graphics.beginFill(0x00FF00, 1);
			MainConstants.currentLevel.graphics.moveTo(_lastPointX, _lastPointY);
			MainConstants.currentLevel.graphics.lineStyle(2,0xFFFF00);
			MainConstants.currentLevel.graphics.lineTo(MainConstants.currentLevel.mouseX, MainConstants.currentLevel.mouseY);
			MainConstants.currentLevel.graphics.drawCircle(MainConstants.currentLevel.mouseX, MainConstants.currentLevel.mouseY, 5);
		}
		
		
		public function onPlayBattleHandler():void
		{
			totalIterations = Utilities.distanceBetweenTwoPoints(pathSheltersList[0].x, pathSheltersList[0].y, pathSheltersList[1].x, pathSheltersList[1].y) / currentVelosity;
			currentIteration = 0;
		}
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		public function showPath(vec:Vector.<ShelterVO>):void
		{
			if(vec.length < 2) return
			pathMc.graphics.beginFill(0x00FF00, 1);
			pathMc.graphics.clear();
			for(var i:int = 0; i < vec.length - 1; i++)
			{
				pathMc.graphics.moveTo(vec[i].x, vec[i].y);
				pathMc.graphics.lineStyle(12,0xFFFF00, 0.1);
				pathMc.graphics.lineTo(vec[i + 1].x, vec[i + 1].y);
			}
		}
		
		
		public function init($vo:Object = null):void
		{
			if($vo)
			{
				VO = $vo;
				accuracy = $vo.accuracy;
				selfTreat = $vo.selfTreat;
				rapidity = $vo.rapidity;
				armor = $vo.armor;
				FOV = $vo.FOV;
				damage = $vo.damage;
			}
			life += armor;
			pathMc = new Sprite();
			MainConstants.currentLevel.enemyLayer_mc.addChild(pathMc);
		}
		
		
		protected function addPathStatesToList(s:Number):void
		{
			pathStateList.push(s);
		}
		
		public function addPathPointToList(p:ShelterVO):void
		{
			pathSheltersList.push(p);
		}
		
		public function addPathAngleToList(a:int):void
		{
			pathAnglesList.push(a);
		}
		
		
		/*Обнулить данные для следующего хода*/
		protected function reset():void
		{
			granadesList.length = 0;
			minesList.length = 0;
			pathAnglesList.length = 0; 
			pathSheltersList.length = 0;
			pathStateList.length = 0;
		}
		
		
		public function setAngleAttack(dx:int, dy:int):int
		{
			angleAttack = Utilities.radiansToDegrees(Utilities.rotateTowards(this.x, this.y, dx, dy) + Math.PI);
			return angleAttack;
		}
		
		public function isInFOV(ang:int):Boolean
		{
			return (ang > angleAttack - FOV && ang < angleAttack + FOV) ? true : false;
		}
		
		protected function pathDistance():int
		{
			var d:int;
			for(var i:int = 0; i < _listWayPoints.length - 1; i++)
			{
				d += Utilities.distanceBetweenTwoPoints(_listWayPoints[i].x, _listWayPoints[i].y, _listWayPoints[i + 1].x, _listWayPoints[i + 1].y);
			}
			return d;
		}
		
		/*Находится ли юнит на заданной дистанции от заданной точки*/		
		protected function isGotPoint(dx:int, dy:int, dist:Number):Boolean
		{
			var d:Number = Utilities.distanceBetweenTwoPoints(x, y, dx, dy);
			if(d <= dist) return true;
			return false;
		}
		
		
		protected var currentEnemy:SimpleUnit;
		public var iAmInOurArmy:Boolean;
		
		protected function strike():void
		{
				var mcTarget:Sprite = (currentEnemy as MovieClip);
				var ang:Number = Utilities.radiansToDegrees(Utilities.rotateTowards(mcTarget.x, mcTarget.y, this.x, this.y));
				(this.skin.getChildByName("upPart_mc") as MovieClip).rotation = ang;

			if(iAmInOurArmy) 
				var b:SimpleBullet =  new SimpleBullet(currentEnemy, this.x, this.y, MainConstants.game.listEnemyArmy, currentVelosity);
			else b = new SimpleBullet(currentEnemy, this.x, this.y, MainConstants.game.listOurArmy, currentVelosity);
				b.maxDistance = (VO.accuracy * 3) + 300;
				b.owner = this;
		}
		
		
		public function endOfMove():void
		{			
			permitToMove = false;
			currentVelosity = IDLE_STATE;
		}
		
		
		public function setDamage(value:int, owner:SimpleUnit):void
		{
			var koof:uint;
			if(currentVelosity == IDLE_STATE || currentVelosity == STAND_STATE) koof = 2;
			if(currentVelosity == DOING_MINE) koof = 2;
			if(currentVelosity == DOWN_STATE || currentVelosity == GROUND_STATE) koof = 1;
			value *= koof;
			//life -= (value - (value / 100 * armor));
			life -= value;
			this.life_tf.text = String(life); 
			if(owner is PlayerUnit) 
			{
				owner.VO.murder++;
				if(life <= 0) owner.VO.murder += 10;
			}
		}
		
		
		
		public function setAction($action:String):void
		{
			switch($action)
			{
				case "murderByBullet":
					giveMeAchivement(AchivementsConstants.FIRST_MURDER);
					break;
				
				case "murderByBoom":
					giveMeAchivement(AchivementsConstants.EXPLODER);
					break;
				
				case "murderByMine":
					giveMeAchivement(AchivementsConstants.MINER);
					break;
			}
		}
		
		private function giveMeAchivement($achivement:String):void
		{
			var o:Object = MainConstants.serializationManager.serialData;
			if(o.achievements.indexOf($achivement) == -1)
				o.achievements.push($achivement);
		}
		
		public function settingAngles(vecShelters:Vector.<ShelterVO>):Array
		{ 
			var angle:Number;
			var resVec:Array = [];
			
			for(var i:int = 1; i < vecShelters.length; i++)
			{
				angle = Utilities.radiansToDegrees(Utilities.rotateTowards(vecShelters[i].x, vecShelters[i].y, vecShelters[i - 1].x, vecShelters[i - 1].y));
				resVec.push(angle);
				if(i == vecShelters.length - 1) resVec.push(angle);
			}
			return resVec;
		}
		
		
		
		private var stateAfterMine:int;
		protected function move():void
		{
			if(currentIteration >= totalIterations) 
			{
				if(granadesList[currentPathPointIndex]) 
				{
					useGranade(granadesList[currentPathPointIndex]);
					granadesList[currentPathPointIndex] = null;
					stateAfterMine = pathStateList[currentPathPointIndex];
				}
				
				if(minesList[currentPathPointIndex]) 
				{
					setMine();
					minesList[currentPathPointIndex] = false;
					currentPathPointIndex--;
					stateAfterMine = pathStateList[currentPathPointIndex];
				}
				else currentVelosity = pathStateList[currentPathPointIndex];
				
				trace(currentVelosity);
				
				angleAttack = pathAnglesList[currentPathPointIndex];
				
				if(!_upDifferent) (this.skin.getChildByName("upPart_mc") as MovieClip).rotation = angleAttack;
				
				 
				(this.skin.getChildByName("downPart_mc") as MovieClip).rotation = angleAttack;
				
				
				if(_currentPathPointIndex == pathSheltersList.length - 1) 
				{
					endOfMove();
					return;
				}
				
				nextShelter = pathSheltersList[++currentPathPointIndex];
				
				totalIterations = Utilities.distanceBetweenTwoPoints(x, y, pathSheltersList[currentPathPointIndex].x, pathSheltersList[currentPathPointIndex].y) / currentVelosity;

				angle = Utilities.rotateTowards(pathSheltersList[currentPathPointIndex].x, pathSheltersList[currentPathPointIndex].y, x, y);
				
				currentIteration = 0;
			}
			
			currentIteration++;
			
			this.x += currentVelosity * Math.cos(angle);
			this.y += currentVelosity * Math.sin(angle);
			
		}
		
		
		
		
		
		
		
		protected function isUniqueShelter(s:ShelterVO, inVec:Vector.<ShelterVO>):Boolean
		{
			return (inVec.indexOf(s) > -1) ? false : true;
		}
		
		
		
		protected function yesOrNo(v:int):Boolean
		{
			var r:int = Math.random() * 100;
			return (r < v) ? true : false;	
		}
		
		public function die():void
		{
			this.skin.rotation = this.skin.getChildByName("downPart_mc").rotation;
			this.skin.gotoAndPlay("dead");
			hidePath();
			InterfaceListenerOwner.Owner.dispatchEvent(new GameEvents(GameEvents.ON_DESTROY_UNIT, this));
		}

		
		public function hidePath():void
		{
			pathMc.graphics.clear();
			for (var i:uint = 0; i < checkPointList.length; i++)
			{
					checkPointList[i].destroy();
					checkPointList[i].parent.removeChild(checkPointList[i]);
					checkPointList[i] = null;
			}
			checkPointList.length = 0;
		}
		
		
		public function destroy():void 	{}
		
		
		
		public function isVisibleNew(myx:Number, myy:Number, dx:Number, dy:Number):Boolean
		{
			for(var i:uint = 0; i < MainConstants.game.constructionsList.length; i++)
			{
				var p1x:Number = MainConstants.game.constructionsList[i].x1;
				var p1y:Number = MainConstants.game.constructionsList[i].y1;
				
				var p2x:Number = MainConstants.game.constructionsList[i].x2;
				var p2y:Number = MainConstants.game.constructionsList[i].y2;
				
				var p3x:Number = MainConstants.game.constructionsList[i].x3;
				var p3y:Number = MainConstants.game.constructionsList[i].y3;
				
				var p4x:Number = MainConstants.game.constructionsList[i].x4;
				var p4y:Number = MainConstants.game.constructionsList[i].y4;
				
				if(Utilities.lineIntersectLine(new Point(myx, myy), new Point(dx, dy), new Point(p1x, p1y), new Point(p2x, p2y)) ||
				   Utilities.lineIntersectLine(new Point(myx, myy), new Point(dx, dy), new Point(p2x, p2y), new Point(p3x, p3y)) ||
				   Utilities.lineIntersectLine(new Point(myx, myy), new Point(dx, dy), new Point(p3x, p3y), new Point(p4x, p4y)) ||
				   Utilities.lineIntersectLine(new Point(myx, myy), new Point(dx, dy), new Point(p4x, p4y), new Point(p1x, p1y))) 
				return false;
			}

		
		return true;
		}
		
		
		public function isVisible(myx:Number, myy:Number, dx:Number, dy:Number):Boolean
		{
			var ang:Number = Utilities.rotateTowards(myx, myy, dx, dy);
		
			var mx:int = myx + Math.cos(ang - Math.PI / 2) * 10;
			var my:int = myy + Math.sin(ang - Math.PI / 2) * 10;
			var leftPoint1:Point = new Point(mx, my);
			
			mx = myx + Math.cos(ang + Math.PI / 2) * 10;
			my = myy + Math.sin(ang + Math.PI / 2) * 10;
			var rightPoint1:Point = new Point(mx, my);
			
			mx = dx + Math.cos(ang - Math.PI / 2) * 10;
			my = dy + Math.sin(ang - Math.PI / 2 ) * 10;
			var leftPoint2:Point = new Point(mx, my);
			
			mx = dx + Math.cos(ang + Math.PI / 2) * 10;
			my = dy + Math.sin(ang + Math.PI / 2) * 10;
			var rightPoint2:Point = new Point(mx, my);
			
			
			/*(MainConstants.currentLevel.enemyLayer_mc as Sprite).graphics.clear();
			
			(MainConstants.currentLevel.enemyLayer_mc as Sprite).graphics.beginFill(0x00FF00, 1);
			(MainConstants.currentLevel.enemyLayer_mc as Sprite).graphics.lineStyle(2,0xFFFFFF , 1);
			(MainConstants.currentLevel.enemyLayer_mc as Sprite).graphics.moveTo(leftPoint1.x, leftPoint1.y);
			(MainConstants.currentLevel.enemyLayer_mc as Sprite).graphics.lineTo(leftPoint2.x, leftPoint2.y);
			
			(MainConstants.currentLevel.enemyLayer_mc as Sprite).graphics.moveTo(rightPoint1.x, rightPoint1.y);
			(MainConstants.currentLevel.enemyLayer_mc as Sprite).graphics.lineTo(rightPoint2.x, rightPoint2.y);*/
			
			if(isVisibleNew(leftPoint1.x, leftPoint1.y, leftPoint2.x, leftPoint2.y) &&
				isVisibleNew(rightPoint1.x, rightPoint1.y, rightPoint2.x, rightPoint2.y)) return true;
			
			return false;
			
		}
		
		/*Видна ли точка?*/
		public function isVisible2(myx:int, myy:int, dx:int, dy:int):Boolean
		{
			var testPoint:Point = new Point();
			var step:int = 1;
			var angle:Number = Utilities.rotateTowards(myx, myy, dx, dy) + Math.PI;
			
			var angle1:Number = Utilities.radiansToDegrees(angle);
			
			
			var d:Number = Utilities.distanceBetweenTwoPoints(myx, myy, dx, dy);
			var iterations:int = d / 5;
			var cosAngle:Number = Math.cos(angle);
			var sinAngle:Number = Math.sin(angle);
			for(var i:int = 0; i < iterations; i++)
			{
				testPoint.x = myx + (i * 5) * cosAngle;
				testPoint.y = myy + (i * 5) * sinAngle;
				
				for(var j:uint = 0; j < MainConstants.game.constructionsList.length; j++)
				{
					if(MainConstants.game.constructionsList[j].skin.hitTestPoint(testPoint.x, testPoint.y, true)) return false;
				}
			}
			return true;
		}
		
		private var oo:Object;
		private var _waitingTimer:Timer;
		public function useGranade($o:Object):void
		{
			oo = $o;
			_granadeAngle = Utilities.radiansToDegrees(Utilities.rotateTowards(oo.x, oo.y, x, y));
			/*if(this is EnemyUnit && currentEnemy) */currentVelosity = GRANADE;
			_waitingTimer = new Timer(500, 1);
			_waitingTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onUsingGranadeCompleteHandler);
			_waitingTimer.start();
			_upDifferent = true;
			
		}
		
		private var _granadeAngle:Number;
		protected function onUsingGranadeCompleteHandler(event:TimerEvent):void
		{
			if(_waitingTimer)
			{
				_waitingTimer.stop();
				_waitingTimer = null;
			}


			if(this is PlayerUnit) 
			{
				var granade:Granade = new Granade();
				MainConstants.currentLevel.addChild(granade);
				granade.unitOwner = this;
				granade.x = this.x;
				granade.y = this.y;
				granade.flyTo(oo.x, oo.y);
			}
			else if(this is EnemyUnit) 
			{
				if(currentEnemy)
				{
					oo.x = (currentEnemy as MovieClip).x;
					oo.y = (currentEnemy as MovieClip).y;
				}
					granade = new Granade();
					MainConstants.currentLevel.addChild(granade);
					granade.x = this.x;
					granade.y = this.y;
					_granadeAngle = Utilities.radiansToDegrees(Utilities.rotateTowards(oo.x, oo.y, x, y));
					granade.owner = false;
					granade.flyTo(oo.x, oo.y);
				
			}
			trace("Бросил гранату!");
			
			_upDifferent = false;
			if(this.skin.getChildByName("upPart_mc"))
			(this.skin.getChildByName("upPart_mc") as MovieClip).rotation = angleAttack;
			if (pathSheltersList.length > 0) permitToMove = true;
			currentVelosity = stateAfterMine;
		}
		
		public function setMine():void
		{
			permitToMove = false;
			currentVelosity = DOING_MINE;
			var waitingTimer:Timer = new Timer(2000, 1);
			waitingTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onDoingMineCompleteHandler);
			waitingTimer.start();
			
		}
		
		protected function onDoingMineCompleteHandler(event:TimerEvent):void
		{
			 if (pathSheltersList.length > 0) permitToMove = true;
			var mine:Mine = new Mine();
			MainConstants.currentLevel.addChild(mine);
			mine.x = this.x; mine.y = this.y; 
			mine.owner = this;
			MainConstants.game.listMines.push(mine);
			currentVelosity = stateAfterMine;
		}		
		
		
		protected function serialization():Object
		{
			var vo:Object = new UnitVO(type);
			vo.life = life;
			vo.rotation = this.rotation;
			vo.x = this.x;
			vo.y = this.y;
			vo.weapon = weapon;
			return vo;
		}
		//--------------------------------------------------------------------------
		//
		//  Logs
		//
		//--------------------------------------------------------------------------
	}
}