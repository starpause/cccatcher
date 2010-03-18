package main {
	//adobe
	import flash.desktop.*;
	import flash.display.*;
	import flash.events.*;
	import flash.filesystem.File;
	import flash.ui.*;
	import flash.utils.*;
	
	import gs.TweenLite;
	import gs.easing.*;
	
	import mx.core.WindowedApplication;
	
	import utils.FileSystem;
	import utils.Utils;
	
	import view.CoverDisplay;
	import view.HitBox;
	import view.NfoDisplay;
	import view.Progress;
	import view.SoundEngine;
	import view.Time;
	import view.Transport;
			
	public class CCCatcher extends WindowedApplication{
		[Embed(source='../assets/SWFIT_SL.TTF', fontName='_swfit')]
		public static var _swfit:Class;
		
		[Embed(source='../assets/_uni05_53.ttf', fontName='_uni05')]
		public static var _uni05:Class;
								
        static private var model:Model = Model.instance;
		static private var glob:Glob = Glob.instance;
		
		private var cm:ContextMenu = new ContextMenu();
		
		private var randomCover:CoverDisplay = new CoverDisplay();			
		private var soundEngine:SoundEngine = new SoundEngine();
		private var timeDisplay:Time = new Time();
		private var nfoDisplay:NfoDisplay = new NfoDisplay();
		private var hitBox:HitBox = new HitBox();
		private var transport:Transport = new Transport();
		private var progress:Progress = new Progress();
		
		//double click emulation
		private var leftClicks:int = 0;
		private var rightClicks:int = 0;
		private var clickWindow:Timer = new Timer(250,1);
		private var waitToDrag:Timer = new Timer(40,1);
		private var shiftKeyDown:Boolean = false;
		private var mouseLeftDown:Boolean = false;
		private var mouseRightDown:Boolean = false;
		
		private var alphaDiv:Sprite = new Sprite();
		private var alphaValue:Number = .8;
		
		private var dropFiles:Array;
		private var dropFilesTotal:int;
		private var populateInProgress:Boolean;
		private var dropInProgress:Boolean;
		private var populateTimer:Timer;
			
		public function CCCatcher(){
		}

//- SETUP -//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//-
        public function init():void {
            stage.nativeWindow.visible = false;
            this.setStyle("backgroundAlpha", .0);
			this.alwaysInFront = true;
			stage.nativeWindow.addEventListener(Event.CLOSING, windowClosingHandler); 
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp);
			
			alphaDiv.alpha = alphaValue;
			alphaDiv.addEventListener(MouseEvent.MOUSE_OVER, onAlphaDivOver);
			alphaDiv.addEventListener(MouseEvent.MOUSE_MOVE, onAlphaDivOver);
			alphaDiv.addEventListener(MouseEvent.MOUSE_OUT, onAlphaDivOut);

			stage.addChild(alphaDiv);
			
			//controller business
			glob.addEventListener(GlobEvent.SOUND_LOADED, onSoundLoaded);
			glob.addEventListener(GlobEvent.UPDATE_TIME, updateTime);
			//glob.addEventListener(GlobEvent.FILE_DROP, populatePlaylist);
									
			//randomCover.alpha = alphaValue;
			alphaDiv.addChild(randomCover);
							
			//double click emulation
			clickWindow.addEventListener(TimerEvent.TIMER, clickWindowExpired);
			//attach sh*t to the hitbox
			hitBox.buttonMode = true;
			hitBox.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER,onDragIn);				
			hitBox.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP,onDrop);
			hitBox.addEventListener(NativeDragEvent.NATIVE_DRAG_EXIT,onDragExit);
			hitBox.addEventListener(MouseEvent.MOUSE_DOWN, hitBoxLeftDown);
			hitBox.addEventListener(MouseEvent.MOUSE_UP, hitBoxLeftUp);
			//hitBox.addEventListener(MouseEvent.CLICK, hitBoxLeftClick);
			hitBox.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, hitBoxRightDown);
			hitBox.addEventListener(MouseEvent.RIGHT_MOUSE_UP, hitBoxRightUp);
			//hitBox.contextMenu = cm;
			alphaDiv.addChild(hitBox);
			
			//nfo display
			nfoDisplay.buttonMode = true;
			nfoDisplay.useHandCursor = true;
			nfoDisplay.visible = false;
			nfoDisplay.contextMenu = cm;
			alphaDiv.addChild(nfoDisplay);


			timeDisplay.buttonMode=true;
			timeDisplay.useHandCursor=true;
			timeDisplay.visible=false;
			//timeDisplay.useHandCursor = true;//auto display fwd/bak hint text   << >>
			//timeDisplay.x = int(stage.width/2 - timeDisplay.width/2);
			//timeDisplay.y = int(stage.height - 15);
			timeDisplay.addEventListener("LEFT_SINGLE_CLICK", clickTime);
			timeDisplay.addEventListener("LEFT_SHIFT_CLICK", onPauseSelect);
			timeDisplay.addEventListener("RIGHT_SHIFT_CLICK", onPauseSelect);
			timeDisplay.addEventListener("RIGHT_SINGLE_CLICK", rightClickTime);
			alphaDiv.addChild(timeDisplay);
			
			//play+pause+quit
			transport.visible=false;
			transport.addEventListener("PAUSE", onPauseSelect);
			transport.addEventListener("PLAY", onPauseSelect);
			transport.addEventListener("QUIT", onQuitSelect);
			transport.addEventListener("TRASH", onDeleteSelect);
			transport.addEventListener("STAR_ON", onStarSelect);
			transport.addEventListener("STAR_OFF", onStarSelect);
			alphaDiv.addChild(transport);
			
			//red progress pie
			//progress.visible=false;
			alphaDiv.addChild(progress);
			
			//clean dead items out of the TrackList
			configureContextMenu();
			loadWindowPosition();
			
			//start timer for update song position
			var myTimer:Timer = new Timer(50);
			myTimer.addEventListener('timer', updateTime);
			myTimer.start();
        }
        
        private function hoverCheck(e:Event):void{
        	if(this.mouseX > 0 && this.mouseY > 0 && this.mouseX < 128 && this.mouseY < 128){
        		//trace('huffa: '+this.mouseX+' '+this.mouseY);
        	}else{
        		//trace('gone: '+this.mouseX+' '+this.mouseY);
        	}
        }

        private function configureContextMenu():void{            			
			stage.showDefaultContextMenu = true;
			cm.hideBuiltInItems();
			
			/*var pause:ContextMenuItem = new ContextMenuItem("Pause");
			pause.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onPauseSelect);
			cm.customItems.push(pause);*/

			//var star:ContextMenuItem = new ContextMenuItem("Star");
			//star.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onStarSelect);
			//cm.customItems.push(star);
			
			//var delTrack:ContextMenuItem = new ContextMenuItem("Delete");
			//delTrack.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onDeleteSelect);
			//cm.customItems.push(delTrack);

			var clear:ContextMenuItem = new ContextMenuItem("Flush");
			clear.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onClearSelect);
			cm.customItems.push(clear);
			
			//stars only as a submenu, flush could go in this submenu too
			/*
			var subMenu:NativeMenu = new NativeMenu();
			var starsOnly:NativeMenuItem = new NativeMenuItem("Stars Only");
			starsOnly.addEventListener(Event.SELECT, onStarsOnly);
			subMenu.addItem(starsOnly);
			cm.addSubmenu(subMenu,"Playlist");
			
			
			var quit:ContextMenuItem = new ContextMenuItem("Quit");
			quit.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onQuitSelect);
			cm.customItems.push(quit);
			*/
        }
        
        private function loadWindowPosition():void{
			stage.nativeWindow.x = model.windowX;
			stage.nativeWindow.y = model.windowY;
			//stage.nativeWindow.width = prefsXML.windowState.@width;
			//stage.nativeWindow.height = prefsXML.windowState.@height;
        	stage.nativeWindow.visible = true;
        	erectPlayer();
        }
		
        private function erectPlayer():void{
			var storedRandomSong:String = model.currentRandomSong;
			//special case: first time app is run there's no song to play =(
			if(storedRandomSong == ''){
				return;
			}
							
			//if the storedRandomSong is exists, play it
        	if(FileSystem.nativePathExists(storedRandomSong) == true){
        		soundEngine.forceTrack = storedRandomSong;
        		soundEngine.playNext();
			}else{//we randomly play a song like usual
				soundEngine.playNext();
			}
		}


