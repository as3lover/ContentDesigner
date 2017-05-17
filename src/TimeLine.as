/**
 * Created by mkh on 2017/04/03.
 */
package
{
import cmodule.aircall._imalloc;

import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.filesystem.File;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

import items.Item;

import saveLoad.saveItem;
import soundPlayer;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.utils.getTimer;

import src2.AnimateObject;
import src2.SnapLine;

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


    private var _sound:soundPlayer;
    private var _lastTime:int;
    private var _elapsedTime:int;
    private var _paused:Boolean;

    private var _soundFile:String;
    private var _pathHolder:Object={};
    private var _t:TextFormat;
    private var _t2:TextFormat;
    private var _t3:TextFormat;
    public var fileName:String;
    private const DEFAULT_TIME:int = 120;
    private var _animation:AnimateObject;

    public function TimeLine(updateFunction)
    {
        _updateFunc = updateFunction;

        _paused = true;

        _sound = new soundPlayer();



        var X:int = 20;
        var X2:int = 620;
        var Y:int = 387;
        var dis:int = 10;
        var textWidth:int = 150;
        var textHeigth:int = 30;


        //==========Button
        _playBtn = new Sprite();
        Utils.drawRect(_playBtn,0,0,24,24,0xffffff);
        var bit:Bitmap = new assets.Play();
        bit.smoothing = true;
        bit.width = bit.height = 24;
        _playBtn.addChild(bit);
        _playBtn.x = X + 40;
        _playBtn.y = Y;
        addChild(_playBtn);
        _playBtn.addEventListener(MouseEvent.CLICK, onPausePlayBtn);


        //==========Seek Bar
        var dif:int = 8;
        _timeBar = new TimeBar(0,0xffffff,20000,_playBtn.height-dif);
        _timeBar.x = _playBtn.width + _playBtn.x + dis;
        _timeBar.y = _playBtn.y + dif;
        _timeBar.width = X2 - _timeBar.x;
        _timeBar.onChange = changePercent;
        _timeBar.start();
        addChild(_timeBar);

        var handle:Handle = new Handle(_timeBar.height);
        //handle.height = _timeBar.height;
        _timeBar.handle = handle;
        addChild(handle)

        var mask:Sprite = new Sprite();
        Utils.drawRect(mask, 0, 0, _timeBar.width, _timeBar.height);
        mask.x = _timeBar.x;
        mask.y = _timeBar.y;
        addChild(mask);
        _timeBar.mask = mask;


        var lineBack:Sprite = new Sprite();
        Utils.drawRect(lineBack, 0,0,mask.width, dif-3, 0x000000);
        lineBack.x = mask.x;
        lineBack.y = mask.y - dif;
        addChild(lineBack);

        var line:Sprite = new Sprite();
        Utils.drawRect(line, 0,0,mask.width, dif-3, 0x777777);
        lineBack.addChild(line);
        lineBack.addEventListener(Event.ENTER_FRAME, ef);
        lineBack.addEventListener(MouseEvent.MOUSE_DOWN, onLine);
        var handle2:Sprite = new Sprite();
        Utils.drawRect(handle2,-1,lineBack.y,2,lineBack.height,0xff0000)
        addChild(handle2);
        var down:Boolean = false;
        function ef(event:Event):void
        {
            line.scaleX = mask.width/_timeBar.width;
            line.x = ((mask.x-_timeBar.x) / _timeBar.width) * mask.width;
            handle2.x = lineBack.x + _timeBar.percent*lineBack.width;

            if(down)
            {
                changePercent(lineBack.mouseX/lineBack.width);
                _timeBar.x = mask.x - ((lineBack.mouseX - line.width/2)/lineBack.width)*_timeBar.width;
            }
        }
        function onLine(e:MouseEvent):void
        {
            down = true;
            stage.addEventListener(MouseEvent.MOUSE_UP, upLine)
        }
        function upLine(event:MouseEvent):void
        {
            down = false;
            stage.removeEventListener(MouseEvent.MOUSE_UP, upLine)

        }

        //==========Text Fields
        _currentBox = new TextField();
        _totalBox = new TextField();

        _currentBox.width = _totalBox.width = textWidth;
        _currentBox.height = _totalBox.height = textHeigth;

        _currentBox.x = _timeBar.x;
        _totalBox.x = X2 - _totalBox.width;

        _currentBox.y = _timeBar.y + _timeBar.height;
        _totalBox.y = _currentBox.y;

        //_totalBox.selectable = _currentBox.selectable = false;

        _t = new TextFormat();
        _t2 = new TextFormat();
        _t3 = new TextFormat();
        _t3.font = _t2.font = _t.font = "B Yekan"
        _t3.size = _t.size = 15;
        _t2.size = 12;
        _t3.color = _t.color = 0xffffff;
        _t2.color = 0x222222;
        _t2.align = _t.align = TextFormatAlign.LEFT;
        _t3.align = TextFormatAlign.RIGHT;

        _currentBox.type = 'input';
        _currentBox.addEventListener(FocusEvent.FOCUS_IN, focusInCurrentBox);
        _currentBox.addEventListener(FocusEvent.FOCUS_OUT, focusOutCurrentBox);

        addChild(_currentBox);
        addChild(_totalBox);


        //================ init
        totalSec = DEFAULT_TIME;
        currentSec = 0;


        var cover:Sprite;

        /*
        cover = new Sprite();
        Utils.drawRect(cover,_currentBox.x,_currentBox.y,_currentBox.width,_currentBox.height);
        cover.alpha = 0;
        addChild(cover);
        */

        cover = new Sprite();
        Utils.drawRect(cover,_totalBox.x,_totalBox.y,_totalBox.width,_totalBox.height);
        cover.alpha = 0;
        addChild(cover);

    }


    //////////////////////
    public function set sound(path:String):void
    {
        pause();
        Main.changed = true;
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
    public function changePercent(percent:Number):void
    {
        ObjectManager.deselect();
        if(!_paused && _soundFile)
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
        ObjectManager.deselect();
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

        if(Main.animationControl)
            Main.animationControl.time = currentSec
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

        _timeBar.reset();
        _totalMSec = value;
        _totalSec = value / 1000;
        _totalBox.text = totalTime;
        _totalBox.setTextFormat(_t3);
        //update timeBar
        _timeBar.percent = currentMSec / totalMSec;
        _timeBar.totalTime = totalSec;
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
        _currentBox.text = currentTime + '.' + String(Utils.addZero(int((currentSec - int(currentSec))*100)));
        _currentBox.setTextFormat(_t)
        _currentBox.setTextFormat(_t2, _currentBox.length-3, _currentBox.length);
    }

    ///////////////// Insert Current Time By User
    private function changeTime(event:Event = null):void
    {
        currentTime = _currentBox.text;
    }

    private function focusInCurrentBox(event:FocusEvent):void
    {
        stage.addEventListener(KeyboardEvent.KEY_DOWN, key);
        stage.addEventListener(MouseEvent.MOUSE_DOWN, down);
    }

    private function down(e:MouseEvent):void
    {
        if(!Utils.isParentOf(stage, this, e.target as DisplayObject))
        {
            focusOutCurrentBox(null);
            if(stage.focus == _currentBox);
                stage.focus = null;
        }
    }

    private function focusOutCurrentBox(event:FocusEvent):void
    {
        stage.removeEventListener(KeyboardEvent.KEY_DOWN, key);
        stage.removeEventListener(MouseEvent.MOUSE_DOWN, down);

        changeTime();
    }

    private function key(e:KeyboardEvent):void
    {
        _currentBox.setTextFormat(_t);

        if(e.keyCode == 13)
        {
            focusOutCurrentBox(null);
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
        if(!soundFile)
        {
            dispatchComplete();
            return;
        }
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
            var f:File = new File(_pathHolder.newPath);
            fileName = f.name;
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

    public function reset():void
    {
        if(!_paused)
                pause();
        _timeBar.reset();
        _sound.reset();
        _soundFile = null;
        currentSec = 0;
        totalSec = DEFAULT_TIME;
        fileName = null;
    }

    public function get typing():Boolean
    {
        if(stage.focus == _currentBox)
                return true;
        else
                return false;
    }

    public function toPause():void
    {
        if(!_paused)
                pause()
    }

    public function zoom(value:Number):void
    {
        _timeBar.setZoom(value);
    }

    public function select(obj:Item):void
    {
        _timeBar.deselect();

        if(_animation)
            _animation.removeEventListener(Event.CHANGE, changeAnim);

        if(obj)
        {
            _animation = obj.animation;
            _animation.addEventListener(Event.CHANGE, changeAnim);
            changeAnim();
        }
    }

    private function changeAnim(e:Event = null):void
    {
        if(!_animation)
                return;

        //trace('changeAnim');

        var stop:Number = _animation.stopTime;
        if(stop == -1)
                stop = totalSec;
        var duration:Number = stop - _animation.startTime;

        _timeBar.select(_animation.startTime/totalSec, duration/totalSec)
    }

    public function stepUp():void
    {
        var x:int = _timeBar.handle.x;
        setTimeByTopic(currentSec + (_timeBar.mask.width/_timeBar.width)*totalSec);
        _timeBar.x -= (_timeBar.handle.x - x)
    }
    public function stepDown():void
    {
        var x:int = _timeBar.handle.x;

        setTimeByTopic(currentSec - (_timeBar.mask.width/_timeBar.width)*totalSec);
        _timeBar.x -= (_timeBar.handle.x - x)

    }

    public function addSnap(time:Number):SnapLine
    {
       return(_timeBar.addSnap(time/totalSec));
    }

    public function get paused():Boolean
    {
        return _paused;
    }
}
}