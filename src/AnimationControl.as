/**
 * Created by mkh on 2017/04/09.
 */
package
{
import flash.events.Event;
import flash.events.MouseEvent;
import flash.utils.setTimeout;

import items.Item;

import saveLoad.SaveFile;

import src2.AnimateObject;

import src2.AnimateObject;
import src2.Utils;

public class AnimationControl
{
    private var _list:Array;
    private var _time:Number;
    private var _duration:Number = 0;
    private var _savedDirectory:String = '';
    private var _number:int = 0;
    private var _length:uint;

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

        _length =  _list.length;
        for(var i:int = 0 ; i < _length; i++)
        {
            AnimateObject(_list[i]).time = _time;
        }
    }

    public function add(object:Item, time:Number):void
    {
        object.number = ++_number;
        var anim:AnimateObject = new AnimateObject(object, time);
        _list.push(anim);
        object.animation = anim;
    }

    public function removeAnimation(item:Item):void
    {
        _length = _list.length;
        for (var i:int = 0; i<_length; i++)
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


    public function addLoaded(holder:Item, startTime:Number, stopTime:Number, showDuration:Number, hideDuration:Number, typingEndTime:Number):void
    {
        var anim:AnimateObject = new AnimateObject(holder, startTime, true);
        anim.stopTime = stopTime
        anim.duration(showDuration, hideDuration);
        anim.time = 0;
        anim.typingEndTime = typingEndTime;

        _list.push(anim);
        holder.animation = anim;
    }

    public function loadItems():void
    {
        var len:int = _list.length;
        var i:int = 0;
        load()

        function load():void
        {
            if(i>=len)
            {
                trace('complete load');
                trace('=========================');
                for(var j :int = 0; j <len; j++)
                {
                    AnimateObject(_list[j]).object.setIndex();
                }
                Main.changed = false;
                Main.timeLine.setTimeByTopic(Main.loadedTime);
                return;
            }

            AnimateObject(_list[i]).object.addEventListener(Event.COMPLETE, onComplete);
            AnimateObject(_list[i]).object.load();
        }

        function onComplete(event:Event):void
        {
            AnimateObject(_list[i]).object.removeEventListener(Event.COMPLETE, onComplete);
            i++;

            Main._progress.percent = i/len;
            Main._progress.text = 'Loading Files ' + i + ' / ' + len;
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

        object.snapList = Main.snapList.object;

        return object;
    }

    public function reSave():void
    {
        saveFiles();
    }

    public function saveFiles():void
    {
        _savedDirectory = FileManager.itemsFolder;

        var i:int = 0;
        var len:int = _list.length;
        save()

        function save():void
        {
            if(i>=len)
            {
                trace('complete save');
                i = 0;
                move();

                return;
            }

            AnimateObject(_list[i]).object.addEventListener(Event.COMPLETE, onComplete);
            AnimateObject(_list[i]).object.save(_savedDirectory);
        }

        function onComplete(event:Event):void
        {
            AnimateObject(_list[i]).object.removeEventListener(Event.COMPLETE, onComplete);
            i++;

            Main._progress.percent = i/len;
            Main._progress.text = 'Saving Files ' + i + ' / ' + len;

            setTimeout(save, 10);
        }

        function move():void
        {
            if(i>=len)
            {
                trace('complete move');
                trace('=========================');
                Main.timeLine.addEventListener(Event.COMPLETE, onCompleteSound);
                Main.timeLine.saveSound(_savedDirectory);
                return;
            }

            AnimateObject(_list[i]).object.addEventListener(Event.COMPLETE, onCompleteMove);
            AnimateObject(_list[i]).object.move();
        }

        function onCompleteMove(event:Event):void
        {
            AnimateObject(_list[i]).object.removeEventListener(Event.COMPLETE, onCompleteMove);
            i++;

            Main._progress.percent = i/len;
            Main._progress.text = 'Saving Settings ' + i + ' / ' + len;

            setTimeout(move, 10);
        }

    }

    private function onCompleteSound(event:Event):void
    {
        SaveFile.save(saveObject, Utils.time);


        trace('============ FINISH SAVING ===============');

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

    private function get visibleList():Array
    {
        var newList:Array = new Array();
        _length = _list.length;
        for(var i:int = 0; i<_length; i++)
        {
            if(AnimateObject(_list[i]).object.visible)
                newList.push(_list[i]);
        }

        return newList;
    }

    public function hideAll():void
    {
        var list:Array = visibleList;
        _length = list.length;

        for(var i:int = 0; i<_length; i++)
        {
            AnimateObject(list[i]).object.Hide();
        }
    }


    public function showAll():void
    {
        var list:Array = visibleList;
        _length = list.length;

        for(var i:int = 0; i<_length; i++)
        {
            AnimateObject(list[i]).object.Show();
        }
    }

    public function showAllNew():void
    {
        var list:Array = visibleList;

        Main.hightLight(TimeLine);
        Main.STAGE.addEventListener(MouseEvent.MOUSE_UP, onUp);
        function onUp(e:MouseEvent):void
        {
            Main.hightLight();
            Main.STAGE.removeEventListener(MouseEvent.MOUSE_UP, onUp);

            _length = list.length;

            for(var i:int = 0; i<_length; i++)
            {
                AnimateObject(list[i]).object.Show();
            }
        }
    }

    public function hideAllNew():void
    {
        var list:Array = visibleList;

        Main.hightLight(TimeLine);
        Main.STAGE.addEventListener(MouseEvent.MOUSE_UP, onUp);
        function onUp(e:MouseEvent):void
        {
            Main.hightLight();
            Main.STAGE.removeEventListener(MouseEvent.MOUSE_UP, onUp);

            _length = list.length;

            for (var i:int = 0; i < _length; i++)
            {
                AnimateObject(list[i]).object.Hide();
            }
        }
    }
}
}
