/**
 * Created by Morteza on 4/19/2017.
 */
package texts
{
import fl.text.TLFTextField;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

import flashx.textLayout.formats.Direction;

import src2.Fonts;

import src2.Utils;

public class TextBox extends Sprite
{
    private var _box:TLFTextField;
    private var _fmt:TextFormat;

    public function TextBox()
    {
        _fmt = new TextFormat();
        _box = new TLFTextField ;

        _fmt.letterSpacing = -0;
        //fmt.lineSpacing = 19;
        //fmt.leading = 0;  //فاصله بین خطوط
        _fmt.leftMargin = 0;
        _fmt.align = TextFormatAlign.RIGHT; //راست چین
        //fmt.align = "justify";
        //fmt.align = "right";
        size = 16;

        _box.defaultTextFormat = _fmt;
        _box.border = true;
        _box.wordWrap = true;
        _box.multiline = true;
        _box.embedFonts = true;
        _box.condenseWhite = true;
        _box.selectable = false;
        padding();
        //_box.autoSize = TextFieldAutoSize.RIGHT;
        _box.cacheAsBitmap = true;
        _box.direction = Direction.RTL;
        font = Fonts.YEKAN;

        addChild(_box);
    }

    private function padding():void
    {
        _box.paddingBottom = 10;
        _box.paddingTop = 10;
        _box.paddingLeft = 10;
        _box.paddingRight = 10;
    }

    private function setFormat()
    {
        _box.defaultTextFormat = _fmt;
        _box.setTextFormat(_fmt);
        padding();
    }

    public function get text():String
    {
        return _box.text;
    }

    public function set text(value:String):void
    {
        _box.text = value;
    }

    public function set color(value:uint):void
    {
        _fmt.color = value;
        setFormat();
    }

    public function set font(value:String):void
    {
        _fmt.font = value;
        setFormat();
    }

    public function set size(value:uint):void
    {
        _fmt.size = value;
        setFormat();
    }

    public function set align(textFormatAlign:String):void
    {
        _fmt.align = textFormatAlign;
        setFormat();
    }

    public function set selectable(value:Boolean):void
    {
        _box.selectable = value;
    }

    public function set editable(value:Boolean):void
    {
        if(value)
            _box.type = TextFieldType.INPUT;
        else
            _box.type = TextFieldType.DYNAMIC;
    }

    public function set background(value:int):void
    {
        _box.backgroundColor = value;
    }

    public override function set width(value:Number):void
    {
        _box.width = value;
    }

    public override function get width():Number
    {
        return _box.width;
    }

    public override function set height(value:Number):void
    {
        _box.height = value;
    }

    public function set numberMode(value:Boolean):void
    {
        if(value)
        {
            _box.direction = Direction.LTR;
            align = TextFormatAlign.LEFT;
        }
        else
        {
            _box.direction = Direction.RTL;
            align = TextFormatAlign.RIGHT;
        }
    }

    public function get bitmap():Bitmap
    {
        return Utils.textBoxToBitmap(_box);
    }

}
}