//- UTIL -//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//-
		/** Takes an array of files and folders & retuns an array of just files, excluding hidden files */
		private function cleanFileArray(files:Array):Array{
			var arrayToReturn:Array = new Array();
			
			for each (var fileOrDir:File in files){
				if( fileOrDir.isDirectory ){
					// If we find a directory, call this method again to extract the files
					// This will recurse until there are only files in the returning array
					var subArray:Array = this.cleanFileArray( fileOrDir.getDirectoryListing() );
					arrayToReturn = arrayToReturn.concat( subArray ); // Combin the files with the arrayToReturn
				}else if( fileOrDir.isHidden ){
					// Skip hidden files
				}else{
					// If we have a file add it to the array of files to return
					arrayToReturn.push( fileOrDir );
				}
			}
			return arrayToReturn;
		}
		
		private function tagCurrentTrack():void{
			var currentRandomSong:String = model.currentRandomSong;
			var renameName:String;
			if( currentRandomSong.indexOf(model.tagCopy) == -1 ){
				renameName = currentRandomSong.replace('.mp3', model.tagCopy+'.mp3');
				//trace(renameName);				
			}else{
				renameName = currentRandomSong.replace(model.tagCopy, '');
			}
			FileSystem.rename(currentRandomSong, renameName);
			model.renameTrack(currentRandomSong, renameName);
			model.currentRandomSong = renameName;
			nfoDisplay.refreshWith(renameName);
		}
		
		/** randomPlay() the next track, delete the file from the filesystem. */
		private function deleteCurrentTrack():void{
			var nativePathToNuke:String = model.currentRandomSong;
			soundEngine.playNext();
			
			var tempFile:File = new File(nativePathToNuke);
			//tempFile = tempFile.resolvePath(nativePathToNuke);
			tempFile.moveToTrashAsync();
			
			//FileSystem.remove(nativePathToNuke);
			//model.removeTrack(currentRandomSong);//not 100% necessary since model.randomPlay() will delete any nulls it finds in the tracklist
		}

