package model{
	import flash.filesystem.*;
	import utils.Rnd;
	//import flash.events.EventDispatcher;// This import is required for Flex 2

	// To avoid binding warnings to "instance" in Flex 2 we need to explicitly extends EventDispatcher and add [Bindable] to the static instance getter. 
	[Bindable] public class Config /*extends EventDispatcher*/{
		public var prefsFile:File; // The preferences File
		private var prefsXML:XML; // The XML data
		public var stream:FileStream; // The FileStream object used to read and write prefsFile data.
		
		public var windowX:int=0;
		public var windowY:int=0; 
		public var trackList:Array=null;
		
		public var currentRandomSong:String = "";
		public var savedPosition:Number = 0;
		
		//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//
		// SINGLETON ENFORCING
		//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//
		private static const _instance:Config = new Config(SingletonLock); // Storage for the singleton instance.

		/** Provides singleton access to the instance. */
  		public static function get instance():Config{
			return _instance;
		}
		
		/** @param lock The Singleton lock class to pevent outside instantiation. */
		public function Config(lock:Class){
			// Verify that the lock is the correct class reference.
			if ( lock != SingletonLock ){
				throw new Error( "Invalid Singleton access, use Config.instance" );
			}
			//normal construction continues here
			init();
		}
		
		//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//
		// STARTUP AND FILE IO
		//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//
		/**
		 * Called when on app start. Points the prefsFile File object to the cccatcher-config.xml prefsFile in the AIR application store directory, 
		 * which is uniquely defined for the application. It then calls the readXML() method, which reads the XML data.
		 */
		private function init():void{
			prefsFile = File.applicationStorageDirectory;
			prefsFile = prefsFile.resolvePath("cccatcher-config.xml");
			readXML();			
		}
		private function readXML():void {
			stream = new FileStream();
			if (prefsFile.exists) {
				trace('found '+prefsFile.nativePath);
    			stream.open(prefsFile, FileMode.READ);
			    processXMLData();
			}
			else{
			    createXMLData();
			    writeXMLData();
			}
		}
		
		/**
		 * Called after the data from the prefs file has been read. The readUTFBytes() reads
		 * the data as UTF-8 text, and the XML() function converts the text to XML. The x, y,
		 * width, and height properties of the main window are then updated based on the XML data.
		 */
		private function processXMLData():void {
			prefsXML = XML(stream.readUTFBytes(stream.bytesAvailable));
			stream.close();
			if(prefsXML.windowState.@x>=0){windowX=prefsXML.windowState.@x;}else{windowX=0;}
			if(prefsXML.windowState.@y>=0){windowY=prefsXML.windowState.@y;}else{windowY=0;}
			currentRandomSong = prefsXML.channelState.@currentTrack;
			savedPosition = prefsXML.channelState.@currentPosition;
		}
		
		/**
		 * Creates an XML object with all the variables in the config.
		 * This is only for the first run or if the xml file gets kicked in the balls.
		 */
		private function createXMLData():void {
			prefsXML = <preferences/>;
			prefsXML.windowState.@x = windowX;
			prefsXML.windowState.@y = windowY;
			prefsXML.channelState.@currentPosition = 0;
			prefsXML.appendChild('<trackList/>');
		}
		
		/**
 		 * Called when the NativeWindow closing event is dispatched. The method 
		 * converts the XML data to a string, adds the XML declaration to the beginning 
		 * of the string, and replaces line ending characters with the platform-
		 * specific line ending character. Then sets up and uses the stream object to
		 * write the data.
		 */
		public function writeXMLData():void {
			trace(' ! writeXMLData()');
			var outputString:String = '<?xml version="1.0" encoding="utf-8"?>\n';
			outputString += prefsXML.toXMLString();
			outputString = outputString.replace(/\n/g, File.lineEnding);
			stream = new FileStream();
			stream.open(prefsFile, FileMode.WRITE);
			stream.writeUTFBytes(outputString);
			stream.close();
		}

		//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//
		// GETTERS AND SETTERS
		//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//
		/**
		 * assert that the native path exists
		 */
		public function nativePathExists(uri:String):Boolean {
			var pathToFile:File = File.userDirectory.resolvePath(uri)
			pathToFile = pathToFile.resolvePath(uri);
			
			if (pathToFile.exists) {
				return true;
			}
			else{
				return false;
			}
		}
		
		public function addTrack(uri:String):void{
			//make sure the nativePath isn't already in the list
			if( nativePathAlreadyExists(uri) ){
				return void;
			}
			
			//make the node
			var newNode:XML = <TRACK/>;
			newNode.@uri = uri;
			newNode.@playCount = '0';
			
			prefsXML.trackList.appendChild(newNode);			
		}
		
		public function removeTrack(uri:String):void{
			for each (var child:XML in prefsXML.trackList.*) {
				if(child.@uri == uri){
					delete prefsXML.trackList.child;
					trace('removed from xml: '+uri);
				}
			}
		}
		
		public function renameTrack(uri:String, newPath:String):void{
			for each (var child:XML in prefsXML.trackList.*) {
				if(child.@uri == uri){
					child.@uri = newPath;
					trace('renamed in xml: '+newPath);
				}
			}
		}
		
		public function saveWindowState(x:Number,y:Number):void{
            prefsXML.windowState.@x = x;
			prefsXML.windowState.@y = y;
		}
				
		public function saveChannelState(currentPosition:Number):void{
			prefsXML.channelState.@currentPosition = currentPosition;
			prefsXML.channelState.@currentTrack = currentRandomSong;
		}
		
		private function nativePathAlreadyExists(uri:String):Boolean{
			var baby:Boolean = false;
			for each (var child:XML in prefsXML.trackList.*) {
				if(child.@uri == uri){
					trace('nativePath already exists');
					baby = true;
				}
			}
			return baby;
		}
		
		/**
		 * Recursively calls itself so we don't hear the same track twice in a row.
		 */		
		public function getRandomSong():String{
			var songNativePath:String = getRandomNativePath();
			return songNativePath;
		}
		private function getRandomNativePath():String{
			//check for zero track length
			if(prefsXML.trackList.TRACK.length() == 0){
				return '';
			}
			
			checkAllTracksPlayed();
			
			var rndInt:int = Rnd.integer(0, (prefsXML.trackList.TRACK.length()));
			var nextRandomSong:String = prefsXML.trackList.children()[rndInt].@uri;
			
			//if the nextRandomSong is bad for any reason, make a recursive call:
			//bad if it's already been played
			if(prefsXML.trackList.children()[rndInt].@playCount == '1'){
				return getRandomNativePath();
			}
			//bad if we're currently playing the nextRandomSong
			if(nextRandomSong == currentRandomSong && prefsXML.trackList.TRACK.length() > 1){//if there's only 1 track we loop out
				return getRandomNativePath();
			}
			//bad if the file doesn't exist anymore
			if(nativePathExists(nextRandomSong) == false){
				delete prefsXML.trackList.children()[rndInt];
				return getRandomNativePath();
			}

			//we got a Good one!			
			currentRandomSong = nextRandomSong;
			prefsXML.trackList.children()[rndInt].@playCount = '1';
			return nextRandomSong;
		}
		
		/**
		 * if there are only songs that have been played, reset all their playedFlag 
		 */
		private function checkAllTracksPlayed():void{
			// First obtain an XMLList object representing all <EMPLOYEE> elements
			var allEmployees:XMLList = prefsXML.trackList.*;
			// Now filter the list of <EMPLOYEE> elements
			var employeesUnderJames:XMLList = allEmployees.(@playCount == '0');
			
			if(employeesUnderJames.length() == 0){
				resetPlayCounts();
			}
		}
		private function resetPlayCounts():void{
			for each (var child:XML in prefsXML.trackList.*) {
				trace('reset playcount!');
				child.@playCount = '0';
			}
		}
		
		

	}//Config class
}//package

/**
 * SingletonLock is a private class declared outside of the package, accessible to classes inside of the Model.as
 * file.  Because of that, no outside code is able to get a reference to this class to pass to the constructor, which
 * enables us to prevent outside instantiation.
 * 
 * Singleton setup stolen from http://www.darronschall.com/weblog/2007/11/actionscript-3-singleton-redux.cfm
 */
class SingletonLock{
}


