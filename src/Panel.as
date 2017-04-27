/**
 * Created by Morteza on 4/22/2017.
 */
package
{
import fl.controls.ComboBox;
import fl.controls.NumericStepper;
import fl.data.DataProvider;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import items.TextItem;
import src2.ColorSelector;
import src2.Fonts;
import src2.Utils;

public class Panel extends Sprite
{
    private  var selectedText:TextItem;
    private var _opened:Boolean;
    private var _size:NumericStepper;
    private var _leading:NumericStepper;
    private var _space:NumericStepper;
    private var _fontList:ComboBox;
    private var _selector:ColorSelector;

    public function Panel()
    {
        addEventListener(Event.ADDED_TO_STAGE, init);
    }

    private function init(e:Event):void
    {
        hide();

        _selector = new ColorSelector(Main.colorPicker, changeColor);
        _selector.x = 10;
        _selector.y = 10;
        addChild(_selector);

        _size = Utils.numericStepper(this, 1,100,1, _selector.x, _selector.y + _selector.height + 10, 60, numberChange);
        _leading = Utils.numericStepper(this, 0,100,1, _size.x, _size.y + _size.height + 10, 60, numberChange);
        _space = Utils.numericStepper(this,1,40,1, _leading.x, _leading.y + _leading.height + 10, 60, numberChange);

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
        Utils.drawRect(back, 0, 0, width + 20, height - 58);
        addChildAt(back, 0);

        trace(width)
    }

    private function selectFont(event:Event):void
    {
        selectedText.setFont(_fontList.selectedItem.data as String);
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
        _selector.color = textI.getColor();
        visible = true;
    }

    private function changeColor (color:uint):void
    {
        selectedText.setColor(color);
    }

    public function hide():void
    {
        visible = false;
    }

}
}
