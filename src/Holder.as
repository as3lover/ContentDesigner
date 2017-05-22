/**
 * Created by Morteza on 5/12/2017.
 */
package
{
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.geom.Rectangle;

import items.Item;

import src2.Utils;

public class Holder extends Sprite
{
    private var _top:Sprite;
    private var _bottom:Sprite;
    private var _left:Sprite;
    private var _right:Sprite;
    private var _curser:Cursor;

    private var _box_1:Sprite;
    private var _box_2:Sprite;
    private var _box_3:Sprite;
    private var _box_4:Sprite;
    private var _box_5:Sprite;
    private var _box_6:Sprite;
    private var _box_7:Sprite;
    private var _box_8:Sprite;

    private var _target:DisplayObject;
    private var _x1:Number;
    private var _x2:Number;
    private var _y1:Number;
    private var _y2:Number;
    private var _over:Boolean;
    private var _moving:Boolean;
    private var _point:Sprite;

    public function Holder()
    {
        //Constructor
        _top = new Sprite();
        _top.graphics.lineStyle(1);
        _top.graphics.lineTo(200,0);

        _bottom = new Sprite();
        _bottom.graphics.lineStyle(1);
        _bottom.graphics.lineTo(200,0);

        _left = new Sprite();
        _left.graphics.lineStyle(1);
        _left.graphics.lineTo(0,200);

        _right = new Sprite();
        _right.graphics.lineStyle(1);
        _right.graphics.lineTo(0,200);

        //addChild(_top);
        //addChild(_bottom);
        //addChild(_left);
        //addChild(_right);

        _box_1 = Box(Cursor.ARROW_1);
        _box_2 = Box(Cursor.ARROW_2);
        _box_3 = Box(Cursor.ARROW_3);
        _box_4 = Box(Cursor.ARROW_4);
        _box_5 = Box(Cursor.ARROW_5);
        _box_6 = Box(Cursor.ARROW_6);
        _box_7 = Box(Cursor.ARROW_7);
        _box_8 = Box(Cursor.ARROW_8);

        _point = Box(Cursor.POINT, 0x000000);

        function Box(name:String, color:uint = 0xff0000):Sprite
        {
            var box:Sprite = new Sprite();
            box.graphics.lineStyle(2,0xffffff);
            box.graphics.beginFill(color);
            //box.graphics.drawRect(-4, -4, 8, 8);
            box.graphics.drawCircle(0,0,5);
            box.graphics.endFill();
            box.addEventListener(MouseEvent.MOUSE_OVER, onBoxOver);
            box.addEventListener(MouseEvent.MOUSE_OUT, onBoxOut);
            box.name = name;
            addChild(box);
            return box;
        }

        _curser = new Cursor();
    }

    // On Box Over
    private function onBoxOver(e:MouseEvent):void
    {
        ////trace('over box', e.target.name);
        _curser.type = e.target.name;
        _over = true;
    }

    //On Box Out
    private function onBoxOut(event:MouseEvent):void
    {
        ////trace('out box');

        _curser.type = Cursor.NORMAL;
        _over = false;
    }


    //Get Target
    public function get target():DisplayObject
    {
        return _target;
    }

    //Set Target
    public function set target(item:DisplayObject):void
    {
        ////trace('set holder target', item);
        disable();
        _target = item;

        if(_target)
                enable();
    }

    //Enable Select
    private function enable():void
    {
        ////trace('enable holder');

        _point.x = 0;
        _point.y = 0;
        update();
        Main.STAGE.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
        mouseMove();
    }


    //Disable Select
    private function disable():void
    {
        ////trace('disable holder');
        Main.STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);

        _curser.type = Cursor.NORMAL;
        _over = false;
        _moving = false;
    }

    private function mouseMove(event:MouseEvent = null):void
    {
        if(_over || moving)
            return;

        var x:Number = mouseX;
        var y:Number = mouseY;
        var dis:int = 20;

        _curser.type = Cursor.NORMAL;

        if(_x1 <= x && x <= _x2 && _y1 <= y && y <= _y2)
            _curser.type = Cursor.MOVE;
        else if(Utils.distanceTwoPoints(x,y,_x1,_y1) < dis)
            _curser.type = Cursor.ROTATE_1;
        else if(Utils.distanceTwoPoints(x,y,_x2,_y1) < dis)
            _curser.type = Cursor.ROTATE_2;
        else if(Utils.distanceTwoPoints(x,y,_x2,_y2) < dis)
            _curser.type = Cursor.ROTATE_3;
        else if(Utils.distanceTwoPoints(x,y,_x1,_y2) < dis)
            _curser.type = Cursor.ROTATE_4;
    }

    public function update():void
    {
        //////trace('update holder');
        if(!target)
                return;

        setRotation();
        setSize();
        setPosition();
    }

    public function setRotation():void
    {
        rotation = target.rotation;
        _curser.rotation = rotation;
    }

    //Set Selector Size
    public function setSize():void
    {
        if(!target || !target.parent)
        {
            target = null;
            return;
        }

        /*
        var item:Item = target as Item;
        var scaleX:Number = Utils.globalToLocalScaleX(item);
        var scaleY:Number = Utils.globalToLocalScaleY(item);

        ///////////////
        var w:Number = Math.abs(item.insideWidth) * scaleX;
        var h:Number = Math.abs(item.insideWHeight) * scaleY;
        */
        var item:Item = target as Item;
        var rect:Rectangle = item.getRect(target);
        var scaleX:Number = Utils.globalToLocalScaleX(item);
        var scaleY:Number = Utils.globalToLocalScaleY(item);
        var w:Number = rect.width * scaleX;
        var h:Number = rect.height * scaleY;

        _x1 = -w/2;
        _x2 = w/2;
        _y1 = -h/2;
        _y2 = h/2;

        with(this.graphics)
        {
            clear();
            lineStyle(1)
            moveTo(_x1,_y1);
            lineTo(_x2, _y1);
            lineTo(_x2, _y2);
            lineTo(_x1, _y2);
            lineTo(_x1, _y1);
        }

        _box_1.x = _box_7.x = _box_8.x = _x1;
        _box_3.x = _box_4.x = _box_5.x = _x2;
        _box_2.x = _box_6.x = 0;

        _box_1.y = _box_2.y = _box_3.y = _y1;
        _box_5.y = _box_6.y = _box_7.y = _y2;
        _box_4.y = _box_8.y = 0;
    }

    //Set Selector Position
    public function setPosition():void
    {
        if(!target || !target.parent)
        {
            target = null;
            return;
        }
        
        var rect:Rectangle = target.getBounds(Main.STAGE);
        x = rect.x + rect.width/2;
        y = rect.y + rect.height/2;
    }

    public function get state():String
    {
        return _curser.type;
    }

    public function get moving():Boolean
    {
        return _moving;
    }

    public function set moving(value:Boolean):void
    {
        _moving = value;
        _curser.visible = !value;
        mouseMove()
    }

    public function setPoint():void
    {
        _point.x = mouseX;
        _point.y = mouseY
    }

    public function get center():Object
    {
        return {x:_point.x, y:_point.y};
    }

    public function get globalCenter():Point
    {
        return localToGlobal(new Point(_point.x, _point.y));
    }

    public function set globalCenter(gc:Point):void
    {
        var point:Point = globalToLocal(gc);
        _point.x = point.x;
        _point.y = point.y;
    }
}
}
