/**
 * Created by Morteza on 4/4/2017.
 */
package
{
import com.greensock.TimelineMax;
import com.greensock.plugins.*;

import flash.events.TimerEvent;
import flash.utils.Timer;


public class Animations
{
    private var _timeLine:TimelineMax;

    private var _object;
    private var _duration:Number;
    private var _delay:Number;
    private var _changeTime:String;
    private var _x:int;
    private var _y:int;
    private var _scaleX:Number;
    private var _scaleY:Number;
    private var _rotation:int;
    private var _alpha:Number;
    private var _totalTime:Number;
    private var _startTime:Number;
    private var _paused:Boolean = true;

    private var _updateTimeLine:Function;
    private var _timer:Timer;
    private var _list:Array=[];

    public function Animations(updateTimeLine:Function)
    {
        TweenPlugin.activate([AutoAlphaPlugin]);
        _updateTimeLine = updateTimeLine;
        _timeLine = new TimelineMax();
        _timer = new Timer(1000/60);
        _timer.addEventListener(TimerEvent.TIMER, onTimer);
    }

    private function onTimer(event:TimerEvent):void
    {
        _updateTimeLine();

        if(_timeLine.time() == _timeLine.duration())
            pause();
    }


    public function build(list:Array, time:Number, paused:Boolean = true):void
    {
        _list = list;
        _paused = paused;

        _totalTime = 0;
        _timeLine.pause();
        _timeLine = null;
        _timeLine = new TimelineMax();


        var length:int = list.length;
        for (var i:int=0; i<length; i++)
        {
            list[i].from.object.visible = false;
            _startTime = list[i].from.startTime;
            if(!paused)
                addToTimeLine(list[i].from, true);
            else
            {
                addToTimeLine(list[i].to, true);
                list[i].from.object.alpha = 0;
            }
            addToTimeLine(list[i].to);
        }

        if(paused)
            _timeLine.pause(time);
        else
            _timeLine.seek(time);
    }

    private function addToTimeLine(obj:Object, start:Boolean = false):void
    {
        for (var field:String in obj)
        {
            switch(field)
            {
                case 'object':
                    _object = obj[field];
                    break;

                case 'duration':
                    _duration = obj[field];
                    break;

                case 'alpha':
                    _alpha = obj[field];
                    break;

                case 'rotation':
                    _rotation = obj[field];
                    break;

                case 'x':
                    _x = obj[field];
                    break;

                case 'y':
                    _y = obj[field];
                    break;

                case 'scaleX':
                    _scaleX = obj[field];
                    break;

                case 'scaleY':
                    _scaleY = obj[field];
                    break;

                default:
                    trace('Error: undefined property: ' + field , obj[field]);
                    break;
            }
        }

        if(start)
        {
            _object.x = _x;
            _object.y = _y;
            _object.scaleX = _scaleX;
            _object.scaleY = _scaleY;
            _object.alpha = _alpha;
            _object.rotation = _rotation;
            return;
        }

        if(_paused)
            _duration = 0;

        _delay = 0;
        _changeTime = "-=" + String(0);

        if (_totalTime == _startTime)
        {
            _totalTime += _duration;
        }
        else if (_totalTime > _startTime)
        {
            _changeTime = "-=" + String(_totalTime - _startTime);
            _totalTime = Math.max(_startTime + _duration, _totalTime)
        }
        else
        {
            _delay = _startTime - _totalTime;
            _totalTime += _delay + _duration;
        }


        trace(_timeLine.duration(), _delay, _changeTime, _duration );
        _timeLine.to(_object, _duration, {x:_x, y:_y, scaleX:_scaleX, scaleY:_scaleY,
                    autoAlpha:_alpha, rotation:_rotation, delay:_delay}, _changeTime);
    }

    public function seek(seconds:Number):void
    {
        _timeLine.seek(seconds);
    }

    public function pause():void
    {
        paused = true;
    }

    public function play():void
    {
        paused = false;
    }

    public function stop():void
    {
        pause();
        _timeLine.stop();
    }

    public function pausePlay():void
    {
        if(_paused)
            play();
        else
            pause();
    }

    public function get paused():Boolean
    {
        return _paused;
    }

    public function set paused(value:Boolean):void
    {
        if(_paused == value)
                return;

        _paused = value;

        build(_list, time, _paused);

        if(value)
            _timer.stop();
        else
            _timer.start();
    }

    public function get time():Number
    {
        return _timeLine.time();
    }

}
}
