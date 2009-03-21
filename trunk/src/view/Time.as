package view{
	import flash.display.*;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.*;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	public class Time extends Sprite{
		public var _elapsedField:TextField = new TextField();
		private var shiftKeyDown:Boolean = false;
		
		//double click emulation
		private var leftClicks:int = 0;
		//private var rightClicks:int = 0;
		private var clickWindow:Timer = new Timer(250,1);
//- PUBLIC -//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//-
		public function Time(){
			draw();
			addEventListener( Event.ADDED, init );
		}
		
		private function init(e:Event):void{
			listen();			
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
		}
		
		private function listen():void{
			//double click emulation
			clickWindow.addEventListener(TimerEvent.TIMER, clickWindowExpired);

			this.addEventListener(MouseEvent.CLICK, onLeftClick);
			this.addEventListener(MouseEvent.RIGHT_CLICK, onRightClick);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp);
			
		}
		
//- HANDLERS -//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//-
		private function clickWindowExpired(event:TimerEvent):void{
			if(leftClicks==1){
				leftSingleClick();
			}else if(leftClicks > 1){
				leftDoubleClick();
			}/*else if(rightClicks==1){
				rightSingleClick();
			}else if(rightClicks>1){
				rightDoubleClick();
			}*/
			clickWindow.stop();
			leftClicks=0;
			//rightClicks=0;
		}

		private function onLeftClick(e:MouseEvent):void{
			if(shiftKeyDown)
				dispatchEvent(new Event("LEFT_SHIFT_CLICK") );			
			else
				dispatchEvent(new Event("LEFT_SINGLE_CLICK") );
		}
		private function leftSingleClick():void{
		}
		
		private function leftDoubleClick():void{
			dispatchEvent(new Event("LEFT_DOUBLE_CLICK") );			
		}
		
		private function onRightClick(e:MouseEvent):void{
			dispatchEvent(new Event("RIGHT_SINGLE_CLICK") );
			/*rightClicks++;
			clickWindow.start();
			*/
		}
		/*
		private function rightSingleClick():void{
			dispatchEvent(new Event("RIGHT_SINGLE_CLICK") );
		}
		private function rightDoubleClick():void{
			trace('dubba right');
			dispatchEvent(new Event("RIGHT_DOUBLE_CLICK") );
		}*/
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