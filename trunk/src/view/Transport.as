package view{
	import flash.display.*;
	import flash.events.*;
	
	import main.Glob;
	import main.GlobEvent;
	
	public class Transport extends Sprite{
		static private var glob:Glob = Glob.instance;
		
		//these guys are 18x18 ... is 16x16 cooler like favicons?!
		[Embed(source='./assets/play.png')]
		public static var PlayIcon:Class;
		private var playIcon:Bitmap = new PlayIcon();
		[Embed(source='./assets/play-over.png')]
		public static var PlayOver:Class;
		private var playOver:Bitmap = new PlayOver();
		private var playButton:Sprite = new Sprite();
		
		[Embed(source='./assets/pause.png')]
		public static var PauseIcon:Class;
		private var pauseIcon:Bitmap = new PauseIcon();
		[Embed(source='./assets/pause-over.png')]
		public static var PauseOver:Class;
		private var pauseOver:Bitmap = new PauseOver();
		private var pauseButton:Sprite = new Sprite();
		
		[Embed(source='./assets/quit.png')]
		public static var QuitIcon:Class;
		private var quitIcon:Bitmap = new QuitIcon();
		[Embed(source='./assets/quit-over.png')]
		public static var QuitOver:Class;
		private var quitOver:Bitmap = new QuitOver();
		private var quitButton:Sprite = new Sprite();
		
		[Embed(source='./assets/trash.png')]
		public static var TrashIcon:Class;
		private var trashIcon:Bitmap = new TrashIcon();
		[Embed(source='./assets/trash-over.png')]
		public static var TrashOver:Class;
		private var trashOver:Bitmap = new TrashOver();
		private var trashButton:Sprite = new Sprite();
		
		[Embed(source='./assets/star.png')]
		public static var StarIcon:Class;
		private var starIcon:Bitmap = new StarIcon();
		[Embed(source='./assets/star-over.png')]
		public static var StarOver:Class;
		private var starOver:Bitmap = new StarOver();
		private var starButton:Sprite = new Sprite();

		[Embed(source='./assets/starFull.png')]
		public static var StarFullIcon:Class;
		private var starFullIcon:Bitmap = new StarFullIcon();
		[Embed(source='./assets/starFull-over.png')]
		public static var StarFullOver:Class;
		private var starFullOver:Bitmap = new StarFullOver();
		private var starFullButton:Sprite = new Sprite();

		public function Transport(){
			addEventListener( Event.ADDED, init );
		}
		
		private function init(e:Event):void{
			glob.addEventListener(GlobEvent.SET_STAR_FULL, setStar);

			//pauseButton
			pauseButton.addChild(pauseIcon);
			pauseButton.addChild(pauseOver);
			pauseOver.alpha=0;
			pauseOver.name='over';
			pauseButton.name='pauseButton';
			pauseButton.buttonMode=true;
			pauseButton.mouseChildren=false;
			pauseButton.addEventListener(MouseEvent.MOUSE_DOWN, onPauseDown);
			pauseButton.addEventListener(MouseEvent.MOUSE_OVER, onRollOver);
			pauseButton.addEventListener(MouseEvent.MOUSE_OUT, onRollOut);
			pauseButton.y=this.stage.stageHeight-pauseIcon.height-8;
			pauseButton.x=this.stage.stageWidth-pauseIcon.width-4;
			addChild(pauseButton);
			
			//playButton
			playButton.addChild(playIcon);
			playButton.addChild(playOver);
			playOver.alpha=0;
			playOver.name='over';
			playButton.name='playButton';
			playButton.buttonMode=true;
			playButton.mouseChildren=false;
			playButton.addEventListener(MouseEvent.MOUSE_DOWN, onPlayDown);
			playButton.addEventListener(MouseEvent.MOUSE_OVER, onRollOver);
			playButton.addEventListener(MouseEvent.MOUSE_OUT, onRollOut);
			playButton.visible=false;
			playButton.y=pauseButton.y;
			playButton.x=pauseButton.x;
			addChild(playButton);
			
			//quitButton
			quitButton.addChild(quitIcon);
			quitButton.addChild(quitOver);
			quitOver.alpha=0;
			quitOver.name='over';
			quitButton.name='quitButton';
			quitButton.buttonMode=true;
			quitButton.mouseChildren=false;
			quitButton.addEventListener(MouseEvent.MOUSE_DOWN, onQuitDown);
			quitButton.addEventListener(MouseEvent.MOUSE_OVER, onRollOver);
			quitButton.addEventListener(MouseEvent.MOUSE_OUT, onRollOut);
			quitButton.y=pauseButton.y;
			quitButton.x=4;
			addChild(quitButton);

			//trashButton
			trashButton.addChild(trashIcon);
			trashButton.addChild(trashOver);
			trashOver.alpha=0;
			trashOver.name='over';
			trashButton.name='trashButton';
			trashButton.buttonMode=true;
			trashButton.mouseChildren=false;
			trashButton.addEventListener(MouseEvent.MOUSE_DOWN, onTrashDown);
			trashButton.addEventListener(MouseEvent.MOUSE_OVER, onRollOver);
			trashButton.addEventListener(MouseEvent.MOUSE_OUT, onRollOut);
			trashButton.y=quitButton.y-16-8;
			trashButton.x=quitButton.x;
			//trashButton.y=quitButton.y-8;
			//trashButton.x=12+quitButton.x+quitButton.width;
			addChild(trashButton);

			//starFullButton
			starFullButton.addChild(starFullIcon);
			starFullButton.addChild(starFullOver);
			starFullOver.alpha=0;
			starFullOver.name='over';
			starFullButton.name='starButton';
			starFullButton.buttonMode=true;
			starFullButton.mouseChildren=false;
			starFullButton.addEventListener(MouseEvent.MOUSE_DOWN, onStarFullDown);
			starFullButton.addEventListener(MouseEvent.MOUSE_OVER, onRollOver);
			starFullButton.addEventListener(MouseEvent.MOUSE_OUT, onRollOut);
			starFullButton.y=playButton.y-16-8;
			starFullButton.x=playButton.x;
			//starButton.y=quitButton.y-8;
			//starButton.x=12+quitButton.x+quitButton.width;
			addChild(starFullButton);
			
			//starButton
			starButton.addChild(starIcon);
			starButton.addChild(starOver);
			starOver.alpha=0;
			starOver.name='over';
			starButton.name='starButton';
			starButton.buttonMode=true;
			starButton.mouseChildren=false;
			starButton.addEventListener(MouseEvent.MOUSE_DOWN, onStarDown);
			starButton.addEventListener(MouseEvent.MOUSE_OVER, onRollOver);
			starButton.addEventListener(MouseEvent.MOUSE_OUT, onRollOut);
			starButton.y=playButton.y-16-8;
			starButton.x=playButton.x;
			//starButton.y=quitButton.y-8;
			//starButton.x=12+quitButton.x+quitButton.width;
			addChild(starButton);
		}
		
		private function onRollOver(e:Event):void{
			Sprite(e.currentTarget).getChildByName('over').alpha=1;
		}
		
		private function onRollOut(e:Event):void{
			Sprite(e.currentTarget).getChildByName('over').alpha=0;
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

		private function onTrashDown(e:Event):void{
			dispatchEvent(new Event("TRASH") );			
		}

		private function onStarDown(e:Event):void{
			starButton.visible=false;
			starFullButton.visible=true;
			dispatchEvent(new Event("STAR_ON") );			
		}

		private function onStarFullDown(e:Event):void{
			starButton.visible=true;
			starFullButton.visible=false;
			dispatchEvent(new Event("STAR_OFF") );			
		}
		
		private function setStar(e:GlobEvent):void{
			if(e.params.full==true){
				starButton.visible=false;
				starFullButton.visible=true;
			}else{
				starButton.visible=true;
				starFullButton.visible=false;
			}
		}
		
	}//class
}//view	