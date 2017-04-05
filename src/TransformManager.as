/**
 * Created by Morteza on 4/5/2017.
 */
package
{
import com.senocular.display.transform.ControlSetStandard;
import com.senocular.display.transform.TransformTool;

import flash.display.DisplayObject;

import flash.display.DisplayObject;
import flash.display.Sprite;

import flash.display.Stage;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Point;

public class TransformManager
{
    public var stage:Stage;
    public var area:Sprite;
    private var _tool:TransformTool;

    public function TransformManager(stage:Stage, area:Sprite)
    {
        this.stage = stage;
        this.area = area;

        _tool = new TransformTool(new ControlSetStandard());
        area.addChild(_tool)
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
        }
    }

    public function add(object:DisplayObject):void
    {
        area.setChildIndex(_tool, area.numChildren-1);
        object.addEventListener(MouseEvent.MOUSE_DOWN, _tool.select);
        object.addEventListener(MouseEvent.MOUSE_DOWN, selectObject);
        _tool.target = object;
        /*
        _tool.registrationManager.setRegistration(object, new Point(20, 20));
        trace(_tool.registrationManager.getRegistration(object));
        _tool.registrationManager.setRegistration(object, new Point(20, 20));
        */
    }

    private function selectObject(e:MouseEvent):void
    {
        if(e.target.parent && e.target.parent == area)
        {
            area.setChildIndex(DisplayObject(e.target), area.numChildren-1);
            area.setChildIndex(_tool, area.numChildren-1);
        }
    }

    public function select(object:DisplayObject):void
    {
        _tool.target = object;
    }

    public function deselect():void
    {
        _tool.target = null;
    }
}
}
