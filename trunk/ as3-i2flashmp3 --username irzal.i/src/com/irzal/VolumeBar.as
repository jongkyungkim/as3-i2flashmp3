package com.irzal 
{
	import flash.events.*;
	import flash.display.Sprite;
	/**
	 * i2FlashMP3 v2.1.1 BETA
	 * @author Irzal Idris (Dedet)
	 * http://www.irzal.com
	 * Copyright (c) 2010 Irzal Idris
	 * This program is under CREATIVE COMMONS LICENSE see "License.txt" file for more detail
	 */
	public class VolumeBar extends Sprite
	{
		public function VolumeBar() 
		{
			if (stage) init();
			addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
		}
		//event on added to stage
		public function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			//-----------------;
			Sprite(getChildByName("_volSlider")).buttonMode = true;
			Sprite(getChildByName("_volSlider")).addEventListener(MouseEvent.MOUSE_DOWN, volSliderDownHandler, false, 0, true);
		}
		//volume button mouse down handler
		private function volSliderDownHandler(e:MouseEvent):void 
		{
			Sprite(getChildByName("_volSlider")).removeEventListener(MouseEvent.MOUSE_DOWN, volSliderDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, false, 0, true);
		}
		//volume button mouse up handler
		private function mouseUpHandler(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			Sprite(getChildByName("_volSlider")).addEventListener(MouseEvent.MOUSE_DOWN, volSliderDownHandler,false,0,true);
		}
		//set volume button x
		public function set sliderx(value:int):void { Sprite(getChildByName("_volSlider")).x = value }
	}
}