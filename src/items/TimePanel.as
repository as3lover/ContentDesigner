/**
 * Created by Morteza on 4/27/2017.
 */
package items
{
import flash.display.Sprite;
import flash.events.Event;

import src2.Utils;

public class TimePanel extends Sprite
{
    private var _stop:TimeBox;
    private var _start:TimeBox;
    private var _item:Item;

    public function TimePanel()
    {
        visible = false;

        _start = new TimeBox();
        _start.x = 10;
        _start.y = 10;

        _stop = new TimeBox();
        _stop.x = _start.x;
        _stop.y = _start.y + _start.height + 10;

        addChild(_start);
        addChild(_stop);

        var text:Sprite;

        text = new Sprite();
        text.addChild(Utils.StringToBitmap('شروع'));
        text.x = _start.x + _start.width + 10;
        text.y = _start.y;
        addChild(text);

        text = new Sprite();
        text.addChild(Utils.StringToBitmap('پایان'));
        text.x = _stop.x + _stop.width + 10;
        text.y = _stop.y;
        addChild(text);

        Utils.drawRect(this, 0, 0, 154, height + 20);
    }

    private function change(e:Event):void
    {
        if(!_item)
                return;

        trace('change time on timePanel')
        if(e.target == _start)
            _item.animation.startTime = _start.time;
        else if(e.target == _stop)
            _item.animation.stopTime = _stop.time;
        else
            trace(e.target);
    }

    public function show(item:Item):void
    {
        _item = item;

        _start.time = item.animation.startTime;
        _stop.time = item.animation.stopTime;

        _start.addEventListener('edited', change);
        _stop.addEventListener('edited', change);

        visible = true;
        Main.topics.visible = false;
    }

    public function hide()
    {
        _item = null;
        _start.removeEventListener('edited', change);
        _stop.removeEventListener('edited', change);

        visible = false;
        Main.topics.visible = true;
    }
}
}
