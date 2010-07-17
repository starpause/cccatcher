package main {
	import flash.events.Event;
	
	public class GlobEvent extends Event {
		public static const SOUND_LOADED:String = "SOUND_LOADED";
		public static const UPDATE_TIME:String = "UPDATE_TIME";
		public static const SET_STAR_FULL:String = "SET_STAR_FULL";
		public static const FILE_DROP:String = "FILE_DROP";
		public static const TRACK_PLAYING:String = "TRACK_PLAYING";
		public static const WAVE_CLICK:String = "WAVE_CLICK";
		
		public var params:Object;
		private var _type:String;
		
		public function GlobEvent($type:String, $params:Object = null) {
			super($type, true, true);
			this._type = $type;
			this.params = $params;
		}

		public override function clone():Event {
			return new GlobEvent(this.type,this.params);
		}
		
		override public function toString():String {
			return ("[Event GlobEvent], type:"+_type);
		}
		
	}
}