package view{
	import flash.display.*;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.*;
	import flash.ui.Keyboard;
	
	public class Time extends Sprite{
		public var _elapsedField:TextField = new TextField();
		private var shiftKeyDown:Boolean = false;
		
//- PUBLIC -//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//-
		public function Time(){
			addEventListener( Event.ADDED, onAdded );
		}
		
		public function display(elapsed:String, total:String):void{
			//could display
			//var secSinceStart
			//var secTillEnd 			
			_elapsedField.text = elapsed+'/'+total;
		}
		
//- PRIVATE -//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//-
		private function draw():void{
			this.graphics.beginFill(0xFFFFFF);
			this.graphics.drawRect(0,4,80,11);//magic
			this.graphics.endFill();
			
			_elapsedField.defaultTextFormat = new TextFormat("_swfit", 8, 0x000000);
			_elapsedField.embedFonts = true;
			//_elapsedField.antiAliasType = AntiAliasType.ADVANCED; 
			_elapsedField.autoSize = TextFieldAutoSize.LEFT;
			_elapsedField.border = false;
			_elapsedField.selectable = false;
			//_elapsedField.x = xHandle;
			_elapsedField.y = -1;
			//_elapsedField.wordWrap = true;
			_elapsedField.text = '77:77/77:77';//rollin/*53v7nZ*/
			addChild(_elapsedField);			

			this.x = int(stage.width/2 - this.width/2)+1;
			this.y = int(stage.height - 17);
		}
		
		private function position():void{
			
		}
				
		private function onAdded(e:Event):void{
			draw();

			//add listeners once the stage is accessible
			this.addEventListener(MouseEvent.CLICK, onLeftClick);
			this.addEventListener(MouseEvent.RIGHT_CLICK, onRightClick);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp);
		}

//- HANDLERS -//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//-
		private function onLeftClick(e:MouseEvent):void{
			if(shiftKeyDown)
				dispatchEvent(new Event("LEFT_SHIFT_CLICK") );			
			else
				dispatchEvent(new Event("LEFT_SINGLE_CLICK") );
		}
		
		private function onRightClick(e:MouseEvent):void{
			dispatchEvent(new Event("RIGHT_SINGLE_CLICK") );
		}

		private function onKeyDown(e:KeyboardEvent):void{
			if(e.keyCode == Keyboard.SHIFT){
				shiftKeyDown = true;					
			}
		}
		private function onKeyUp(e:KeyboardEvent):void{
			if(e.keyCode == Keyboard.SHIFT){
				shiftKeyDown = false;
			}
		}
	
	}//class
}//package