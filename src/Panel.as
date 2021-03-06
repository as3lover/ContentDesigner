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

import items.ItemText;

import items.TimeBox;

import panels.Alignment;

import src2.ColorSelector;
import src2.Fonts;
import src2.Utils;

public class Panel extends Sprite
{
    private var _opened:Boolean;
    private var _size:NumericStepper;
    private var _leading:NumericStepper;
    private var _space:NumericStepper;
    private var _fontList:ComboBox;
    private var _selector:ColorSelector;
    private var _typeDur:TimeBox;
    private var _bold:Bold;
    private var _item:ItemText;
    private var _alignment:Alignment;

    public function Panel()
    {
        addEventListener(Event.ADDED_TO_STAGE, init);
    }

    private function init(e:Event):void
    {
        visible = false;

        _selector = new ColorSelector(Main.colorPicker, changeColor);
        _selector.x = 10;
        _selector.y = 10;
        addChild(_selector);

        _bold = new Bold(setBold);
        _bold.x = _selector.x + _selector.width + 10;
        _bold.y = _selector.y;
        addChild(_bold);

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
        for(var i:int = 0; i<Fonts.FONTS.length; i++)
        {
            fonts.push({label:Fonts.FONTS[i], data:Fonts.FONTS[i]})
        }

        _fontList = new ComboBox();
        _fontList.dropdownWidth = 130;
        _fontList.rowCount = 12;
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

        ////////////////////////////////
        ////////////////////////////////

        _alignment = new Alignment();
        _alignment.x = 10;
        _alignment.y = _fontList.y + _fontList.height + 10;
        _alignment.addEventListener(Event.CHANGE, setAlign);
        _alignment.addEventListener(Event.LOCATION_CHANGE, setDrection);
        addChild(_alignment);

        _typeDur = new TimeBox();
        _typeDur.x = 10;
        _typeDur.y = _alignment.y + _alignment.height + 10;
        addChild(_typeDur);

        text = new Sprite();
        text.addChild(Utils.StringToBitmap('پایان تایپ'));
        text.x = _typeDur.x + _typeDur.width + 10;
        text.y = _typeDur.y;
        addChild(text);
        ////////////////////////////////
        ////////////////////////////////


        var back:Shape = new Shape();
        Utils.drawRect(back, 0, 0, width + 20, height);
        addChildAt(back, 0);
    }

    private function setDrection(e:Event):void
    {
        Main.textEditor.setDirection(_alignment.direction);
    }


    private function setBold(bold:Boolean):Boolean
    {
        Main.textEditor.setBold(bold);

        var font:String = _fontList.selectedLabel;
        if(!bold && font.indexOf('Bold') > -1)
        {
            font = font.slice(0, font.length - 5);
            var index:int = Utils.getObjectIndex(Fonts.FONTS, font);
            if (index != -1)
            {
                _fontList.selectedIndex = index;
                Main.textEditor.setFont(font);
                return true;
            }
        }
        else if (bold && font.indexOf('Bold') == -1)
        {
            font = font + ' Bold';
            index = Utils.getObjectIndex(Fonts.FONTS, font);
            if (index != -1)
            {
                _fontList.selectedIndex = index;
                Main.textEditor.setFont(font);
                return true;
            }
        }

        return false;

    }

    private function changeTypeDur(event:Event):void
    {
        if(_item)
        {
            _item.animation.typingEndTime = _typeDur.time;
        }
    }

    private function selectFont(event:Event):void
    {
        Main.textEditor.setFont(_fontList.selectedItem.data as String);

        setBoldStatus();
    }

    private function setAlign(e:Event):void
    {
        Main.textEditor.setAlign(_alignment.align)
    }

    private function setBoldStatus():void
    {
        var font:String = _fontList.selectedLabel;
        if(font.indexOf('Bold') > -1)
        {
            _bold.bold = true;
        }
        else
        {
            font = font + ' Bold';
            var index:int = Utils.getObjectIndex(Fonts.FONTS, font);
            if (index != -1)
            {
                _bold.bold = false;
            }
            else
            {
                _bold.disable();
            }
        }
    }

    private function numberChange(e:Event):void
    {
        switch(e.target)
        {
            case _size:
                Main.textEditor.setSize(e.target.value);
                break;

            case _leading:
                Main.textEditor.setLeading(e.target.value);
                break;

            case _space:
                Main.textEditor.setSpace((e.target.value/10)-2);
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

    public function show(item:ItemText = null):void
    {
        //trace('show');
        if(item)
            _item = item;
        _size.value = Main.textEditor.getSize();
        _space.value = (Main.textEditor.getSpace() + 2)*10;
        _leading.value = Main.textEditor.getLeading();
        _selector.color = Main.textEditor.getColor();
        _alignment.align = Main.textEditor.getAlign();
        _alignment.direction = Main.textEditor.getDirection();
        //_bold.bold = Main.textEditor.getBold();
        _fontList.selectedIndex = Utils.getObjectIndex(Fonts.FONTS, Main.textEditor.getFont());
        setBoldStatus();
        if(_item && _item.animation)
        {
            _typeDur.time = _item.animation.typingEndTime;
            _typeDur.addEventListener('edited', changeTypeDur);
            _typeDur.alpha = 1;
        }
        else
        {
            _typeDur.time = -1;
            _typeDur.alpha = .5;
        }
        visible = true;
    }

    private function changeColor (color:uint):void
    {
        Main.textEditor.setColor(color);
    }

    public function hide():void
    {
        if(_typeDur)
            _typeDur.removeEventListener('edited', changeTypeDur);
        _item = null;
        visible = false;
    }

    public override function set visible (value:Boolean):void
    {
        super.visible = value;
        Utils.listVisible();
    }

}
}
