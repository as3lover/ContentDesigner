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

import items.Item;

import src2.Utils;

public class Holder extends Sprite
{
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
    private var _selectList:Array;
    private var _x:Number;
    private var _y:Number;

    public function Holder()
    {
        //Constructor

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


    public function set selectList(selectList:Array):void
    {
        _selectList = selectList;
        trace(_selectList);

        if(_selectList)
            enable();
    }

    //Enable Select
    private function enable():void
    {
        trace('enable holder');

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

        _selectList = null;
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
        var dis:int = 35;

        _curser.type = Cursor.NORMAL;

        var x1:Number = Math.min(_x1, _x2);
        var x2:Number = Math.max(_x1, _x2);;
        var y1:Number = Math.min(_y1, _y2);
        var y2:Number = Math.max(_y1, _y2);

        if(Keyboard.CTRL)
                trace(int(x1), int(x), int(x2), int(y1), int(y), int(y2));

        if(x1 <= x && x <= x2 && y1 <= y && y <= y2)
            _curser.type = Cursor.MOVE;
        else if(Utils.distanceTwoPoints(x,y,x1,y1) < dis)
            _curser.type = Cursor.ROTATE_1;
        else if(Utils.distanceTwoPoints(x,y,x2,y1) < dis)
            _curser.type = Cursor.ROTATE_2;
        else if(Utils.distanceTwoPoints(x,y,x2,y2) < dis)
            _curser.type = Cursor.ROTATE_3;
        else if(Utils.distanceTwoPoints(x,y,x1,y2) < dis)
            _curser.type = Cursor.ROTATE_4;
    }

    public function update():void
    {
        if(target == null && _selectList == null)
                return;

        setRotation();
        setSize();
        setPosition();
    }

    public function setRotation():void
    {
        if(target)
            rotation = target.rotation;
        else if(_selectList)
            rotation = 0;

        _curser.rotation = rotation;
    }

    //Set Selector Size
    public function setSize():void
    {
        trace('setSize 1',_selectList)
        if((!target || !target.parent) && !_selectList)
        {
            target = null;
            return;
        }

        trace('_selectList', _selectList)


        /*
        var item:Item = target as Item;
        var scaleX:Number = Utils.globalToLocalScaleX(item);
        var scaleY:Number = Utils.globalToLocalScaleY(item);

        ///////////////
        var w:Number = Math.abs(item.insideWidth) * scaleX;
        var h:Number = Math.abs(item.insideWHeight) * scaleY;
        */
        if(target)
        {
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

        }
        else if(_selectList)
        {
            var list:Array = _selectList;
            var length:int = list.length;
            var i:int;
            var r:Rectangle = Sprite(list[0]).getBounds(Main.STAGE);

            var x1:Number = r.x;
            var y1:Number = r.y;
            var x2:Number = r.x + r.width;
            var y2:Number = r.y + r.height;

            for(i=1; i<length; i++)
            {
                r = Sprite(list[i]).getBounds(Main.STAGE);

                x1 = Math.min(r.x, x1);
                y1 = Math.min(r.y , y1);
                x2 = Math.max(x2, r.x + r.width);
                y2 = Math.max(y2, r.y + r.height);

            }

            _x1 = -(x2 - x1)/2;
            _y1 = -(y2 - y1)/2;
            _x2 = -_x1;
            _y2 = -_y1;

            var p:Point = new Point(x1 + _x2, y1 + _y2);
            x = p.x;
            y = p.y;


        }
        else
        {
            return;
        }


        with(this.graphics)
        {
            clear();
            lineStyle(1);
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
        trace('setPosition1')

        if(!target || !target.parent)
            target = null;


        if(target)
        {
            var rect:Rectangle = target.getBounds(Main.STAGE);
            x = rect.x + rect.width/2;
            y = rect.y + rect.height/2;
        }

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
