/**
 * Created by Morteza on 4/27/2017.
 */
package src2
{
import com.greensock.TweenLite;

import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFormat;

import items.Item;

public class ToolTip extends Sprite
{
    private static var _stage:Stage;
    private static var _box:TextField;
    private static var _format:TextFormat;
    private static var _list:Array;
    private static var _text:Array;
    private static var _onlineList:Array;
    private static var _item:Object;

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
        _onlineList = new Array();
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

    //////////////////////////////
    public static function addOnline(obj:DisplayObject):void
    {
        _onlineList.push(obj);
        obj.addEventListener(MouseEvent.MOUSE_OVER, overOnline);
    }

    public static function removeOnline(obj:DisplayObject):void
    {
        obj.removeEventListener(MouseEvent.MOUSE_OVER, overOnline);
        Utils.removeObjectFromArray(_onlineList, obj);
    }

    private static function overOnline(e:MouseEvent):void
    {
        show(e.target, _onlineList);
    }
    //////////////////////////

    private static function over(e:MouseEvent):void
    {
        show(e.target, _list);
    }

    public static function show(item, list:Array):void
    {
        var i:int = Utils.getObjectIndex(list, item);

        if (i == -1)
        {
            if(item.parent && item.parent != _stage)
                    show(item.parent, list);
            return
        }

        _item = item;

        if(list == _list)
            startShow(item, _text[i]);
        else
            startShow(item, item.toolTipText, 'left')

    }

    public static function update(item:Item):void
    {
        if(item == _item)
        {
            startShow(item, item.toolTipText, 'left');
            _box.alpha = 1;
        }
    }

    private static function startShow(item:DisplayObject, text:String, align:String = 'center'):void
    {
        _box.text = text;
        _format.align = align;
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
        _box.width = _box.textWidth + 10;
        _box.height = _box.textHeight + 5;
        if(_format.align == 'center')
        {
            _box.x = _stage.mouseX - _box.width - 5;
            _box.y = _stage.mouseY - _box.height/2;
        }
        else
        {
            _box.x = 0;
            _box.y = _stage.stageHeight - _box.height;
        }
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
