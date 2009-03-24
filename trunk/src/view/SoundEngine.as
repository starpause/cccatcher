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
		private	var currentRandomSong:String = '';
		public var forceTrack:String;
		
		public var songPaused:Boolean = false;
		public var songPosition:Number = 0;

		private var previousRandomSong:String;
		private var rewinding:Boolean=false;
		private var backStack:Array = new Array;
		private var nextStack:Array = new Array;

		
		public function SoundEngine(){
		}

		public function togglePlay():void{
			//modify sound?
			if(songPaused == true){ //is paused, must play
				_channel = _songCurrent.play(songPosition);
				_channel.addEventListener(Event.SOUND_COMPLETE, playNext);
			}else{ //is play, must pause
				songPosition = _channel.position;
				_channel.stop();
			}
			songPaused = !songPaused;
		}
		
		/**
		 * if a forceTrack has been injected or set, play that back. otherwise, grab a random track to play
		 * 
		 */
		public function playNext(e:Event=null):void{
			backStack.push(currentRandomSong);			
			
			//decide what to play next
			if(forceTrack == '' || forceTrack == null){
				if(nextStack.length>0){
					//we are seeking forward through the nextStack after having seeked backward
					currentRandomSong = nextStack.pop();
					config.currentRandomSong=currentRandomSong;
					config.savedPosition=0;
				} else {
					//we are free to random
					currentRandomSong = config.getRandomSong();
					config.savedPosition=0;
				}
			} else {
				//we were told to play a specific track by having the public forceTrack set
				currentRandomSong=forceTrack;
				forceTrack='';
			}

			//make sure a track exists before loading it?
			//as is logic else where should ensure that the currentRandomSong exists but it's easy to break
			loadSound();
		}
		
		public function playPrevious():void{
			if(backStack.length>1){
				nextStack.push(currentRandomSong);
				currentRandomSong=backStack.pop();
				config.currentRandomSong=currentRandomSong;
			}else{
				trace('backStack empty');
			}
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
			
			if(rewinding==true){
				config.savedPosition=_songCurrent.length-TRANSPORT_MS;
				rewinding=false;
			}
			
			_channel = _songCurrent.play(config.savedPosition);				
			_channel.addEventListener(Event.SOUND_COMPLETE, playNext);
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
				_channel.addEventListener(Event.SOUND_COMPLETE, playNext);
			}else{
				playNext();
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
				_channel.addEventListener(Event.SOUND_COMPLETE, playNext);
			}
			songPaused = false;
			dispatchEvent(new Event("UPDATE_TIME") );
		}
		
	}//class
}//package