package view{
	import flash.display.*;
	
	public class HitBox extends Sprite{
		public function HitBox(){
			this.graphics.beginFill(0xFFFFFF);
			this.graphics.drawRect(0,0,128,128); //stage.stageWidth,stage.stageHeight
			this.graphics.endFill();
			this.alpha = 0;
		}

	}//class
}//package