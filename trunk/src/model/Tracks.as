package model{
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	
	public class Tracks{
		private var conn:SQLConnection = new SQLConnection();
		private var dbFile:File;

		public function Tracks(){
			conn.addEventListener(SQLEvent.OPEN, openHandler);
			conn.addEventListener(SQLErrorEvent.ERROR, errorHandler);
			dbFile = File.applicationStorageDirectory.resolvePath("DBSample.db");
			conn.openAsync(dbFile);
		}
		
		public function createTable():void{
			var createStmt:SQLStatement = new SQLStatement();
			createStmt.sqlConnection = conn;
			
			var sql:String = 
			    "CREATE TABLE IF NOT EXISTS employees (" + 
			    "    empId INTEGER PRIMARY KEY AUTOINCREMENT, " + 
			    "    nativePath TEXT, " + 
			    "    playedFlag TEXT" + 
			    ")";

			createStmt.text = sql;			
			createStmt.addEventListener(SQLEvent.RESULT, createResult);
			createStmt.addEventListener(SQLErrorEvent.ERROR, createError);
			createStmt.execute();
		}
		
		private function openHandler(event:SQLEvent):void{
		    trace("the database was created successfully");
		}
		
		private function errorHandler(event:SQLErrorEvent):void{
		    trace("Error message:", event.error.message);
		    trace("Details:", event.error.details);
		}

		private function createResult(event:SQLEvent):void{
		    trace("Table created");
		}
		
		private function createError(event:SQLErrorEvent):void{
		    trace("Error message:", event.error.message);
		    trace("Details:", event.error.details);
		}
		


	} //end class
} //end package 
