/**
 * Created by Morteza on 4/22/2017.
 */
package
{
import fl.controls.ComboBox;
import fl.controls.NumericStepper;
import fl.data.DataProvider;

import flash.display.Bitmap;

import flash.display.Shape;

import flash.display.Sprite;
import flash.events.Event;
import flash.text.TextFormat;

import items.TextItem;

import src2.Fonts;

import src2.Utils;

public class Panel extends Sprite
{
    import fl.controls.ColorPicker;
    import fl.events.ColorPickerEvent;

    private  var selectedText:TextItem;
    private var _opened:Boolean;
    private var _size:NumericStepper;
    private var _leading:NumericStepper;
    private var _space:NumericStepper;
    private var _fontList:ComboBox;

    public function Panel()
    {
        hide();

        var color:ColorPicker = new ColorPicker();
        color.editable = true;
        color.move(10, 10);
        addChild(color);
        color.addEventListener(ColorPickerEvent.CHANGE, changeHandler);
        color.addEventListener(Event.OPEN, open);
        color.addEventListener(Event.CLOSE, close);


        _size = addNumber(1,100,1, color.x, color.y + color.height + 10);
        _leading = addNumber(0,100,1, _size.x, _size.y + _size.height + 10);
        _space = addNumber(1,40,1, _leading.x, _leading.y + _leading.height + 10);

        var text:Sprite;

        text = new Sprite();
        text.addChild(Utils.StringToBitmap('سایز'));
        text.x = _size.x + _size.width + 10;
        text.y = _size.y;
        addChild(text);

        text = new Sprite();
        text.addChild(Utils.StringToBitmap('فاصله خطوط'));
        text.x = _leading.x + _leading.width + 10;
        text.y = _leading.y;
        addChild(text);

        text = new Sprite();
        text.addChild(Utils.StringToBitmap('فاصله حروف'));
        text.x = _space.x + _space.width + 10;
        text.y = _space.y;
        addChild(text);



        var fonts:Array = new Array();
        for(var i:String in Fonts.FONTS)
        {
            fonts.push({label:i, data:Fonts.FONTS[i]})
            trace('font', i, Fonts[i]);
        }

        _fontList = new ComboBox();
        _fontList.dropdownWidth = 130;
        _fontList.width = 130;
        _fontList.move(150, 50);
        _fontList.prompt = "Select Font";
        _fontList.dataProvider = new DataProvider(fonts);
        _fontList.addEventListener(Event.CHANGE, selectFont);
        _fontList.x = _space.x;
        _fontList.y = _space.y + _space.height + 10;
        addChild(_fontList);
        _fontList.addEventListener(Event.OPEN, open);
        _fontList.addEventListener(Event.CLOSE, close);


        var back:Shape = new Shape();
        Utils.drawRect(back, 0, 0, width + 20, height - 20);
        addChildAt(back, 0);
    }

    private function selectFont(event:Event):void
    {
        selectedText.setFont(_fontList.selectedItem.data as String);
    }

    private function addNumber(min:int, max:int, step:Number, x:int, y:int):NumericStepper
    {
        var number:NumericStepper = new NumericStepper();
        number.x = x;
        number.y = y;
        number.width = 60;
        number.minimum = min;
        number.maximum = max;
        number.stepSize = step;
        number.addEventListener(Event.CHANGE, numberChange)
        addChild(number);
        return number;
    }

    private function numberChange(e:Event):void
    {
        switch(e.target)
        {
            case _size:
                selectedText.setSize(e.target.value);
                break;

            case _leading:
                selectedText.setLeading(e.target.value);
                break;

            case _space:
                selectedText.setSpace((e.target.value/10)-2);
                break;
        }
    }



    private function close(event:Event):void
    {
        _opened = false;
    }

    private function open(event:Event):void
    {
        _opened = true;
    }

    public function get opened():Boolean
    {
        return _opened;
    }

    public function show(textI:TextItem):void
    {
        selectedText = textI;
        _size.value = textI.getSize();
        _space.value = (textI.getSpace() + 2)*10;
        _leading.value = textI.getLeading();
        visible = true;
    }

    private function changeHandler (event:ColorPickerEvent):void
    {
        var newuint = uint("0x"+event.target.hexValue);
        selectedText.setColor(newuint);
    }

    public function hide():void
    {
        visible = false;
    }
}
}
