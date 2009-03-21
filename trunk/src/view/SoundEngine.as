package view{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	
	import model.Config;
	
	public class SoundEngine extends EventDispatcher{
		static private var config:Config = Config.instance;
		private var TRANSPORT_MS:int = 7000;
		public var _songCurrent:Sound = new Sound();
		public var _channel:SoundChannel = new SoundChannel();
		private	var currentRandomSong:String;
		private var previousRandomSong:String;
		private var rewinding:Boolean=false;
		public var forceTrack:String;
		
		public var songPaused:Boolean = true;
		public var songPosition:Number = 0;
		
		public function SoundEngine(){
		}

		public function togglePlay():void{
			//modify sound?
			if(songPaused == true){ //is paused, must play
				_channel = _songCurrent.play(songPosition);
				_channel.addEventListener(Event.SOUND_COMPLETE, play);
			}else{ //is play, must pause
				songPosition = _channel.position;
				_channel.stop();
			}
			songPaused = !songPaused;
		}
		
		public function play(savedSong:String=''):void{
			//push current song onto previousStack
			if(forceTrack != ''){
				currentRandomSong=forceTrack;
				forceTrack='';
				previousRandomSong=currentRandomSong;//temporary until i get real previous track implemented
			} else {
				previousRandomSong=currentRandomSong;
				currentRandomSong = config.getRandomSong();
			}

			loadSound();
		}
		
		public function playPrevious():void{
			var tempRandom:String=currentRandomSong;
			currentRandomSong=previousRandomSong;
			previousRandomSong=tempRandom;
			loadSound();
		}
		
		private function loadSound():void{
			trace('shuffle: '+currentRandomSong);
			
			//special case: first time application is run, lets not freak out
			if(currentRandomSong == ''){
				return void;
			}
			
			//stop currentRandomSong
			if(_channel){
				_channel.stop();
				_channel = null;
			}
			//do a newie
			_channel = new SoundChannel();
			
			//var req:URLRequest = new URLRequest(currentRandomSong);
			//trying to get the app: off the URLRequest under OSX
			//maybe its possible to open the file and play the bytearray instead
			var file:File = new File();
			file = file.resolvePath(currentRandomSong);
			var req:URLRequest = new URLRequest(file.url);
			
			_songCurrent = new Sound();
			_songCurrent.addEventListener(IOErrorEvent.IO_ERROR, onSoundError);				
			_songCurrent.addEventListener(Event.COMPLETE, onSoundLoaded);
			_songCurrent.load(req);
		}
		
		private function onSoundLoaded(event:Event):void{
			_channel.stop();
			
			if(rewinding==true)
				config.savedPosition=_songCurrent.length-TRANSPORT_MS;
			else
				config.savedPosition=0;
			
			_channel = _songCurrent.play(config.savedPosition);				
			_channel.addEventListener(Event.SOUND_COMPLETE, play);
			songPaused = false;
			//displatch event 
			dispatchEvent(new Event("SOUND_LOADED") );
		}
		
		private function onSoundError(event:IOErrorEvent):void{
			trace("onSoundError(): " + event.text);
		}
		
		public function fastForward():void{
			if(songPaused==true){
				togglePlay();
				return;
			}

			//move ahead a magic number of milliseconds
			songPosition = _channel.position + TRANSPORT_MS; 
			_channel.stop();
			if(_songCurrent.length > songPosition){
				_channel = _songCurrent.play(songPosition);
				_channel.addEventListener(Event.SOUND_COMPLETE, play);
			}else{
				play();
			}
			dispatchEvent(new Event("UPDATE_TIME") );
		}
		
		public function rewind():void{
			//move ahead a magic number of milliseconds
			songPosition = _channel.position - TRANSPORT_MS; 
			_channel.stop();
			if(0 > songPosition){
				playPrevious();
				rewinding=true;
			}else{
				_channel = _songCurrent.play(songPosition);
				_channel.addEventListener(Event.SOUND_COMPLETE, play);
			}
			songPaused = false;
			dispatchEvent(new Event("UPDATE_TIME") );
		}
		
	}//class
}//package