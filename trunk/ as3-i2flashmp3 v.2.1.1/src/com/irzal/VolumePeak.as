package com.irzal 
{
	import flash.display.Sprite;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	import flash.display.GradientType;
	import VolGridMask;
	/**
	 * i2FlashMP3 v2.1.1 BETA
	 * @author Irzal Idris (Dedet)
	 * http://www.irzal.com
	 * Copyright (c) 2010 Irzal Idris
	 * This program is under CREATIVE COMMONS LICENSE see "License.txt" file for more detail
	 */
	public class VolumePeak extends Sprite
	{
		private var _mask:VolGridMask = new VolGridMask();
		//constractor
		public function VolumePeak()
		{ 
			addChild(_mask);
			this.mask = _mask;			
			drawPeak();
		}
		//clear volume peak bar dan draw again
		public function _volumePeak(peak:Number):void
		{
			graphics.clear();
			drawPeak(peak);
		}
		//draw volume peak bar
		private function drawPeak(volPeak:*=null):void
		{
			var fillType:String = GradientType.LINEAR;
			var colors:Array = [0x0DF205,0xF2E205,0xF20505]; //green, yellow, orange
			var alphas:Array = [1,1,1];
			var ratios:Array = [0,127.5,255];
			var matr:Matrix = new Matrix();
			var spreadMethod:String = SpreadMethod.PAD;
			matr.createGradientBox(100,7,0,0,0);
			graphics.beginGradientFill(fillType,colors,alphas,ratios,matr,spreadMethod); 
			graphics.drawRect(0,0,volPeak,8);
			graphics.endFill();
		}
	}
}