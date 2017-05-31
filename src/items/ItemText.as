/**
 * Created by Morteza on 4/30/2017.
 */
package items
{
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextFormat;
import flash.utils.getTimer;
import flash.utils.setTimeout;

import src2.AnimateObject;

import src2.Utils;

public class ItemText extends Item
{
    private var _text:String;
    public static const QUALITY:Number = 2;
    private var _sprite:Sprite;
    private var _formats:Array;
    private var _defaultFormat:TextFormat;
    private var _lines:int = 1;
    private var _mask:TextMask;
    public var typeEffect:Boolean = true;
    private var _toEdit:Boolean;
    private var _firstTime:Number;
    private var _savedPng:String;

    public function ItemText(removeAnimataion:Function, toEdit:Boolean = false, add:Boolean = true, keyBoard:Boolean = false):void
    {
        super(removeAnimataion, null);

        _text = '';
        scaleX = scaleY = 1/QUALITY;
        if(add)
            Main.dragManager.target.addChild(this);

        if(toEdit)
        {
            x = Main.dragManager.target.mouseX;
            y = Main.dragManager.target.mouseY;
            if(keyBoard);
            {
                x = Main.target.x + Main.target.w/2;
                y = Main.target.y + Main.target.h/2;
            }
            _toEdit = toEdit;
            _firstTime = Utils.time;
        }


        _sprite = new Sprite();
        Utils.drawRect(_sprite, 0,0,100,40);
        _sprite.alpha = 0;
        addChild(_sprite);

        this.doubleClickEnabled = true;
        _sprite.doubleClickEnabled = true;
        this.addEventListener(MouseEvent.DOUBLE_CLICK, double);

        if(toEdit)
            edit();

    }


    public function double(e:MouseEvent = null):void
    {
        trace('double')
       edit();
    }

    public function edit():void
    {
        Main.textEditor.show(_text, func, false, _formats);
        Main.panel.show(this);
    }

    private function func(text:String):void
    {
        if(text == '' || text == ' ' || text == '  ')
        {
            this.remove(false);
            return;
        }

        if(_toEdit)
        {
            _toEdit = false;
            Main.addObject(this, _firstTime);
            setProps();
            addToHistory(History.ADD);

            sett();
        }
        else
        {
            var value:Object = {from:{}, to:{}};

            value.from.text = _text;
            value.from.formats = _formats;

            sett();

            value.to.text = _text;
            value.to.formats = _formats;

            addToHistory(History.TEXT, value);
        }

        function sett():void
        {
            _text = text;
            _formats = Main.textEditor.formats;
            _defaultFormat = Main.textEditor.fmt;
        }



        update();
        updateTransform();
    }

    private function update():void
    {
        bitmap = Main.textEditor.getBitmaap(QUALITY);
        bitmap.scaleX = 1.15;
        bitmap.scaleY = 1.15;
        bitmap.x = - bitmap.width/2;
        bitmap.y = - bitmap.height/2;

        _sprite.x =  bitmap.x - (10*QUALITY);
        _sprite.y =  bitmap.y - (10*QUALITY);
        _sprite.width = bitmap.width + (20*QUALITY);
        _sprite.height = bitmap.height + (20*QUALITY);
        addChild(_sprite);

        _lines =  Main.textEditor.lines;

        changed;
    }

    private function updateBitmap():void
    {
        Main.textEditor.show(_text, afterUpdate , false, _formats, false);

        function afterUpdate():void
        {
            update();
            trace('updated', getTimer());
            setTimeout(dispatchComplete, 10);
        }
    }

    //////////////// all //////////////////////////
    public override function get all():Object
    {
        var obj:Object = super.all;

        obj.type = 'text';

        if(Main.toExport)
        {
            obj.lines = _lines;
            obj.fileName = _savedPng;
            obj.scaleX *= (bitmap.scaleX / Item.BITMAP_SCALE);
            obj.scaleY *= (bitmap.scaleY / Item.BITMAP_SCALE);
        }
        else
        {
            obj.text = _text;
            obj.formats = _formats;
        }

        return obj;
    }

    public override function set all(obj:Object):void
    {
        _text = obj.text;
        _formats = obj.formats;

        super.all = obj;
    }

    ///////////////// load //////////////////////////
    public override function load():void
    {
        setTimeout(updateBitmap,10);
    }

    ///////////////// save //////////////////////////
    public override function save(dir:String):void
    {
        if(Main.toExport)
        {
            _savedPng ='image_' + String(_number)+'.pic';
            Utils.saveBitmap(bitmap, dir+'/'+ _savedPng,dispatchComplete);
        }
        else
            dispatchComplete();
    }
    ///////////////// move //////////////////////////
    public override function move():void
    {
        dispatchComplete();
    }

    ////////////////

    public function showTypeEffect(percent:Number):void
    {
        if(!typeEffect || percent == 1 || Main.timeLine.paused)
        {
            mask = null;
            return;
        }

        if(!_mask)
        {
            _mask = new TextMask();
            addChild(_mask);
        }

        _mask.update(bitmap.x, bitmap.y, bitmap.width, bitmap.height, _lines, percent);

        mask = _mask;
    }

    public override function set alpha(val:Number):void
    {
        if(typeEffect && Utils.time < animation.typingEndTime)
                val = 1;

        super.alpha = val;
    }


    public function setTextAndFormat(text:String, formats:Array):void
    {
        _text = text;
        _formats = formats;
        load();
    }



    //////////////
    public override function get insideWidth():Number
    {
        return _sprite.width * scaleX;
    }

    public override function get insideWHeight():Number
    {
        return _sprite.height * scaleY;
    }


}
}
