package factories
{
	
	import ViewComponents.WayPoint;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Stage;
	
	import singletons.MainConstants;
	
	import superClasses.EnemyUnit;
	import superClasses.IUnit;
	import superClasses.PlayerUnit;
	import superClasses.SimpleUnit;
	import superClasses.UnitVO;
	import superClasses.UnitsSetting;

	
	/**
	 * @author - Artem Fedorov aka Timer
	 * @version - 
	 * 
	 * @langversion - ActionScript 3.0
	 * @playerversion - FlashPlayer 10.2
	 */
	
	
	
	
	public class MainFactory
	{
		//--------------------------------------------------------------------------
		//
		//  Constants and Variables
		//
		//--------------------------------------------------------------------------
		//Constants
		
		//Private variables
		
		//Public variables
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		
		public static function createScreens(contaner:DisplayObjectContainer):MovieClip
		{
			var mc:MovieClip = new screens_mc();
			contaner.addChild(mc);
			return mc;
		}
		
		public static function createPopUp(type:String, contaner:DisplayObjectContainer, dx:Number = 0, dy:Number = 0):MovieClip
		{
			var mc:MovieClip = new popup_mc();
			contaner.addChild(mc);
			mc.gotoAndStop(type);
			mc.x = dx;
			mc.y = dy;
			return mc;
		}
		
		public static function createStatisticWindow(contaner:DisplayObjectContainer, dx:Number = 0, dy:Number = 0):MovieClip
		{
			var mc:MovieClip = new statistic_mc();
			contaner.addChild(mc);
			mc.x = dx;
			mc.y = dy;
			return mc;
		}
		
		
		
		/*public static function createLevelInfoWindow(contaner:MovieClip, dx:Number = 0, dy:Number = 0):MovieClip
		{
			var mc:MovieClip = new levelStat_mc();
			contaner.addChild(mc);
			mc.x = dx;
			mc.y = dy;
			return mc;
		}*/
		
		/*public static function createWeaponInfoWindow(contaner:MovieClip, dx:Number = 0, dy:Number = 0):MovieClip
		{
			var mc:MovieClip = new weaponInfo_mc();
			contaner.addChild(mc);
			mc.x = dx;
			mc.y = dy;
			return mc;
		}*/
		
		/*public static function createNotEnoughMoneyWindow(contaner:MovieClip, dx:Number = 0, dy:Number = 0):MovieClip
		{
			var mc:MovieClip = new notEnoughMoney_mc();
			contaner.addChild(mc);
			mc.x = dx;
			mc.y = dy;
			return mc;
		}
		
		public static function createBullet(contaner:MovieClip, dx:Number, dy:Number):BulletSimple 
		{
			var bullet:BulletSimple;
			bullet = new BulletSimple(contaner, dx * PhysiVals.RATIO, dy * PhysiVals.RATIO);
			contaner.addChild(bullet);
			return bullet;
		}*/
		
		public static function createLevel(contaner:DisplayObjectContainer, num:int, dx:Number = 0, dy:Number = 0):MovieClip
		{
			var stageLink:Stage = contaner.stage;
			var lev:Class = stageLink.loaderInfo.applicationDomain.getDefinition("level_0"+num+"_mc") as Class;
			var mc:MovieClip = new lev();
			contaner.addChild(mc);
			mc.x = dx;
			mc.y = dy;
			return mc;   
		}
		
		
		
		public static function createEnemyUnit(type:String, dx:int, dy:int, rot:int):SimpleUnit
		{
			var unit:SimpleUnit = new PlayerUnit();
			unit = new EnemyUnit();
					
			if(type.substr(0, 10) != "airSupport")
			{
				
				unit.VO = new UnitVO(type);
				
				MainConstants.currentLevel.enemyLayer_mc.addChild(unit as EnemyUnit);
				(unit as EnemyUnit).name = "enemy";
				(unit as EnemyUnit).rank_mc.gotoAndStop(type);
				(unit as EnemyUnit).x = dx;
				(unit as EnemyUnit).y = dy;
				(unit as EnemyUnit).rotation = rot;
				(unit as EnemyUnit).type = type;
				return unit;
			}
			else
			{
				
				MainConstants.game.whoTargetOfAirSupport = false;
				MainConstants.game.airSupport = type;
			}
			
			return null;
		}
		
		public static function createUnit(type:String, dx:int, dy:int, rot:int):SimpleUnit
		{
			switch(type)
			{
				case "private_mc":
				case "corporal_mc":
				case "sergeant_mc":
				case "capitain_mc":
				case "lieutenant_mc":
				case "major_mc":
				case "lieutenantColonell_mc":
				case "colonel_mc":
					var unit:SimpleUnit = new PlayerUnit();
					MainConstants.currentLevel.enemyLayer_mc.addChild(unit as PlayerUnit);
					(unit as PlayerUnit).name = "player";
					(unit as PlayerUnit).x = dx;
					(unit as PlayerUnit).y = dy;
					(unit as PlayerUnit).rotation = rot;
					(unit as PlayerUnit).type = type;
					(unit as PlayerUnit).iAmInOurArmy = true;
					(unit as PlayerUnit).rank_mc.gotoAndStop(type);
					return unit;
					break;
			}
			return null;
		}
		
		
		public static function createWayPoint(dx:int, dy:int):WayPoint
		{
			var wp:WayPoint = new WayPoint();
			wp.x = dx;
			wp.y = dy;
			MainConstants.currentLevel.addChild(wp);
			return wp;
		}
		//--------------------------------------------------------------------------
		//
		//  Logs
		//
		//--------------------------------------------------------------------------
	
		public static function createHelperWindow(type:String, contaner:DisplayObjectContainer):MovieClip
		{
			var mc:MovieClip = new helper();
			contaner.addChild(mc);
			mc.x = 400;
			mc.y = 300;
			mc.text_tf.text = type;
			return mc;
		}
		public static function createLevelDiscriptionWindow(type:String, contaner:DisplayObjectContainer, dx:Number = 0, dy:Number = 0):MovieClip
		{
			var mc:MovieClip = new levelDiscription_mc();
			contaner.addChild(mc);
			mc.gotoAndStop(type);
			mc.x = dx;
			mc.y = dy;
			return mc;
		}
		
		public static function createShopWindow(contaner:DisplayObjectContainer):MovieClip
		{
			var mc:MovieClip = new shop_mc();
			contaner.addChild(mc);
			return mc;
		}
		
		public static function createBarrackWindow(contaner:DisplayObjectContainer):MovieClip
		{
			var mc:MovieClip = new barrack_mc();
			contaner.addChild(mc);
			return mc;
		}
		public static function createAchivementWindow(contaner:DisplayObjectContainer):MovieClip
		{
			var mc:MovieClip = new achivements_mc();
			contaner.addChild(mc);
			return mc;
		}
		
		
	}
}