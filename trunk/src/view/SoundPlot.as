package view {
	import flash.ui.Mouse;
	import flash.display.MovieClip;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextField;

	import utils.Utils;

	import flash.events.MouseEvent;
	import flash.media.Sound;

	import main.GlobEvent;

	import flash.events.Event;
	import flash.display.BitmapData;

	import main.Glob;
	import main.Model;

	import flash.geom.Point;
	import flash.display.Bitmap;
	import flash.display.Sprite;

	import efnx.sound.Waveform;
	import efnx.events.WaveformEvent;
	import efnx.general.Component;
	import efnx.gfx.Raster;

	/**
	 * @author jgray
	 */
	public class SoundPlot extends Sprite {
		//globals
		static private var model : Model = Model.instance;
		static private var glob : Glob = Glob.instance;

		private var plotter : Waveform;
		private var waveFull : Bitmap = new Bitmap();
		private var wavePlayed : Bitmap = new Bitmap();
		private var waveMask : Bitmap = new Bitmap();
		private var seekHead : Sprite = new Sprite();
		private var seekField : TextField = new TextField();
		private var seekFill : Bitmap = new Bitmap();
		private var dx : int = 0;
		private const TALL : int = 128 / 6;

		//private var method : String = "rms";
		//private var playhead:Bitmap = new Bitmap();
		//private var selection:Bitmap = new Bitmap();

		public function SoundPlot() {
			addEventListener(Event.ADDED, onAdded);			
		}

		private function onAdded(e : Event) : void {
			glob.addEventListener(GlobEvent.SOUND_LOADED, onSoundLoaded);
			glob.addEventListener(GlobEvent.UPDATE_TIME, onUpdateTime);
			this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			this.addEventListener(MouseEvent.CLICK, onMouseClick);
			
			this.buttonMode = true;
			this.useHandCursor = true;
			
			waveFull.y = model.STAGE_WIDTH - TALL;
			this.addChild(waveFull);			

			wavePlayed.y = model.STAGE_WIDTH - TALL;
			this.addChild(wavePlayed);

			waveMask.y = model.STAGE_WIDTH - TALL;
			wavePlayed.mask = waveMask;	
			this.addChild(waveMask);
			
			seekHead.mouseEnabled = false;
			seekHead.mouseChildren = false;
			seekHead.y = model.STAGE_WIDTH - TALL;
			this.addChild(seekHead);
			
			
			seekFill.bitmapData = new BitmapData(1, TALL, false, 0xFFFFFF00);
			seekHead.addChild(seekFill);
			
			seekField.defaultTextFormat = new TextFormat("_progtiny", 16, 0xFFFF00);
			seekField.embedFonts = true;
			seekField.multiline = false;
			seekField.wordWrap = false;
			seekField.border = false;
			seekField.selectable = false;
			seekField.width = 40;
			seekField.y = TALL - 12;
			seekField.x = -16;
			seekHead.addChild(seekField);
		}

		private function redrawWave() : void {
			//stick the plot at the bottom of the screen
			waveFull.bitmapData = new BitmapData(model.STAGE_WIDTH, TALL, true, 0x00FFFFFF);
			//display the play progress using a 2nd wave on top of the 1st one
			wavePlayed.bitmapData = new BitmapData(model.STAGE_WIDTH, TALL, true, 0x00FFFFFF);
			//mask the wavePlayed so we can unmask it as progress occurs
			waveMask.x = -model.STAGE_WIDTH;
			waveMask.bitmapData = new BitmapData(model.STAGE_WIDTH, TALL, true, 0x00FFFFFF);
			//cursor that shows up where the mouse is at so user can seek
			seekHead.alpha = 0;
		}

		private function onMouseClick(event : MouseEvent) : void {
			glob.dispatchEvent(new GlobEvent(GlobEvent.WAVE_CLICK, {positionAsPercent: event.localX / model.STAGE_WIDTH}));
			trace(event.localX);
		}

		private function onMouseMove(event : MouseEvent) : void {
			Mouse.hide();
			seekHead.alpha = 1;
			seekHead.x = event.localX;
			seekField.text = Utils.formatTime(((event.localX / model.STAGE_WIDTH) * model.currentSongLength) / 1000);
		}

		private function onMouseOut(event : MouseEvent) : void {
			Mouse.show();
			seekHead.alpha = 0;
		}

		private function onUpdateTime(event : GlobEvent) : void {
			waveMask.x = model.STAGE_WIDTH * (event.params.position / event.params.length) - model.STAGE_WIDTH;
		}

		public function onLoadProgress(event : Event) : void {
			//draw something?
		}

		public function onSoundLoaded(event : GlobEvent) : void {
			var mp3 : Sound = event.params.songCurrent;			
			redrawWave();
			dx = 0;

			if(plotter != null) {
				//kill listeners, if we don't sometimes the wave display gets spikey when loading a new track over an old one
				plotter.cancel();
				plotter.removeEventListener("progress", onWindowAnalyze);
				plotter.removeEventListener("complete", onAnalyzeComplete);
			}
			plotter = new Waveform();
			plotter.sound = mp3;
			plotter.leftSample = 0;
			plotter.rightSample = mp3.length * 44.1;
			plotter.numWindows = waveFull.bitmapData.width;
			plotter.addEventListener("progress", onWindowAnalyze, false, 0, true);
			plotter.addEventListener("complete", onAnalyzeComplete, false, 0, true);
			plotter.createWaveform("rms");			
		}

		/**
		 *	Draws the analyzed data sent from plotter.
		 */
		public function onWindowAnalyze(event : WaveformEvent) : void {
			var h : int = waveFull.bitmapData.height;
			var a : int = event.windowsAnalyzed;
			var l : Number = event.leftChunk.length;
			var r : Number = event.rightChunk.length;
			var scaleUp : Number = 2.5; //crazy magic number, doing this because i mp3gain all my files. ideal solution would be to scale after determining the max value.
			
			//summing the left and right channels rather than drawing top/bottom
			for (var i : int = 0;i < l;i++) {
				var lv : Number = event.leftChunk[i];
				var rv : Number = event.rightChunk[i];
				var sum : Number = h - h * scaleUp * Math.abs(lv + rv);
				if(sum < 0){
					sum = h - h * Math.abs(lv + rv);
				}
				Raster.line(waveFull.bitmapData, dx + i, sum, dx + i, h, 0xFF808080);
				Raster.line(wavePlayed.bitmapData, dx + i, sum, dx + i, h, 0xFFa0a0a0);
				//trace('onWindowAnalyze: '+sum+', '+lv+', '+rv);
			}
			/*
			for (var j:int = 0; j < r; j++){
			var rv:Number = event.rightChunk[j];
			Raster.line(waveform.bitmapData, dx+j, h/2+h/2*Math.abs(rv), dx+j, h/2, 0xFFC25BCC);
			}
			 * 
			 */
			dx += i;
		}

		/**
		 *	Called when analyzation is complete.
		 */
		public function onAnalyzeComplete(event : Event) : void {
			//trace("Waveform_Main::onAnalyzeComplete()");
		}
	}
}
