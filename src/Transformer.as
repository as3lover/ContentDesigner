/**
 * Created by Morteza on 5/10/2017.
 */
package
{
import flash.display.Sprite;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Point;

import items.Item;

import src2.Utils;

public class Transformer extends Sprite
{
    private var _holder:Holder;
    private var _target:Sprite;
    private var _xDistance:Number;
    private var _yDistance:Number;
    private var _rotation:Number;
    private var _scaleX:Number;
    private var _scaleY:Number;
    private var _state:String;
    private var _x:Number;
    private var _y:Number;
    private var _selectList:Array;
    private var _xPointDis:Number;
    private var _yPointDis:Number;
    private var _xTargetCenterDis:Number;
    private var _yTargetCenterDis:Number;
    private var _localPoint:Point;
    private var _globalPoint:Point;
    private var _targetPoint:Point;

    public function Transformer()
    {
        _holder = new Holder();
        addChild(_holder);
    }

    // Get Current Target
    public function get target():Sprite
    {
        return _target;
    }

    //Set Current Target
    public function set target(item:Sprite):void
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

    public function set selectList(selectList:Array):void
    {
        return;
        _selectList = selectList;
        Main.STAGE.addChild(this);
        Main.STAGE.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
        Main.STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
    }


    public function mouseDown(e:MouseEvent = null):void
    {
        if(state == Cursor.NORMAL || target == null)
                return;

        ////trace('mouseDown')


        _x = target.parent.mouseX;
        _y = target.parent.mouseY;
        _xPointDis = _holder.mouseX - _holder.center.x;
        _yPointDis = _holder.mouseY - _holder.center.y;
        _globalPoint = _holder.globalCenter;

        _rotation = target.rotation;
        _scaleX = target.scaleX;
        _scaleY = target.scaleY;
        _xDistance = _x - target.x;
        _yDistance = _y - target.y;
        _localPoint = target.parent.globalToLocal(_globalPoint);
        _targetPoint = target.globalToLocal(_globalPoint);

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

            case Cursor.POINT:
                movePoint();
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

    private function movePoint():void
    {
        _holder.setPoint();
    }

    private function scale(type:String):void
    {
        if(type == 'x')
        {
            target.scaleX = _scaleX * newScaleX();

        }
        else if(type == 'y')
        {
            target.scaleY = _scaleY * newScaleY();
        }
        else if (Keyboard.CTRL || Keyboard.SHIFT)
        {
            var scale:Number = Math.min(newScaleX(), newScaleY());
            target.scaleX = _scaleX * scale;
            target.scaleY = _scaleY * scale;
        }
        else
        {
            target.scaleX = _scaleX * newScaleX();
            target.scaleY = _scaleY * newScaleY();
        }

        resetPos();
        _holder.setSize();
    }

    private function resetPos():void
    {
        var currentPoint = target.parent.globalToLocal(target.localToGlobal(_targetPoint));
        target.x += _localPoint.x - currentPoint.x;
        target.y += _localPoint.y - currentPoint.y;
        _holder.setPosition();
        _holder.globalCenter = _globalPoint;
    }

    private function newScaleY():Number
    {
        return (_holder.mouseY - _holder.center.y)/_yPointDis;
    }

    private function newScaleX():Number
    {
        return (_holder.mouseX - _holder.center.x)/_xPointDis;
    }

    private function rotate():void
    {
        var angle:Number = Math.atan2(_y - _localPoint.y,_x - _localPoint.x)-Math.atan2(target.parent.mouseY - _localPoint.y, target.parent.mouseX - _localPoint.x);
        //var angle:Number = Math.atan2(_y-target.y,_x-target.x)-Math.atan2(target.parent.mouseY-target.y,target.parent.mouseX-target.x);
        angle = Utils.radToDeg(angle);
        angle = _rotation - angle;
        if(Keyboard.CTRL || Keyboard.SHIFT)
                angle = int(angle/45) * 45;
        target.rotation = angle;
        _holder.setRotation();
        resetPos();
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
                Item(target).changed;

        return;

        if(target)
        {
            var item:Item;
            for(var i:int=0; i<target.numChildren; i++)
            {
                if(target.getChildAt(i) is Item)
                {
                    item = target.getChildAt(i) as Item;
                    item.x += target.x;
                    item.y += target.y;
                    item.rotation += target.rotation;
                    item.scaleX *= target.scaleX;
                    item.scaleY *= target.scaleY;
                    item.changed;
                }
            }

            target.x = 0;
            target.y = 0;
            target.rotation = 0;
            target.scaleX = 1;
            target.scaleY = 1;
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
