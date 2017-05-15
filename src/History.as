/**
 * Created by Morteza on 5/5/2017.
 */
package
{
import items.Item;
import items.ItemText;

import texts.Text;

public class History
{
    public static const TRANSFORM:String = 'transform';
    public static const ADD:String = 'add';
    public static const REMOVE:String = 'remove';
    private static var _list:Array = new Array();
    private static var _current:int = 0;
    private static var _item:Object;
    public static const TEXT:String = 'text';
    public static const TIME:String = 'time';
    public static const INDEX:String = 'index';

    public static function reset():void
    {
        _list = [];
        _current = 0;
    }

    ///////////////// Add To History
    public static function add(object:Object, type:String, value:Object):void
    {
        _list[_current] = ({object:object, type:type, value:value});
        _current++;
        trace('add', type, _current);

        if(_list.length > _current)
        {
            _list = _list.slice(0, _current);
        }
    }

    ///////////////// Undo
    public static function undo():void
    {
        if(_current < 1)
            return;

        ObjectManager.deselect();
        Main.changed = true;

        _current--;

        _item = _list[_current];

        trace('undo', _current)

        back(_item.object, _item.type, _item.value);
    }

    ///////////////// Redo
    public static function redo():void
    {
        if(_current >= _list.length)
            return;


        ObjectManager.deselect();
        Main.changed = true;

        _item = _list[_current];
        _current++;
        trace('redo', _current);

        forward(_item.object, _item.type, _item.value);
    }

    ///////////////// Redo Function
    private static function forward(item:Object, type:String, value:Object):void
    {
        switch (type)
        {
            case TRANSFORM:
                transform(item, value.to);
                break;

            case ADD:
                addObject(item as Item, value);
                break;

            case REMOVE:
                remove(Item(item));
                break;

            case INDEX:
                changeIndex(item as Item, value.to.index);
                break;

            case TEXT:
                changeText(item as ItemText, value.to);
                break;

            case TIME:
                animationValues(item as Item, value.to);
                break;
        }
    }

    ///////////////// Undo Function
    private static function back(item:Object, type:String, value:Object):void
    {
        switch (type)
        {
            case TRANSFORM:
                transform(item, value.from);
                break;

            case ADD:
                remove(Item(item));
                break;

            case REMOVE:
                addObject(item as Item, value);
                break;

            case INDEX:
                changeIndex(item as Item, value.from.index);
                break;

            case TEXT:
                changeText(item as ItemText, value.from);
                break;

            case TIME:
                animationValues(item as Item, value.from);
                break;
        }
    }

    private static function changeIndex(item:Item, index:int):void
    {
        index = item.correctIndex(index);
        trace('change index', item.index, index);
        item._index = index;
        item.index = index;
    }

    private static function changeText(item:ItemText, value:Object):void
    {
        item.setTextAndFormat(value.text, value.formats);
        showItem(item);
    }

    private static function showItem(item:Item):void
    {
        item.setProps();
        item.alpha = 1;
        //Main.transformer.select(item);
        ObjectManager.target = item;
    }

    ///////////////// Set Item Tansform
    private static function transform(item:Object, value:Object):void
    {
        setObjectValues(item, value);
        showItem(item as Item);
    }

    ///////////////// Remove Item
    private static function remove(item:Item):void
    {
        item.remove(false);
    }

    ///////////////// Set Object Values
    private static function setObjectValues(object:Object, value:Object):void
    {
        for (var i:String in value)
        {
            trace('set',  value[i], i);
            object[i] = value[i];
        }
    }

    ///////////////// Add Object
    private static function addObject(item:Item, value:Object):void
    {
        Main.dragManager.target.addChild(Item(item));
        Main.animationControl.add(Item(item), value.startTime);

        animationValues(item, value);
    }

    private static function animationValues(item:Item, value:Object):void
    {
        item.animation.setValues(value);
        showItem(item);
    }

}
}
