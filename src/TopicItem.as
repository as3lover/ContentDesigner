/**
 * Created by Morteza on 4/18/2017.
 */
package
{
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

public class TopicItem extends Sprite
{
    private var _time:Number;
    private var _evt:Event;
    private var _text:String;
    private var _remove:Function;

    public function TopicItem(remove:Function, txt:String = 'عنوان جدید')
    {
        _remove = remove;
        var menu:TopicMenu = new TopicMenu();
        this.contextMenu = menu.menu;

        text = txt;
        deActive();
        _evt = new Event(Event.ACTIVATE);
        this.addEventListener(MouseEvent.CLICK, onClick)
    }

    private function onClick(event:MouseEvent):void
    {
        trace('topic', time);
        dispatchEvent(_evt);
    }

    public function get time():Number
    {
        return _time;
    }

    public function set time(value:Number):void
    {
        _time = value;
    }

    public function active():void
    {
        alpha = 1;
    }

    public function deActive():void
    {
        alpha= .7;
    }

    public function changeText():void
    {
        Main.textEditor.show(text, setText)
    }

    public function changeTime():void
    {
        Main.textEditor.show(Utils.timeFormat(time*1000), setTime, true)
    }

    public function remove():void
    {
        _remove(this)
    }

    public function get text():String
    {
        return _text;
    }

    public function set text(value:String):void
    {
        if(_text == value)
                return;

        _text = value;
        removeChildren();
        addChild(new Button(_text, 0, 0, 100));

    }

    private function setText(txt:String):void
    {
        text = txt;
    }

    public function setTime(txt:Object):void
    {
        if(parent)
                Topics(parent).changeTime(this, Utils.timeToSec(txt))
    }

    public function get object():Object
    {
        var obj:Object = {};
        obj.time = time;
        obj.text = text;
        return obj;
    }
}
}
