/**
 * Created by mkh on 2017/04/09.
 */
package src2
{
import flash.events.Event;

import items.Item;
import items.TextItem;

public class AnimateObject
{
    private var _object:Item;
    private var _startTime:Number;
    private var _showDuration:Number = 1;
    private var _stopTime:Number = -1;
    private var _hideDuration:Number = 1;
    private var _time:Number = -1;


    public function AnimateObject(object:Item, startTime:Number):void
    {
        _object = object;
        _object.addEventListener(Event.CLEAR, onClear);
        _object.addEventListener(Event.ADDED, onAdd);

        this.startTime = startTime;
    }

    private function onAdd(event:Event):void
    {
        startTime = Utils.time;
        show();
    }

    private function onClear(event:Event):void
    {
        if(stopTime < Utils.time)
            show();

        stopTime =  Utils.time;
    }

    public function get time():Number
    {
        return _time;
    }

    public function set time(value:Number):void
    {
        if(_time == value)
                return;

        _time = value;

        if(time < _startTime)
        {
            hide();
        }
        else if (time < _startTime + _showDuration)
        {
            show((time - _startTime) / _showDuration);
        }
        else if (time < _stopTime || _stopTime < _startTime + _showDuration)
        {
            show();
        }
        else if(time < _stopTime + _hideDuration)
        {
            hide((time -_stopTime) / _hideDuration)
        }
        else
        {
            hide();
        }
    }

    private function show(percent:Number = 1):void
    {
        setProps(percent);
    }

    private function hide(percent:Number = 1):void
    {
        if(percent == 1)
        {
            _object.visible = false;
        }
        else
        {
            setProps();
            _object.alpha = 1 - percent;
        }
    }

    private function setProps(percent:Number = 1):void
    {
        _object.setState();
        _object.alpha = percent;
        if(_object is TextItem)
                TextItem(_object).showTypeEffect();
        if(percent == 1)
                return;

        for (var field:String in _object.startProps)
        {
            setProp(field, 1-percent);
        }
    }

    private function setProp(prop:String, percent:Number)
    {
        _object[prop] -= percent * (_object[prop] - _object.startProps[prop]);
    }

    public function get startTime():Number
    {
        return _startTime;
    }

    public function set startTime(value:Number):void
    {
        _startTime = value;

    }

    public function get stopTime():Number
    {
        return _stopTime;
    }

    public function set stopTime(value:Number):void
    {

        if(value < _startTime + _showDuration && value != -1)
            value = _startTime + _showDuration;

        _stopTime = value;
    }

    public function get object():Item
    {
        return _object;
    }

    public function duration(showDuration:Number, hideDuration:Number):void
    {
        _showDuration = showDuration;
        _hideDuration = hideDuration;
    }

    public function get all():Object
    {
        var obj:Object = object.all;
        obj.startTime = startTime;
        obj.stopTime = stopTime;
        obj.showDuration = _showDuration;
        obj.hideDuration = _hideDuration;
        return obj;
    }
}
}