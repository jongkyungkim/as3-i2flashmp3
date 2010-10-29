package com.irzal 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	/**
	 * i2FlashMP3 v2.1.1 BETA
	 * @author Irzal Idris (Dedet)
	 * http://www.irzal.com
	 * Copyright (c) 2010 Irzal Idris
	 * This program is under CREATIVE COMMONS LICENSE see "License.txt" file for more detail
	 */
	public class SongList extends Sprite
	{
		public static var _height:Number;
		public static var yUpper:Number;
		public static var yLower:Number;
		public static var yRange:Number;
		private var glow:GlowFilter = new GlowFilter(0xFFFFFF, 1, 6, 6, 2, 2, true);
		private var songArray:Array = [];
		private var _object:*;
		//constractor
		public function SongList() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
		}
		//initiate on added to stage
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			//-------------------------
			this.doubleClickEnabled = true;
			this.buttonMode = true;
			addEventListener(MouseEvent.MOUSE_OVER, mouseOverhandler, false, 0, true);
		}
		//change play list item background on mouse over
		private function mouseOverhandler(e:MouseEvent):void 
		{
			removeEventListener(MouseEvent.MOUSE_OVER, mouseOverhandler);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler, false, 0, true);
			e.target.opaqueBackground = 0x4b95e5;
			e.target._songTitleText.filters = [glow];
			_object = e.target;
			addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, 0, true);
		}
		//enter frame run slideText
		private function enterFrameHandler(e:Event):void 
		{
			slideText(_object);
		}
		//scroll play list text if width wider than its background
		private function slideText(object:*,out:Boolean=false):void
		{
			if (out) object.getChildAt(0).scrollH = 0;
			 else object.getChildAt(0).scrollH += 1;
		}
		//on mouse event out handler
		private function mouseOutHandler(e:MouseEvent):void 
		{
			removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			addEventListener(MouseEvent.MOUSE_OVER, mouseOverhandler, false, 0, true);
			if(!e.target.isPlaying) e.target.opaqueBackground = null;
			e.target._songTitleText.filters = null;
			slideText(_object, true);
			_object = null;
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		//get height of current playlists
		public function resetHeight():void { _height = this.height }
		//set upper and lower for scrolling
		public function setVars():void
		{
			this.y = 0;
			yUpper = this.y;
			yLower = this.y + (ScrollBar._pathHeight - (this.height+2));
			yRange = yUpper - yLower;
		}
	}
}