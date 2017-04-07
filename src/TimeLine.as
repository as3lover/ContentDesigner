/**
 * Created by mkh on 2017/04/03.
 */
package
{
import flash.display.Sprite;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.text.TextField;

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

    private var _playBtn:Button

    private var _animation:Animations;

    public function TimeLine(animation:Animations)
    {
        _animation = animation;

        //==========Seek Bar
        _timeBar = new TimeBar();
        _timeBar.x = 150;
        _timeBar.y = 400;
        _timeBar.width = 500;
        _timeBar.onChange = changePercent;
        _timeBar.start();
        addChild(_timeBar);

        //==========Button
        _playBtn = new Button('>||',0,0,40,20);
        _playBtn.x = _timeBar.x - _playBtn.width - 5;
        _playBtn.y = _timeBar.y - 5;
        _playBtn.addEventListener(MouseEvent.CLICK, onPausePlayBtn);
        addChild(_playBtn);

        //==========Text Fields
        _currentBox = new TextField();
        _totalBox = new TextField();

        _currentBox.width = _totalBox.width = 60;
        _currentBox.height = _totalBox.height = 20;

        _currentBox.x = _playBtn.x - _currentBox.width - 10;
        _totalBox.x = _timeBar.x + _timeBar.width + 10;

        _currentBox.y = _timeBar.y + (_timeBar.height - _currentBox.height) / 2;
        _totalBox.y = _currentBox.y;

        _currentBox.type = 'input';
        _currentBox.addEventListener(FocusEvent.FOCUS_IN, focusInCurrentBox);
        _currentBox.addEventListener(FocusEvent.FOCUS_OUT, focusOutCurrentBox);

        addChild(_currentBox);
        addChild(_totalBox);

        //================ init
        totalSec = 20;
        currentSec = 0;
    }

    //////////////////////Change percent by user click on timeBar
    private function changePercent(percent:Number):void
    {
        if(_animation.paused == false)
            _animation.pause();

        currentMSec = percent * totalMSec;
    }


    ////////////////////////////////
    private function onPausePlayBtn(event:MouseEvent):void
    {
        _animation.pausePlay();
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

    ////////////////////////////////////// onUpdate Function
    public function get updateFunc():Function
    {
        return _updateFunc;
    }

    public function set updateFunc(value:Function):void
    {
        _updateFunc = value;
    }

}
}