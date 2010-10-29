package com.irzal 
{
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.Rectangle;
	/**
	 * i2FlashMP3 v2.1.1 BETA
	 * @author Irzal Idris (Dedet)
	 * http://www.irzal.com
	 * Copyright (c) 2010 Irzal Idris
	 * This program is under CREATIVE COMMONS LICENSE see "License.txt" file for more detail
	 */
	public class PlayList extends Sprite
	{
		private var getWidth:Number;
		//constractor
		public function PlayList() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
		}
		//init on added to stage
		private function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			//------------
			_scrollBar._slider.addEventListener(MouseEvent.MOUSE_DOWN, sliderDownHandler, false, 0, true);
			getWidth = this.parent.getChildByName("_playListBg").width;
		}
		//scroll text
		public function setScroll():void
		{
			_songList.resetHeight();
			_songList.setVars();
			_scrollBar._setSliderHeight();
			setMaskWidth();
		}
		//set playlist mask width
		private function setMaskWidth():void { _mask.width = this.parent.getChildByName("_playListBg").width }
		//scroll button mouse down handler
		private function sliderDownHandler(e:MouseEvent):void 
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE, stageSliderMoveHandler, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, stageSliderUpHandler, false, 0, true);
			_scrollBar._slider.removeEventListener(MouseEvent.MOUSE_DOWN, sliderDownHandler);
		}
		//scroll button on stage mouse move handler
		private function stageSliderMoveHandler(e:MouseEvent):void 
		{
			_scrollBar._slider.startDrag(false, new Rectangle(5, ScrollBar.scrollUpper, 0, ScrollBar.scrollLower));
			var moveDrag:Number = _scrollBar._slider.y - ScrollBar.scrollUpper;
			var procentDrag:Number = moveDrag/ScrollBar.scrollLower;
			var objectMove:Number = procentDrag*SongList.yRange;
			_songList.y = SongList.yUpper - objectMove;
		}
		//scroll button on stage mouse up handler
		private function stageSliderUpHandler(e:MouseEvent):void 
		{
			_scrollBar._slider.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, stageSliderMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stageSliderUpHandler);
			_scrollBar._slider.addEventListener(MouseEvent.MOUSE_DOWN, sliderDownHandler, false, 0, true);
		}
	}
}