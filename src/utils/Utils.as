package utils{
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
			var hString:String = hours < 10 ? "0" + hours : "" + hours;	
			var mString:String = minutes < 10 ? "0" + minutes : "" + minutes;
			var sString:String = seconds < 10 ? "0" + seconds : "" + seconds;
						
			if ( time < 0 || isNaN(time)) return "00:00";			
			
			if ( hours > 0 ){			
				return mString + ":" + sString;//return hString + ":" + mString + ":" + sString;
			}else{
				return mString + ":" + sString;
			}
		}

		public function Utils(seed:uint=0) {
			throw(new Error("the Utils class cannot be instantiated"));
		}
	}
}