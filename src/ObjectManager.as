/**
 * Created by Morteza on 5/10/2017.
 */
package
{
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Matrix;
import flash.utils.setTimeout;

import items.Item;
import items.ItemText;
import items.TimePanel;

import src2.AnimateObject;

import src2.Consts;

import src2.Utils;

public class ObjectManager
{
    private static var _transformer:Transformer = new Transformer();
    private static var _target:Item;
    private static var _clipBoardItem:Item;
    private static var _selectList:Array;
    private static var _objects:Sprite;

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
        {
            var item:Item = Utils.targetClass(e.target as DisplayObject, Item) as Item;
            if(item && _selectList)
            {
                var i:int = Utils.getObjectIndex(_selectList, item);
                if(i != -1)
                {
                    return;
                    _transformer.mouseDown();
                }
                else
                    target = item as Item;
            }
            else
                target = item;
        }

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
        if(_selectList)
        {
            _selectList = null;
            _transformer.selectList = null
        }
        /*
        if(_selectList && _objects)
        {
            if(_objects && _objects.parent)
                _objects.parent.removeChild(_objects);

            var list:Array = _selectList;
            var length:int = list.length;

            for(var i:int = 0; i<length; i++)
            {
                Main.dragManager.target.addChildAt(Item(list[i]), Item(list[i])._index);
                Item(list[i]).x += _objects.x * _objects.scaleX;
                Item(list[i]).y += _objects.y * _objects.scaleY;
                Item(list[i]).rotation += _objects.rotation;
                Item(list[i]).scaleX *= _objects.scaleX;
                Item(list[i]).scaleY *= _objects.scaleY;
                Item(list[i]).changed;
            }

            _objects = null;
            _selectList = null;
        }
        */
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

    public static function set selectList(list:Array):void
    {
        _selectList = list;
        _transformer.selectList = list;
         /*
        var length:int = list.length;

        _objects = new Sprite();

        //_objects.rotation = int(Math.random() * 10);
        _objects.x = -50 + int(Math.random() * 100);
        _objects.y = -50 + int(Math.random() * 100);
        _objects.scaleX += -.5 + int(Math.random() * 10)/10;
        _objects.scaleY += -.5 + int(Math.random() * 10)/10;

        sortList(list);

        for(var i:int=0; i<length; i++)
        {
            Item(list[i]).resetIndex();
        }

        for(i=0; i<length; i++)
        {
            _objects.addChild(list[i]);
        }

        Main.dragManager.target.addChildAt(_objects, Item(list[0])._index)
        */
    }

    private static function sortList(list:Array):void
    {
        var length:int = list.length;

        for(var i:int=length-1; i>-1; i--)
        {
            for(var j:int=0; j<i; j++)
            {
                if(Item(list[j]).index > Item(list[j+1]).index)
                        Utils.swapInArray(list, j, j+1)
            }
        }
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
    public static function moveLeft(ctrlKey:Boolean, shift:Boolean, alt:Boolean):void
    {
        if(target)
        {
            var d:int = 5;
            if(ctrlKey)
                d = 1;
            else if(shift)
                d = 20;
            else if(alt)
                d = target.x - target.width/2;

            target.x -= d;
            target.changed;
            _transformer.update();
        }
    }

    public static function moveUp(ctrlKey:Boolean, shift:Boolean, alt:Boolean):void
    {
        if(target)
        {
            var d:int = 5;
            if(ctrlKey)
                d = 1;
            else if(shift)
                d = 20;
            else if(alt)
                d = target.y - target.height/2;

            target.y -= d;
            target.changed;
            _transformer.update();
        }
    }

    public static function moveDown(ctrlKey:Boolean, shift:Boolean, alt:Boolean):void
    {
        if(target)
        {
            var d:int = 5;
            if(ctrlKey)
                d = 1;
            else if(shift)
                d = 20;
            else if(alt)
                d = (Main.target.h - target.height/2) - target.y;


            target.y += d;
            target.changed;
            _transformer.update();
        }
    }

    public static function moveRight(ctrlKey:Boolean, shift:Boolean, alt:Boolean):void
    {
        if(target)
        {
            var d:int = 5;
            if(ctrlKey)
                d = 1;
            else if(shift)
                d = 20;
            else if(alt)
                d = (Main.target.w - target.width/2) - target.x;

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

    public static function MirorX():void
    {
        if(!target)
            return;

        target.scaleX = -target.scaleX;
        target.changed;
    }

    public static function MirorY():void
    {
        if(!target)
            return;

        target.scaleY = -target.scaleY;
        target.changed;
    }

    public static function End():void
    {
        Item.setIndexByUser(Consts.ARRANGE.BACK,target);
    }

    public static function Home():void
    {
        Item.setIndexByUser(Consts.ARRANGE.FRONT,target);
    }

    public static function PageDown():void
    {
        Item.setIndexByUser(Consts.ARRANGE.BACK_LEVEL,target);
    }

    public static function PageUp():void
    {
        Item.setIndexByUser(Consts.ARRANGE.FRONT_LEVEL,target);
    }

    public static function get selected():Boolean
    {
        trace('selected', target)
        if(target == null)
            return false;
        else
            return true;
    }


    public static function ResetItem():void
    {
        if(target)
        {
            var scale:Number = 1;

            if(target is ItemText)
                scale = 1/ItemText.QUALITY;

            target.scaleX = scale;
            target.scaleY = scale;
            target.rotation = 0;
            target.updateTransform();
            target.changed;
        }
    }

    public static function selectByTab(ctrlKey:Boolean):void
    {
        var list:Array = Main.animationControl.visibleList;

        if(list.length == 0)
                return;

        var i:int = 0;

        if(target)
        {
           i = Utils.getObjectIndex(list, target.animation);

            trace('A',i);

            if(ctrlKey)
                i--;
            else
                i++;

            trace(i);

            if(i<0)
                i = list.length - 1;
            else if(i >= list.length)
                i = 0;

            trace(i);
        }

        trace('B',i);

        target = AnimateObject(list[i]).object;

    }

    public static function scaleUp():void
    {
        if(target)
        {
            target.scaleX *= 1.1;
            target.scaleY *= 1.1;
            target.updateTransform();
            target.changed;
        }
    }

    public static function scaleDown():void
    {
        if(target)
        {
            target.scaleX *= .9;
            target.scaleY *= .9;
            target.updateTransform();
            target.changed;
        }
    }
}
}
