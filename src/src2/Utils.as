/**
 * Created by Morteza on 4/4/2017.
 */
package src2
{
import fl.text.TLFTextField;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.display.Stage;
import flash.geom.Matrix;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

public class Utils
{
    public function Utils()
    {
    }

    //convert time format to Number data type
    public static function timeToSec(t:Object):Number
    {
        if (t is Number)
            return Number(t);
        else if (t is String)
        {
            var parts:Array=new Array(3);
            parts=t.split(":",3);
            if (parts[1]==undefined)
                return Number(parts[0]);
            else if (parts[2]==undefined)
                return Number(parts[0])*60+Number(parts[1]);
            else
                return Number(parts[0])*3600+Number(parts[1])*60+Number(parts[2]);
        }
        else
        {
            trace("time type is wrong!");
            return 0;
        }
    }


    /////////////////////// milli Sec to String
    public static function timeFormat(milliSeconds:Number):String
    {
        var t:int = milliSeconds;
        if (t < 1 * 60 * 60 * 1000)
        {
            return addZero(t / 1000 / 60) + " : " + addZero(t / 1000 % 60);
        }
        else
        {
            return String(int(t / 1000 / 60 / 60)) + " : " + addZero(t / 1000 % 3600 / 60)+ " : " + addZero(t / 1000 % 60);
        }
    }

    /////////////// addZero
    public static function addZero(num:Number):String
    {
        if ((num < 10))
        {
            return "0" + int(num);
        }
        else
        {
            return String(int(num));
        }
    }

    public static function drawRect(object:Object, x:int, y:int, width:int, height:int, color:int = 0x333333):void
    {
        object.graphics.beginFill(color);
        object.graphics.drawRect(x, y, width, height);
        object.graphics.endFill();
    }

    public static function get time():Number
    {
        return Main.animationControl.time;
    }

    public static function removeObjectFromArray(list:Array, item:Object):Boolean
    {
        var length:int = list.length
        for (var i: int = 0; i < length; i++)
        {
            if (list[i] == item)
            {
                removeItemAtIndex(list, i)
                return true;
            }
        }

        return false;
    }

    public static function removeItemAtIndex(list:Array, index:int)
    {
        list.splice(index, 1);
    }

    public static function pushAtIndex(list:Array, index:int, item:Object):void
    {
        list.splice(index,0, item);
    }

    ///////////////////
    public static function StringToBitmap(text:String, color:uint=0xffffff, font:String="B Yekan", size:int=14 ,width:int= 260, height:int=35):Bitmap
    {
        var fmt:TextFormat = new TextFormat();
        fmt.color = color;
        fmt.font = font;
        fmt.size = size * 3;
        fmt.leftMargin = 0;
        fmt.align = TextFormatAlign.LEFT;

        var txt:TLFTextField = new TLFTextField ;
        txt.defaultTextFormat = fmt;
        txt.width = 1000;
        txt.height = 1000;
        txt.wordWrap = true;
        txt.multiline = true;
        txt.embedFonts = true;
        txt.condenseWhite = true;
        txt.autoSize = TextFieldAutoSize.RIGHT;
        txt.text = text;
        txt.cacheAsBitmap = true;

        var sprite:Sprite = new Sprite();
        sprite.addChild(txt);
        var snapshot:BitmapData = new BitmapData(txt.textWidth, txt.textHeight, true, 0x00000000);
        snapshot.draw(sprite, new Matrix());
        var bit:Bitmap = new Bitmap(snapshot);
        bit.smoothing = true;

        sprite.removeChild(txt);
        sprite.addChild(bit);

        bit.scaleX = bit.scaleY = 1/3;

        return bit;
    }

    public static function textBoxToBitmap(textBox):Bitmap
    {
        var x = textBox.x;
        var y = textBox.y;
        var border:Boolean = textBox.border;
        var scale:Number = textBox.scaleX;
        var parent;
        var index:int;
        if(textBox.parent)
        {
            parent = textBox.parent;
            index = parent.getChildIndex(textBox);
        }
        textBox.scaleX = textBox.scaleY = scale * 3;
        textBox.y = 0;
        textBox.x = - (textBox.width - textBox.textWidth * 3);
        textBox.border = false;

        var padding:int = 50;
        textBox.x += padding;

        var sprite:Sprite = new Sprite();
        sprite.addChild(textBox);

        var snapshot:BitmapData = new BitmapData(padding + textBox.textWidth * 3, padding + textBox.textHeight * 3, true, 0x00000000);
        snapshot.draw(sprite, new Matrix());

        var bit:Bitmap = new Bitmap(snapshot);
        bit.smoothing = true;

        textBox.scaleX = textBox.scaleY = scale;
        textBox.border = border;
        textBox.x = x;
        textBox.y = y;
        if(parent)
            parent.addChildAt(textBox, index);

        bit.scaleX = bit.scaleY = 1/3;
        return bit;
    }

    public static function isParentOf(stage:Stage, parent:Object, child:DisplayObject):DisplayObject
    {
        if(child && child.parent && child.parent != stage)
        {
            if(
                    (parent is Class && child.parent is (parent as Class))
                    || (parent is DisplayObject && child.parent == parent)
                                                                                )
            {
                return child.parent;
            }
            else
            {
                return isParentOf(stage, parent, child.parent);
            }
        }
        else
        {
            return null;
        }
    }

    public static function traceParents(obj:DisplayObject, tab:String = ''):void
    {
        trace(tab , obj, obj.name);
        if(obj.parent)
                traceParents(obj.parent, tab + '\t')
    }
}
}
