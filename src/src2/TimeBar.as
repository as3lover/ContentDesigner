/**
 * Created by Morteza on 4/3/2017.
 */
package src2 {
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.utils.setTimeout;

public class TimeBar extends Sprite
{
    private var _back:Sprite;
    private var _bar:Sprite;
    private var _newPercent:Number
    private var _onChange:Function;
    private var _percent:Number;
    private var _handle:Handle;
    private var _width:Number;
    private var _scaleX:Number;
    private var _lines:Sprite;
    private var _originalWidth:uint;
    private var _step:Number;
    private var _x:Number;
    private var _handleX:Number;
    private var _distance:Number;
    private var _line:Sprite;
    private var _snaps: Sprite;


    public function TimeBar(backColor:uint = 0, frontColor:uint = 0xffffff, width:uint = 1000, height:uint = 25)
    {
         _back = new Sprite();
        _bar = new Sprite();
        _line = new Sprite();
        _snaps = new Sprite();


        _lines = new Sprite();
        _back.addChild(_lines);

        _bar.alpha = .75;
        _bar.visible = false;

        _line.visible = false;
        _line.y = height - 2;


        Utils.drawRect(_back, 0, 0, width, height, backColor);
        Utils.drawRect(_bar, 0, 0, width, height, frontColor);
        Utils.drawRect(_line,0,0,width,2,0xff9900);


        addChild(_back);
        addChild(_bar);
        addChild(_line);
        addChild(_snaps);

        _originalWidth = width;

        percent = 0;

        this.addEventListener(MouseEvent.MOUSE_WHEEL, wheel)

    }

    private function wheel(e:MouseEvent):void
    {
        setZoom(-e.delta/30);
    }

    public function setZoom(value:Number=.1):void
    {
        var newWidth:int = width + (value)*width;
        if(newWidth > 4*(_back.width/scaleX))
            newWidth = 4*(_back.width/scaleX);

        _handleX = _handle.x;
        width = newWidth;
        x = _handleX - _bar.width*scaleX
    }

    public function start()
    {
        addOnDown();
    }

    private function addOnDown():void
    {
        addEventListener(MouseEvent.MOUSE_DOWN, onDown);
        if (_handle)
            _handle.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
    }

    private function removeOnDown():void
    {
        removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
        if (_handle)
            _handle.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
    }

    public function stop()
    {
        removeOnDown();
        removeEventListener(Event.ENTER_FRAME, check);
        stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
    }

    private function onDown(event:MouseEvent):void
    {
        _distance = 0;
        if (stage)
            stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
        else
            return;

        removeOnDown();

        addEventListener(Event.ENTER_FRAME, check)
    }

    private function onUp(event:MouseEvent):void
    {
        addOnDown();
        removeEventListener(Event.ENTER_FRAME, check);
        stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
    }


    private function check(event:Event):void
    {
        if(_x && parent.mouseX<_x)
        {
            _distance = (_x - parent.mouseX)/scaleX;
            x += (_x - parent.mouseX)/10;
        }
        else if(_x && parent.mouseX >_x+_width)
        {
            _distance = (_x+_width - parent.mouseX)/scaleX;
            x += (_x+_width - parent.mouseX)/10;
        }
        else
            _distance = 0;




            _newPercent = correctPercent((mouseX+_distance) / _back.width);
        if (_newPercent != percent && _onChange != null)
            _onChange(_newPercent);
    }

    private function correctPercent(value:Number):Number
    {
        if (value > 1)
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
        if (_percent == value)
            return;

        _percent = value;
        _bar.scaleX = value;
        if(x + _bar.width*scaleX > _x+_width)
            x = _x+_width - _bar.width*scaleX;
        else if(x+_bar.width*scaleX < _x)
            x = _x - _bar.width*scaleX;

        moveHandle();
    }

    private function moveHandle():void
    {
        if (!_handle)
            return;

        _handle.x = x + _bar.width * scaleX;
        _handle.y = y + height / 2;
    }

    public function set onChange(func:Function):void
    {
        _onChange = func;
    }


    public function set handle(handle:Handle):void
    {
        _handle = handle;
        _width = width;
        _scaleX = scaleX;
        _x = x;
        _handle.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
        _handle.addEventListener(MouseEvent.MOUSE_WHEEL, wheel)

        moveHandle();
    }

    public override function set width(value:Number):void
    {
        if (_width && value <= _width)
        {
            value = _width;
            x = _x;
        }
        super.width = value;


        moveHandle();
        setSnapSize();
    }

    public override function set scaleX(value:Number):void
    {
        if (_scaleX && value < _scaleX)
            value = _scaleX;

        super.scaleX = value;
        moveHandle();
        setSnapSize();
    }


    public override function set x(x:Number):void
    {
        if(_x && x+width < _x+_width)
                x = _x + _width - width;
        else if (_x && x+_bar.width*scaleX < _x)
            x = _x - _bar.width*scaleX;
        else if(_x && x > _x)
                x = _x;

        super.x = x;
        moveHandle();
    }

    public function set totalTime(seconds:Number):void
    {
        _lines.graphics.clear();
        _lines.graphics.lineStyle(.1, 0x777777);
        _step = _originalWidth/(seconds/20);
        drawLine(_step)
        setSnapSize(true);
    }

    function drawLine(i:Number)
    {
        var step:int=0;
        for(i; i<_originalWidth; i+=_step)
        {
            _lines.graphics.moveTo(i, 0);
            _lines.graphics.lineTo(i, height/3);
            step++;
            if (step > 20)
            {
                setTimeout(drawLine, 100, i);
                return;
            }
        }
    }

    public function reset():void
    {
        if(!_x)
            return;

        width = _width;
        x = _x;
        percent = 0;


    }

    public function deselect():void
    {
        _line.visible = false;
    }

    public function select(start:Number, width:Number):void
    {
        _line.x = start * _back.width;
        _line.width = width * _back.width;
        _line.visible = true;
    }

    public function get handle():Handle
    {
        return _handle;
    }

    public function addSnap(percent:Number):SnapLine
    {
        var snap:SnapLine = new SnapLine(_back.height);
        snap.percent = percent;
        snap.y = _back.y;
        snap.x = percent * _back.width;
        snap.scaleX = 1/scaleX;
        _snaps.addChild(snap);
        return snap;
    }

    private function setSnapSize(snapTime:Boolean = false):void
    {
        var len:int = _snaps.numChildren;
        for (var i:int =0; i<len; i++)
        {
            if(snapTime)
                SnapLine(_snaps.getChildAt(i)).reset();

            _snaps.getChildAt(i).scaleX = 1/scaleX;
        }
    }

    public function setSnapTime(snap:SnapLine, percent:Number):void
    {
        snap.x = percent * _back.width;
        snap.scaleX = 1/scaleX;
    }


}
}
