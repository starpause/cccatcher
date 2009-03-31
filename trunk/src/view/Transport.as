package view{
	import flash.display.*;
	import flash.events.*;
	
	public class Transport extends Sprite{
		//these guys are 18x18 ... is 16x16 cooler like favicons?!
		[Embed(source='./assets/play.png')]
		public static var PlayIcon:Class;
		private var playIcon:Bitmap = new PlayIcon();
		private var playButton:Sprite = new Sprite();
		
		[Embed(source='./assets/pause.png')]
		public static var PauseIcon:Class;
		private var pauseIcon:Bitmap = new PauseIcon();
		private var pauseButton:Sprite = new Sprite();

		[Embed(source='./assets/quit.png')]
		public static var QuitIcon:Class;
		private var quitIcon:Bitmap = new QuitIcon();
		private var quitButton:Sprite = new Sprite();

		public function Transport(){
			addEventListener( Event.ADDED, init );
		}
		
		private function init(e:Event):void{
			pauseButton.addChild(pauseIcon);
			pauseButton.mouseChildren=false;
			pauseButton.addEventListener(MouseEvent.MOUSE_DOWN, onPauseDown);
			pauseButton.y=this.stage.stageHeight-pauseIcon.height-8;
			pauseButton.x=this.stage.stageWidth-pauseIcon.width-4;
			addChild(pauseButton);
			
			playButton.addChild(playIcon);
			playButton.mouseChildren=false;
			playButton.addEventListener(MouseEvent.MOUSE_DOWN, onPlayDown);
			playButton.visible=false;
			playButton.y=pauseButton.y;
			playButton.x=pauseButton.x;
			addChild(playButton);

			quitButton.addChild(quitIcon);
			quitButton.mouseChildren=false;
			quitButton.addEventListener(MouseEvent.MOUSE_DOWN, onQuitDown);
			quitButton.y=pauseButton.y;
			quitButton.x=4;
			addChild(quitButton);

		}
		
		private function onPauseDown(e:Event):void{
			playButton.visible=true;
			pauseButton.visible=false;
			dispatchEvent(new Event("PAUSE") );			
		}

		private function onPlayDown(e:Event):void{
			playButton.visible=false;
			pauseButton.visible=true;
			dispatchEvent(new Event("PLAY") );			
		}

		private function onQuitDown(e:Event):void{
			dispatchEvent(new Event("QUIT") );			
		}

	}//class
}//view	