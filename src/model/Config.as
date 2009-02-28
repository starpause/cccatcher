package model{
	import flash.filesystem.*;
	
	import utils.Rnd;
	
	public class Config{
		public var prefsFile:File; // The preferences prefsFile
		[Bindable] private var prefsXML:XML; // The XML data
		public var stream:FileStream; // The FileStream object used to read and write prefsFile data.
		
		public var windowX:int=0;
		public var windowY:int=0; 
		public var trackList:Array=null;
		
		public var currentRandomSong:String = "";
		public var savedPosition:Number = 0;
		//private var rnd:Rnd = new Rnd();
		
		/**
		* Called when the application starts. The method points the prefsFile File object 
		* to the "preferences.xml prefsFile in the Apollo application store directory, which is uniquely 
		* defined for the application. It then calls the readXML() method, which reads the XML data.
		*/
		public function Config(){
			prefsFile = File.applicationStorageDirectory;
			prefsFile = prefsFile.resolvePath("preferences.xml");
			readXML();
		}
		
		/**
		 * git wigglty on the logic tip
		 */
		public function nativePathDontExist(nativePath:String):Boolean {
			var pathToFile:File = File.applicationStorageDirectory;
			pathToFile = pathToFile.resolvePath(nativePath);
			
			if (pathToFile.exists) {
				return false;
			}
			else{
				return true;
			}
		}
		
		private function readXML():void {
			stream = new FileStream();
			if (prefsFile.exists) {
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
		* called when window is closing.
		
		public function saveData():void{
			createXMLData();
			writeXMLData();
		}
		*/
		
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
		
		public function addTrack(nativePath:String):void{
			//make sure the nativePath isn't already in the list
			if( nativePathAlreadyExists(nativePath) ){
				return void;
			}
			
			//make the node
			var newNode:XML = <TRACK/>;
			newNode.@nativePath = nativePath;
			newNode.@playCount = '0';
			
			prefsXML.trackList.appendChild(newNode);			
		}
		
		public function removeTrack(nativePath:String):void{
			for each (var child:XML in prefsXML.trackList.*) {
				if(child.@nativePath == nativePath){
					delete prefsXML.trackList.child;
					trace('removed from xml: '+nativePath);
				}
			}
		}
		
		public function renameTrack(nativePath:String, newPath:String):void{
			for each (var child:XML in prefsXML.trackList.*) {
				if(child.@nativePath == nativePath){
					child.@nativePath = newPath;
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
				
		private function nativePathAlreadyExists(nativePath:String):Boolean{
			var baby:Boolean = false;
			for each (var child:XML in prefsXML.trackList.*) {
				if(child.@nativePath == nativePath){
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
			//make a list of all the songs that have not been played, and go random inside that
			//if there are only songs that have been played, reset all their playedFlag
			
			//check for zero track length
			if(prefsXML.trackList.TRACK.length() == 0){
				return '';
			}
			
			checkForAllPlayedOut();
			
			var rndInt:int = Rnd.integer(0, (prefsXML.trackList.TRACK.length()));
			var nextRandomSong:String = prefsXML.trackList.children()[rndInt].@nativePath;
			
			//check for bad ones
			if(prefsXML.trackList.children()[rndInt].@playCount == '1'){
				return getRandomNativePath();
			}
			if(nextRandomSong == currentRandomSong && prefsXML.trackList.TRACK.length() > 1){//if there's only 1 track we loop out
				return getRandomNativePath();
			}
			if(nativePathDontExist(nextRandomSong)){//we get a nativePath, and nativePath doesn't still exist anymore, delete nativePath out of the list!
				delete prefsXML.trackList.children()[rndInt];
				return getRandomNativePath();
			}

			//we got a Good one!			
			currentRandomSong = nextRandomSong;
			prefsXML.trackList.children()[rndInt].@playCount = '1';
			return nextRandomSong;
		}
		
		private function checkForAllPlayedOut():void{
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
		
	}//end class
}//end package

