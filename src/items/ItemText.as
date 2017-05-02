/**
 * Created by Morteza on 4/30/2017.
 */
package items
{
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextFormat;
import flash.ui.ContextMenu;
import flash.utils.getTimer;
import flash.utils.setTimeout;

import src2.Consts;
import src2.Utils;

public class ItemText extends Item
{
    private var _text:String;
    private const quality:Number = 2;
    private var _sprite:Sprite;
    private var _formats:Array;
    private var _defaultFormat:TextFormat;
    private var _lines:int = 1;
    private var _mask:TextMask;
    public var typeEffect:Boolean = true;

    public function ItemText(removeAnimataion:Function, toEdit:Boolean = false, add:Boolean = true):void
    {
        super(removeAnimataion, null);

        _text = '';
        scaleX = scaleY = 1/quality;
        if(add)
            Main.dragManager.target.addChild(this);

        if(toEdit)
        {
            x = Main.dragManager.target.mouseX;
            y = Main.dragManager.target.mouseY;
        }

        _sprite = new Sprite();
        Utils.drawRect(_sprite, 0,0,100,40);
        _sprite.alpha = 0;
        addChild(_sprite);

        _sprite.doubleClickEnabled = true;
        _sprite.addEventListener(MouseEvent.DOUBLE_CLICK, double);

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
        changed;
        Main.textEditor.show(_text, func, false, _formats);
        Main.panel.show();
    }

    private function func(text:String):void
    {
        if(text == '')
        {
            this.remove();
            return;
        }

        _text = text;
        _formats = Main.textEditor.formats;
        _defaultFormat = Main.textEditor.fmt;

        update();
        updateTransform();
    }

    private function update():void
    {
        bitmap = Main.textEditor.getBitmaap(quality);
        bitmap.scaleX = 1;
        bitmap.scaleY = 1;
        bitmap.x = - bitmap.width/2;
        bitmap.y = - bitmap.height/2;

        _sprite.x =  bitmap.x - (10*quality);
        _sprite.y =  bitmap.y - (10*quality);
        _sprite.width = bitmap.width + (20*quality);
        _sprite.height = bitmap.height + (20*quality);
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
        obj.text = _text;
        obj.formats = _formats;
        obj.type = 'text';
        return obj;
    }

    public override function set all(obj:Object)
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

        _mask.height = _sprite.height;
        _mask.y = _sprite.y;

        _mask.width = _sprite.width * percent;
        _mask.x = _sprite.x + (_sprite.width - _mask.width);

        mask = _mask;
    }

    public override function set alpha(val:Number):void
    {
        if(typeEffect && Utils.time < animation.typingEndTime)
                val = 1;

        super.alpha = val;
    }


}
}
