/**
 * Created by Morteza on 4/18/2017.
 */
package src2
{
import flash.display.Sprite;
import flash.events.Event;

import src2.TopicItem;

public class Topics extends Sprite
{
    private var _time:Number;
    private var _activeItem:TopicItem;
    private var _list:Array;
    private var _len:int;
    private const COLOR:uint = 0x333333;
    private var _loading:Boolean;
    protected var _scroll:Scroll;

    public function Topics()
    {
        _time = -1;
        _list = new Array();
        _len = 0;
    }

    public function init():void
    {
        _scroll = new Scroll(this, x, y, 100, 13*28-8, stage);
    }

    public function set time(time:Number):void
    {
        if(time == _time)
                return;

        _time = time;

        for(var i:int=len-1; i>-1; i--)
        {
            if(TopicItem(_list[i]).time <= time+1)
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
    public function addQuiz(time:Number):void
    {
        add(time, 'آزمون', 'quiz')
    }

    public function add(seconds:Number=-1, text:String = 'عنوان جدید', type:String = 'topic'):TopicItem
    {
        if(seconds == -1)
                seconds = Utils.time;

        var color:uint = COLOR;
        if(type == 'quiz')
                color = 0x0066cc;

        var newType:String = type;
        if(type == 'quiz')
                newType = 'topic';


        var topic:TopicItem = new TopicItem(remove, text, newType, seconds, color);
        topic.time = seconds;

        if(type == 'quiz')
        {
            topic.addEventListener('clicked', clickOnQuiz);
            if(!_loading)
            {
                topic.id = 'quiz_' + Math.random().toString() + Math.random().toString();
                Main.quiz.add(topic.id);
            }
        }
        else
            topic.addEventListener('clicked', clickOnTopic);

        sort(addTopic(topic));
        ToolTip.add(topic, Utils.timeFormat(topic.time*1000));
        addChild(topic);
        time = _time;

        checkScroll();

        return topic;
    }

    private function clickOnQuiz(e:Event):void
    {
        Main.quiz.show(TopicItem(e.target).id);
        Main.timeLine.setTimeByTopic(TopicItem(e.target).time);
    }
    private function clickOnTopic(e:Event):void
    {
        Main.timeLine.setTimeByTopic(TopicItem(e.target).time);
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

    public function changeTime(topic:TopicItem, seconds:Number):void
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
            _list[i].y = i*28;
            if(TopicItem(_list[i]).type == 'snap')
                TopicItem(_list[i]).text = String(i+1)
        }
    }

    public function remove(topic:TopicItem):void
    {
        topic.removeEventListener('clicked', clickOnTopic);
        topic.removeEventListener('clicked', clickOnQuiz);

        if(Utils.removeObjectFromArray(_list, topic))
            _len--;

        if(topic.parent)
                topic.parent.removeChild(topic);

        if(topic.type == 'snap')
                topic.snapLine.remove();

        sort();
        time = _time;

        checkScroll();

    }

    private function checkScroll():void
    {
        if(len > 13)
                _scroll.show();
        else
                _scroll.hide();
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
        _loading = true;
        for(var i:String in obj)
        {
            if(obj[i].id)
            {
                var t:TopicItem = add(obj[i].time, obj[i].text, 'quiz');
                t.id = obj[i].id;
                Main.quiz.addLoaded(t.id, obj[i].quiz);
            }
            else
                add(obj[i].time, obj[i].text, obj[i].type);
        }
        _loading = false;

    }

    //////////
    public function reset():void
    {
        for(var i:int=len-1; i>-1; i--)
        {
            remove(_list[i]);
        }
    }

    public override function set visible (value:Boolean):void
    {
        if(value)
        {
            if(_len >= 13)
                _scroll.visible = true;
        }
        else
        {
            _scroll.visible = false;
        }

        super.visible = value;
    }

    public function select(topicItem:TopicItem):void
    {
        for (var i:int = 0; i<0; i++)
        {
            if(getChildAt(i) is TopicItem)
            {
                TopicItem(getChildAt(i)).select = false;
            }
            else
            {
                trace(getChildAt(i), typeof getChildAt(i))
            }
        }

        topicItem.select = true;
    }

    public function gotoItemTime(index:int):void
    {
        TopicItem(_list[index]).onClick();
    }

    public function get nums():int
    {
        return _len;
    }
}
}
