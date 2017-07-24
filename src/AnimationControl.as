/**
 * Created by mkh on 2017/04/09.
 */
package
{
import SpriteSheet.Packer;

import flash.display.Bitmap;

import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.utils.getTimer;
import flash.utils.setTimeout;

import items.Item;

import org.villekoskela.utils.IntegerRectangle;

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
    private var packer:Packer;

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

        if(value < 0)
                value = 0;

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
        }

        trace('Animation Object no Exist')
    }


    public function addLoaded(holder:Item, startTime:Number, stopTime:Number, showDuration:Number, hideDuration:Number, typingEndTime:Number):void
    {
        var anim:AnimateObject = new AnimateObject(holder, startTime, true);
        anim._stopTime = stopTime;
        anim.duration(showDuration, hideDuration);
        anim.time = 0;
        anim._typingEndTime = typingEndTime;

        _list.push(anim);
        holder.animation = anim;
    }

    public function loadItems():void
    {
        var len:int = _list.length;
        if(!len)
        {
            Main._progress.percent = 1;
            return;
        }
        var i:int = 0;
        load()

        function load():void
        {
            var removes:Array =[];
            if(i>=len)
            {
                trace('complete load');
                trace('=========================');
                for(var j :int = 0; j <len; j++)
                {
                    AnimateObject(_list[j]).object.setIndex();
                    if(AnimateObject(_list[j]).object._noExist)
                        removes.push(AnimateObject(_list[j]).object);
                }
                for(var n:int = 0; n<removes.length; n++)
                {
                    Item(removes[n]).remove(false);
                }
                Main.changed = false;
                trace('Main.loadedTime',Main.loadedTime);
                _time = -1;
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
            setTimeout(load, 1);
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

        if(Main.dragManager.back)
                object.back = Main.dragManager.getBackName;

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
        Main._progress.percent = 0;
        Main._progress.text = 'Comparing...';
        setTimeout(save, 100);

        var total:int=0;

        function save():void
        {
            if(Main.toExport)
            {
                var bitmaps:Vector.<DisplayObject> = new <DisplayObject>[];
                var ids:Vector.<int> = new <int>[];
                var repeats:Vector.<AnimateObject> = new <AnimateObject>[];
                var item:Item;
                var obj1:AnimateObject;
                var obj2:AnimateObject;
                var bit:Bitmap;


                var sheetNum:int = 0;
                var items:int = 0;
                trace('All', _list.length, 'packed', bitmaps.length, 'repeat', repeats.length, 'diff', _list.length-(bitmaps.length+repeats.length));

                i = 0;
                compare();
                function compare():void
                {
                    if(i>=_list.length)
                    {
                        if(!packer)
                            packer = new Packer();

                        packer.create(bitmaps, ids, func);

                        return;
                    }


                    obj1 = AnimateObject(_list[i]);
                    item = obj1.object;
                    item.smallBitmap();

                    bit = item.bitmap;

                    var mathedId:int = -10;
                    var j:int = ids.length-1;
                    var total:int = j;

                    var time1:int = getTimer();
                    var time2:int;
                    var numOfStack:int = 0;

                    check();

                    function check():void
                    {
                        Main._progress.percent = i/_list.length;
                        Main._progress.text = 'Comparing Item ' + String(i+1) + '/' + String(_list.length)  + ' - Mathed Items: ' + String(repeats.length);

                        if(j <= -1)
                        {
                            if(mathedId == -10)
                            {
                                bitmaps.push(bit);
                                ids.push(i);
                                obj1.id = i;
                            }
                            else
                            {
                                obj1.id = mathedId;
                                repeats.push(obj1);
                                obj2.object.correctBitmap(obj1.object.bitmap);
                            }

                            i++;
                            compare();

                            return;
                        }



                        obj2 = AnimateObject(_list[ids[j]]);

                        if(Utils.displayMatching(bit, obj2.object.bitmap) == 1)
                        {
                            mathedId = ids[j];
                            //break;
                            j = -1;
                        }

                        j--;

                        time2 = getTimer();
                        if(time2 - time1 > 100 || numOfStack >= 35)
                        {
                            time1 = time2;
                            numOfStack = 0;
                            setTimeout(check, 1);
                        }
                        else
                        {
                            numOfStack++;
                            check();
                        }
                    }
                }

                function func(bit:Bitmap,rects:Vector.<IntegerRectangle>):void
                {
                    var n:int = 0;
                    if(rects)
                    {
                        n = rects.length
                    }
                    else
                    {
                        trace('NOOOOOO rects.length')
                    }

                    total += n;
                    if(bit == null || !bit.width || !bit.height)
                    {
                        trace('finish', total, _list.length, repeats.length);
                        setTimeout(saveSound,1000);
                        return;
                    }

                    sheetNum++;

                    Main._progress.percent = items/len;
                    Main._progress.text = 'Creat Sheets... ' + String(items) + '/' + String(len);
                    items +=  rects.length;

                    Utils.saveBitmap(bit, _savedDirectory+'/'+ String(sheetNum)+'.png', f);
                    var pos:Object;
                    for(var i:int=rects.length-1; i>-1; i--)
                    {
                        pos = {x:rects[i].x, y:rects[i].y, w:rects[i].width , h:rects[i].height};

                        AnimateObject(_list[rects[i].id]).position = pos;
                        AnimateObject(_list[rects[i].id]).sheet = sheetNum;

                        for(var j:int=repeats.length-1; j>-1; j--)
                        {
                            if(repeats[j].id == rects[i].id)
                            {
                                repeats[j].object.resetBitmap(AnimateObject(_list[rects[i].id]).object.bitmap);
                                repeats[j].position = pos;
                                repeats[j].sheet = sheetNum;
                                repeats[j] = repeats.pop();
                            }
                            else
                            {
                                //trace('false', repeats[j].id , rects[i].id)
                            }
                        }

                    }
                }

                function f():void
                {
                    //trace('sheetNum:' ,sheetNum);
                    //trace('repeats.length',repeats.length);
                }

                return;
            }


            if(i>=len)
            {
                trace('complete save');
                i = 0;
                saveSound();

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

            setTimeout(save, 1);
        }

        function move():void
        {
            if(i>=len)
            {
                trace('complete move');
                trace('=========================');
                saveSound();
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

            setTimeout(move, 1);
        }

    }

    private function saveSound():void
    {
        Main._progress.percent = 0;
        Main._progress.text = 'Saving Sound...';
        Main.timeLine.addEventListener(Event.COMPLETE, onCompleteSound);
        //Main.timeLine.saveSound(_savedDirectory);
        setTimeout(Main.timeLine.saveSound, 20, _savedDirectory);
    }

    private function onCompleteSound(event:Event):void
    {
        Main._progress.percent = .33;
        Main._progress.text = 'Saving Back...';
        if(Main.dragManager.back)
        {
            //Main.dragManager.saveBack(completeSaving);
            setTimeout(Main.dragManager.saveBack, 20, _savedDirectory, completeSaving);
        }
        else
            completeSaving();

    }

    private function completeSaving():void
    {
        Main._progress.percent = .66;
        Main._progress.text = 'Saving Project File...';
        SaveFile.save(saveObject, Utils.time);
        //Main.toExport = false;
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

    public function get visibleList():Array
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

    public function get visibleItems():Array
    {
        var newList:Array = new Array();
        _length = _list.length;
        for(var i:int = 0; i<_length; i++)
        {
            if(AnimateObject(_list[i]).object.visible)
                newList.push(_list[i].object);
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
