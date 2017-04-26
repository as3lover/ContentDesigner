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
import flash.utils.setTimeout;

import items.Item;

import items.TextItem;

import src2.Utils;

public class TransformManager
{
    public var stage:Stage;
    public var area:Sprite;
    private var _tool:TransformTool;
    public var _target:Item;
    private var _clipBoardItem:Item;

    public function TransformManager(stage:Stage, area:Sprite)
    {
        this.stage = stage;
        this.area = area;

        _tool = new TransformTool(new ControlSetStandard());
        area.addChild(_tool)
        stage.addEventListener(MouseEvent.MOUSE_DOWN, onStage);
        stage.addEventListener(MouseEvent.MOUSE_DOWN, _tool.deselect);
        area.addEventListener(MouseEvent.MOUSE_DOWN, _tool.deselect);
        stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown)
        area.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown)

    }

    private function onKeyDown(e:KeyboardEvent):void
    {
        if(_tool.target != null && (e.charCode == 127 || e.keyCode == 46) && !Main.textEditor.visible)
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
        var a = Utils.isParentOf(stage, TextItem, e.target as DisplayObject);
        if(e.target is TextItem || a)
        {
            if(TextItem(a).editable)
                    return;
        }
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

    private function onStage(e:MouseEvent = null):void
    {
        if(_tool.target == null)
        {
            if(_target != null)
            {
                deselectObject(_target);
                _target = null;
            }
        }
        else
        {
            if(_target == null)
            {
                _target = _tool.target as Item;
                selectObject(_target);
            }
            else if(_target != _tool.target)
            {
                deselectObject(_target);
                _target = _tool.target as Item;
                selectObject(_target)
            }
        }
    }

    private function deselectObject(target:Item):void
    {
        target.changed
        Main.panel.hide();
    }

    private function selectObject(target:Item):void
    {
        if(target && target.parent && target.parent == area)
        {
            //area.setChildIndex(target, area.numChildren-1);
            area.setChildIndex(_tool, area.numChildren-1);
            if(target is TextItem)Main.panel.show(target as TextItem);
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
        if(_target)
        {
            if(_target is TextItem)
                _clipBoardItem = new TextItem(Main.removeAnimation);
            else
                _clipBoardItem = new Item(Main.removeAnimation, _target.path);

            _target.changed;
            var props:Object = _target.all;
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
        if(_target)
        {
            _clipBoardItem = _target;
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
        if(_target)
        {
            var d:int = 5;
            if(ctrlKey)
                d = 1;
            else if(shift)
                    d = 20;

            _target.x -= d;
            _target.updateTransform();
        }
    }

    public function moveUp(ctrlKey:Boolean, shift:Boolean):void
    {
        if(_target)
        {
            var d:int = 5;
            if(ctrlKey)
                d = 1;
            else if(shift)
                d = 20;

            _target.y -= d;
            _target.updateTransform();
        }
    }

    public function moveDown(ctrlKey:Boolean, shift:Boolean):void
    {
        if(_target)
        {
            var d:int = 5;
            if(ctrlKey)
                d = 1;
            else if(shift)
                d = 20;

            _target.y += d;
            _target.updateTransform();
        }
    }

    public function moveRight(ctrlKey:Boolean, shift:Boolean):void
    {
        if(_target)
        {
            var d:int = 5;
            if(ctrlKey)
                d = 1;
            else if(shift)
                d = 20;

            _target.x += d;
            _target.updateTransform();
        }
    }

    public function EnterKey():void
    {
        if(_target is TextItem)
        {
            var t:TextItem = TextItem(_target);
            deselect();
            t.editable = true;
        }
    }
}
}
