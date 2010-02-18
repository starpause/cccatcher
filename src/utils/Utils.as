package utils{
	//duplicateDisplayObject includes:
	import flash.geom.Rectangle;
	import flash.display.*;
	
	public class Utils{
		
		/**
		 * @author andrewwright
         * returns time in hh:mm:ss format from seconds
         */
		public static function formatTime(time:Number):String{
			var remainder:Number;
			var hours:Number = time / ( 60 * 60 );
			remainder = hours - (Math.floor ( hours ));
			hours = Math.floor ( hours );
			var minutes:Number = remainder * 60;
			remainder = minutes - (Math.floor ( minutes ));
			minutes = Math.floor ( minutes );
			var seconds:Number = remainder * 60;
			remainder = seconds - (Math.floor ( seconds ));
			seconds = Math.floor ( seconds );
			var mString:String = minutes < 10 ? "0" + minutes : "" + minutes;
			var sString:String = seconds < 10 ? "0" + seconds : "" + seconds;
						
			if ( time < 0 || isNaN(time)) return "00:00";			
			
			if ( hours > 0 ){			
				return mString + ":" + sString;//return hString + ":" + mString + ":" + sString;
			}else{
				return mString + ":" + sString;
			}
		}

		/**
		 * duplicateDisplayObject
		 * creates a duplicate of the DisplayObject passed.
		 * similar to duplicateMovieClip in AVM1
		 * @param target the display object to duplicate
		 * @param autoAdd if true, adds the duplicate to the display list
		 * in which target was located
		 * @return a duplicate instance of target
		 */
		public static function duplicateDisplayObject(target:DisplayObject, autoAdd:Boolean = false):DisplayObject {
		    // create duplicate
		    var targetClass:Object = Object(target).constructor;
		    var duplicate:DisplayObject = new targetClass();
		    
		    // duplicate properties
		    duplicate.transform = target.transform;
		    duplicate.filters = target.filters;
		    duplicate.cacheAsBitmap = target.cacheAsBitmap;
		    duplicate.opaqueBackground = target.opaqueBackground;
		    if (target.scale9Grid) {
		        var rect:Rectangle = target.scale9Grid;
		        // WAS Flash 9 bug where returned scale9Grid is 20x larger than assigned
		        // rect.x /= 20, rect.y /= 20, rect.width /= 20, rect.height /= 20;
		        duplicate.scale9Grid = rect;
		    }
		    
		    // add to target parent's display list
		    // if autoAdd was provided as true
		    if (autoAdd && target.parent) {
		        target.parent.addChild(duplicate);
		    }
		    return duplicate;
		}

		public function Utils(seed:uint=0) {
			throw(new Error("the Utils class cannot be instantiated"));
		}
	}
}