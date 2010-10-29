package com.irzal 
{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.media.Sound;
	/**
	 * i2FlashMP3 v2.1.1 BETA
	 * @author Irzal Idris (Dedet)
	 * http://www.irzal.com
	 * Copyright (c) 2010 Irzal Idris
	 * This program is under CREATIVE COMMONS LICENSE see "License.txt" file for more detail
	 */
	public class SeekBar extends Sprite
	{
		//constractor
		public function SeekBar() 
		{
			if (stage) init();
			addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
		}
		//added to stage event
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			//---------------------;
			seekButt.buttonMode = true;
			Sprite(getChildByName("_progBar")).scaleX = 0;
			addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, 0, true);
		}
		//set search song position button on enter frame
		private function enterFrameHandler(e:Event):void 
		{
			if(Music.$progress)
			{
				MovieClip(this.parent).totalText.text = Math.floor((Music.$progNumber * 100)).toString() + "%";
				Sprite(getChildByName("_progBar")).scaleX = Music.$progNumber;
			}else
			{
				MovieClip(this.parent).totalText.text = Music.$length;
				Sprite(getChildByName("_progBar")).scaleX = Math.round(Music.$progNumber);
			}
		}
	}
}