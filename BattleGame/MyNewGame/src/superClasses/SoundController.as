package superClasses
{
	import com.greensock.easing.Linear;
	import com.greensock.TweenMax;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	/**
	 * Класс для работы с музыкой и звуками
	 * @author rocket
	 */
	public class SoundController extends EventDispatcher
	{
		private var _musicTransform:SoundTransform;
		private var _currentMusic:SoundChannel;
		
		private var _musicsPool:Array;		//пул звуков для проигрывания
		private var _playedSounds:Dictionary;	//проигрываемые звуки
		private var _playedMusics:Dictionary;	//проигрываемая музыка
		private var _soundChanels:Dictionary;	//соответствие канала проигрываемому звуку в _playedSounds
		private var _soundGroups:Dictionary;	//группы звуков
		private var _defaultSoundVolume:Number;	//значение звука по умолчанию
		private var _defaultMusicVolume:Number;	//значение музыки по умолчанию
		private var _soundID:int;				//уникальный идентификатор звука
		private var _musicID:int;				//уникальный идентификатор музыки
		private var _isSoundMute:Boolean;		//приглушен ли звук
		private var _isMusicMute:Boolean;		//приглушена ли музыка
		private var _musicPosition:int;
		private var _mutedGroups:Dictionary;
		
		public function SoundController() 
		{
			init();
		}
		
		/**
		 * Инициализация переменных
		 */
		private function init():void 
		{
			_musicsPool = new Array;
			_playedSounds = new Dictionary;
			_playedMusics = new Dictionary;
			_soundChanels = new Dictionary;
			_soundGroups = new Dictionary;
			_mutedGroups = new Dictionary;
			_currentMusic = new SoundChannel();
			_musicTransform = new SoundTransform();
			_isSoundMute = false;
			_isMusicMute = false;
		}
		
		/**
		 * Проигрывание звука
		 * @param	$soundName имя звука для поигрывания
		 * @param	$volume громкость для данного звука
		 * @param	$loops количество повторов
		 * @param	$startTime позиция начала проигрывания
		 * @param	$fadeInTime время возростания громкости звука при старте проигрывания
		 * @param	$fadeOutTime время затухания звука при остановке
		 * @param	$callback функция вызываемая при завершении проигрывания звука
		 * @param	$dualChanel использование двойнего канала (не работает)
		 * @return идентификатор звука
		 */
		public function playSound($soundName:String, $volume:Number = -1, $loops:int = 0, $startTime:Number = 0, $fadeInTime:Number = 0, $fadeOutTime:Number = 0, $group:String = "", $callback:Function = null, $callbackParams:Object = null, $dualChanel:Boolean = false):String
		{
			if (!FileManager.getSoundByName($soundName)) 
			{
				trace("Не найден звук", $soundName);
				if ($callback != null)
					if ($callbackParams != null)
						$callback($callbackParams);
					else
						$callback();
				return null;
			}
			var sound:CustomSound = new CustomSound($soundName, $volume, $startTime, -1, $loops, $fadeInTime, $fadeOutTime, String(_soundID++));
			sound.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);			
			sound.group = $group == "" ? "DEFAULT" : $group;
			sound.callback = $callback;
			sound.callbackParams = $callbackParams;
			
			_playedSounds[sound.soundId] = sound;
			addSoundToGroup(sound.soundId, sound.group);
			return sound.soundId.toString();
		}
		
		/**
		 * Завершение проирывания звука
		 * Удаление звука из массива проигрывающихся звуков
		 * Если звук последний в группе, то граппа удаляется после удаления группы
		 * @param	e
		 */
		private function onSoundComplete(e:Event):void 
		{
			var currentSound:CustomSound = e.target as CustomSound;
			if (currentSound)
			{				
				delete(_soundGroups[currentSound.group][currentSound.soundId]);
				if (Utils.countOf(_soundGroups[currentSound.group]) == 0)
					delete(_soundGroups[currentSound.group]);
				delete(_playedSounds[currentSound.soundId]);
			}
		}
		
		/**
		 * Пауза звука
		 * @param	$soundId
		 */
		public function pauseSound($soundId:*):void
		{
			var soundId:Dictionary = getSoundById($soundId);
			
			for (var obj:String in soundId)
			{
				var currentSound:CustomSound = _playedSounds[obj];
				currentSound.pauseSound();
			}
		}
		
		/**
		 * Возобновление проигырвания звука
		 * @param	$soundId
		 */
		public function resumeSound($soundId:*):void
		{
			var soundId:Dictionary = getSoundById($soundId);
			
			for (var obj:String in soundId)
			{
				var currentSound:CustomSound = _playedSounds[obj];
				currentSound.resumeSound();
			}
		}
		
		/**
		 * Остановка выбранного звука
//		 * @param	$soundId идентификатор звука который нужно остановить
		 * @param	$useFadeOut использоваие затухиния звука
		 */
		public function stopSound($soundId:*, $useFadeOut:Boolean = true, $ignoreSound:* = null):void
		{
			var soundId:Dictionary = getSoundById($soundId);
			var ignoreSound:Dictionary = getSoundById($ignoreSound);
			var soundStop:Boolean = true;
			
			for (var key:String in soundId)
			{
				for (var key1:String in ignoreSound)
				{
					if (key == key1)
					{
						soundStop = false;
					}
				}
				if (soundStop && _playedSounds[key])
				{
					var currentSound:CustomSound = _playedSounds[key];
					if (currentSound)
					{
						currentSound.stopSound();
						
						delete(_soundGroups[currentSound.group][currentSound.soundId]);
						if (Utils.countOf(_soundGroups[currentSound.group]) == 0)
							delete(_soundGroups[currentSound.group]);
						delete(_playedSounds[currentSound.soundId]);
					}
				}
				soundStop = true;
			}
		}
		
		/**
		 * Остановка всех звуков
		 * @param	$useFadeOut использовать ли фейд при остановке
		 */
		public function stopAllSounds($ignoreSound:* = null, $useFadeOut:Boolean = false):void
		{
			stopSound(_playedSounds, $useFadeOut, $ignoreSound);
		}
		
		/**
		 * Задание позиции звука слева или справа
		 * @param	$soundId идентификатор звука
		 * @param	$pan позиция от -1 до 1
		 */
		public function setPan($soundId:*, $pan:Number):void
		{
			var soundId:Dictionary = getSoundById($soundId);

			for (var obj:String in soundId)
			{
				var currentSound:CustomSound = _playedSounds[obj];
				currentSound.setPan = $pan;
			}
		}
		
		/**
		 * Получить звуки по группе
		 * @param	$groupName
		 * @return словарь
		 */
		public function getGroupByName($groupName:String):Dictionary
		{
			if(_soundGroups[$groupName])
				return _soundGroups[$groupName];
			return null;
		}
		
		public function addSoundToGroup($soundId:String, $groupName:String):void
		{
			if (!_soundGroups[$groupName])
				_soundGroups[$groupName] = new Dictionary();
				
			_soundGroups[$groupName][$soundId] = $soundId;
			
			if (_mutedGroups[$groupName])
			{
				var currentSound:CustomSound = _playedSounds[$soundId];
				currentSound.mute = true;
			}
		}
		
		/**
		 * Получение звука по идентификатору. Можео использовать id звука или словарь со звуками
		 * @param	$soundId
		 * @return
		 */
		private function getSoundById($soundId:*):Dictionary
		{
			var soundId:Dictionary = new Dictionary();
			if ($soundId is int)
				soundId[String($soundId)] = _playedSounds[$soundId];
			if ($soundId is String)
				soundId[$soundId] = _playedSounds[$soundId];
			if ($soundId is Dictionary)
				if ($soundId == _playedSounds)
					soundId = $soundId;
				else
					for (var obj:String in $soundId)
						soundId[obj] = _playedSounds[$soundId[obj]];
			
			return soundId;
		}
		
		/**
		 * Приглушение играющих звуков
		 */
		public function muteSounds($soundId:*, $value:Boolean):void 
		{
			var soundId:Dictionary = getSoundById($soundId);
			
			for (var obj:String in soundId)
			{
				var currentSound:CustomSound = _playedSounds[obj];
				currentSound.mute = $value;
			}
		}
		
		public function muteGroup($groupName:String, $value:Boolean):void 
		{
			if ($value)
				_mutedGroups[$groupName] = true;
			else
				delete(_mutedGroups[$groupName]);
			
			var group:Dictionary = getGroupByName($groupName)
			if (!group) return;
			
			for (var key:String in group)
			{
				if (_playedSounds[key])
				{
					var currentSound:CustomSound = _playedSounds[key];
					currentSound.mute = $value;
				}
			}
		}
		
		public function set muteMusic(value:Boolean):void { }
		public function set muteSound(value:Boolean):void { }
		
		/**
		 * Громкость звуков по умолчанию
		 */
		public function get defaultSoundVolume():Number { return _defaultSoundVolume;  }
		public function set defaultSoundVolume(value:Number):void 
		{
			_defaultSoundVolume = value;
		}
		
		/**
		 * Громкость музыки по умалчанию
		 */
		public function get defaultMusicVolume():Number { return _defaultMusicVolume;  }
		public function set defaultMusicVolume(value:Number):void 
		{
			_defaultMusicVolume = value;
		}
		
		public function get isMusicMute():Boolean { return _isMusicMute; }
		
		public function get isSoundMute():Boolean { return _isSoundMute; }
		
	}

}