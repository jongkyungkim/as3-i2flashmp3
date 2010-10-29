package com.irzal 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.BlendMode;
	/**
	 * i2FlashMP3 v2.1.1 BETA
	 * @author Irzal Idris (Dedet)
	 * http://www.irzal.com
	 * Copyright (c) 2010 Irzal Idris
	 * This program is under CREATIVE COMMONS LICENSE see "License.txt" file for more detail
	 */
	public class Buttons extends MovieClip
	{
		public static const PLAY:String = "play";
		public static const STOP:String = "stop";
		public static const PAUSE:String = "pause";
		public static const SHUFFLE_ON:String = "on";
		public static const SHUFFLE_OFF:String = "off";
		public static const SHUFFLE_ALL:String = "all";
		public static const PREV:String = "prev";
		public static const NEXT:String = "next";
		
		public function Buttons()
		{
			buttonMode = true;
			this.addEventListener(MouseEvent.MOUSE_DOWN, thisDown,false,0,true);
		}
		//set button type
		public function buttonType(type:String=null):void
		{
			switch(type)
			{
				case "play":gotoAndStop("play"); 
				break;
				case "pause":gotoAndStop("pause"); 
				break;
				case "stop":gotoAndStop("stop"); 
				break;
				case "next":gotoAndStop("next"); 
				break;
				case "prev":gotoAndStop("prev"); 
				break;
				case "on":gotoAndStop("on"); 
				break;
				case "off":gotoAndStop("off"); 
				break;
				case "all":gotoAndStop("all");
				break;
			}
		}
		//button mouse down handler
		private function thisDown(e:MouseEvent):void
		{
			this.blendMode = BlendMode.HARDLIGHT;
			this.addEventListener(MouseEvent.MOUSE_UP, thisUp, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_OUT, thisUp, false, 0, true);
			this.removeEventListener(MouseEvent.MOUSE_DOWN, thisDown);
		}
		//button mouse up handler
		private function thisUp(e:MouseEvent):void
		{
			this.blendMode = BlendMode.NORMAL;
			this.removeEventListener(MouseEvent.MOUSE_OUT, thisUp);			
			this.removeEventListener(MouseEvent.MOUSE_UP, thisUp);
			this.addEventListener(MouseEvent.MOUSE_DOWN, thisDown, false, 0, true);
		}
	}
}