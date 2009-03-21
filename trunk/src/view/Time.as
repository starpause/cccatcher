package view{
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.text.*;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	//double click emulation
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class Time extends Sprite{
		public var _elapsedField:TextField = new TextField();
					
		//double click emulation
		private var leftClicks:int = 0;
		//private var rightClicks:int = 0;
		private var clickWindow:Timer = new Timer(250,1);
//- PUBLIC -//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//-
		public function Time(){
			draw();
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
			leftClicks++;
			clickWindow.start();
		}
		private function leftSingleClick():void{
			dispatchEvent(new Event("LEFT_SINGLE_CLICK") );			
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
		
	}//class
}//package