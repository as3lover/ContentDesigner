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
import flash.events.MouseEvent;
import flash.net.URLRequest;

import saveLoad.saveItem;

import src2.Consts;

public class Item extends Sprite
{
    private var _removeAnimation:Function;
    private var _onChange:Function;

    private var _x:Number;
    private var _y:Number;
    private var _scaleX:Number;
    private var _scaleY:Number;
    private var _rotation:Number;

    public var startProps:Object;
    private var _motion:String;
    private const distance:Number = 100;
    private var _path:String;

    private var _number:int = -1;

    private var _index:int;
    protected var _bitmap:Bitmap;
    private var _pathHolder:Object={};
    private const _eventComplete:Event = new Event(Event.COMPLETE);

    public function Item(removeAnimataion:Function, path:String, motion:String = Consts.fade)
    {
        super();
        _removeAnimation = removeAnimataion;
        _path = path;

        var menu:ItemMenu = new ItemMenu();
        this.contextMenu = menu.menu;

        startProps = new Object();
        _motion = motion;

        this.addEventListener(MouseEvent.CONTEXT_MENU, rightClick)
    }


    private function rightClick(event:MouseEvent):void
    {
        ItemMenu.currentItem = this;
        changed;
    }

    public function remove():void
    {
        if(parent)
        {
            parent.removeChild(this)
        }

        if(_removeAnimation)
        {
            _removeAnimation(this)
        }
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
            setProps();
            return true;
        }
        return false;
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

    public function newMotion(type:String)
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
    }

    public function Show():void
    {
        dispatchEvent(new Event(Event.ADDED));
        //preview();
    }

    public function HideNew():void
    {
        Main.hightLight(TimeLine);
        stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
        function onUp(e:MouseEvent)
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
        function onUp(e:MouseEvent)
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
                return 0;
        return parent.getChildIndex(this);
    }

    public function set index(i:int):void
    {
        if(!parent)
                return;

        if(i == -100 || i >= parent.numChildren)
            i = parent.numChildren - 1
        else if(i < 0)
            i = 0;

        parent.setChildIndex(this, i);

    }

    public function get path():String
    {
        return _path;
    }

    public function get all():Object
    {
        var obj = new Object();
        obj.x = _x
        obj.y = _y
        obj.scaleX = _scaleX
        obj.scaleY = _scaleY
        obj.rotation = _rotation
        obj.index = index;
        obj.motion = _motion
        obj.path = _path
        obj.number = _number;
        obj.type = 'image'
        return obj;
    }

    public function set all(obj:Object)
    {
        _x = obj.x;
        _y = obj.y;
        _scaleX = obj.scaleX;
        _scaleY = obj.scaleY;
        _rotation = obj.rotation;
        _path = obj.path
        motion = obj.motion;
        _index = obj.index;
        _number = obj.number;

    }

    public function load():void
    {
        var loader:Loader = new Loader();
        loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
        loader.load(new URLRequest(_path));

        function onComplete (event:Event):void
        {
            var bit:Bitmap = Bitmap(LoaderInfo(event.target).content);
            bit.scaleX = .5;
            bit.scaleY= .5;
            bit.x = -bit.width/2;
            bit.y = -bit.height/2;
            bitmap = bit;
            //trace('complete', _path);
            dispatchEvent(new Event(Event.COMPLETE));
        }
    }

    public function setIndex():void
    {
        index = _index;
    }

    public function save(dir:String):void
    {
        var newDir = dir + '/images';
        var newName:String = 'image_' + String(number) + '.pic';

        saveItem.copyAndRename(_path, newDir, newName, _pathHolder, after);
        function after():void
        {
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
            dispatchComplete();
        }
    }

    protected function dispatchComplete():void
    {
        dispatchEvent(_eventComplete);
    }

    public function set bitmap(value:Bitmap):void
    {
        _bitmap = value;
        addChild(value);
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
        if(Main.transformer._target == this)
        {
            Main.transformer.select(null);
            Main.transformer.select(this);
        }
    }
}
}