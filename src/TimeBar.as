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

    private var _updateFunction:Function;

    public function TimeBar(backColor:uint = 0, frontColor:uint = 0xffffff, width:uint = 1000, height:uint = 10, updateFunction:Function = null)
    {
        _back = new Sprite();
        _bar = new Sprite()

        _back.graphics.beginFill(backColor);
        _back.graphics.drawRect(0,0,width,height);
        _back.graphics.endFill();

        _bar.graphics.beginFill(frontColor);
        _bar.graphics.drawRect(0,0,width,height);
        _bar.graphics.endFill();

        addChild(_back);
        addChild(_bar);

        _updateFunction = updateFunction;
    }

    public function start()
    {
        _bar.scaleX = 0;
        addEventListener(MouseEvent.MOUSE_DOWN, onDown);
    }

    private function onDown(event:MouseEvent):void
    {
        if(stage)
            stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
        else
            return;

        removeEventListener(MouseEvent.MOUSE_DOWN, onDown);

        addEventListener(Event.ENTER_FRAME, update)
    }

    private function onUp(event:MouseEvent):void
    {
        addEventListener(MouseEvent.MOUSE_DOWN, onDown);
        removeEventListener(Event.ENTER_FRAME, update);
        stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
    }

    private function update(event:Event):void
    {
        percent = mouseX / _back.width;
    }

    public function get percent():Number
    {
        return _bar.scaleX;
    }

    public function set percent(value:Number):void
    {
        if(value > 1)
            value = 1;
        else if (value < 0)
            value = 0;

        if(value == percent)
                return;

        _bar.scaleX = value;

        if(_updateFunction)
                _updateFunction(percent);
    }

    public function set updateFunction(func:Function):void
    {
        _updateFunction = func;
    }
}
}
