/**
 * Created by Morteza on 5/10/2017.
 */
package
{
import flash.display.Sprite;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

import items.Item;

import src2.Utils;

public class Transformer extends Sprite
{
    private var _holder:Holder;
    private var _target:Item;
    private var _xDistance:Number;
    private var _yDistance:Number;
    private var _rotation:Number;
    private var _scaleX:Number;
    private var _scaleY:Number;
    private var _state:String;
    private var _x:Number;
    private var _y:Number;

    public function Transformer()
    {
        _holder = new Holder();
        addChild(_holder);
    }

    // Get Current Target
    public function get target():Item
    {
        return _target;
    }

    //Set Current Target
    public function set target(item:Item):void
    {
        if(target && target == item)
            return;

        ////trace('set transformer target', item);

        if(item)
        {
            ////trace('add transformer');
            Main.STAGE.addChild(this);
        }
        else if(parent)
        {
            ////trace('remove transformer');
            if(parent)
                parent.removeChild(this);

            Main.STAGE.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
            Main.STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
        }

        _target = item;
        _holder.target = item;
    }

    public function mouseDown(e:MouseEvent = null):void
    {
        if(state == Cursor.NORMAL || target == null)
                return;

        ////trace('mouseDown')

        _xDistance = target.parent.mouseX - target.x;
        _yDistance = target.parent.mouseY - target.y;
        _rotation = target.rotation;
        _scaleX = target.scaleX;
        _scaleY = target.scaleY;
        _x = target.parent.mouseX;
        _y = target.parent.mouseY;

        _state = state;

        _holder.moving = true;


        Main.STAGE.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
        Main.STAGE.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
        Main.STAGE.addEventListener(KeyboardEvent.KEY_DOWN, onKey);
        Main.STAGE.addEventListener(KeyboardEvent.KEY_UP, onKey);
    }

    private function onKey(event:KeyboardEvent):void
    {
        mouseMove(null)
    }

    private function mouseMove(e:MouseEvent):void
    {
        ////trace('mouseMove')
        switch(_state)
        {
            case Cursor.MOVE:
                move();
                break;

            case Cursor.ARROW_2:
                scale('y');
                break;

            case Cursor.ARROW_6:
                scale('y');
                break;

            case Cursor.ARROW_4:
                scale('x');
                break;

            case Cursor.ARROW_8:
                scale('x');
                break;

            case Cursor.ARROW_1:
                scale('xy');
                break;

            case Cursor.ARROW_3:
                scale('xy');
                break;

            case Cursor.ARROW_5:
                scale('xy');
                break;

            case Cursor.ARROW_7:
                scale('xy');
                break;

            case Cursor.ROTATE_1:
                rotate();
                break;

            case Cursor.ROTATE_2:
                rotate();
                break;

            case Cursor.ROTATE_3:
                rotate();
                break;

            case Cursor.ROTATE_4:
                rotate();
                break;

            default:
                return;
                break;
        }

        if(e)
            e.updateAfterEvent();

    }

    private function move():void
    {
        ////trace('move')
        target.x = target.parent.mouseX - _xDistance;
        target.y = target.parent.mouseY - _yDistance;
        _holder.setPosition();
    }

    private function scale(type:String):void
    {
        if(type == 'x')
            target.scaleX = _scaleX * newScaleX();
        else if(type == 'y')
            target.scaleY = _scaleY * newScaleY();
        else if (Keyboard.CTRL || Keyboard.SHIFT)
        {
            var scale:Number = Math.max(newScaleX(), newScaleY());
            target.scaleX = _scaleX * scale;
            target.scaleY = _scaleY * scale;
        }
        else
        {
            target.scaleX = _scaleX * newScaleX();
            target.scaleY = _scaleY * newScaleY();
        }

        _holder.setSize();
    }

    private function newScaleY():Number
    {
        return (target.parent.mouseY - target.y) / _yDistance;
    }

    private function newScaleX():Number
    {
        return (target.parent.mouseX - target.x) / _xDistance;
    }

    private function rotate():void
    {
        var angle:Number = Math.atan2(_y-target.y,_x-target.x)-Math.atan2(target.parent.mouseY-target.y,target.parent.mouseX-target.x);
        angle = Utils.radianToDegree(angle);
        angle = _rotation - angle;
        if(Keyboard.CTRL || Keyboard.SHIFT)
                angle = int(angle/45) * 45;
        target.rotation = angle;
        _holder.setRotation();
    }

    private function mouseUp(event:MouseEvent):void
    {
        ////trace('mouseUp')
        Main.STAGE.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
        Main.STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
        Main.STAGE.removeEventListener(KeyboardEvent.KEY_DOWN, onKey);
        Main.STAGE.removeEventListener(KeyboardEvent.KEY_UP, onKey);

        _holder.moving = false;

        if(target)
        {
            target.changed;
        }
    }



    //State
    public function get state():String
    {
        return _holder.state;
    }

    public function update():void
    {
        _holder.update();
    }
}
}
