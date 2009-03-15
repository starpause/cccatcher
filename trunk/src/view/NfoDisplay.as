package view{
	import flash.display.*;
	import flash.text.*;
	
	public class NfoDisplay extends Sprite{
		public var _nfoField:TextField = new TextField();
		public var _nfoBg:Sprite = new Sprite();
		
		public function NfoDisplay(){
			_nfoBg.graphics.beginFill(0xFFFFFF);
			_nfoBg.graphics.drawRect(0,0,128-4,2);//magic
			_nfoBg.x = 2;
			_nfoBg.y = 2;
			_nfoBg.graphics.endFill();
			addChild(_nfoBg);
			
			_nfoField.defaultTextFormat = new TextFormat("_uni05", 8, 0x000000);
			_nfoField.embedFonts = true;
			//_nfoField.antiAliasType = AntiAliasType.ADVANCED; 
			_nfoField.autoSize = TextFieldAutoSize.LEFT;
			_nfoField.multiline = true;
			_nfoField.wordWrap = true;
			_nfoField.border = false;
			_nfoField.selectable = false;
			_nfoField.x = 4;
			_nfoField.y = -2;
			_nfoField.width = 128 - 8;//magic
			addChild(_nfoField);
			
			setCopy();
		}
		
		private function setCopy(newNfo:String='1. drop some mp3 on this window. \n2. double click to begin the jams.'):void{
			_nfoField.text = newNfo;
			_nfoBg.height = _nfoField.height-4;
		}
		
		public function refreshWith(nativePathToParse:String):void{
			var trackCopy:String;
			var folderCopy:String;
			var chopping:Array;
			
			if(nativePathToParse.indexOf('/') != -1){//running on OSX/NIX
				trackCopy = nativePathToParse.substr(nativePathToParse.lastIndexOf('/')+1);
				chopping = nativePathToParse.split('/');
			}else{//running on WIN
				trackCopy = nativePathToParse.substr(nativePathToParse.lastIndexOf('\\')+1);
				chopping = nativePathToParse.split('\\');
			}
			
			folderCopy = chopping[chopping.length-2]//+' in '+chopping[chopping.length-3];
			trackCopy = trackCopy.replace('.mp3','');
			trackCopy = trackCopy.replace('.MP3','');
			trackCopy = trackCopy.replace('.Mp3','');
			trackCopy = trackCopy.replace('.mP3','');
			setCopy(trackCopy+' in '+folderCopy);
		}

	}//class
}//package