/**
 * Created by Morteza on 4/18/2017.
 */
package src2
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
    private var _width:int;
    private var _type:String;
    public var snapLine:SnapLine;
    private var _color:uint;
    private var _id:String;

    public function TopicItem(remove:Function, txt:String, type:String, seconds:Number, color:uint)
    {
        _color = color;
        _type = type;
        if(type == 'topic')
        {
            _width = 135-30;
        }
        else
        {
            _width = 20;
            snapLine = Main.timeLine.addSnap(seconds);
        }

        _remove = remove;
        var menu:TopicMenu = new TopicMenu(type);
        this.contextMenu = menu.menu;

        text = txt;
        deActive();
        _evt = new Event('clicked');
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
        Main.changed = true;

        Main.textEditor.show(text, setText)
    }

    public function changeTime():void
    {
        Main.changed = true;

        Main.textEditor.show(Utils.timeFormat(time*1000), setTime, true)
    }

    public function remove():void
    {
        if(snapLine)
            snapLine.remove();

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
        addChild(new Button(_text, 0, 0, _width, 20, 0xeeeeee, _color));
    }

    private function setText(txt:String):void
    {
        text = txt;
    }

    public function setTime(txt:Object):void
    {
        if(parent)
                Topics(parent).changeTime(this, Utils.timeToSec(txt));

        if(snapLine)
            snapLine.time = Utils.timeToSec(txt);
    }

    public function get object():Object
    {
        var obj:Object = {};
        obj.time = time;
        obj.text = text;
        obj.type = type;
        return obj;
    }

    public function get type():String
    {
        return _type;
    }

    public function get id():String
    {
        return _id;
    }

    public function set id(value:String):void
    {
        _id = value;
    }
}
}
