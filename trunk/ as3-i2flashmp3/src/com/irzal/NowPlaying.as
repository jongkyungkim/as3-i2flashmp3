package com.irzal 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	/**
	 * i2FlashMP3 v2.1.1 BETA
	 * @author Irzal Idris (Dedet)
	 * http://www.irzal.com
	 * Copyright (c) 2010 Irzal Idris
	 * This program is under CREATIVE COMMONS LICENSE see "License.txt" file for more detail
	 */
	public class NowPlaying extends Sprite
	{
		public function NowPlaying() 
		{
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, 0, true);
		}
		//enter frame handler
		private function enterFrameHandler(e:Event):void 
		{
			if (this["_text"].width > this.parent["_nowPlayingBG"].width-5) _text.x -= 1;
			if (Math.floor(this["_text"].x) == Math.floor(0 - (this["_text"].width))) this["_text"].x = this.parent["_nowPlayingBG"].width;
		}
	}
}