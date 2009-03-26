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
	public class CoverDisplay extends Sprite{
		[Embed(source='./assets/cccatcher.jpg')]
		public static var DefaultImage:Class;
		
		private var nativePathToParse:String;
		private var directoryToSearch:String;
		private var possibleImages:Array;
		private var imageToLoad:String;
		private var WINDOW_PX:int = 128;
		private var defaultImage:Bitmap;
		private var image:Bitmap=new Bitmap();
		private var coverOld:Cover;
		private var coverNew:Cover;
		//private var coverOld:Bitmap=new Bitmap();
		
		private var imageLoaderNew:Loader = new Loader();
		private var imageLoaderOld:Loader = new Loader();
		private var imageLoader:Loader = new Loader();

		public function CoverDisplay(){
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
				if( (node.extension == 'jpg' || node.extension == 'JPG') && node.name.charAt(0) != '.'){
					possibleImages.push(node.nativePath);
				}
			}
			if(possibleImages.length > 0){
				determineImage();
			}else{
				image.visible = false;
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
		
		
//- IMAGE LOADING AND HANDLING --//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//
		private function loadImage():void{
			var file:File = new File();
			file = file.resolvePath(imageToLoad);
			var imageRequest:URLRequest = new URLRequest(file.url);
			
			//fill new
			imageLoader.unload();			
			imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onImageError);
			imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageComplete);
			imageLoader.load(imageRequest);
		}
		private function onImageComplete(event:Event):void{
			defaultImage.visible = false;
			
			//copy new 2 old
			//position old at 0,0
			//posiiton new at 128,0
			//posiiton default at 128,0			
			//put image in new
			//tween
						
			try{
				removeChild(coverNew);
			} catch (e:Error){ trace('no image to remove'); }
			
			image = new Bitmap( (event.target.content as Bitmap).bitmapData );
			coverNew = new Cover(image);
			addChild(coverNew);
		}
		
		private function onImageError(event:IOErrorEvent):void{
			image.visible = false;
			defaultImage.visible = true;
			trace('IOErrorEvent.IO_ERROR: '+imageToLoad+' from loadImage() in RandomCover');
		}

	}
}
