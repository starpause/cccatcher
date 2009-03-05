package utils{
	import flash.filesystem.*;
	import flash.events.Event;

	public class FileSystem{

		/**
		 * Assert that the nativePathExists 
		 * 
 		 * @param uri nativePath to check
		 * @return true if file does exist, false if file doesn't exist
		 */
		public static function nativePathExists(uri:String):Boolean {
			var pathToFile:File = File.userDirectory.resolvePath(uri)
			pathToFile = pathToFile.resolvePath(uri);
			
			if (pathToFile.exists) {
				return true;
			}
			else{
				return false;
			}
		}
		
		public static function rename(oldUri:String, newUri:String):void{
			var origFileLoc:File = File.desktopDirectory.resolvePath(oldUri);
			origFileLoc.addEventListener(Event.COMPLETE,moveFileListener);
			var newFileLoc:File = File.desktopDirectory.resolvePath(newUri);
			origFileLoc.moveToAsync(newFileLoc);			
		}
		private static function moveFileListener(event:Event):void{
		    trace('file tagged! event: '+event.toString());
		}
		
		public static function remove(uri:String):void{
		    var temp:File = File.desktopDirectory.resolvePath(uri)
		    if(temp.exists == true){
				temp.addEventListener(Event.COMPLETE, deleteFileListener);
				temp.deleteFileAsync();
			}
		}
		private static function deleteFileListener(event:Event):void{
			//trace('filesystem no longer contains '+currentRandomSong);
		}

		public function FileSystem(){
			throw(new Error("FileSystem class should not be instantiated. Access ala Filesystem.whateverFunction() after including this class."));
		}
	}
}
