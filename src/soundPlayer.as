package
{
	//Morteza Khodadadi 1391/4/29
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.display.MovieClip;
	import flash.net.URLRequest;
	import flash.media.SoundLoaderContext;

	public class soundPlayer extends MovieClip
	{
		public var mySound:Sound;
		public var myChannel:SoundChannel;
		var myTransform:SoundTransform;
		var lastPosition:Number;
		var played:Boolean;
		
		public var duration:Number;
		public var playing:Boolean;

		private var _loaded:Boolean = false;
		
		private const buffer:int = 10;
		
		private var toSeek:Number;

		public function soundPlayer()
		{
			// constructor code
			myTransform= new SoundTransform();
			myTransform.volume = 2;
			mySound = new Sound();
			myChannel = new SoundChannel();
		}

		/////////////// Play
		public function load(file:String)
		{
            _loaded = false;
			playing = false;
			toSeek = 0;
			mySound.removeEventListener(Event.COMPLETE,onLoadeded);
			myChannel.removeEventListener(Event.SOUND_COMPLETE,finished);
			try
			{
				myChannel.stop();
			}
			catch(a){}
			try
			{
				mySound.close();
			}
			catch(a){}
			
			mySound = null;
			mySound = new Sound();
			mySound.load(new URLRequest(file), new SoundLoaderContext(buffer * 1000));
			mySound.addEventListener(Event.COMPLETE,onLoadeded);
			this.addEventListener(Event.EXIT_FRAME,ef);
		}
		
		function ef(e:Event)
		{
			duration = mySound.length / 1000;
			
			if(mySound.isBuffering || toSeek+buffer > mySound.length / 1000)
			{
				playing = false;
			}
			else if(!playing)
			{
				Stop();
				playing = true;
				setTime(toSeek);
			}

		}
		
		private function onLoadeded(e:Event = null)
		{
			this.removeEventListener(Event.EXIT_FRAME,ef);
			mySound.removeEventListener(Event.COMPLETE,onLoadeded);
			myChannel.addEventListener(Event.SOUND_COMPLETE,finished);
			
			duration = mySound.length / 1000;
			if(!playing)
			{
				playing = true;
				Stop();
				myChannel = mySound.play();
				myChannel.soundTransform = myTransform
				
				if(toSeek != 0)
					setTime(toSeek);
			}
			
			played = true;

            _loaded = true;
			dispatchEvent(new Event('duration'));
		}
		
		private function finished(e:Event)
		{
			dispatchEvent(new Event('finish'));
		}

		/////////////// Pause
		public function pause():void
		{
			if (played)
			{
				lastPosition = myChannel.position;
				myChannel.stop();
				played = false;
			}
			else
			{
				myChannel = mySound.play(lastPosition);
				myChannel.soundTransform = myTransform
				played = true;
			}
		}
		
		public function Pause():void
		{
			if (played)
			{
				lastPosition = myChannel.position;
				myChannel.stop();
				played = false;
			}
		}
		public function Resume():void
		{
			if (!played)
			{
				myChannel = mySound.play(lastPosition);
				myChannel.soundTransform = myTransform
				played = true;
			}
		}
		

		/////////////// Stop
		public function Stop()
		{
			myChannel.stop();
			lastPosition = 0;
			played = false;
		}
		public function end()
		{
			Stop();
			myChannel = null;
			mySound=null;
		}

		/////////////// setTimePercent
		public function setPercent(percent:Number)
		{
			setTime(percent * mySound.length / 1000);

		}
		
		/////////////// setTimeSecond
		public function setTime(second:Number)
		{
			if(!playing || second+buffer > mySound.length)
			{
				toSeek = second;
				return;
			}
			toSeek = 0;
			myChannel.stop();
			myChannel = mySound.play(second*1000);
			myChannel.soundTransform = myTransform
			played = true;
		}

		/////////////// getTime
		private function getTimeString():String
		{
			return timeFormat(myChannel.position);
		}
		
		public function getTime():Number
		{
			return myChannel.position / 1000;
		}		
		
		/////////////// getTotal
		private function getTotal():String
		{
			return timeFormat(mySound.length);
		}

		/////////////// getPercent
		function getPercent():Number
		{
			return myChannel.position / mySound.length;
		}

		/////////////// timeFormat
		public function timeFormat(miliSec:Number):String
		{
			if (miliSec < 1 * 60 * 60 * 1000)
			{
				return addZero(miliSec / 1000 / 60) + " : " + addZero(miliSec / 1000 % 60);
			}
			else
			{
				return addZero(miliSec / 1000 / 60 / 60) + " : " + addZero(miliSec / 1000 % 3600)+ " : " + addZero(miliSec / 1000 % 60);
			}
		}
		
		/////////////// addZero
		function addZero(num:Number):String
		{
			if ((num < 10))
			{
				return "0" + int(num);
			}
			else
			{
				return String(int(num));
			}
		}

        public function get loaded():Boolean
        {
            return _loaded;
        }

        public function reset():void
        {
            Stop();
			_loaded = false;
        }
    }

}