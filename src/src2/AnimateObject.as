/**
 * Created by mkh on 2017/04/09.
 */
package src2
{
import flash.events.Event;
import flash.events.EventDispatcher;

import items.Item;
import items.ItemText;

public class AnimateObject extends EventDispatcher
{
    private var _object:Item;
    public var _startTime:Number;
    private var _showDuration:Number = .5;
    public var _stopTime:Number = -1;
    private var _hideDuration:Number = 1;
    private var _time:Number = -1;
    private var _changeEvent:Event;
    public var _typingEndTime:Number = -1;
    private var _id:int = -1;
    private var _sheet:int;
    private var _position:Object;
    private var settedID:Boolean;
    private static var total:int=0;
    private var _number:int;


    public function AnimateObject(object:Item, startTime:Number, loadedObject:Boolean = false):void
    {
        _number = AnimateObject.total++;
        _changeEvent = new Event(Event.CHANGE);

        _object = object;
        _object.addEventListener(Event.CLEAR, onClear);
        _object.addEventListener(Event.ADDED, onAdd);
        _object.addEventListener('startTime', changeStartTime);

        //this.startTime = startTime;
        _startTime = startTime;
    }

    private function changeStartTime(event:Event):void
    {
        startTime = Utils.time;
        dispatchChangeEvent();
    }

    private function onAdd(event:Event):void
    {
        //trace('onAdd');

        //startTime = Utils.time;

        if(Main.changed)
            show();

        //dispatchChangeEvent();

    }

    private function onClear(event:Event):void
    {
        if(stopTime < Utils.time)
            show();

        stopTime =  Utils.time;

        dispatchChangeEvent();
    }

    private function dispatchChangeEvent():void
    {
        dispatchEvent(_changeEvent);
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

        var showDuration:Number = _showDuration;
        if(_object is ItemText )
        {
            if(_typingEndTime == -1)
            {
                ItemText(_object).typeEffect = false;
            }
            else
            {
                showDuration = _typingEndTime - _startTime;
                ItemText(_object).typeEffect = true;
            }
        }

        if(time < _startTime)
        {
            hide();
        }
        else if (time < _startTime + showDuration)
        {
            show((time - _startTime) / showDuration);
        }
        else if (time < _stopTime || _stopTime < _startTime + showDuration)
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

        dispatchChangeEvent();

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

        if(_object is ItemText)
            ItemText(_object).showTypeEffect(percent);

        if(percent == 1)
                return;

        for (var field:String in _object.startProps)
        {
            setProp(field, 1-percent);
        }
    }

    private function setProp(prop:String, percent:Number):void
    {
        _object[prop] -= percent * (_object[prop] - _object.startProps[prop]);
    }

    public function get startTime():Number
    {
        return _startTime;
    }

    public function set startTime(value:Number):void
    {
        var stop:Number = _stopTime;
        if(_stopTime < value)
                stop = Main.timeLine.totalSec;

        History.add(_object, History.TIME,{
            from:{startTime:_startTime, stopTime:_stopTime},
            to:{startTime:value, stopTime:stop}
        });


        if(Main.timeLine.totalSec < stop || Main.timeLine.totalSec < value)
            Main.timeLine.totalSec = Math.max(stop, value);

        _startTime = value;
        _stopTime = stop;

        if(Utils.time < _startTime)
            Main.timeLine.setTimeByTopic(_startTime);

            dispatchChangeEvent();
    }

    public function get stopTime():Number
    {
        return _stopTime;
    }

    public function set stopTime(value:Number):void
    {
        var start:Number = _startTime;
        if(value < _startTime + _showDuration && value != -1)
        {
            start = 0;
        }

        History.add(_object, History.TIME,{
            from:{startTime:_startTime, stopTime:_stopTime},
            to:{startTime:start, stopTime:value}
        });

        if(Main.timeLine.totalSec < start || Main.timeLine.totalSec < value)
            Main.timeLine.totalSec = Math.max(start, value);

        _stopTime = value;
        _startTime = start;

        if(Utils.time > _stopTime)
            Main.timeLine.setTimeByTopic(_stopTime);

        dispatchChangeEvent();

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
        trace('get ID >>>>>>', id, settedID, _number);

        if(id == -1)
        {
            //object.save(FileManager.itemsFolder);
            //object.move();
            trace('NOOOOOOOOOOOOOOOOOOO', object.bitmap.width, object.bitmap.height, sheet, position);
        }

        var obj:Object = object.all;
        obj.startTime = startTime;
        obj.stopTime = stopTime;
        obj.showDuration = _showDuration;
        obj.hideDuration = _hideDuration;
        obj.typingEndTime = _typingEndTime;

        if(id != -1)
        {
            obj.id = id;
            obj.sheet = sheet;
            obj.position = position;
        }

        return obj;
    }

    public function set typingEndTime(value:Number):void
    {
        if(value <= 0)
            value = -1;
        if(value > Main.timeLine.totalSec)
                value = Main.timeLine.totalSec;


        History.add(_object, History.TIME,{
            from:{typingEndTime:_typingEndTime},
            to:{typingEndTime:value}
        });

        _typingEndTime = value;

    }

    public function get typingEndTime():Number
    {
        return _typingEndTime;
    }

    public function get showDuration():Number
    {
        return _showDuration;
    }

    public function get hideDuration():Number
    {
        return _hideDuration;
    }

    public function set showDuration(showDuration:Number):void
    {
        _showDuration = showDuration;
        dispatchChangeEvent();

    }

    public function set hideDuration(hideDuration:Number):void
    {
        _hideDuration = hideDuration;
        dispatchChangeEvent();

    }

    public function setValues(values:Object):void
    {
        for (var i:String in values)
        {
            //trace(i, values[i])
            this[String('_' + i)] = values[i];
        }
        /*
        _startTime = values.startTime;
        _stopTime = values.stopTime;
        _hideDuration = values.hideDuration;
        _showDuration = values.showDuration;

        trace(values.startTime, values.stopTime, values.showDuration, values.hideDuration);
        */
    }

    private function set _index(value:int):void
    {
        _object._index = value;
        _object.index = value;
    }

    public function get id():int
    {
        return _id;
    }

    public function set id(value:int):void
    {
        _id = value;
        //trace('set id', _id, _number, Main.count++);
        settedID = true;
    }

    public function get sheet():int
    {
        return _sheet;
    }

    public function set sheet(value:int):void
    {
        _sheet = value;
    }

    public function get position():Object
    {
        return _position;
    }

    public function set position(value:Object):void
    {
        _position = value;
    }
}
}
