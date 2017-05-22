/**
 * Created by Morteza on 5/10/2017.
 */
package
{
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.utils.setTimeout;

import items.Item;
import items.ItemText;
import items.TimePanel;

import src2.Utils;

public class ObjectManager
{
    private static var _transformer:Transformer = new Transformer();
    private static var _target:Item;
    private static var _clipBoardItem:Item;
    private static var _selectList:Array;

    public static function start():void
    {
        Main.STAGE.addEventListener(MouseEvent.MOUSE_DOWN, onDown)

    }

    private static function onDown(e:MouseEvent):void
    {
        //trace('==========================');
        //trace('onDown stage');
        if(Utils.targetClass(e.target as DisplayObject, TimePanel))
                return;

        if(!target || _transformer.state == Cursor.NORMAL)
                target = Utils.targetClass(e.target as DisplayObject, Item) as Item;
        else if(target && _transformer.state == Cursor.MOVE)
            target = Utils.targetClass(e.target as DisplayObject, Item) as Item;

        if(target)
        {
            _transformer.mouseDown();
        }
        else if(Utils.targetClass(e.target as DisplayObject, DragManager))
        {
            SelectRange.start();
        }

    }

    public static function deselect():void
    {
        if(target)
            target = null;
    }

    public static function get target():Item
    {
        return _target;
    }

    public static function set target(item:Item):void
    {
        //trace('set ObjectManager Target', item);
        if(_target == item)
                return;

        _target = item;

        /*
        var index:int = target.index;
        item._index = index;
        var sprite:Sprite = new Sprite();
        item.parent.addChildAt(sprite, index);
        sprite.addChild(item);
        _transformer.target = sprite;
        */

        _transformer.target = item;

        if(item)
        {
            Main.timeLine.toPause();
            Main.timePanel.show(item);
            Main.timeLine.select(item);
        }
        else
        {
            Main.timePanel.hide();
            Main.timeLine.select(null)
        }
    }

    public static function set selectList(value:Array):void
    {
        _selectList = value;
        _transformer.selectList = value;

    }

    public static function EnterKey()
    {
        trace('EnterKey');
        if(target && target is ItemText)
        {
            var it:ItemText = ItemText(target);
            it.edit();
        }
        else
        {
            trace('target is', target);
        }
    }


    ////////////////MOVE
    public static function moveLeft(ctrlKey:Boolean, shift:Boolean):void
    {
        if(target)
        {
            var d:int = 5;
            if(ctrlKey)
                d = 1;
            else if(shift)
                d = 20;

            target.x -= d;
            target.changed;
            _transformer.update();
        }
    }

    public static function moveUp(ctrlKey:Boolean, shift:Boolean):void
    {
        if(target)
        {
            var d:int = 5;
            if(ctrlKey)
                d = 1;
            else if(shift)
                d = 20;

            target.y -= d;
            target.changed;
            _transformer.update();
        }
    }

    public static function moveDown(ctrlKey:Boolean, shift:Boolean):void
    {
        if(target)
        {
            var d:int = 5;
            if(ctrlKey)
                d = 1;
            else if(shift)
                d = 20;

            target.y += d;
            target.changed;
            _transformer.update();
        }
    }

    public static function moveRight(ctrlKey:Boolean, shift:Boolean):void
    {
        if(target)
        {
            var d:int = 5;
            if(ctrlKey)
                d = 1;
            else if(shift)
                d = 20;

            target.x += d;
            target.changed;
            _transformer.update();
        }
    }
    //////////////////////////////
    //////////////////////////////
    //////////////////////////////

    public static function Copy(item:Item = null):void
    {
        if(item && item != target)
            target = item;

        if(target)
        {
            trace('copy');

            if(target is ItemText)
                _clipBoardItem = new ItemText(Main.removeAnimation, false, false);
            else
                _clipBoardItem = new Item(Main.removeAnimation, target.path);

            target.changed;
            var props:Object = target.all;
            props.x += 10;
            props.y += 10;
            _clipBoardItem.all = props;
            _clipBoardItem.setState();
            _clipBoardItem.load();
        }
    }

    public static function Cut(item:Item = null):void
    {
        if(item && item != target)
                target = item;

        if(target)
        {
            trace('cut');

            _clipBoardItem = target;
            removeObject(target);
        }
    }

    public static function Paste(shift:Boolean = false, rightClick:Boolean=false):void
    {
        if(_clipBoardItem)
        {
            trace('paste');

            target = null;
            if(shift)
            {
                _clipBoardItem.x -= 10;
                _clipBoardItem.y -= 10;
                _clipBoardItem.setProps();
            }
            else if(rightClick)
            {
                _clipBoardItem.x = Main.dragManager.target.mouseX;
                _clipBoardItem.y = Main.dragManager.target.mouseY;
                _clipBoardItem.setProps();
            }
            Main.dragManager.target.addChild(_clipBoardItem);
            Main.animationControl.add(_clipBoardItem, Utils.time);
            target = _clipBoardItem;
            _clipBoardItem.addToHistory(History.ADD);
            _clipBoardItem = null;
        }
    }

    public static function DeleteKey():void
    {
        if(target != null && !Main.textEditor.visible && !Main.timePanel.focus)
        {
            removeObject(target);
        }
    }

    private static function removeObject(obj:Item):void
    {
        deselect();
        obj.remove(true);
        Main.changed = true;
    }

    /*
     public function Transformer()
     {

     }

     public static function add(object:Item):void
     {
        //object.addEventListener(MouseEvent.MOUSE_DOWN, onObject);
     }

     public static function remove(object:Item):void
     {
        //object.removeEventListener(MouseEvent.MOUSE_DOWN, onObject)
     }
     */
    public static function reset():void
    {
        deselect();
    }

    public static function select(item:Item):void
    {
        target = item;
    }

    public static function Duplicate():void
    {
        if(!target)
            return;
        Copy();
        if(_clipBoardItem)
        {
            target = null;
            setTimeout(Paste, 100);
        }
    }

    public static function Miror():void
    {
        if(!target)
            return;

        target.scaleX = -target.scaleX;
        target.changed;
    }
}
}
