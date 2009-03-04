package view{
	import flash.display.*;
	import flash.events.*;
	import flash.filesystem.File;
	import flash.geom.*;
	import flash.net.*;
	import flash.text.*;
	
	import mx.controls.Alert;
	
	import utils.Rnd;
		
	/**
	 * Select a random image from the directory of the currently playing mp3.
	 * Constructor is a dummy, call refreshWith() to get a picture! 
	 *
	 * @author jgray 
	 */
	public class RandomCover extends Sprite{
		[Embed(source='./assets/cccatcher.jpg')]
		public static var DefaultImage:Class;
		
		private var nativePathToParse:String;
		private var directoryToSearch:String;
		private var possibleImages:Array;
		private var imageToLoad:String;
		private var WINDOW_PX:int = 128;
		private var defaultImage:Bitmap;
		private var imageLoader:Loader = new Loader();

		public function RandomCover(){
			defaultImage = new DefaultImage();
			addChild(defaultImage); 			
		}
		
		public function refreshWith(nativePathToParse:String):void{
			this.nativePathToParse = nativePathToParse;
			determineDirectory();
		}
		
		private function determineDirectory():void{
			if(nativePathToParse.indexOf('/') != -1){
				directoryToSearch = nativePathToParse.slice(0, (nativePathToParse.lastIndexOf('/')) );
			}else{
				directoryToSearch = nativePathToParse.slice(0, (nativePathToParse.lastIndexOf("\\")) ); 
			}

			//now that we know the dir, attack it!
			var dir:File = new File(directoryToSearch);
			if (!dir.isDirectory){
				Alert.show("Invalid directory path.", "Error");
			}
			else{
				dir.addEventListener(FileListEvent.DIRECTORY_LISTING, findImagesInDirectory);
				dir.getDirectoryListingAsync();
			}

		}
		
		/**
		 * Don't go deep! JPG only for now.
		 * Sets possibleImages:Array
		 */
		private function findImagesInDirectory(event:FileListEvent):void 
		{
			possibleImages = new Array();
			var currentNodes:Array = event.files;
			var nodeCount:uint = currentNodes.length;
			var node:File;
			var fileExtension:String;
			for (var i:int = 0; i < currentNodes.length; i++){
				node = currentNodes[i];	
				if(node.extension == 'jpg'){
					possibleImages.push(node.nativePath);
				}
			}
			if(possibleImages.length > 0){
				determineImage();
			}else{
				imageLoader.unload();
				defaultImage.visible = true;
			}
		}

		/**
		 * Randomly select an image from the ones in the directory.  
		 * 
		 */
		private function determineImage():void{
			//trace('possibleImages: '+possibleImages);
			imageToLoad = possibleImages[Rnd.integer(possibleImages.length)];
		    var temp:File = File.desktopDirectory.resolvePath(imageToLoad)
		    if(temp.exists == true)
				loadImage();
		}
		
		
		//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//
		// IMAGE LOADING AND HANDLING
		//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//
		private function loadImage():void{
			var file:File = new File();
			file = file.resolvePath(imageToLoad);
			var imageRequest:URLRequest = new URLRequest(file.url);
			imageLoader.unload();
			imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onImageError);
			imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageComplete);
			imageLoader.load(imageRequest);
			addChild(imageLoader);
		}
		private function onImageComplete(event:Event):void{
			defaultImage.visible = false;
			resizeCover(event);
			panCover(event);
		}
		/**
		 * Make sure the window will be covered 100%  
		 * by picking the smallest side and scaling it to be the same width/height as the player window.
		 * @param event Event.COMPLETE from imageLoader:Loader
		 */
		public function resizeCover(event:Event):void{
			var scaleBy:Number;
			trace(event.target.content.width+'x'+event.target.content.height);
			if(event.target.content.width < event.target.content.height){//if width smaller, scale by width
				scaleBy = WINDOW_PX / event.target.content.width;
			}else{//if height smaller, scale by height
				scaleBy = WINDOW_PX / event.target.content.height;
			}
			event.target.content.scaleX = scaleBy;
			event.target.content.scaleY = scaleBy;
			//trace('scaleBy: '+scaleBy+' achieves '+event.target.content.width+'x'+event.target.content.height);

			//for safety mask it off to not display anything outside that box if the image sent is larger than that space.
			//like if i do the dropshadow  
			//event.target.content.mask = this.getChildByName('rect');
		}
		/**
		 * Randomly pan up/down & left/right so the user doesn't always see the same slice of the scaled image.
		 * Math makes sure the image still covers the entire application window.
		 * @param event Event.COMPLETE from imageLoader:Loader
		 */
		public function panCover(event:Event):void{
			event.target.content.x = Rnd.float(event.target.content.width - WINDOW_PX) * -1;
			event.target.content.y = Rnd.float(event.target.content.height - WINDOW_PX) * -1;
			//trace('panCover achieves '+event.target.content.x+'x'+event.target.content.y);
		}
		private function onImageError(event:IOErrorEvent):void{
			trace('IOErrorEvent.IO_ERROR: '+imageToLoad+' from loadImage() in RandomCover');
		}

	}
}
