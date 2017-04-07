/**
 * Created by Morteza on 4/5/2017.
 */
package
{
import flash.display.Sprite;

public class Item extends Sprite
{
    private var _removeAnimation:Function;
    private var _x:Number;
    private var _y:Number;
    private var _scaleX:Number;
    private var _scaleY:Number;
    private var _rotation:Number;
    private var _startTime:Number;
    public function Item(removeAnimataion:Function)
    {
        super();
        _removeAnimation = removeAnimataion;
    }

    public function remove():void
    {
        if(parent)
        {
            parent.removeChild(this)
        }

        if(_removeAnimation)
        {
            _removeAnimation(this)
        }
    }

    public function setPrps():void
    {
        _x = x;
        _y = y;
        _scaleX = scaleX;
        _scaleY = scaleY;
        _rotation = rotation;
        trace(x,y,scaleX,scaleY,rotation)
    }

    public function get changed():Boolean
    {
        if(_x != x || _y != y || _scaleX != scaleX || _scaleY != scaleY || _rotation != rotation)
        {
            setPrps();
            return true;
        }
        return false;
    }

    public function get startTime():Number
    {
        return _startTime;
    }

    public function set startTime(value:Number):void
    {
        _startTime = value;
    }
}
}
