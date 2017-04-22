/**
 * Created by mkh on 2017/04/09.
 */
package
{
import flash.events.Event;
import flash.utils.setTimeout;

import items.Item;

import saveLoad.SaveFile;

import src2.AnimateObject;
import src2.Utils;

public class AnimationControl
{
    private var _list:Array;
    private var _time:Number;
    private var _duration:Number = 0;
    private var _savedDirectory:String = '';
    private var _number:int = 0;

    public function AnimationControl()
    {
        _list = new Array();
        _time = 0;
        _duration = 0;
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

        for(var i:int = 0 ; i < _list.length; i++)
        {
            AnimateObject(_list[i]).time = _time;
        }
    }

    public function add(object:Item, time:Number):void
    {
        object.number = ++_number;
        _list.push(new AnimateObject(object, time))
    }

    public function removeAnimation(item:Item):void
    {

        for (var i:int = 0; i<_list.length; i++)
        {
            if(AnimateObject(_list[i]).object == item)
            {
                Utils.removeItemAtIndex(_list, i);
                return;
            }
            else
            {
                trace(AnimateObject(_list[i]).object.name, item.name)
            }
        }
    }


    public function addLoaded(holder:Item, startTime:Number, stopTime:Number, showDuration:Number, hideDuration:Number):void
    {
        var anim:AnimateObject = new AnimateObject(holder, startTime);
        anim.stopTime = stopTime
        anim.duration(showDuration, hideDuration);
        anim.time = 0;
        _list.push(anim);
    }

    public function loadItems():void
    {
        var len:int = _list.length;
        var i:int = 0;
        load()

        function load()
        {
            if(i>=len)
            {
                trace('complete load');
                trace('=========================');
                for(var j :int = 0; j <len; j++)
                {
                    AnimateObject(_list[j]).object.setIndex();
                }
                return;
            }

            AnimateObject(_list[i]).object.addEventListener(Event.COMPLETE, onComplete);
            AnimateObject(_list[i]).object.load();
        }

        function onComplete(event:Event):void
        {
            AnimateObject(_list[i]).object.removeEventListener(Event.COMPLETE, onComplete);
            i++;
            trace('load', i, '/', len, '=', int((100 * i / len)*100)/100, '%');
            setTimeout(load, 10);
        }

    }


    public function get saveObject():Object
    {
        var object:Object = {};
        var len:int =  _list.length;

        for(var i:int = 0; i<len; i++)
        {
            var obj:Object = AnimateObject(_list[i]).all;
            object['obj_' + String(i)] = obj;
        }

        object.number = number;

        object.topics = Main.topics.object;

        return object;
    }

    public function reSave()
    {
        saveFiles(_savedDirectory);
    }

    public function saveFiles(path:String):void
    {
        _savedDirectory = path;

        var i:int = 0;
        var len:int = _list.length;
        save()

        function save()
        {
            if(i>=len)
            {
                trace('complete save');
                i = 0;
                move();

                return;
            }

            AnimateObject(_list[i]).object.addEventListener(Event.COMPLETE, onComplete);
            AnimateObject(_list[i]).object.save(path);
        }

        function onComplete(event:Event):void
        {
            AnimateObject(_list[i]).object.removeEventListener(Event.COMPLETE, onComplete);
            i++;
            trace('save', i, '/', len, '=', int((100 * i / len)*100)/100, '%');
            setTimeout(save, 10);
        }

        function move()
        {
            if(i>=len)
            {
                trace('complete move');
                trace('=========================');
                Main.timeLine.addEventListener(Event.COMPLETE, onCompleteSound);
                Main.timeLine.saveSound(path);
                return;
            }

            AnimateObject(_list[i]).object.addEventListener(Event.COMPLETE, onCompleteMove);
            AnimateObject(_list[i]).object.move();
        }

        function onCompleteMove(event:Event):void
        {
            AnimateObject(_list[i]).object.removeEventListener(Event.COMPLETE, onCompleteMove);
            i++;
            trace('move', i, '/', len, '=', int((100 * i / len)*100)/100, '%');
            setTimeout(move, 10);
        }

    }

    private function onCompleteSound(event:Event):void
    {
        SaveFile.save(saveObject, Utils.time, null, _savedDirectory);
        trace('==========================================')
        trace('============ FINISH SAVING ===============');
        trace('==========================================')
    }

    public function get savedDirectory():String
    {
        return _savedDirectory;
    }

    public function set savedDirectory(value:String):void
    {
        _savedDirectory = value;
    }

    public function get number():int
    {
        return _number;
    }

    public function set number(value:int):void
    {
        _number = value;
    }

    public function reset():void
    {
        _number = 0;
        _list = [];
    }
}
}
