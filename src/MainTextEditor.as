/**
 * Created by Morteza on 4/19/2017.
 */
package
{
import fl.controls.ColorPicker;
import fl.events.ColorPickerEvent;

public class MainTextEditor extends TextEditor
{
    public function MainTextEditor()
    {
        super(20, 40, 600, 337);

        var colorPicker:ColorPicker = new ColorPicker();
        colorPicker.editable = true;
        colorPicker.move(10, 10);
        colorPicker.x = cancel.x;
        colorPicker.y = cancel.y + cancel.height + 10;
        addChild(colorPicker);

        colorPicker.addEventListener(ColorPickerEvent.CHANGE, changeHandler);

        function changeHandler (event:ColorPickerEvent):void
        {
            var newuint = uint("0x"+event.target.hexValue);
            color = newuint;
        }

    }
}
}
