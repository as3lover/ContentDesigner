/**
 * Created by Morteza on 4/26/2017.
 */
package src2
{
import components.ColorPicker;

import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.ColorTransform;
import flash.utils.setTimeout;

public class ColorSelector extends Sprite
{
    private var _picker:ColorPicker;
    private var _color:uint;
    private var _onSelect:Function;
    private var _transform:ColorTransform;

    public function ColorSelector(picker:ColorPicker, onSelect:Function)
    {
        _picker = picker;
        _onSelect = onSelect;
        _transform = new ColorTransform();
        Utils.drawRect(this, 0, 0, 25, 25);
        this.addEventListener(MouseEvent.CLICK, onClick)
    }

    private function onStage(event:MouseEvent):void
    {
        stage.removeEventListener(MouseEvent.CLICK, onStage);
        _picker.hide();
    }

    private function onClick(event:MouseEvent):void
    {
        _picker.show(onChange, _color);
        setTimeout(stage.addEventListener, 1, MouseEvent.CLICK, onStage);
    }

    private function onChange():void
    {
        if(_color == _picker.Color)
                return;
        color = _picker.Color;
        _onSelect(_color);
    }

    public function get color():uint
    {
        return _color;
    }

    public function set color(value:uint):void
    {
        _color = value;
        _transform.color = value;
        this.transform.colorTransform = _transform;
    }
}
}
