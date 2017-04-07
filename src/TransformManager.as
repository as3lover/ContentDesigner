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

public class TransformManager
{
    public var stage:Stage;
    public var area:Sprite;
    private var _tool:TransformTool;
    private var onChange:Function;
    private var _target:Item;

    public function TransformManager(stage:Stage, area:Sprite, onChange:Function)
    {
        this.stage = stage;
        this.area = area;
        this.onChange = onChange;

        _tool = new TransformTool(new ControlSetStandard());
        area.addChild(_tool)
        stage.addEventListener(MouseEvent.MOUSE_DOWN, onStage);
        stage.addEventListener(MouseEvent.MOUSE_DOWN, _tool.deselect);
        area.addEventListener(MouseEvent.MOUSE_DOWN, _tool.deselect);
        stage.addEventListener(KeyboardEvent.KEY_DOWN, onDown)
        area.addEventListener(KeyboardEvent.KEY_DOWN, onDown)

    }

    private function onDown(e:KeyboardEvent):void
    {
        if(_tool.target != null && (e.charCode == 127 || e.keyCode == 46))
        {
            var obj:Item = Item(_tool.target);
            _tool.target = null;
            obj.remove();
            onStage();
        }
    }

    public function add(object:Item):void
    {
        area.setChildIndex(_tool, area.numChildren-1);
        object.addEventListener(MouseEvent.MOUSE_DOWN, _tool.select);
        object.setPrps();
        onStage();
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
        if(target.changed)
                onChange(target);
    }

    private function selectObject(target:Item):void
    {
        if(target.parent && target.parent == area)
        {
            area.setChildIndex(target, area.numChildren-1);
            area.setChildIndex(_tool, area.numChildren-1);
        }
    }
}
}
