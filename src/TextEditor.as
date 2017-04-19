/**
 * Created by Morteza on 4/19/2017.
 */
package
{
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.MouseEvent;

public class TextEditor extends Sprite
{
    private var _textBox:TextBox;
    private var _function:Function;
    protected var cancel:Button;

    public function TextEditor(x:int,y:int,width:int,height:int, color:uint=0xcccccc)
    {
        visible = false;
        this.x = x;
        this.y = y;
        Utils.drawRect(this, 0, 0, width, height, color);

        _textBox = new TextBox();
        _textBox.x = 10;
        _textBox.y = 10;
        _textBox.width = width - 80;
        _textBox.height = height - 20;
        _textBox.text = 'متن نمونه';
        _textBox.editable = true;
        _textBox.color = 0x000000;
        _textBox.background = 0xbbbbbb
        addChild(_textBox);


        var ok:Button = new Button('ثبت', 0, 0, 40);
        ok.addEventListener(MouseEvent.CLICK, onOk)
        ok.x = _textBox.x + _textBox.width + 10;
        ok.y = 10;
        addChild(ok)

        cancel = new Button('لغو', 0, 0, 40);
        cancel.addEventListener(MouseEvent.CLICK, onCancel)
        cancel.x = ok.x;
        cancel.y = ok.y + ok.height + 5;
        addChild(cancel)
    }

    private function onCancel(event:MouseEvent):void
    {
        hide();
    }

    private function onOk(event:MouseEvent):void
    {
        if(_function != null)
                _function(_textBox.text);
        hide();
    }

    public function hide():void
    {
        visible = false;
    }

    public function show(text:String = '', func:Function = null, numberMode:Boolean = false):void
    {
        _textBox.text = text;
        _textBox.numberMode = numberMode;
        visible = true;
        _function = func;
    }

    public function get bitmap():Bitmap
    {
        return _textBox.bitmap;
    }

    public function set text(text:String):void
    {
        _textBox.text = text;
    }

    public function set color(color:uint):void
    {
        _textBox.color = color;
    }
}
}
