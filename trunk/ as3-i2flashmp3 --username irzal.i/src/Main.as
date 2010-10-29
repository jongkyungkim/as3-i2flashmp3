package  
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.system.LoaderContext;
	import flash.net.URLRequest;
	import flash.display.StageScaleMode;
	import flash.text.TextFieldAutoSize;
	import flash.events.*;
	import com.irzal.*;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.Timer;
	import flash.system.Security;
	import flash.text.TextField;
	/**
	 * i2FlashMP3 v2.1.1 BETA
	 * @author Irzal Idris (Dedet)
	 * http://www.irzal.com
	 * Copyright (c) 2010 Irzal Idris
	 * This program is under CREATIVE COMMONS LICENSE see "License.txt" file for more detail
	 */
	public class Main extends MovieClip
	{
		//xml path and buffer time setting//
		private var urlPath:String = "album.xml";		//path for XML file album
		public static const BUFFER_TIME:Number = 10; 	// set sound buffer time in seconds
		//----//
		private var $pause:Boolean;
		private var $stop:Boolean;
		private var $shuffle:Boolean;
		private var $shuffeAll:Boolean;
		private var $added:Boolean;
		private var $xmlSongLoaded:Boolean;
		
		private var shuffleCount:int = 0;
		private var musicCounter:int = 0;
		private var albumCounter:int = 0;
		private var storeCounter:int;
		
		private var _nowPlaying:NowPlaying = new NowPlaying();
		
		private var music:Music = new Music();
		
		private var leftPeak:VolumePeak;
		private var rightPeak:VolumePeak;
		
		private var seekDrag:Boolean;
		
		private var albumXML:XML;
		private var imgLoader:Loader = new Loader();
		private var albumLoader:URLLoader = new URLLoader();
		
		private var storeURL:String;		
		
		private var xmlLoader:URLLoader = new URLLoader();
		private var xmlSong:XML;
		
		private var songArray:Array = [];
		private var _songTitle:SongTitle;
		
		private var visibleTimer:Timer = new Timer(5000, 1); //set timer for album button visible
		
		//constractor
		public function Main() 
		{
			//Security.loadPolicyFile("http://irzal.com/crossdomain.xml");
			//right click menu item
			var menu:ContextMenu = new ContextMenu();
			var menuItem1:ContextMenuItem = new ContextMenuItem("i2FlashMP3 v2.1.1 Beta");
			var menutItem2:ContextMenuItem = new ContextMenuItem("Copyright (C) 2010 Irzal Idris");
			
			menu.hideBuiltInItems();
			menu.customItems.push(menuItem1,menutItem2);
			this.contextMenu = menu;
			
			//set no scale
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//load main xml
			albumLoader.load(new URLRequest(urlPath + "?" + new Date().getTime()));
			albumLoader.addEventListener(IOErrorEvent.IO_ERROR, albumErrorHandler, false, 0, true);
			albumLoader.addEventListener(Event.COMPLETE, albumLoadHandler, false, 0, true);

			//hide buffer and error status
			_buffContainer.visible = false;
			errorText.visible = false;
			
			_nowPlaying._text.autoSize = TextFieldAutoSize.LEFT;
			if (!Music.$volume) Music.$volume = 1;
			$stop = true;
			
			visibleTimer.start();
			positionNowPlaying();
			createVolPeak();
			setButton();
			addEvents();
			visibleButton();
			
			//set volume
			_volBar.sliderx = Music.$volume * _volBar._volStat.width;
			//
			_artistText.htmlText = "<b>i2FlashMP3 v2.1.1 Beta</b>";
			_nowPlaying._text.htmlText = "Free Open Source Flash MP3 player. Copyright (c) 2010 Irzal Idris, this program is Under <a href='http://creativecommons.org/licenses/by-sa/3.0/' target='_blank'><u>Creative Commons license</u></a>.";
		}
		//set property x and y _nowPlaying
		private function positionNowPlaying():void
		{
			_nowPlaying.x = 6;
			_nowPlaying.y = 159;
			addChild(_nowPlaying);
		}
		//set visible album button
		private function visibleButton():void
		{
			_imgPrev.visible = true;
			_imgNext.visible = true;
			if (albumCounter == 0) _imgPrev.visible = false;
			else if (albumCounter == albumXML.album.length() - 1) _imgNext.visible = false;			
		}
		//set button type
		private function setButton():void
		{
			_shuffle.buttonType(Buttons.SHUFFLE_OFF);
			_prev.buttonType(Buttons.PREV);
			_next.buttonType(Buttons.NEXT);
			_stop.buttonType(Buttons.STOP);
			_play.buttonType(Buttons.PLAY);
		}
		//add event to buttons, Main, _cover and timer event
		private function addEvents():void
		{
			//buttons events
			_play.addEventListener(MouseEvent.CLICK, playClick,false,0,true);
			_stop.addEventListener(MouseEvent.CLICK, stopClick,false,0,true);
			_next.addEventListener(MouseEvent.CLICK, nextClick,false,0,true);
			_prev.addEventListener(MouseEvent.CLICK, prevClick,false,0,true);
			_shuffle.addEventListener(MouseEvent.CLICK, shuffleClick,false,0,true);
			_seekBar.addEventListener(MouseEvent.MOUSE_DOWN, seekBarDownHandler, false, 0, true);
			_volBar.addEventListener(MouseEvent.MOUSE_DOWN, volBarDownHandler, false, 0, true);
			_imgNext.addEventListener(MouseEvent.CLICK, imgNextClickHandler, false, 0, true);
			_imgPrev.addEventListener(MouseEvent.CLICK, imgPrevClickHandler, false, 0, true);
			
			//other events
			addEventListener(Event.ADDED_TO_STAGE, addedHandler, false, 0, true);
			addEventListener(Event.ENTER_FRAME, enterFrame, false, 0, true);
			_cover.addEventListener(MouseEvent.MOUSE_OVER, coverOverHandler, false, 0, true);
			_cover.addEventListener(MouseEvent.MOUSE_OUT, coverOutHandler, false, 0, true);
			visibleTimer.addEventListener(TimerEvent.TIMER, timerHandler, false, 0, true);			
		}
		//xml album error handler
		private function albumErrorHandler(e:IOErrorEvent):void 
		{
			errorText.visible = true;
			errorText.autoSize = TextFieldAutoSize.CENTER;
			errorText.text = "Cannot load album data base, check URL";
		}		
		//load albums @param e event complete handler
		private function albumLoadHandler(e:Event=null):void 
		{
			if (albumLoader.hasEventListener(Event.COMPLETE))
			{
				albumLoader.removeEventListener(Event.COMPLETE, albumLoadHandler);
				albumXML = new XML(albumLoader.data);
			} else
			{
				_cover._image.removeChild(imgLoader.content);
				imgLoader.unloadAndStop();
				visibleButton();
			}
			imgLoader.load(new URLRequest(albumXML.album[albumCounter].img));
			imgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imgLoaderErrorHandler, false, 0, true);
			imgLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, imgProgressHandler, false, 0, true);
			imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imgLoadHandler, false, 0, true);
			
			if (xmlSong) 
			{
				resetSongTitle();
				$xmlSongLoaded = false;
			}
			xmlLoader.load(new URLRequest(albumXML.album[albumCounter].songs + "?" + new Date().getTime()));
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, loaderLoadErrorHandler, false, 0, true);
			xmlLoader.addEventListener(Event.COMPLETE, loaderLoadHandler, false, 0, true);
		}
		//set now playing text and musicCounter @param  objName convert to number
		private function setNowPlaying(objName:Object=null):void
		{
			_nowPlaying._text.x = 0;
			if(objName)	musicCounter = Number(objName.name);
			_artistText.htmlText = "<b>"+albumXML.album[albumCounter].name+"</b>";
			_nowPlaying._text.htmlText = "<b>" + xmlSong.song[musicCounter].artist + "</b>" + " - " + xmlSong.song[musicCounter].title;
		}
		//remove playlist if new album is load
		private function resetSongTitle():void
		{
			for (var j:int = 0; xmlSong.song.length() > j; j++)
			{
				_playList._songList.removeChildAt(xmlSong.song.length() - 1 -j);
				songArray.pop();
				_songTitle = null;
			}
		}
		//create playlist
		private function createSongTitle():void
		{
			for (var i:int = 0; i < xmlSong.song.length(); i++)
			{
				_songTitle = new SongTitle();
				songArray[i] = _songTitle;
				_songTitle.name = String(i);
				_songTitle.buttonMode = true;
				_songTitle.mouseChildren = false;
				_songTitle.doubleClickEnabled = true;
				_songTitle._songTitleText.width = _playListBg.width - 1;
				_songTitle._songTitleText.text = xmlSong.song[i].artist + " - " + xmlSong.song[i].title; 
				if (i > 0)
				{
					_songTitle.y = songArray[i - 1].y + songArray[i - 1].height;
				}
				_playList._songList.addChild(_songTitle);
			}
			_playList.setScroll();
			onLoadSongTitleBG();
			
			_playList.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
			_playList.addEventListener(MouseEvent.DOUBLE_CLICK, doubleClickHandler, false, 0, true);
		}
		//get current music time position
		private function timerText():void { currentText.htmlText = music._timer; }
		//create volume peak bar
		private function createVolPeak():void
		{
			leftPeak = new VolumePeak();
			leftPeak.rotation = 180;
			leftPeak.x = 77;
			leftPeak.y = 198.5;
			addChildAt(leftPeak,numChildren-1);
			
			rightPeak = new VolumePeak();
			rightPeak.x = 79.9;
			rightPeak.y = 190.5;
			addChildAt(rightPeak,numChildren-1);
		}
		//set song position button, run on enterFrame() and stageMouseUpHandler()
		private function seekButtPosistion(type:Boolean = true, position:*= null):void
		{
			if (!type || position != null)
			{
				var i:Number;
				(!position)? i = (music._position / music._lengthNumber) * _seekBar._progBar.width:i = position;
				_seekBar.seekButt.x = i;
			}
		}
		//@param position set song time and search button x property
		private function setTimePosition(position:Number):void
		{
			var i:Number = (music._lengthNumber / _seekBar._progBar.width) * position;
			_seekBar.seekButt.x = position;
			music._timePosition = i;
		}
		//run volumer bar peak on enterFrame
		private function runVolPeak(type:Boolean=true):void
		{
			if (type)
			{
				leftPeak._volumePeak(Math.round((music._leftPeak * 72)));
				rightPeak._volumePeak(Math.round((music._rightPeak * 72)));
			} else
			{
				leftPeak._volumePeak(0);
				rightPeak._volumePeak(0);
			}
		}
		//reset song seek button
		private function resetSeekButt():void { _seekBar.seekButt.x = 0  }
		//check for open stream
		private function checkStream():void
		{
			$added = false;
			if (!music._error) 
			{
				if (Music.$progress) 
				{
					try {
						music.close() 
					}catch (e:Error)
					{
						trace(e.message);
					}
				}
			}
			Music.$progress = false;
			Music.$length = "00:00";
			Music.$progNumber = 0;
			music._stop();
			music._removeEvents();
			music = null;			//remove music object from memory
			music = new Music();
		}
		// auto next song on sound complete
		private function autoNext():void
		{
			if (music._complete)
			{
				checkStream();
				checkShuffle(shuffleCount);
				if (shuffleCount==0 || $shuffle) 
				{
					music._play(xmlSong.song[musicCounter].songurl);
					setNowPlaying();
					addSongTitleBG();					
				}
				removeSongTitleBG();
			}
		}
		//check sound buffering
		private function isBuffering():void
		{
			if (music.isBuffering)
			{
				var bufferTime:int = ((music.length - music._position) / (BUFFER_TIME*1000)) * 100;
				_buffContainer.visible = true;
				_buffContainer.alpha = 1.25 - ((music.length - music._position) / (BUFFER_TIME*1000));
				_buffContainer.bufferText.text = bufferTime.toString() +"%";
				if (_seekBar.hasEventListener(MouseEvent.MOUSE_DOWN)) _seekBar.removeEventListener(MouseEvent.MOUSE_DOWN, seekBarDownHandler);
			} else
			{
				_buffContainer.visible = false;
				if (!_seekBar.hasEventListener(MouseEvent.MOUSE_DOWN)) _seekBar.addEventListener(MouseEvent.MOUSE_DOWN, seekBarDownHandler, false, 0, true);
			}
		}
		//set sound volume
		private function setVolume():void
		{
			Music.$volume = _volBar._volSlider.x / _volBar._volStat.width;
			music._vol = Music.$volume;
		}
		//visible stream error check incase stream error
		private function checkError():void
		{
			if (music._error)
			{
				_buffContainer.visible = false;
				errorText.visible = true;
			} else errorText.visible = false;
		}
		//check shuffle
		private function checkShuffle(type:Number=0,name:String=null):void
		{
			if (type!=0) 
			{
				switch(shuffleCount)
				{
					case 1:
					musicCounter = Math.random() * xmlSong.song.length();
						break;
					case 2:
					albumCounter = Math.random() * albumXML.album.length();
					albumLoadHandler();
						break;
				}
			}
			else
			{
				switch(name)
				{
					case "_prev":
					(musicCounter > 0)? musicCounter -= 1:musicCounter = xmlSong.song.length() - 1;
					break;
					default:
					(musicCounter < xmlSong.song.length() - 1)? musicCounter += 1:musicCounter = 0;
				}
			}
		}
		private function onLoadSongTitleBG():void
		{
			if (storeCounter < songArray.length)
			{
				if (storeURL == xmlSong.song[storeCounter].songurl)
				{
					_playList._songList.getChildByName(String(storeCounter)).opaqueBackground = 0x4b95e5;
					_playList._songList.getChildByName(String(storeCounter)).isPlaying = true;						
				}
			}
		}
		private function addSongTitleBG():void
		{
			_playList._songList.getChildByName(String(musicCounter)).opaqueBackground = 0x4b95e5;
			_playList._songList.getChildByName(String(musicCounter)).isPlaying = true;
		}
		private function removeSongTitleBG():void
		{
			if (storeCounter < songArray.length)
			{
				_playList._songList.getChildByName(String(storeCounter)).opaqueBackground = null;
				_playList._songList.getChildByName(String(storeCounter)).isPlaying = false;
			}
			storeCounter = musicCounter;
			storeURL = xmlSong.song[musicCounter].songurl;
		}		
		//EVENTS------------------------//
		//enter frame event handler
		private function enterFrame(e:Event):void 
		{		
			//remove this if condition if you removed line 55-59
			if(!$added)
			{
				timerText();
				autoNext();
				runVolPeak();
				isBuffering();
				checkError();
				seekButtPosistion(seekDrag);
			}
		}
		//other events		
		private function addedHandler(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedHandler);
			$added=true;
		}
		//img/swf progress status
		private function imgProgressHandler(e:ProgressEvent):void 
		{
			var perc:Number = Math.floor((e.bytesLoaded / e.bytesTotal) * 100);
			_cover._imgLoad.text = String(perc) + "%";
			_imgNext.removeEventListener(MouseEvent.CLICK, imgNextClickHandler);
			_imgPrev.removeEventListener(MouseEvent.CLICK, imgPrevClickHandler);
		}
		//imge/swf I/O error handler
		private function imgLoaderErrorHandler(e:IOErrorEvent):void 
		{
			errorText.visible = true;
			errorText.autoSize = TextFieldAutoSize.CENTER;
			errorText.text = "Cannot load album cover, check URL";			
		}
		// img/swf load complete event
		private function imgLoadHandler(e:Event):void 
		{
			_cover._image.addChild(imgLoader.content);
			imgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, imgLoadHandler);
			imgLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, imgProgressHandler);
			_cover._imgLoad.visible = false; //hide loading status on album
			_imgNext.addEventListener(MouseEvent.CLICK, imgNextClickHandler, false, 0, true);
			_imgPrev.addEventListener(MouseEvent.CLICK, imgPrevClickHandler, false, 0, true);
		}
		//play list xml error handler
		private function loaderLoadErrorHandler(e:IOErrorEvent):void 
		{
			errorText.visible = true;
			errorText.autoSize = TextFieldAutoSize.CENTER;
			errorText.text = "Cannot load play list, check URL";				
		}		
		//playlist xml load complete event
		private function loaderLoadHandler(e:Event=null):void 
		{
			xmlLoader.removeEventListener(Event.COMPLETE, loaderLoadHandler);
			xmlSong = new XML(xmlLoader.data);
			$xmlSongLoaded = true;
			_xmlStatus.visible = false; //hide load status on playlist
			createSongTitle();
			if ($shuffeAll && !Music.$progress && !music._playStatus)
			{
				musicCounter = Math.random() * xmlSong.song.length();
				if ($pause)
				{
					music._play(xmlSong.song[musicCounter].songurl);
					setNowPlaying();
					try {
						removeSongTitleBG();
					} catch (e:Error)
					{
						trace(e.message);
					}
					addSongTitleBG();					
				}
			}
		}
		//set now playing on mouse click if song is stop
		private function clickHandler(e:MouseEvent):void 
		{
			if ($stop && e.target.name!="_path" && e.target.name!="_slider")
			{
				setNowPlaying(e.target);
			}
		}
		//play selected song on double click
		private function doubleClickHandler(e:MouseEvent):void
		{
			setNowPlaying(e.target);
			removeSongTitleBG();
			e.target.isPlaying = true;
			e.target.opaqueBackground = 0x4b95e5;
			checkStream();
			_play.buttonType(Buttons.PAUSE);
			$pause = true;
			$stop = false;
			music._play(xmlSong.song[musicCounter].songurl);
			if (!this.hasEventListener(Event.ENTER_FRAME)) this.addEventListener(Event.ENTER_FRAME, enterFrame,false,0,true);
		}
		//set visible album buttons on mouse out cover
		private function coverOutHandler(e:MouseEvent):void 
		{
			if(!visibleTimer.hasEventListener(TimerEvent.TIMER)) visibleTimer.addEventListener(TimerEvent.TIMER, timerHandler, false, 0, true);
			visibleTimer.start();
		}
		//timer handler for album buttons
		private function timerHandler(e:TimerEvent):void 
		{
			_imgNext.visible = false;
			_imgPrev.visible = false;
		}
		//set visible album button on mouse over cover
		private function coverOverHandler(e:MouseEvent):void 
		{
			if (visibleTimer.hasEventListener(TimerEvent.TIMER)) visibleTimer.removeEventListener(TimerEvent.TIMER, timerHandler);
			visibleTimer.stop();
			visibleButton();
		}		
		//BUTTONS EVENT------------------//
		//prev album button on click event
		private function imgPrevClickHandler(e:MouseEvent):void 
		{
			_cover._imgLoad.text = "0%";
			_xmlStatus.visible = true;
			albumCounter--;
			_cover._imgLoad.visible = true;
			albumLoadHandler();
		}
		//next album button on click event
		private function imgNextClickHandler(e:MouseEvent):void 
		{
			_cover._imgLoad.text = "0%";
			_xmlStatus.visible = true;
			albumCounter++;
			_cover._imgLoad.visible = true;
			albumLoadHandler();
		}
		//volume bar handler on mouse down
		private function volBarDownHandler(e:MouseEvent):void 
		{
			if (e.target.buttonMode)
			{
				stage.addEventListener(MouseEvent.MOUSE_MOVE, volSliderMOveHandler, false, 0, true);
				stage.addEventListener(MouseEvent.MOUSE_UP, stageUpVolHandler, false, 0, true);
			}
		}
		//volume bar handler on mouse move
		private function volSliderMOveHandler(e:MouseEvent):void 
		{
			_volBar._volSlider.startDrag(false, new Rectangle(0, 0, _volBar._volStat.width, 0));
			setVolume();
		}
		//volume bar handler on stage mouse up
		private function stageUpVolHandler(e:MouseEvent):void 
		{
			_volBar._volSlider.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, volSliderMOveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stageUpVolHandler);
		}
		//sound time search button down handler
		private function seekBarDownHandler(e:MouseEvent):void 
		{
			if (e.target.buttonMode)
			{
				seekDrag = true;
				_seekBar.seekButt.addEventListener(MouseEvent.MOUSE_MOVE, seekBarMoveHandler, false, 0, true);
				stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler, false, 0, true);
			}
		}
		//sound time search button move handler
		private function seekBarMoveHandler(e:MouseEvent):void 
		{
			_seekBar.seekButt.startDrag(false, new Rectangle(0, 0, _seekBar._progBar.width, 0));
		}
		//sound time search button on stage mouse up
		private function stageMouseUpHandler(e:MouseEvent):void 
		{
			_seekBar.seekButt.stopDrag();
			music._stop();
			setTimePosition(_seekBar.seekButt.x);
			if ($pause || $stop) seekButtPosistion(seekDrag, _seekBar.seekButt.x);
			if ($pause) music._play(xmlSong.song[musicCounter].songurl);
			seekDrag = false;
			_seekBar.seekButt.removeEventListener(MouseEvent.MOUSE_MOVE, seekBarMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
		}
		//stop button click handler
		private function stopClick(e:MouseEvent):void
		{
			$stop = true;
			music._stop();
			_play.buttonType(Buttons.PLAY);
			$pause = false;
			currentText.text = "00:00";
			runVolPeak(false);
			resetSeekButt();
			_buffContainer.visible = false;
			this.removeEventListener(Event.ENTER_FRAME, enterFrame);
		}
		//play button click handler
		private function playClick(e:MouseEvent=null):void
		{
			if ($pause)
			{
				_play.buttonType(Buttons.PLAY);
				$pause = false;
				$stop = false;
				music._pause();
				runVolPeak(false);
				this.removeEventListener(Event.ENTER_FRAME, enterFrame);
			}
			else
			{
				_play.buttonType(Buttons.PAUSE);
				$pause = true;
				$added = false;
				if ($stop) 
				{
					checkStream();
					$stop = false;
				}
				music._play(xmlSong.song[musicCounter].songurl);
				setNowPlaying();
				removeSongTitleBG();
				addSongTitleBG();				
				if(!this.hasEventListener(Event.ENTER_FRAME))this.addEventListener(Event.ENTER_FRAME, enterFrame,false,0,true);
			}
		}
		//prev button click handler
		private function prevClick(e:MouseEvent=null):void 
		{
			checkStream();
			checkShuffle(shuffleCount,e.currentTarget.name);
			_play.buttonType(Buttons.PAUSE);
			$pause = true;
			if (shuffleCount==0 || $shuffle) 
			{
				music._play(xmlSong.song[musicCounter].songurl);
				setNowPlaying();
				addSongTitleBG();				
			}
			removeSongTitleBG();
			if(!this.hasEventListener(Event.ENTER_FRAME)) this.addEventListener(Event.ENTER_FRAME, enterFrame,false,0,true);
		}
		//next button click handler
		private function nextClick(e:MouseEvent=null):void 
		{
			checkStream();
			checkShuffle(shuffleCount);
			_play.buttonType(Buttons.PAUSE);
			$pause = true;
			if (shuffleCount==0 || $shuffle) 
			{
				music._play(xmlSong.song[musicCounter].songurl);
				setNowPlaying();
				addSongTitleBG();				
			}
			removeSongTitleBG();
			if(!this.hasEventListener(Event.ENTER_FRAME)) this.addEventListener(Event.ENTER_FRAME, enterFrame,false,0,true);
		}
		//shuffle button click handler
		private function shuffleClick(e:MouseEvent):void
		{
			shuffleCount++;
			switch(shuffleCount)
			{
				case 1:
				_shuffle.buttonType(Buttons.SHUFFLE_ON);
				$shuffle = true;
					break;
				case 2:
				_shuffle.buttonType(Buttons.SHUFFLE_ALL);
				$shuffle = false;
				$shuffeAll = true;
					break;
				default:
				_shuffle.buttonType(Buttons.SHUFFLE_OFF);
				$shuffeAll = false;
				$shuffle = false;
				shuffleCount = 0;
			}
		}
	}
}