/**
 * Created by Morteza on 4/27/2017.
 */
package src2
{
import com.greensock.TweenLite;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFormat;

public class ToolTip extends Sprite
{
    private static var _stage:Stage;
    private static var _box:TextField;
    private static var _format:TextFormat;
    private static var _list:Array;
    private static var _text:Array;

    public static function start(stage:Stage):void
    {
        _stage = stage;
        _box = new TextField();
        _box.visible = false;
        _box.width = 60;
        _box.height = 20;
        _box.border = true;
        _box.background = true;
        _box.backgroundColor = 0xffffff;
        _list = new Array();
        _text = new Array();
        _format = new TextFormat();
        _format.font = 'Tahoma';
        _format.align = 'center';
    }

    public static function add(obj:DisplayObject, text:String):void
    {
        _list.push(obj);
        _text.push(text);
        obj.addEventListener(MouseEvent.MOUSE_OVER, over);
    }

    private static function over(e:MouseEvent):void
    {
        show(e.target);
    }

    public static function show(item):void
    {
        var i:int = Utils.getObjectIndex(_list, item);

        if (i == -1)
        {
            if(item.parent && item.parent != _stage)
                    show(item.parent);
            return
        }

        _box.text = _text[i];
        _box.setTextFormat(_format);

        item.addEventListener(MouseEvent.MOUSE_OUT, out);
        _stage.addEventListener(Event.ENTER_FRAME, ef);
        ef();

        _stage.addChild(_box);
        _box.visible = true;
        _box.alpha = 0;
        TweenLite.to(_box, 0.3, {alpha:1});
    }

    private static function ef(event:Event=null):void
    {
        move();
    }

    private static function move(e:MouseEvent=null):void
    {
        _box.x = _stage.mouseX - _box.width - 5;
        _box.y = _stage.mouseY - _box.height/2;
    }

    private static function out(e:MouseEvent):void
    {

        e.target.removeEventListener(MouseEvent.MOUSE_OUT, out);
        _stage.removeEventListener(Event.ENTER_FRAME, ef);

        _box.visible = false;
    }


    public static function remove(topic:TopicItem):void
    {
        var i:int = Utils.getObjectIndex(_list, topic);

        if(i == -1)
        {
            trace('not found 2', topic);
            return
        }

        Utils.removeItemAtIndex(_list,i);
        Utils.removeItemAtIndex(_text,i);
    }
}
}
