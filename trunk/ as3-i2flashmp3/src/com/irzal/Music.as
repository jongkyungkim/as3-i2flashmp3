package com.irzal 
{
	import flash.events.*;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	/**
	 * i2FlashMP3 v2.1.1 BETA
	 * @author Irzal Idris (Dedet)
	 * http://www.irzal.com
	 * Copyright (c) 2010 Irzal Idris
	 * This program is under CREATIVE COMMONS LICENSE see "License.txt" file for more detail
	 */
	public class Music extends Sound
	{
		public static var $progNumber:Number = 0;
		public static var $volume:Number;
		public static var $length:String = "00:00";
		public static var $progress:Boolean;	
		
		public var _complete:Boolean;
		public var _error:Boolean;
		public var _playStatus:Boolean;
		
		private var _loaded:Boolean;
		
		private var _time:Number;
		private var _musicTimer:Number;
		
		private var sndChannel:SoundChannel = new SoundChannel();
		private var sndTransform:SoundTransform = new SoundTransform();
		private var sndContext:SoundLoaderContext = new SoundLoaderContext(Main.BUFFER_TIME*1000, false);//buffer sound 5 second
		
		public function Music()
		{
			super();
		}
		//sound play
		public function _play(url:String):void
		{
			//prevent double loading
			if (!_loaded)
			{
				this.load(new URLRequest(url), sndContext);
				_loaded = true;
			}
			_complete = false;
			this.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
			this.addEventListener(ProgressEvent.PROGRESS, progHandler, false, 0, true);
			if (!_time) _time = 0;
			_playStatus = true;
			
			sndTransform = sndChannel.soundTransform;
			sndTransform.volume = $volume;
			sndChannel = this.play(_time);
			sndChannel.soundTransform = sndTransform;
			sndChannel.addEventListener(Event.SOUND_COMPLETE, sndChannelCompleteHandler, false, 0, true);
		}
		//on pause get sound time position
		public function _pause():void
		{
			sndChannel.stop();
			_time = sndChannel.position;
		}
		//sound stop
		public function _stop():void
		{
			sndChannel.stop();
			_time = 0;
			_playStatus = false;
		}
		//@param e stream error handler
		private function ioErrorHandler(e:IOErrorEvent):void 
		{ 
			_error = true;
			sndChannel.removeEventListener(Event.SOUND_COMPLETE, sndChannelCompleteHandler);
		}
		//@param e sound complete handler
		private function sndChannelCompleteHandler(e:Event):void 
		{
			sndChannel.removeEventListener(Event.SOUND_COMPLETE, sndChannelCompleteHandler);
			_complete = true;
		}
		//@param e sound progress handler
		private function progHandler(e:ProgressEvent):void 
		{
			$progNumber = e.bytesLoaded / e.bytesTotal;
			$progress = true;
			if ($progNumber == 1)
			{
				this.removeEventListener(ProgressEvent.PROGRESS, progHandler);
				this.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				$progress = false;
				musicLength();
			}
		}		
		//getter setter------------------------------------//
		//return sound position
		public function get _position():Number { return sndChannel.position }
		//return sound length
		public function get _lengthNumber():Number { return this.length }
		//return current sound time position string
		public function get _timer():String 
		{ 
			var strMinute:String;
			var strSecond:String;
			var mnt:Number = Math.floor((sndChannel.position / 1000) / 60);
			var scd:Number = Math.floor((sndChannel.position / 1000) % 60);
			(mnt < 10)? strMinute = "0" + mnt.toString():strMinute = mnt.toString();
			(scd < 10)? strSecond = "0" + scd.toString():strSecond = scd.toString();
			return strMinute + ":" + strSecond;
		}
		//set $length to current song length
		private function musicLength():void { $length = this._length }
		//return current sound length to string
		public function get _length():String
		{
			var strMinute:String;
			var strSecond:String;
			var mnt:Number = Math.floor((this.length / 1000) / 60);
			var scd:Number = Math.floor((this.length / 1000) % 60);
			(mnt < 10)? strMinute = "0" + mnt.toString():strMinute = mnt.toString();
			(scd < 10)? strSecond = "0" + scd.toString():strSecond = scd.toString();
			return strMinute + ":" + strSecond;
		}
		//return current sound left peak sound channel
		public function get _leftPeak():Number { return sndChannel.leftPeak }
		//return current sound right peak sound channel
		public function get _rightPeak():Number { return sndChannel.rightPeak }
		//return current sound time posistion
		public function get timePosition():Number { return _time }
		//@param value set _time 
		public function set _timePosition(value:Number):void { _time = value }	
		//@param value set current sound volume
		public function set _vol(value:Number):void 
		{
			$volume = value;
			sndTransform = sndChannel.soundTransform;
			sndTransform.volume = $volume;
			sndChannel.soundTransform = sndTransform;
		}
		//remove events
		public function _removeEvents():void
		{
			if (this.hasEventListener(ProgressEvent.PROGRESS)) this.removeEventListener(ProgressEvent.PROGRESS, progHandler);
			if (this.hasEventListener(IOErrorEvent.IO_ERROR)) this.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			if (sndChannel.hasEventListener(Event.SOUND_COMPLETE)) sndChannel.removeEventListener(Event.SOUND_COMPLETE, sndChannelCompleteHandler);
		}
	}
}