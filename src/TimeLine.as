/**
 * Created by mkh on 2017/04/03.
 */
package
{
import flash.display.Bitmap;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

import saveLoad.saveItem;
import soundPlayer;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.utils.getTimer;

import src2.TimeBar;

import src2.Utils;

import src2.assets;

public class TimeLine extends Sprite
{
    private var _timeBar:TimeBar;

    private var _totalMSec:int;
    private var _totalSec:Number;
    private var _currentMSec:int;
    private var _currentSec:Number;

    private var _currentBox:TextField;
    private var _totalBox:TextField;

    private var _updateFunc:Function;

    private var _playBtn:Sprite

    private var _transformer:TransformManager;

    private var _sound:soundPlayer;
    private var _lastTime:int;
    private var _elapsedTime:int;
    private var _paused:Boolean;

    private var _soundFile:String;
    private var _pathHolder:Object={};
    private var _t:TextFormat;

    public function TimeLine(transformer:TransformManager, updateFunction)
    {
        _transformer = transformer;
        _updateFunc = updateFunction;

        _paused = true;

        _sound = new soundPlayer();

        //==========Seek Bar
        _timeBar = new TimeBar();
        _timeBar.x = 150;
        _timeBar.y = 400;
        _timeBar.width = 500;
        _timeBar.onChange = changePercent;
        _timeBar.start();
        addChild(_timeBar);

        //==========Button
        /*
        _playBtn = new Button('>||',0,0,40,20);
        _playBtn.x = _timeBar.x - _playBtn.width - 5;
        _playBtn.y = _timeBar.y - 5;
        _playBtn.addEventListener(MouseEvent.CLICK, onPausePlayBtn);
        addChild(_playBtn);
        */
        _playBtn = new Sprite();
        Utils.drawRect(_playBtn,0,0,24,24,0xffffff);
        var bit:Bitmap = new assets.Play();
        bit.smoothing = true;
        bit.width = bit.height = 24
        _playBtn.addChild(bit);
        _playBtn.x = _timeBar.x - _playBtn.width - 5;
        _playBtn.y = _timeBar.y - 5;
        _playBtn.x -=2;
        _playBtn.y -=2;
        addChild(_playBtn);
        _playBtn.addEventListener(MouseEvent.CLICK, onPausePlayBtn);


        //==========Text Fields
        _currentBox = new TextField();
        _totalBox = new TextField();

        _currentBox.width = _totalBox.width = 60;
        _currentBox.height = _totalBox.height = 20;

        _currentBox.x = _playBtn.x - _currentBox.width - 4;
        _totalBox.x = _timeBar.x + _timeBar.width + 10;

        _currentBox.y = _timeBar.y + (_timeBar.height - _currentBox.height) / 2;
        _totalBox.y = _currentBox.y;

        _t = new TextFormat();
        _t.align = TextFormatAlign.RIGHT;

        _currentBox.type = 'input';
        _currentBox.addEventListener(FocusEvent.FOCUS_IN, focusInCurrentBox);
        _currentBox.addEventListener(FocusEvent.FOCUS_OUT, focusOutCurrentBox);

        addChild(_currentBox);
        addChild(_totalBox);

        //================ init
        totalSec = 20;
        currentSec = 0;

        //sound = 'http://dl1.pop-music.ir/m/Mohsen%20CHavoshi/Mohsen%20Chavoshi%20-%20Man%20Khode%20Aan%2013%20Am/01%20-%20Ghalat%20Kardam.mp3';
    }


    //////////////////////
    public function set sound(path:String):void
    {
        pause();
        _soundFile = path;
        _sound.addEventListener('duration', onLoad);
        _sound.load(path);
    }

    private function onLoad(event:Event):void
    {
        _sound.removeEventListener('duration', onLoad);
        _sound.pause();
        totalSec = _sound.duration;
    }

    //////////////////////Change percent by user click on timeBar
    private function changePercent(percent:Number):void
    {
        _transformer.deselect();
        if(!_paused && _sound)
            _sound.setTime(percent * totalSec);
        else
            currentMSec = percent * totalMSec;
    }

    public function setTimeByTopic(seconds:Number):void
    {
        changePercent(seconds/totalSec);
    }


    ////////////////////////////////
    public function onPausePlayBtn(event:MouseEvent = null):void
    {
        _transformer.deselect();
        if(_paused)
        {
            playTimeLine();
        }
        else
        {
            pause();
        }
    }

    private function pause():void
    {
        _paused = true;
        this.removeEventListener(Event.ENTER_FRAME, moveTime);
        stage.removeEventListener(MouseEvent.MOUSE_DOWN, onStage);
        if(_sound.loaded)
            _sound.pause();
    }

    private function playTimeLine():void
    {
        _paused = false;
        this.addEventListener(Event.ENTER_FRAME, moveTime);
        
        if(_sound.loaded)
        {
            _sound.setTime(currentSec);
            _sound.Resume();
            return;
        }

        _lastTime = getTimer();

        stage.addEventListener(MouseEvent.MOUSE_DOWN, onStage);
    }

    private function onStage(e:MouseEvent):void
    {
        if(e.target != _playBtn && e.target.parent != _playBtn)
            pause();
    }

    private function moveTime(event:Event):void
    {
        if(_sound.loaded)
        {
            currentSec = _sound.getTime();
        }
        else
        {
            _elapsedTime = getTimer() - _lastTime;
            _lastTime += _elapsedTime;
            currentMSec += _elapsedTime;
        }

        if(currentMSec == totalMSec)
                pause();
    }

    //==================================== Time
    /////// total seconds
    public function get totalSec():Number
    {
        return _totalSec;
    }

    public function set totalSec(value:Number):void
    {
        totalMSec = value * 1000;
    }

    /////////// total Milli Seconds
    private function get totalMSec():int
    {
        return _totalMSec;
    }

    private function set totalMSec(value:int):void
    {
        if(value < 0)
            value = 0;

        _totalMSec = value;
        _totalSec = value / 1000;
        _totalBox.text = totalTime;
        //update timeBar
        _timeBar.percent = currentMSec / totalMSec;
    }

    /////////////// Current Time (String)
    private function get currentTime():String
    {
        return Utils.timeFormat(_currentMSec);
    }

    private function set currentTime(value:String):void
    {
        changePercent(Utils.timeToSec(value) / totalSec);
    }

    //////////// Total Time (String)
    private function get totalTime():String
    {
        return Utils.timeFormat(totalMSec);
    }

    private function set totalTime(value:String):void
    {
       totalSec = Utils.timeToSec(value);
    }

    ///////////// Current Seconds
    public function get currentSec():Number
    {
        return _currentSec;
    }

    public function set currentSec(value:Number):void
    {
        currentMSec = value*1000;
    }

    ///////////// Current Milli Seconds
    private function get currentMSec():int
    {
        return _currentMSec;
    }

    private function set currentMSec(value:int):void
    {
        if(value < 0)
            value = 0;
        else if(value >= totalMSec)
                value = totalMSec;

        _currentMSec = value;
        _currentSec = value / 1000;
        _timeBar.percent = value/totalMSec;
        showTime();

        if(_updateFunc != null)
                _updateFunc(currentSec);
    }

    //Show Time
    private function showTime():void
    {
        _currentBox.text = currentTime;
        _currentBox.setTextFormat(_t)
    }

    ///////////////// Insert Current Time By User
    private function changeTime(event:Event = null):void
    {
        currentTime = _currentBox.text;
    }

    private function focusInCurrentBox(event:FocusEvent):void
    {
        stage.addEventListener(KeyboardEvent.KEY_DOWN, key);
    }

    private function focusOutCurrentBox(event:FocusEvent):void
    {
        stage.removeEventListener(KeyboardEvent.KEY_DOWN, key);
        changeTime();
    }

    private function key(e:KeyboardEvent):void
    {
        if(e.keyCode == 13)
        {
            changeTime();
            if(stage.focus == _currentBox);
                stage.focus = null;
        }
    }

    public function get soundFile():String
    {
        return _soundFile;
    }

    ////////////////////////////
    public function saveSound(dir:String):void
    {
        saveItem.copyAndRename(soundFile, dir, 'file.voice', _pathHolder, after);
        function after():void
        {
            _soundFile = _pathHolder.currentPath;
            moveSound();
        }
    }

    public function moveSound():void
    {
        saveItem.move(_pathHolder.currentPath, _pathHolder.newPath, after);
        function after():void
        {
            _soundFile = _pathHolder.newPath;
            dispatchComplete();
        }
    }

    private function dispatchComplete():void
    {
        dispatchEvent(new Event(Event.COMPLETE));
    }

    public function stepForward(ctrlKey:Boolean, shift:Boolean):void
    {
        if(ctrlKey)
            setTimeByTopic(currentSec + .1);
        else if(shift)
            setTimeByTopic(currentSec + 10);
        else
            setTimeByTopic(currentSec + 1);
    }

    public function stepBackward(ctrlKey:Boolean, shift:Boolean):void
    {
        if(ctrlKey)
            setTimeByTopic(currentSec - .1);
        else if(shift)
            setTimeByTopic(currentSec - 10);
        else
            setTimeByTopic(currentSec - 1);
    }
}
}