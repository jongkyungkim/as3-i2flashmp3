package com.irzal 
{
	import flash.display.Sprite;
	import flash.filters.BevelFilter;
	/**
	 * i2FlashMP3 v2.1.1 BETA
	 * @author Irzal Idris (Dedet)
	 * http://www.irzal.com
	 * Copyright (c) 2010 Irzal Idris
	 * This program is under CREATIVE COMMONS LICENSE see "License.txt" file for more detail
	 */
	public class CoverButt extends Sprite
	{
		private var bevel:BevelFilter = new BevelFilter(1, 45, 0xffffff, 1, 0, 1, 2, 2, 1, 2);
		public function CoverButt() 
		{
			this.buttonMode = true;
			this.filters = [bevel];
		}
	}
}