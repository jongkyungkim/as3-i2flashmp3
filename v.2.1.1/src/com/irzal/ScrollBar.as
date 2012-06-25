package com.irzal 
{
	import flash.events.*;
	import flash.display.Sprite;
	import flash.display.BlendMode;
	/**
	 * i2FlashMP3 v2.1.1 BETA
	 * @author Irzal Idris (Dedet)
	 * http://www.irzal.com
	 * Copyright (c) 2010 Irzal Idris
	 * This program is under CREATIVE COMMONS LICENSE see "License.txt" file for more detail
	 */
	public class ScrollBar extends Sprite
	{
		public static var _pathHeight:Number;
		public static var _sliderWidth:Number;
		public static var scrollUpper:Number;
		public static var scrollLower:Number;

		public function ScrollBar() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
		}
		//on added to stage event
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			//------------------;
			_pathHeight = _path.height;
			_sliderWidth = Sprite(getChildByName("_slider")).width * 0.5;
			Sprite(getChildByName("_slider")).buttonMode = true;
			Sprite(getChildByName("_slider")).addEventListener(MouseEvent.MOUSE_DOWN, sliderDownHandler, false, 0, true);
		}
		//scroll bar slider button mouse down handler
		private function sliderDownHandler(e:MouseEvent=null):void 
		{
			Sprite(getChildByName("_slider")).blendMode = BlendMode.DIFFERENCE;
			Sprite(getChildByName("_slider")).removeEventListener(MouseEvent.MOUSE_DOWN, sliderDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, sliderUpHandler,false,0,true);
		}
		//scroll bar slider button mouse up handler
		private function sliderUpHandler(e:MouseEvent):void 
		{
			Sprite(getChildByName("_slider")).blendMode = BlendMode.NORMAL;
			stage.removeEventListener(MouseEvent.MOUSE_UP, sliderUpHandler);
			Sprite(getChildByName("_slider")).addEventListener(MouseEvent.MOUSE_DOWN, sliderDownHandler, false, 0, true);
		}
		
		//set slider button height and scroll range
		public function _setSliderHeight():void
		{
			Sprite(getChildByName("_slider")).height = 15;
			var percObjectHeight:Number = Sprite(getChildByName("_path")).height/SongList._height;
			var percSliderHeight:Number = Sprite(getChildByName("_path")).height / Sprite(getChildByName("_slider")).height;
			var _scaleY:Number = percObjectHeight * percSliderHeight;
			if (percObjectHeight >= 1) Sprite(getChildByName("_slider")).height = Sprite(getChildByName("_path")).height;
			else (_scaleY < 2)? Sprite(getChildByName("_slider")).scaleY = 2 : Sprite(getChildByName("_slider")).scaleY = _scaleY;
			scrollUpper = Sprite(getChildByName("_path")).y + (Sprite(getChildByName("_slider")).height*0.5);
			scrollLower = Sprite(getChildByName("_path")).height - Sprite(getChildByName("_slider")).height;
			Sprite(getChildByName("_slider")).y = scrollUpper;
		}
	}
}