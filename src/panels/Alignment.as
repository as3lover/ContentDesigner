/**
 * Created by mkh on 2017/07/07.
 */
package panels
{
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextFormatAlign;

import flashx.textLayout.formats.Direction;

import src2.assets;

public class Alignment extends Sprite
{
    private var _align:String;
    private var _direction:String;
    public static const RIGHT:String = TextFormatAlign.RIGHT;
    public static const LEFT:String = TextFormatAlign.LEFT;
    public static const CENTER:String = TextFormatAlign.CENTER;
    public static const LTR:String = Direction.LTR;
    public static const RTL:String = Direction.RTL;
    private var _left:Sprite;
    private var _right:Sprite;
    private var _center:Sprite;
    private const _evt:Event = new Event(Event.CHANGE);
    private const _dir:Event = new Event(Event.LOCATION_CHANGE);
    private var _ltr:Sprite;
    private var _rtl:Sprite;

    public function Alignment()
    {
        _left = new Sprite();
        _left.x = 2;
        var bit:Bitmap = new assets.Left();
        bit.width = bit.height = 20;
        bit.smoothing = true;
        _left.addChild(bit);
        addChild(_left);

        _center = new Sprite();
        _center.x = _left.x + _left.width + 4;
        var bit:Bitmap = new assets.Center();
        bit.width = bit.height = 20;
        bit.smoothing = true;
        _center.addChild(bit);
        addChild(_center);

        _right = new Sprite();
        _right.x = _center.x + _center.width + 4;
        var bit:Bitmap = new assets.Right();
        bit.width = bit.height = 20;
        bit.smoothing = true;
        _right.addChild(bit);
        addChild(_right);

        _ltr = new Sprite();
        _ltr.x = _right.x + _right.width + 8;
        var bit:Bitmap = new assets.Ltr();
        bit.width = bit.height = 20;
        bit.smoothing = true;
        _ltr.addChild(bit);
        addChild(_ltr);

        _rtl = new Sprite();
        _rtl.x = _ltr.x + _ltr.width + 4;
        var bit:Bitmap = new assets.Rtl();
        bit.width = bit.height = 20;
        bit.smoothing = true;
        _rtl.addChild(bit);
        addChild(_rtl);

        buttonMode = true;
        addEventListener(MouseEvent.CLICK, onClick)
    }

    private function onClick(e:MouseEvent):void
    {
        switch(e.target)
        {
            case _left:
                align = LEFT;
                break;

            case _right:
                align = RIGHT;
                break;

            case _center:
                align = CENTER;
                break;

            case _rtl:
                direction = RTL;
                dispatchEvent(_dir);
                return;
                break;

            case _ltr:
                direction = LTR;
                dispatchEvent(_dir);
                return;
                break;

            default:
                return;
            break;
        }

        dispatchEvent(_evt);
    }


    public function set align(align:String):void
    {

        _left.alpha = .3;
        _center.alpha = .3;
        _right.alpha = .3;

        switch (align)
        {
            case RIGHT:
                _right.alpha = 1;
                break;

            case LEFT:
                _left.alpha = 1;
                break;

            case CENTER:
                _center.alpha = 1;
                break;

            default:
                return;
                break;
        }

        _align = align;
    }

    public function get align():String
    {
        return _align;
    }

    public function get direction():String
    {
        return _direction;
    }

    public function set direction(value:String):void
    {

        _ltr.alpha = .3;
        _rtl.alpha = .3;

        switch (value)
        {
            case RTL:
                _rtl.alpha = 1;
                break;

            case LTR:
                _ltr.alpha = 1;
                break;

            default:
                return;
                break;
        }

        _direction = value;
    }
}
}
