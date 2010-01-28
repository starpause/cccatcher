/** 
 * Glob is short for Global OR a nasty object we stick stuff on to access all over. A Boy and His Glob? 
 * 
 * Implementation of 'EventCentral' adopted from http://www.angryrocket.com/?p=113 
 * The Glob is a Singleton class which extends flash.events.EventDispatcher and is used across the project classes to dispatch and listen to project events. 
 * The project events are all public static constants in the second class called “GlobEvent.as”. The GlobEvent extends flash.events.Events."
 * 
 * To set up a listener and its corresponding function, it’s very simple:
 * Glob.getInstance().addEventListener(GlobEvent.SOME_EVENT, handleSomeEvent);
 * function handleSomeEvent(event:ProjectEvent):void {trace(event.params.param1);}
 * 
 * Finally, to dispatch the event, with a parameter, we use the following:
 * Glob.getInstance().dispatchEvent(new GlobEvent(GlobEvent.SOME_EVENT, {param1:'something'}));
 * 
 * */
package main {
	import flash.events.EventDispatcher;
	import flash.events.Event;
	
	public class Glob extends EventDispatcher {
		private static const _instance:Glob = new Glob(SingletonLock); // Storage for the singleton instance.
		
  		public static function get instance():Glob{ return _instance; }
		
		/** @param lock The Singleton lock class to pevent outside instantiation. */
		public function Glob(lock:Class){
			super();
			if ( lock != SingletonLock ){
				throw new Error( "Invalid Singleton access, use Glob.instance" );
			}
			//normal construction continues here
			init();
		}

		private function init():void{
		}
				
		public override function dispatchEvent($event:Event):Boolean {
			return super.dispatchEvent($event);
		}
		
	}
}

internal class SingletonLock{
}