//- UI HANDLERS -//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//-            
		//drag & drop handlers
		public function onDragIn(event:NativeDragEvent):void{
		    NativeDragManager.dropAction = NativeDragActions.MOVE;
		    if(event.clipboard.hasFormat(ClipboardFormats.FILE_LIST_FORMAT)){
		    	//stop the user from dropping if we're still processing the last drop
		    	if(dropInProgress==true){return;}
		    	NativeDragManager.acceptDragDrop(hitBox);
		    }
		}
		public function onDrop(event:NativeDragEvent):void{
			dropFiles = event.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
			dropFiles = cleanFileArray(dropFiles);
			dropFilesTotal = dropFiles.length;
			
			if(dropFiles.length==1){
				//user can drop a single mp3 onto CCCATCHER for instant-play
				model.addTrack(File(dropFiles[0]).nativePath);
				soundEngine.forceTrack=(dropFiles[0] as File).nativePath;
				soundEngine.playNext();
			} else{
				//we have to populate the playlist with all the files that got dropped
				startPopulateTimer();
			}
		}
		
		private function startPopulateTimer():void{
			trace('startPopulateTimer()');
			//so user doesn't do another drop while we are processing the last one
			dropInProgress=true;
			//clear display
			progress.update(0);
			progress.visible=true;	
			//timer biz
			populateTimer = new Timer(10);		
			populateTimer.addEventListener(TimerEvent.TIMER, populatePlaylist);
			populateTimer.start();
		}
		
		private function stopPopulateTimer():void{
			trace('stopPopulateTimer()');
			populateTimer.stop();
			populateTimer = null;

			dropInProgress=false;
			populateInProgress=false;
			progress.visible=false;
						
			//we have never played, go at it! so the user doesn't have to double click when dragging files on for the first time
			if(soundEngine._channel.position==0){
				soundEngine.playNext();
			}			
		}
		
		/**
		 * populatePlaylist is an Asynchronous operation so that the display can update while files are being processed
		 * based on notes at http://www.senocular.com/flash/tutorials/asyncoperations/
		 */
		private function populatePlaylist(e:Event=null):void{			
			if(dropFiles.length <= 0){
				stopPopulateTimer();
				return;
			}
			
			//if we're already running a call of populatePlaylist from the timer, escape
			if(populateInProgress==true){
				return;
			}else{
				populateInProgress=true;
			}
			
			//add the files to our playlist
			var i:int=0;
			while(dropFiles.length > 0){
				
				//take a break from populating every once in a while so the screen can update
				if(i >= 10){
					populateInProgress=false;
					return;
				}
				
				var file:File = dropFiles[0];
				//trace('file.nativePath '+file.nativePath);
				switch (file.extension){
					case "mp3":
						if(file.name.indexOf('.')==0){/*it's a hidden file with the . at the start*/
							//skipCount++;
							break;
						}
						if(model.trackAlreadyAdded(file.nativePath)==false){
							trace('onDrop() add file.nativePath: '+file.nativePath);
							model.addTrack(file.nativePath);
							//addedCount++;
						}else{
							//skipCount++;
						}
						break;
					default:
						//skipCount++;
						break;
						//trace(file.name+" not a recognised file format"); 
				}
				
				progress.update((dropFilesTotal-dropFiles.length)/(dropFilesTotal+1));
				
				dropFiles.shift();
				if(dropFiles.length==0){
					stopPopulateTimer();
					return;
				}
				i++;
			}
			//trace('onDrop() added '+addedCount+', skipped '+skipCount);
		}
		
		public function onDragExit(event:NativeDragEvent):void{
		    //trace("Drag exit event.");
		}
		
		private function windowClosingHandler(event:Event=null):void {
			model.saveWindowState(stage.nativeWindow.x, stage.nativeWindow.y);
			model.saveChannelState(soundEngine._channel.position);
			model.writeXMLData();
		}

		//kb handlers			
		private function onKeyDown(e:KeyboardEvent):void{
			if(e.keyCode == Keyboard.SHIFT){
				shiftKeyDown = true;					
			}
		}
		private function onKeyUp(e:KeyboardEvent):void{
			if(e.keyCode == Keyboard.SHIFT){
				shiftKeyDown = false;
			}
		}

		public function mouseDrag(e:Event=null):void {
			trace('mouseDrag()');
        	//Mouse.cursor = MouseCursor.HAND;
			stage.nativeWindow.startMove();
		}
		
		private function hitBoxRightDown(event:MouseEvent):void{
			trace('hitBoxRightDown()');
			if(mouseLeftDown==true){
				onPauseSelect();
			}
			rightClicks++;
			clickWindow.start();
			mouseRightDown=true;
		}
		private function hitBoxLeftDown(e:MouseEvent):void{
			trace('hitBoxLeftDown()');
			//if(mouseRightDown==true){onPauseSelect()}
			
			mouseLeftDown=true;
						
			waitToDrag.addEventListener(TimerEvent.TIMER, mouseDrag);
			waitToDrag.start();
			
			leftClicks++;
			clickWindow.start();				
		}
		private function hitBoxLeftUp(e:MouseEvent):void{
			trace('hitBoxLeftUp()');
        	//Mouse.cursor = MouseCursor.AUTO;				
			waitToDrag.stop();
			mouseLeftDown=false;
		}
		private function hitBoxRightUp(e:MouseEvent):void{
			//trace('R up');
			mouseRightDown=false;
		}
		
		private function clickTime(e:Event):void{
			soundEngine.fastForward();
		}
		
		private function rightClickTime(e:Event):void{
			soundEngine.rewind();
		}
		
		private function hitBoxLeftClick(event:MouseEvent):void{
			leftClicks++;
			clickWindow.start();
		}
		private function clickWindowExpired(event:TimerEvent):void{
			if(leftClicks==1){
				leftSingleClick();
			}else if(leftClicks > 1){
				leftDoubleClick();
			}else if(rightClicks==1){
				//rightSingleClick();
			}else if(rightClicks>1){
				rightDoubleClick();
			}
			clickWindow.stop();
			leftClicks=0;
			rightClicks=0;
		}
		
		private function leftSingleClick():void{
			if(shiftKeyDown == true){
			}
		}
		private function leftDoubleClick():void{
			if(shiftKeyDown == true){
				randomCover.refreshWith(model.currentRandomSong);
			}
			else{
				soundEngine.playNext();
			}
		}
		private function rightDoubleClick():void{
			if(shiftKeyDown == true){
				//move current image to trash
			}
			else{
				soundEngine.playPrevious();
			}
		}
		
        private function onAlphaDivOver(e:MouseEvent):void{
        	TweenLite.killTweensOf(transport);
        	transport.visible=true;
        	transport.alpha=1;

        	TweenLite.killTweensOf(nfoDisplay);
        	nfoDisplay.visible=true;
        	nfoDisplay.alpha=1;

        	TweenLite.killTweensOf(timeDisplay);
        	timeDisplay.visible = true;
        	timeDisplay.alpha=1;

        	TweenLite.killTweensOf(alphaDiv);
        	alphaDiv.alpha = 1;
        }
        
        private function onAlphaDivOut(e:Event):void{
        	//tween out
        	TweenLite.to(transport, 2, {autoAlpha:0, ease:Expo.easeOut});
        	TweenLite.to(nfoDisplay, 2, {autoAlpha:0, ease:Expo.easeOut});
        	TweenLite.to(timeDisplay, 2, {autoAlpha:0, ease:Expo.easeOut});
        	TweenLite.to(alphaDiv, 5, {alpha:alphaValue, ease:Expo.easeOut});
        }
        
			
