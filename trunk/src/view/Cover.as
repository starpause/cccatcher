package view{
	import flash.display.*;
	
	import utils.Rnd;

	public class Cover extends Sprite{
		private var WINDOW_PX:int = 128;
		
		public function Cover(image:Bitmap=null){
			if(image==null){
				//insert default image here instead of in CoverDisplay?
			}
						
			resizeCover(image);
			panCover(image);
			maskThe(image);
			addChild(image);
		}
		
		private function maskThe(image:Bitmap):void{
			var masker:Sprite = new Sprite();
			addChild(masker);
			masker.graphics.beginFill(0x0000FF);
			masker.graphics.drawRect(0,0,WINDOW_PX,WINDOW_PX); //stage.stageWidth,stage.stageHeight
			masker.graphics.endFill();
			image.mask = masker;
		}

		/**
		 * Make sure the window will be covered 100%  
		 * by picking the smallest side and scaling it to be the same width/height as the player window.
		 * @param event Event.COMPLETE from imageLoader:Loader
		 */
		private function resizeCover(image:Bitmap):void{
			var scaleBy:Number;
			//trace(event.image.content.width+'x'+event.image.content.height);
			if(image.width < image.height){//if width smaller, scale by width
				scaleBy = WINDOW_PX / image.width;
			}else{//if height smaller, scale by height
				scaleBy = WINDOW_PX / image.height;
			}
			image.scaleX = scaleBy;
			image.scaleY = scaleBy;
		}

		/**
		 * Randomly pan up/down & left/right so the user doesn't always see the same slice of the scaled image.
		 * Math makes sure the image still covers the entire application window.
		 * @param event Event.COMPLETE from imageLoader:Loader
		 */
		private function panCover(image:Bitmap):void{
			image.x = Rnd.float(image.width - WINDOW_PX) * -1;
			image.y = Rnd.float(image.height - WINDOW_PX) * -1;
			//trace('panCover achieves '+event.target.content.x+'x'+event.target.content.y);
		}
		
	}//class
}//package