/**
 * Created by Morteza on 4/5/2017.
 */
package
{
import flash.display.DisplayObject;

public class ObjectManager
{
    private var _list:Array;
    private var _length:int;

    public function ObjectManager()
    {
        _list = new Array();
        _length = 0;
    }

    public function add(item:DisplayObject, startTime:Number):void
    {
        var index:int = -1;

        for(var i:int = 0; i<_length; i++)
        {
            if(_list[i].from.object == item)
            {
                setObject(_list[i], item, startTime);
                return;
            }
            if(_list[i].from.startTime > startTime    &&    index == -1)
            {
                index = i;
            }
        }
        if(index = -1)
            index = 0;

        _list.splice(index, 0 ,  setObject({from:{}, to:{}}, item, startTime));
        _length++;
    }

    private function setObject(object:Object, item:DisplayObject, startTime:Number):Object
    {
        var to:Object = object.to;
        to.object = item;
        to.x = item.x;
        to.y = item.y;
        to.scaleX = item.scaleX;
        to.scaleY = item.scaleY;
        to.alpha = item.alpha;
        to.rotation = item.rotation;
        to.duration = 1;

        var from:Object = object.from
        from.object = item;
        from.x = item.x -100;
        from.y = item.y -100;
        from.scaleX = item.scaleX /2;
        from.scaleY = item.scaleY /2;
        from.alpha = 0;
        from.rotation = item.rotation - 45;
        from.duration = 0;
        from.startTime = startTime;

        return object;
    }

    public function get list():Array
    {
        return _list;
    }

    public function removeAnimation(item:Item):void
    {
        for(var i:int = 0; i<_length; i++)
        {
            if(_list[i].from.object == item)
            {
                list.splice(i,1);
                _length--;
            }
        }

    }
}
}
