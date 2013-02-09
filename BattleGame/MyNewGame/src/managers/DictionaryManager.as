package managers
{
	public class DictionaryManager
	{
		//--------------------------------------------------------------------------
		//
		//  Constants and Variables
		//
		//--------------------------------------------------------------------------
		//Constants
		
		//Private variables
		
		//Public variables
		public static var language:int;
		
		public static var FollowModeIsON:Array =["Follow mode is ON. Choose by click another unit and follow him",
												 "Режим следования включён. Выберите юнита, за кем следовать"
												];
		public static var FollowModeIsCanceled:Array = ["Follow mode is canceled.", "Режим следования отменён."];
		public static var TheyMustSeeEachOther:Array = ["They must see each other!", "Они должны видеть друг - друга!"];
		public static var TheUnitHasNotPathPointsYet:Array = ["The unit has not a path's points yet!", "У юнита пока ещё нет пути!"];
		public static var EndOfMove:Array = ["End of move. It's time to prepare for next move!", "Конец хода. Время приготовиться к следующему!"];
		public static var YouAlreadyUseMaximumAmountUnits:Array = ["You already use the maximum amount of the units.", "Вы уже используете максимальное количество юнитов."];
		public static var ThisMapNotAvailableYet:Array = ["This map is not available yet.", "Эта миссия ещё не доступна."];
		public static var YourBarracksHasNotSoldiers:Array = ["Your barracks has not soldiers. Recruit the soldiers!", "Ваша казарма пуста."];
		public static var AttentionYourEnemyCalledSoldier:Array = ["Attention! Your enemy called to battle one soldier!", "Внимание! Враг вызвал из казармы нового бойца."];
		public static var YourBarrackCompleted:Array = ["Your barrack is completed!", "В казарме больше нет места!"];
		public static var YouAlreadyUseAirSupport:Array = ["You already use the Air-Support!", "Вы уже выбрали помошь воздушной поддержки!"];

		
		
		
		public static var advices:Array = [
			 ["In the recumbent unit harder to get", "В лежачего юнита сложнее попасть."],
			 ["The lower the speed - the better the bullet flies", "Чем меньше скорость - тем точнее летит пуля."],
			 ["Shoot from behind cover.", "Стреляй из-за укрытия."],
			 ["Move more!", "Больше двигайся!"],
			 ["The fewer moves you use, the more money you earn!", "Чем меньше ходов вы используете, тем больше денег вы заработаете!"],
			 ["The larger unit will destroy the enemies of the faster it will rise in rank!", "Чем больше юнит уничтожит врагов тем быстрее он повысится в звании!"],
			 
			
			];
		
		public function DictionaryManager()
		{
		}
		
	}
} 