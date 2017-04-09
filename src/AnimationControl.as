/**
 * Created by mkh on 2017/04/09.
 */
package
{
public class AnimationControl
{
    private var _list:Array;
    private var _time:Number;
    private var _duration:Number;

    public function AnimationControl()
    {
        _list = new Array();
        _time = 0;
        _duration = 0;
    }


    public function get time():Number
    {
        return _time;
    }

    public function set time(value:Number):void
    {
        if(_time == value)
                return;

        _time = value;

        for(var i:int = 0 ; i < _list.length; i++)
        {
            AnimateObject(_list[i]).time = _time;
        }
    }

    public function add(object:Item, time:Number):void
    {
        _list.push(new AnimateObject(object, time))
    }

    public function removeAnimation(item:Item):void
    {

        for (var i:int = 0; i<_list.length; i++)
        {
            if(AnimateObject(_list[i]).object == item)
            {
                Utils.removeItemAtIndex(_list, i);
                return;
            }
            else
            {
                trace(AnimateObject(_list[i]).object.name, item.name)
            }
        }
    }
}
}
