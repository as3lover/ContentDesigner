/**
 * Created by Morteza on 4/18/2017.
 */
package src2
{
import flash.display.Sprite;
import flash.events.Event;

public class Topics extends Sprite
{
    private var _time:Number;
    private var _activeItem:TopicItem;
    private var _list:Array;
    private var _len:int;

    public function Topics()
    {
        _time = -1;
        _list = new Array();
        _len = 0;
    }

    public function set time(time:Number):void
    {
        if(time == _time)
                return;

        _time = time;

        for(var i:int=len-1; i>-1; i--)
        {
            if(TopicItem(_list[i]).time <= time)
            {
                active(_list[i]);
                return;
            }
        }

        deActive();
    }


    private function active(topic:TopicItem):void
    {
        if(_activeItem != topic)
        {
            deActive();
            _activeItem = topic;
            _activeItem.active();
        }
    }

    private function deActive():void
    {
        if(_activeItem != null)
        {
            _activeItem.deActive();
            _activeItem = null
        }
    }

    public function add(seconds:Number=-1, text:String = 'عنوان جدید'):void
    {
        if(seconds == -1)
                seconds = Utils.time;

        var topic:TopicItem = new TopicItem(remove, text);
        topic.time = seconds;
        topic.addEventListener(Event.ACTIVATE, clickOnTopic);
        sort(addTopic(topic));
        ToolTip.add(topic, Utils.timeFormat(topic.time*1000));
        addChild(topic);
    }

    private function addTopic(topic:TopicItem):int
    {
        for(var i:int=len-1; i>-1; i--)
        {
            if(topic.time > _list[i].time)
                break;
        }

        i++;
        Utils.pushAtIndex(_list, i, topic);
        _len++;
        return i;
    }

    public function changeTime(topic:TopicItem, seconds:Number)
    {
        Utils.removeObjectFromArray(_list, topic);
        _len--;
        topic.time = seconds;
        addTopic(topic);
        ToolTip.remove(topic);
        ToolTip.add(topic, Utils.timeFormat(topic.time*1000));

        sort();
    }

    public function sort(i:int=0):void
    {
        for(i; i<len; i++)
        {
            _list[i].y = i*28
        }
    }

    private function clickOnTopic(e:Event):void
    {
        Main.timeLine.setTimeByTopic(TopicItem(e.target).time);
    }


    public function remove(topic:TopicItem)
    {
        topic.removeEventListener(Event.ACTIVATE, clickOnTopic);

        if(Utils.removeObjectFromArray(_list, topic))
            _len--;

        if(topic.parent)
                topic.parent.removeChild(topic);

        sort();
    }

    private function get len():int
    {
        return _len;
    }

    ///////
    public function get object():Object
    {
        var obj:Object = {};
        for(var i:int=0; i<len; i++)
        {
            obj['obj_' + String(i)] = TopicItem(_list[i]).object
        }

        return obj;
    }

    public function set object(obj:Object):void
    {
        for(var i:String in obj)
        {
            trace(i, obj[i].time, obj[i].text);
            add(obj[i].time, obj[i].text);
        }
    }

    //////////
    public function reset():void
    {
        for(var i:int=len-1; i>-1; i--)
        {
            remove(_list[i]);
        }
    }
}
}
