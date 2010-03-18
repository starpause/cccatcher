package view{
	//adobe
	import flash.display.*;
	
	public class Progress extends Sprite{
		private var fillColor:Number = 0xFF0000;
		private var offset:Number = 90; // Initial angle
		//private var degChange:Number = 1; // Amount angle will change on each click
		private var circleR:Number = 16; // Circle radius (in pixels)
		private var circleX:Number = 64; // Screen coordinates of center of circle
		private var circleY:Number = 64;
		//private var angleR:Number = circleR/4; // Radius of circular arc that illustrates the angle
		private var shFill:Shape = new Shape();
		private var spBoard:Sprite = new Sprite();	

		public function Progress(){
			spBoard.x = circleX;
			spBoard.y = circleY;
			addChild(spBoard);
			
			spBoard.addChild(shFill);
			//update(.90);
		}
		
		public function update(percent:Number):void{
			var t:Number = 360*(1-percent); //t is in degrees
			//var radianAngle:Number = t*Math.PI/180.0;
			
			shFill.graphics.clear();
			shFill.graphics.lineStyle(1,fillColor);
			shFill.graphics.moveTo(0,0);
			shFill.graphics.beginFill(fillColor,1);//.7			
			
			// The loop draws tiny lines between points on the circle one
			// separated from each other by one degree.
			for (var i:int=0+offset; i<=(t+offset); i++) {
				shFill.graphics.lineTo(circleR*Math.cos(i*Math.PI/180), -circleR*Math.sin(i*Math.PI/180) );
				//shAngle.graphics.lineTo(angleR*Math.cos(i*Math.PI/180), -angleR*Math.sin(i*Math.PI/180));
			}
			
			//The final lineTo outside of the loop takes the "pen" back to its starting point.
			shFill.graphics.lineTo(0,0);
			
			//Since the drawing is between beginFill and endFill, we get the filled shape.
			shFill.graphics.endFill();
		}



	}
}