package view{
	import flash.display.*;
	import flash.text.*;
	
	public class Time extends Sprite{
		public var _elapsedField:TextField = new TextField();
					
		public function Time(){
			this.graphics.beginFill(0xFFFFFF);
			this.graphics.drawRect(0,4,80,9);//magic
			this.graphics.endFill();
			
			_elapsedField.defaultTextFormat = new TextFormat("_uni05", 8, 0x000000);
			_elapsedField.embedFonts = true;
			//_elapsedField.antiAliasType = AntiAliasType.ADVANCED; 
			_elapsedField.autoSize = TextFieldAutoSize.LEFT;
			_elapsedField.border = false;
			_elapsedField.selectable = false;
			//_elapsedField.x = xHandle;
			//_elapsedField.y = yHandle;
			//_elapsedField.wordWrap = true;
			_elapsedField.text = '77:77/77:77';//rollin/*53v7nZ*/
			addChild(_elapsedField);

		}
		
		public function display(elapsed:String, total:String):void{
			//could display
			//var secSinceStart
			//var secTillEnd 			
			_elapsedField.text = elapsed+'/'+total;
		}
		
	}//class
}//package