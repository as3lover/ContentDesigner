/**
 * Created by Morteza on 4/5/2017.
 */
package
{
import com.greensock.TweenLite;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.ui.Mouse;

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

    public function Item(removeAnimataion:Function)
    {
        super();
        _removeAnimation = removeAnimataion;

        var menu:ItemMenu = new ItemMenu();
        this.contextMenu = menu.menu;

        startProps = new Object();

        this.addEventListener(MouseEvent.CONTEXT_MENU, rightClick)
    }


    private function rightClick(event:MouseEvent):void
    {
        ItemMenu.currentItem = this;
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
}
}
