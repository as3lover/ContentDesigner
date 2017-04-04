/**
 * Created by mkh on 2017/04/03.
 */
package
{
import flash.display.Sprite;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.text.TextField;

public class TimeLine extends Sprite
{
    private var _timeBar:TimeBar;
    private var _totalMSec:int;
    private var _currentMSec:int;

    private var _currentBox:TextField;
    private var _totalBox:TextField;

    public function TimeLine()
    {
        _timeBar = new TimeBar();
        _timeBar.x = 100;
        _timeBar.y = 400;
        _timeBar.width = 600;
        _timeBar.updateFunction = func;
        _timeBar.start();
        addChild(_timeBar);


        _currentBox = new TextField();
        _totalBox = new TextField();

        _currentBox.width = _totalBox.width = 60;
        _currentBox.height = _totalBox.height = 20;

        _currentBox.x = _timeBar.x - _currentBox.width - 10;
        _totalBox.x = _timeBar.x + _timeBar.width + 10;

        _currentBox.y = _timeBar.y + (_timeBar.height - _currentBox.height) / 2;
        _totalBox.y = _currentBox.y;

        _currentBox.text = '00:00';

        _currentBox.type = 'input';
        _currentBox.addEventListener(FocusEvent.FOCUS_IN, focusInCurrentBox);
        _currentBox.addEventListener(FocusEvent.FOCUS_OUT, focusOutCurrentBox);

        addChild(_currentBox);
        addChild(_totalBox);


        totalSec = 20000;
    }

    private function func(percent:Number):void
    {
        if(_currentMSec == currentMSec)
                return

        _currentMSec = currentMSec;
        _currentBox.text = currentTime;
        trace(_currentBox.text, currentMSec)
    }

    //////////////////////////

    /////// total seconds
    public function get totalSec():int
    {
        return int(totalMSec / 1000);
    }

    public function set totalSec(value:int):void
    {
        totalMSec = value * 1000;
    }

    /////////// total Milli Seconds
    public function get totalMSec():int
    {
        return _totalMSec;
    }

    public function set totalMSec(value:int):void
    {
        if(value < 0)
            value = 0;

        _totalMSec = value;
        _totalBox.text = totalTime;
    }

    /////////////// Current Time (String)
    public function get currentTime():String
    {
        return timeFormat(int(_timeBar.percent * totalMSec));
    }

    public function set currentTime(value:String):void
    {
        _timeBar.percent = timeToSec(value) / totalSec;
    }

    //////////// Total Time (String)
    public function get totalTime():String
    {
        return timeFormat(totalMSec);
    }

    public function set totalTime(value:String):void
    {
       totalSec = timeToSec(value);
    }

    /////////////////////// milli Sec to String
    private function timeFormat(milliSeconds:Number):String
    {
        var t:int = milliSeconds;
        if (t < 1 * 60 * 60 * 1000)
        {
            return addZero(t / 1000 / 60) + " : " + addZero(t / 1000 % 60);
        }
        else
        {
            return String(int(t / 1000 / 60 / 60)) + " : " + addZero(t / 1000 % 3600 / 60)+ " : " + addZero(t / 1000 % 60);
        }
    }

    /////////////// addZero
    private function addZero(num:Number):String
    {
        if ((num < 10))
        {
            return "0" + int(num);
        }
        else
        {
            return String(int(num));
        }
    }

    //convert time format to Number data type
    private function timeToSec(t:Object):Number
    {
        if (t is Number)
            return Number(t);
        else if (t is String)
        {
            var parts:Array=new Array(3);
            parts=t.split(":",3);
            if (parts[1]==undefined)
                return Number(parts[0]);
            else if (parts[2]==undefined)
                return Number(parts[0])*60+Number(parts[1]);
            else
                return Number(parts[0])*3600+Number(parts[1])*60+Number(parts[2]);
        }
        else
        {
            trace("time type is wrong!");
            return 0;
        }
    }

    public function get currentMSec():int
    {
        return int(_timeBar.percent * totalMSec);
    }

    public function set currentMSec(value:int):void
    {
        if(value < 0)
                value = 0;

        _currentMSec = value;
        _timeBar.percent = value/totalMSec;

    }

    /////////////////
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

}
}