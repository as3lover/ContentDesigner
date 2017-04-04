/**
 * Created by Morteza on 4/4/2017.
 */
package
{
import com.greensock.TimelineMax;

public class TweenLine
{
    private var _timeLine:TimelineMax;

    private var _object;
    private var _time:Number;
    private var _duration:Number;
    private var _delay:Number;
    private var _changeTime:String;
    private var _x:int;
    private var _y:int;
    private var _scaleX:Number;
    private var _scaleY:Number;
    private var _rotation:int;
    private var _alpha:Number;

    public function TweenLine()
    {
        _timeLine = new TimelineMax();
    }

    public function build(list:Array, time:Number):void
    {
        _timeLine.pause();
        _timeLine = null;
        _timeLine = new TimelineMax();


        var length:int = list.length;
        for (var i:int=0; i<length; i++)
        {
            list[i].from.object.visible = false;
            addToTimeLine(list[i].from);
            addToTimeLine(list[i].to);
        }

        _timeLine.pause(time);
    }

    private function addToTimeLine(obj:Object):void
    {
        for (var field:String in obj)
        {
            switch(field)
            {
                case 'object':
                    _object = obj[field];
                    break;

                case 'duration':
                    _duration = obj[field];
                    break;

                case 'changeTime':
                    _changeTime = obj[field];
                    break;

                case 'alpha':
                    _alpha = obj[field];
                    break;

                case 'rotation':
                    _rotation = obj[field];
                    break;

                case 'x':
                    _x = obj[field];
                    break;

                case 'y':
                    _y = obj[field];
                    break;

                case 'scaleX':
                    _scaleX = obj[field];
                    break;

                case 'scaleY':
                    _scaleY = obj[field];
                    break;

                case 'delay':
                    _delay = obj[field];
                    break;

                default:
                    trace('Error: undefined property: ' + field , obj[field]);
                    break;
            }
        }

        _timeLine.to(_object, _duration, {x:_x, y:_y, scaleX:_scaleX, scaleY:_scaleY,
                                          autoAlpha:_alpha, rotation:_rotation, delay:_delay}, _changeTime);
    }

    public function seek(seconds:Number):void
    {
        _timeLine.seek(seconds);
    }

    public function pause():void
    {
        _timeLine.pause();
    }

    public function play():void
    {
        _timeLine.play();
    }

    public function stop():void
    {
        _timeLine.stop();
    }
}
}
