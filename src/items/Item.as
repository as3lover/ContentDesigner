/**
 * Created by Morteza on 4/5/2017.
 */
package items
{
import com.greensock.TweenLite;

import flash.display.Bitmap;

import flash.display.Loader;
import flash.display.LoaderInfo;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.MouseEvent;
import flash.filesystem.File;
import flash.net.URLRequest;

import saveLoad.saveItem;

import src2.AnimateObject;

import src2.Consts;
import src2.ToolTip;
import src2.Utils;

public class Item extends Sprite
{
    private var _removeAnimation:Function;
    private var _onChange:Function;

    private var _x:Number;
    protected var _y:Number;
    private var _scaleX:Number;
    private var _scaleY:Number;
    private var _rotation:Number;

    public var startProps:Object;
    private var _motion:String;
    private const distance:Number = 100;
    private var _path:String;

    private var _number:int = -1;

    public var _index:int;
    protected var _bitmap:Bitmap;
    private var _pathHolder:Object={};
    private const _eventComplete:Event = new Event(Event.COMPLETE);
    private var _fileName:String;
    public var animation:AnimateObject;
    public var _noExist:Boolean;

    public function Item(removeAnimataion:Function, path:String, motion:String = Consts.fade)
    {
        super();
        _removeAnimation = removeAnimataion;
        _path = path;

        var menu:ItemMenu = new ItemMenu();
        this.contextMenu = menu.menu;

        startProps = new Object();
        _motion = motion;

        ToolTip.addOnline(this);
        this.addEventListener(MouseEvent.CONTEXT_MENU, rightClick)
    }


    private function rightClick(event:MouseEvent):void
    {
        trace(x,y,rotation,scaleX,scaleY,'-', animation.showDuration, animation.hideDuration, animation.typingEndTime, animation.startTime, animation.stopTime)
        ItemMenu.currentItem = this;
        changed;
        ObjectManager.target = this;
    }

    public function remove(byUser:Boolean):void
    {
        var index:int = this.index;

        if(parent)
        {
            parent.removeChild(this)
        }

        if(_removeAnimation)
        {
            _removeAnimation(this)
        }

        ToolTip.removeOnline(this);

        if(byUser)
            addToHistory(History.REMOVE, {index:index})

    }

    public function setProps():void
    {
        _x = x;
        _y = y;
        _scaleX = scaleX;
        _scaleY = scaleY;
        _rotation = rotation;

        motion = _motion;

    }

    public function setState():void
    {
        rotation = _rotation;
        scaleX = _scaleX;
        scaleY = _scaleY;
        x = _x;
        y = _y;
    }

    public function get changed():Boolean
    {
        if(_x != x || _y != y || _scaleX != scaleX || _scaleY != scaleY || _rotation != rotation)
        {
            var value:Object = {from:{}, to:{}};

            if(_x != x) setHistoryValue('x', value);
            if(_y != y) setHistoryValue('y', value);
            if(_scaleX != scaleX) setHistoryValue('scaleX', value);
            if(_scaleY != scaleY) setHistoryValue('scaleY', value);
            if(_rotation != rotation) setHistoryValue('rotation', value);


            Main.changed = true;
            setProps();

            addToHistory(History.TRANSFORM, value);
            ToolTip.update(this);
            return true;
        }
        return false;
    }

    private function setHistoryValue(i:String, value:Object):void
    {
        trace(i, this[i]);
        value.from[i] = this[String('_' + i)];
        value.to[i] = this[i];
    }


    public function addToHistory(type:String = History.TRANSFORM, value:Object = null):void
    {
        switch (type)
        {
            case History.ADD:
                setAnimation();
                break;

            case History.TRANSFORM:
                if(value == null)
                    value = {x:_x, y:_y, rotation:_rotation, scaleX:_scaleX, scaleY:_scaleY};
                break;

            case History.REMOVE:
                setAnimation();

                break;

            case History.TEXT:
                if(value == null)
                    return;
                break;

            case History.INDEX:
                if(value == null)
                    return;
                break;
        }

        function setAnimation():void
        {
            if(value == null)
                value = new Object();

            value.startTime = animation.startTime;
            value.stopTime = animation.stopTime;
            value.showDuration = animation.showDuration;
            value.hideDuration = animation.hideDuration;
        }

        History.add(this, type, value);
    }



    public function set onChange(value:Function):void
    {
        _onChange = value;
    }

    public function set motion(type:String):void
    {
        if(_motion != type)
        {
            startProps = new Object();
            _motion = type;
        }

        switch (type)
        {
            case Consts.upToDown:
                startProps.y = y - distance;
                break;

            case Consts.downToUp:
                startProps.y = y + distance;
                break;

            case Consts.leftToRight:
                startProps.x = x - distance;
                break;

            case Consts.rightToLeft:
                startProps.x = x + distance;
                break;

            case Consts.rightUp:
                startProps.x = x + distance;
                startProps.y = y - distance;
                break;

            case Consts.leftUp:
                startProps.x = x - distance;
                startProps.y = y - distance;
                break;

            case Consts.rightDown:
                startProps.x = x + distance;
                startProps.y = y + distance;
                break;

            case Consts.leftDown:
                startProps.x = x - distance;
                startProps.y = y + distance;
                break;

            case Consts.zoom:
                startProps.scaleX = scaleX / 3;
                startProps.scaleY = scaleY / 3;
                break;

            case Consts.rotate:
                startProps.rotation = rotation + 180;
                break;
        }
    }

    public function newMotion(type:String):void
    {
        motion = type;
        preview();
    }



    public function preview():void
    {
        setState();
        alpha = 0;

        var vars:Object = {alpha: 1};

        for(var i:String in startProps)
        {
            vars[i] = this[i];
            this[i] = startProps[i];
        }

        TweenLite.to(this, .6, vars);
    }

    public function Hide():void
    {
        dispatchEvent(new Event(Event.CLEAR));
        ObjectManager.target = this;
        alpha = 1;
    }

    public function Show():void
    {
        dispatchEvent(new Event('startTime'));
        ObjectManager.target = this;
        alpha = 1;
        //preview();
    }

    public function HideNew():void
    {
        Main.hightLight(TimeLine);
        stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
        function onUp(e:MouseEvent):void
        {
            Main.hightLight();
            stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
            Hide();
        }
    }

    public function ShowNew():void
    {
        Main.hightLight(TimeLine);
        stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
        function onUp(e:MouseEvent):void
        {
            Main.hightLight();
            stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
            Show();
        }
    }

    public override function set alpha(value:Number):void
    {
        super.alpha = value;

        if(alpha > 0)
                visible = true;
        else
                visible = false;
    }

    public function get index():int
    {
        if(!parent)
                return 1;
        return parent.getChildIndex(this);
    }

    public function set index(i:int):void
    {
        if(!parent)
                return;

        i = correctIndex(i);

        if(i != _index)
        {
            addToHistory(History.INDEX, {from:{index:_index} , to:{index:i}});
            _index = i;
        }

        parent.setChildIndex(this, i);
    }

    public function correctIndex(i:int):int
    {
        if(i == -100 || i > parent.numChildren-1)
            i = parent.numChildren - 1;
        else if(i < 1)
            i = 1;

        return i;
    }

    public function get path():String
    {
        return _path;
    }

    public function get all():Object
    {
        var obj = new Object();
        obj.x = _x;
        obj.y = _y;
        obj.scaleX = _scaleX;
        obj.scaleY = _scaleY;
        obj.rotation = _rotation;
        obj.index = index;
        obj.motion = _motion;
        //obj.path = _path;
        obj.number = _number;
        obj.type = 'image';
        obj.fileName = _fileName;
        return obj;
    }

    public function set all(obj:Object):void
    {
        _x = obj.x;
        _y = obj.y;
        _scaleX = obj.scaleX;
        _scaleY = obj.scaleY;
        _rotation = obj.rotation;
        //_path = obj.path;
        motion = obj.motion;
        _index = obj.index;
        _number = obj.number;
        _fileName = obj.fileName;
    }


    public function load():void
    {
        var loader:Loader = new Loader();
        loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);

        if(_fileName && FileManager.itemsFolder)
        {
            trace('path', _path)
            _path = FileManager.itemsFolder + '/' + _fileName;
            trace('new path:',_path)
        }

        loader.load(new URLRequest(_path));
        loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);

        function onError(event:IOErrorEvent):void
        {
            trace('Can Not Load File:', _path);
            _noExist = true;
            dispatchEvent(new Event(Event.COMPLETE));
            //remove(false);
        }

        function onComplete (event:Event):void
        {
            var bit:Bitmap = Bitmap(LoaderInfo(event.target).content);
            bit.scaleX = .5;
            bit.scaleY= .5;
            bit.x = -bit.width/2;
            bit.y = -bit.height/2;
            bitmap = bit;
            dispatchEvent(new Event(Event.COMPLETE));
        }
    }


    public function setIndex():void
    {
        if(!parent)
                return;

        _index = correctIndex(_index);
        parent.swapChildren(this, parent.getChildAt(_index));
    }

    public function save(dir:String):void
    {
        var newDir = dir;
        var newName:String = 'image_' + String(number) + '.pic';

        saveItem.copyAndRename(_path, newDir, newName, _pathHolder, after);
        function after():void
        {
            /*
            trace('renamed:');
            trace(_pathHolder.currentPath);
            trace(_pathHolder.newPath);
            */
            _path = _pathHolder.currentPath;
            dispatchComplete();
        }
    }

    public function move():void
    {
        saveItem.move(_pathHolder.currentPath, _pathHolder.newPath, after);
        function after():void
        {
            _path = _pathHolder.newPath;
            //trace('saved path', _path);
            var f:File = new File(_path);
            _fileName = f.name;
            dispatchComplete();
        }
    }

    protected function dispatchComplete():void
    {
        dispatchEvent(_eventComplete);
    }

    public function set bitmap(value:Bitmap):void
    {
        if(_bitmap && _bitmap.parent)
            _bitmap.parent.removeChild(_bitmap);

        _bitmap = value;
        _bitmap.smoothing = true;
        addChild(_bitmap);
    }


    public function get bitmap():Bitmap
    {
        return _bitmap;
    }

    public function get number():int
    {
        return _number;
    }

    public function set number(number:int):void
    {
        _number = number;
    }

    public function updateTransform():void
    {
        if(ObjectManager.target == this)
        {
            ObjectManager.target = null;
            ObjectManager.target = this;
        }
    }

    public override function set x(x:Number):void
    {
        x = insideX(x);
        super.x = x;
    }

    public override function get x():Number
    {
        x = super.x;
        return super.x;

    }

    private function insideX(x:Number):Number
    {
        if(x < 0)
            x = 0;
        else if(x > Main.target.w)
            x = Main.target.w;

        return x;
    }

    public override function set y(y:Number):void
    {
        y = insideY(y);
        super.y = y;
    }

    public override function get y():Number
    {
        y = super.y;
        return super.y;

    }

    private function insideY(y:Number):Number
    {
        if(y <0)
            y = 0;
        else if(y > Main.target.h)
            y = Main.target.h;

        return y;
    }

    public static function setIndexByUser(data:String, item:Item):void
    {
        switch(data)
        {
            case Consts.ARRANGE.FRONT:
                item.index = -100;
                break;

            case Consts.ARRANGE.BACK:
                item.index = 1;
                break;

            case Consts.ARRANGE.FRONT_LEVEL:
                item.index++;
                break;

            case Consts.ARRANGE.BACK_LEVEL:
                item.index--;
                break;
        }
    }

    public function get insideWidth():Number
    {
        trace('bitmap', bitmap);
        return bitmap.width * scaleX;
    }

    public function get insideWHeight():Number
    {
        return bitmap.height * scaleY;
    }

    public function get toolTipText():String
    {
        var str:String = '';
        str += '  x: ' + String(normal(_x)) +'     ';
        str += 'y: ' + String(normal(_y)) +'     ';
        str += 'scaleX: ' + String(normal(_scaleX)) +'     ';
        str += 'scaleY: ' + String(normal(_scaleY)) +'     ';
        str += 'Motion: ' + String(_motion) +'     ';
        if(animation.startTime != -1)
            str += 'start: ' + String(Utils.timeFormat(animation.startTime * 1000)) +'     ';
        if(animation.stopTime != -1)
            str += 'stop: ' + String(Utils.timeFormat(animation.stopTime * 1000)) +'     ';
        if(animation.typingEndTime != -1)
            str += 'Type End Time: ' + String(Utils.timeFormat(animation.typingEndTime * 1000)) +'     ';

        return str;
    }

    private function normal(i:Number):Number
    {
        return (int(i*100))/100;
    }
}
}
