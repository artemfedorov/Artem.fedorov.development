package superClasses
{
	
	/**
	 * @author - Artem Fedorov aka Timer
	 * @version - 
	 * 
	 * @langversion - ActionScript 3.0
	 * @playerversion - FlashPlayer 10.2
	 */
	
	
	
	
	public class GameSetting
	{
		//--------------------------------------------------------------------------
		//
		//  Constants and Variables
		//
		//--------------------------------------------------------------------------
		//Constants
		public static const MAX_UNIT_IN_BATTLE:int = 5;
		
		//Private variables
		
		//Public variables
		public static const beginScore:int = 1000000;
		
		
		public static const standartRapidity:int = 8;
		public static const minimalFOV:int = 90;
		public static const middleFOV:int = 100;
		public static const standartFOV:int = 110;
		public static const maximumFOV:int = 120;
		
		public static const minimalRapidity:int = 12;
		public static const middleRapidity:int = 8;
		public static const UsualRapidity:int = 15;
		public static const maximumRapidity:int = 25;
		
		public static const minimalArmor:int = 10;
		public static const middleArmor:int = 20;
		public static const UsualArmor:int = 30;
		public static const maximumArmor:int = 50;
		
		public static const privatePrice:int = 5000;
		public static const corporalPrice:int = 7000;
		public static const sergeantPrice:int = 10000;
		public static const capitainPrice:int = 15000;
		public static const lieutenantPrice:int = 20000;
		public static const majorPrice:int = 30000;
		public static const lieutenantColonellPrice:int = 50000;
		public static const colonelPrice:int = 100000;
		public static const airSupport1Price:int = 100000;
		public static const airSupport2Price:int = 200000;
		public static const airSupport3Price:int = 300000;
		public static const minePrice:int = 800;
		public static const granadePrice:int = 500;
		/*case "private_mc":
		case "corporal_mc":
		case "sergeant_mc":
		case "capitain_mc":
		case "lieutenant_mc":
		case "major_mc":
		case "lieutenantColonell_mc":
		case "colonel_mc":
		case "airSupport1_mc":
		case "airSupport2_mc":
		case "airSupport3_mc":*/
		
		public static var radiusExplosion100:int = 100;
		public static var radiusExplosion50:int = 50;
		
		public static var levelProgress:Array = [100, 200, 300];
		public static var ranks:Array = ["private_mc", "corporal_mc", "sergeant_mc", "capitain_mc", "lieutenant_mc", "major_mc", "lieutenantColonell_mc", "colonel_mc"];
		
		
		public static var lvlEnemies:Array = 
		[
			["private_mc", "private_mc", "private_mc", "private_mc", "private_mc"],
			
			["private_mc", "private_mc", "private_mc", "private_mc", "private_mc"],
			
			["private_mc", "corporal_mc", "sergeant_mc", "capitain_mc", 
				"lieutenant_mc", "major_mc", "lieutenantColonell_mc", "colonel_mc", "colonel_mc", "colonel_mc"],
			
			["private_mc", "corporal_mc", "sergeant_mc", "capitain_mc", 
				"lieutenant_mc", "major_mc", "lieutenantColonell_mc", "colonel_mc", "colonel_mc", "colonel_mc"],
			
			["colonel_mc", "colonel_mc", "colonel_mc", "colonel_mc", 
				"colonel_mc", "colonel_mc", "colonel_mc", "colonel_mc", "colonel_mc", "colonel_mc"]
		];
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}