/**
 * Created by Morteza on 5/2/2017.
 */
package src2
{
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.events.MouseEvent;

public class Scroll extends Sprite
{
    private var _object:DisplayObject;
    private var _mask:Sprite;
    private var Y:Number;
    private var _back:Sprite;
    private var _bar:Sprite;
    private var _dis:int;
    private var _newY:Number;
    private var _stage:Stage;

    public function Scroll(object:DisplayObject, x:int, y:int, w:int, h:int, stage:Stage):void
    {
        super();

        _stage = stage;
        _object = object;
        this.x = x + w + 5;
        this.y = y;

        _mask = new Sprite();
        _mask.alpha = 0;
        Utils.drawRect(_mask,x,y,w,h);

        Y = _object.y;

        _back = new Sprite();
        addChild(_back);
        Utils.drawRect(_back,0,0,7,h, 0x555555);

        _bar = new Sprite();
        addChild(_bar);
        Utils.drawRect(_bar,0,0,7,h, 0x999999);

    }

    public function show():void
    {
        if(!_object.parent)
            return;

        _object.parent.addChild(this);
        _object.parent.addChild(_mask);
        _object.mask = _mask;

        _bar.y = 0;
        _bar.scaleY = _mask.height / _object.height;

        addEventListener(MouseEvent.MOUSE_DOWN, onDown);
        addEventListener(MouseEvent.MOUSE_WHEEL, wheel);
        _object.addEventListener(MouseEvent.MOUSE_WHEEL, wheel);

        visible = true;
    }


    private function wheel(e:MouseEvent):void
    {
        _newY = _bar.y - (e.delta/30)*_back.height;
        setPos();
    }

    private function onDown(e:MouseEvent):void
    {
        this.addEventListener(Event.ENTER_FRAME, ef);
        _stage.addEventListener(MouseEvent.MOUSE_UP, onUp);

        if(e.target == _bar)
                _dis = mouseY - _bar.y;
        else
            _dis = correctDis(_bar.height/2);

        ef();
    }

    private function onUp(event:MouseEvent = null):void
    {
        _stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
        this.removeEventListener(Event.ENTER_FRAME, ef);
    }


    private function ef(event:Event = null):void
    {
        _newY = mouseY - _dis;
        setPos();
    }

    private function setPos():void
    {
        if(_newY < 0)
            _newY = 0;
        else if(_newY > _back.height - _bar.height)
            _newY = _back.height - _bar.height;

        _bar.y = _newY;

        _object.y = Y - (_bar.y/(_back.height - _bar.height)) * (_object.height - _mask.height);
    }

    private function correctDis(y:Number):int
    {
        if (mouseY - y < 0)
                y = mouseY;
        else (mouseY +  y > _back.height)
            y = _bar.height - (_back.height - mouseY);

        return y;
    }

    public function hide():void
    {
        removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
        removeEventListener(MouseEvent.MOUSE_WHEEL, wheel);
        _object.removeEventListener(MouseEvent.MOUSE_WHEEL, wheel);
        onUp();
        visible = false;
        _object.y = Y;
    }

    public override function set visible(value:Boolean):void
    {
        super.visible = value;
    }
}
}