//- MENU ITEM HANDLERS -//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//-
		private function onStarSelect(e:Event=null):void{
			tagCurrentTrack();
		}
		private function onDeleteSelect(e:Event=null):void{
			deleteCurrentTrack();
		}
		private function onPauseSelect(e:Event=null):void{
			this.mouseLeftDown=false;
			this.mouseRightDown=false;
			soundEngine.togglePlay();
		}
		private function onQuitSelect(e:Event=null):void{
			windowClosingHandler();
			//NativeApplication.nativeApplication.exit();
			nativeApplication.exit();
		}
		private function onClearSelect(e:Event=null):void{
			model.removeAllTracks();
		}
		private function onConfigSelect(e:Event=null):void{
			//todo =(
		}
		
//- SOUND ENGINE HANDLERS -//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//---//-
		private function updateTime(e:Event=null):void{
			var elapsedSeconds:String = Utils.formatTime(soundEngine._channel.position/1000);
			var totalSeconds:String = Utils.formatTime(soundEngine._songCurrent.length/1000);
			timeDisplay.display(elapsedSeconds,totalSeconds);
			//display
		}
		private function onSoundLoaded(e:Event):void{
			nfoDisplay.refreshWith(model.currentRandomSong);
			randomCover.refreshWith(model.currentRandomSong);	
			if( model.currentRandomSong.indexOf(model.tagCopy) == -1 ){
				glob.dispatchEvent(new GlobEvent(GlobEvent.SET_STAR_FULL, {full:false}));
			}else{
				glob.dispatchEvent(new GlobEvent(GlobEvent.SET_STAR_FULL, {full:true}));
			}
			
						
		}
		
		
	
		
		
	}
}
