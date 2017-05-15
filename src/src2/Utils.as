/**
 * Created by Morteza on 4/4/2017.
 */
package src2
{
import com.greensock.TweenMax;
import com.greensock.plugins.ColorTransformPlugin;
import com.greensock.plugins.TintPlugin;
import com.greensock.plugins.TweenPlugin;

import fl.controls.NumericStepper;
import fl.text.TLFTextField;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.TextField;
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

    public static function removeItemAtIndex(list:Array, index:int):void
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

    public static function textBoxToBitmap(textBox, quality:Number = 3):Bitmap
    {
        Main.STAGE.focus = null;

        if(textBox.textWidth < 1 || textBox.textHeight < 1)
        {
            textBox.text = 'متن پیش فرض';
            trace('ERRORR متنی وجود ندارد')
        }

        var x:Number = textBox.x;
        var y:Number = textBox.y;
        var border:Boolean = textBox.border;
        var scale:Number = textBox.scaleX;
        var parent:Object;
        var index:int;
        if(textBox.parent)
        {
            parent = textBox.parent;
            index = parent.getChildIndex(textBox);
        }
        textBox.scaleX = textBox.scaleY = scale * quality;
        textBox.y = 0;
        textBox.x = - (textBox.width - textBox.textWidth * quality);
        textBox.border = false;

        var padding:int = 50;
        textBox.x += padding;

        var sprite:Sprite = new Sprite();
        sprite.addChild(textBox);

        var snapshot:BitmapData = new BitmapData(padding + textBox.textWidth * quality, padding + textBox.textHeight * quality, true, 0x00000000);
        snapshot.draw(sprite, new Matrix());

        //var bit:Bitmap = new Bitmap(snapshot);
        var bit:Bitmap = new Bitmap(trimAlpha(snapshot));
        bit.smoothing = true;

        textBox.scaleX = textBox.scaleY = scale;
        textBox.border = border;
        textBox.x = x;
        textBox.y = y;
        if(parent)
            parent.addChildAt(textBox, index);

        bit.scaleX = bit.scaleY = 1/quality;
        return bit;
    }

    public static function trimAlpha(source:BitmapData):BitmapData
    {
        var notAlphaBounds:Rectangle = source.getColorBoundsRect(0xFF000000, 0x00000000, false);
        var trimed:BitmapData = new BitmapData(notAlphaBounds.width, notAlphaBounds.height, true, 0x00000000);
        trimed.copyPixels(source, notAlphaBounds, new Point());
        return trimed;
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

    public static function numericStepper(parent:DisplayObjectContainer, min:int, max:int, step:Number, x:int, y:int, width:int, numberChange:Function):NumericStepper
    {
        var number:NumericStepper = new NumericStepper();
        number.x = x;
        number.y = y;
        number.width = width;
        number.minimum = min;
        number.maximum = max;
        number.stepSize = step;
        number.addEventListener(Event.CHANGE, numberChange);
        parent.addChild(number);
        return number;
    }

    public static function getObjectIndex(list:Array, item:Object):int
    {
        var length:int = list.length;
        for (var i: int = 0; i < length; i++)
        {
            if (list[i] == item)
            {
                return i;
            }
        }

        return -1;
    }

    public static function tint(item:Object, alpha:Number =.5, color:uint = 0xff0000, duration:Number = 0):void
    {
        TweenPlugin.activate([TintPlugin, ColorTransformPlugin]);
        TweenMax.to(item, duration, {colorTransform:{tint:color, tintAmount:alpha}});
    }

    public static function drawCirc(object:Object, x:int, y:int, radius:int, color:int = 0x333333):void
    {
        object.graphics.beginFill(color);
        object.graphics.drawCircle(x, y, radius);
        object.graphics.endFill();
    }

    public static function listVisible():void
    {
        if (Main.panel && Main.timePanel)
        {
        }
        else
        {
            return;
        }

        if(Main.panel.visible ||Main.timePanel.visible)
        {
            if(Main.snapList)
                Main.snapList.visible = false;

            if(Main.topics)
                Main.topics.visible = false;
        }
        else
        {
            if(Main.snapList)
                Main.snapList.visible = true;

            if(Main.topics)
                Main.topics.visible = true;
        }
    }

    public static function targetClass(target:DisplayObject, classType:Class):DisplayObject
    {
        if(target is classType)
                return target;

        return Utils.isParentOf(Main.STAGE, classType, target)
    }

    public static function globalToLocalScaleX(item:DisplayObject):Number
    {
        var scale:Number = 1;
        while(item.parent)
        {
            item = item.parent;
            scale *= item.scaleX;
        }

        return scale;
    }

    public static function globalToLocalScaleY(item:DisplayObject):Number
    {
        var scale:Number = 1;
        while(item.parent)
        {
            item = item.parent;
            scale *= item.scaleY;
        }

        return scale;
    }

    public static function distanceTwoPoints(x1:Number, y1:Number,  x2:Number, y2:Number):Number
    {
        var dx:Number = x1-x2;
        var dy:Number = y1-y2;
        return Math.sqrt(dx * dx + dy * dy);
    }

    public static function radianToDegree(radians:Number):Number
    {
        return radians * 180 / Math.PI;
    }

    public static function pathIsWrong(path:String):Boolean
    {
        for(var i:int = 0; i<path.length; i++)
        {
            if(path.charCodeAt(i) > 1000)
            {
                return true;
            }
        }

        return false;
    }

    public static function isVisible(object:Object):Boolean
    {
        if(object && object is DisplayObject && object.stage)
        {
            var stage:Stage = object.stage;
            while(object != stage)
            {
                if(!object.visible)
                    return false;

                object = object.parent;
            }

            return true;
        }

        return false;
    }
}
}