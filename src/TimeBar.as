/**
 * Created by Morteza on 4/3/2017.
 */
package {
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

public class TimeBar extends Sprite
{
    private var _back:Sprite;
    private var _bar:Sprite;
    private var _newPercent:Number
    private var _onChange:Function;
    private var _percent:Number;


    public function TimeBar(backColor:uint = 0, frontColor:uint = 0xffffff, width:uint = 1000, height:uint = 10)
    {
        _back = new Sprite();
        _bar = new Sprite();

        Utils.drawRect(_back,0,0,width,height,backColor);
        Utils.drawRect(_bar,0,0,width,height,frontColor);

        addChild(_back);
        addChild(_bar);

        percent = 0;

    }

    public function start()
    {
        addEventListener(MouseEvent.MOUSE_DOWN, onDown);
    }

    public function  stop()
    {
        removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
        removeEventListener(Event.ENTER_FRAME, check);
        stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
    }

    private function onDown(event:MouseEvent):void
    {
        if(stage)
            stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
        else
            return;

        removeEventListener(MouseEvent.MOUSE_DOWN, onDown);

        addEventListener(Event.ENTER_FRAME, check)
    }

    private function onUp(event:MouseEvent):void
    {
        addEventListener(MouseEvent.MOUSE_DOWN, onDown);
        removeEventListener(Event.ENTER_FRAME, check);
        stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
    }

    private function check(event:Event):void
    {
        _newPercent = correctPercent(mouseX / _back.width);
        if(_newPercent != percent && _onChange != null)
            _onChange(_newPercent);
    }

    private function correctPercent(value:Number):Number
    {
        if(value > 1)
            value = 1;
        else if (value < 0)
            value = 0;

        return value;
    }

    public function get percent():Number
    {
        return _percent;
    }

    public function set percent(value:Number):void
    {
        value = correctPercent(value);
        if(_percent == value)
                return;

        _percent = value;
        _bar.scaleX = value;
    }

    public function set onChange(func:Function):void
    {
        _onChange = func;
    }
}
}
