/**
 * Created by Morteza on 4/28/2017.
 */
package src2
{
import flash.display.Shape;

public class SnapLine extends Shape
{
    private var _time:Number;
    private var _percent:Number;
    public function SnapLine(height:int)
    {
        with (graphics)
        {
            lineStyle(1, 0xDEAD57);
            moveTo(0,0);
            lineTo(1,0);
            lineTo(1,height);
            lineTo(-1,height);
            lineTo(-1,0);
            lineTo(0,0);
        }
    }

    public function remove():void
    {
        if(parent)
            parent.removeChild(this);
    }

    public function set time(time:Number):void
    {
        _time = time;
        _percent = _time/Main.timeLine.totalSec;
        if(parent)
                TimeBar(parent.parent).setSnapTime(this, _percent);
    }

    public function reset():void
    {
        time = _time;
    }

    public function set percent(percent:Number):void
    {
        _percent = percent;
        _time = _percent*Main.timeLine.totalSec;
        if(parent)
            TimeBar(parent.parent).setSnapTime(this, _percent);
    }
}
}
