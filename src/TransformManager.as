/**
 * Created by Morteza on 4/5/2017.
 */
package
{
import com.senocular.display.transform.ControlSetStandard;
import com.senocular.display.transform.TransformTool;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.utils.setTimeout;

import items.Item;
import items.ItemText;

import items.TextItem;

import src2.AnimateObject;

import src2.Utils;

public class TransformManager
{
    public var stage:Stage;
    public var area:Sprite;
    private var _tool:TransformTool;
    private var _target:Item;
    public var taaarget:Item;
    private var _clipBoardItem:Item;

    public function TransformManager(stage:Stage, area:Sprite)
    {
        this.stage = stage;
        this.area = area;

        _tool = new TransformTool(new ControlSetStandard());
        area.addChild(_tool);
        stage.addEventListener(MouseEvent.MOUSE_DOWN, onStageDown);
        stage.addEventListener(MouseEvent.MOUSE_DOWN, _tool.deselect);
        area.addEventListener(MouseEvent.MOUSE_DOWN, _tool.deselect);
        stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        area.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);

        /*
        Main.dragManager.target.doubleClickEnabled = true;
        Main.dragManager.target.addEventListener(MouseEvent.DOUBLE_CLICK, double1, true, 0);
        Main.dragManager.target.addEventListener(MouseEvent.DOUBLE_CLICK, double2, false, 0);
        Main.dragManager.target.addEventListener(MouseEvent.DOUBLE_CLICK, double3, true, 999);
        Main.dragManager.target.addEventListener(MouseEvent.DOUBLE_CLICK, double4, false, 999);
        */
    }

    /*
    private function double1(event:MouseEvent):void {double()}
    private function double2(event:MouseEvent):void {double()}
    private function double3(event:MouseEvent):void {double()}
    private function double4(event:MouseEvent):void {double()}

    private function double():void
    {
        trace('double on target')
        if(target && target is ItemText)
               ItemText(target).double();
    }
    */

    private function onMouseUp(event:MouseEvent):void
    {
        if(target && target.changed)
        {
            _tool.target = null;
            _tool.target = target;
        }
    }

    private function onKeyDown(e:KeyboardEvent):void
    {
        if(_tool.target != null && (e.charCode == 127 || e.keyCode == 46) && !Main.textEditor.visible && !(stage.focus is TextField))
        {
            deleteObject();
        }
    }


    public function add(object:Item, loaded:Boolean=false):void
    {
        area.setChildIndex(_tool, area.numChildren-1);
        object.addEventListener(MouseEvent.MOUSE_DOWN, toolSelect);
        if(loaded == false)
        {
            object.setProps();
            onStage();
        }
    }

    private function toolSelect(e:MouseEvent):void
    {
        Main.timeLine.toPause();
        var a:Object = Utils.isParentOf(stage, TextItem, e.target as DisplayObject);
        if(e.target is TextItem || a)
        {
            if(TextItem(a).editable)
                    return;
        }
        stage.focus = null;
        _tool.select(e);

    }

    public function select(object:DisplayObject):void
    {
        _tool.target = object;
        onStage();
    }

    public function deselect():void
    {
        _tool.target = null;
        onStage();
    }

    private function onStageDown(e:MouseEvent = null):void
    {
        onStage()
    }

        private function onStage(e:MouseEvent = null):void
    {

        if(_tool.target == null)
        {
            if(target != null)
            {
                deselectObject(target);
                target = null;
            }
        }
        else
        {
            if(target == null)
            {
                target = _tool.target as Item;
                selectObject(target);
            }
            else if(target != _tool.target)
            {
                deselectObject(target);
                target = _tool.target as Item;
                selectObject(target)
            }
        }
    }

    private function deselectObject(item:Item):void
    {
        item.changed
        if(!Main.textEditor.visible)
            Main.panel.hide();
        Main.timePanel.hide();
    }

    private function selectObject(item:Item):void
    {
        if(item && item.parent && item.parent == area)
        {
            //area.setChildIndex(target, area.numChildren-1);
            area.setChildIndex(_tool, area.numChildren-1);
            Main.timePanel.show(item);
            //if(item is TextItem)Main.panel.show(item as TextItem);
            //if(item is ItemText)Main.panel.show(item as ItemText);
        }
    }

    public function reset():void
    {
        trace('to do reset transform')
        select(null);
    }

    public function get tool():Object
    {
        return _tool;
    }

    public function Copy():void
    {
        trace('copy');
        if(target)
        {
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

    public function Paste():void
    {
        trace('paste');
        if(_clipBoardItem)
        {
            select(null);
            Main.dragManager.target.addChild(_clipBoardItem);
            Main.transformer.add(_clipBoardItem, true);
            Main.animationControl.add(_clipBoardItem, Utils.time)
            select(_clipBoardItem);
            _clipBoardItem = null;
        }
    }

    public function Cut():void
    {
        trace('cut');
        if(target)
        {
            _clipBoardItem = target;
            deleteObject();
        }
    }


    private function deleteObject():void
    {
        var obj:Item = Item(_tool.target);
        _tool.target = null;
        obj.remove();
        onStage();
    }

    public function moveLeft(ctrlKey:Boolean, shift:Boolean):void
    {
        if(target)
        {
            var d:int = 5;
            if(ctrlKey)
                d = 1;
            else if(shift)
                    d = 20;

            target.x -= d;
            target.updateTransform();
        }
    }

    public function moveUp(ctrlKey:Boolean, shift:Boolean):void
    {
        if(target)
        {
            var d:int = 5;
            if(ctrlKey)
                d = 1;
            else if(shift)
                d = 20;

            target.y -= d;
            target.updateTransform();
        }
    }

    public function moveDown(ctrlKey:Boolean, shift:Boolean):void
    {
        if(target)
        {
            var d:int = 5;
            if(ctrlKey)
                d = 1;
            else if(shift)
                d = 20;

            target.y += d;
            target.updateTransform();
        }
    }

    public function moveRight(ctrlKey:Boolean, shift:Boolean):void
    {
        if(target)
        {
            var d:int = 5;
            if(ctrlKey)
                d = 1;
            else if(shift)
                d = 20;

            target.x += d;
            target.updateTransform();
        }
    }

    public function EnterKey():void
    {
        if(target is TextItem)
        {
            var t:TextItem = TextItem(target);
            deselect();
            t.editable = true;
            //Main.timePanel.show(t);
        }
        else if(target is ItemText)
        {
            var tt:ItemText = ItemText(target);
            tt.edit();
        }
    }

    public function get target():Item
    {
        return _target;
    }

    public function set target(value:Item):void
    {
        _target = value;
        Main.timeLine.select(_target);
    }
}
}
