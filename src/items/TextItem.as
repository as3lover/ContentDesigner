/**
 * Created by Morteza on 4/21/2017.
 */
package items
{


import fl.text.TLFTextField;

import flash.geom.ColorTransform;
import flash.text.TextField;

import flashx.textLayout.edit.EditManager;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.ContextMenuEvent;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.text.engine.TextLine;
import flash.ui.ContextMenuItem;
import flash.utils.setTimeout;

import flashx.textLayout.formats.Direction;
import flashx.undo.UndoManager;

import src2.Fonts;

import src2.Utils;

public class TextItem extends Item
{
    private var _box:TLFTextField;
    private var _fmt:TextFormat;
    private var _sprite:Sprite;
    //private const W:int = 114;
    //private const H:int = 47;
    private const minWidth:int = 50;
    private const minHeight:int = 50;
    private const margin:int = 25;
    private var _w:Number;
    private var _h:Number;
    public static const DEFAULT_TEXT:String = 'متن پیش فرض' ;
    private var _formats:Array;
    private const formatProps:Array = ['font', 'color', 'size', 'letterSpacing', 'leading'];
    private var _typeEffect:ContextMenuItem;
    private var _stopType:Number = -1;
    private var _startType:Number = -1;
    private var _mask:TextMask;

    public function TextItem(removeAnimation:Function, edit:Boolean = false)
    {
        super(removeAnimation, null);
        /*
        //Menu
        var menu:ContextMenu = new ItemMenu().menu;

        _typeEffect = new ContextMenuItem("Type Effect");
        _typeEffect.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, typeEfect);
        menu.customItems.push(_typeEffect);

        var startType = new ContextMenuItem("Start Type");
        startType.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, StartType);
        menu.customItems.push(startType);

        var stopType = new ContextMenuItem("Stop Type");
        stopType.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, StopType);
        menu.customItems.push(stopType);

        this.contextMenu = menu;

        function typeEfect(event:ContextMenuEvent):void
        {
            if(_typeEffect.checked)
            {
                removeTypeEffect();
            }
            else
            {
                addTypeEffect();
            }
        }
        */
        _fmt = new TextFormat();
        _box = new TLFTextField ;
        //_box.textFlow.interactionManager = new EditManager(new UndoManager());

        _fmt.letterSpacing = 0;
        _fmt.leading = 1;  //فاصله بین خطوط
        _fmt.align = TextFormatAlign.RIGHT; //راست چین
        _fmt.size = 16;
        _fmt.font = Fonts.YEKAN;
        _fmt.leftMargin = margin;
        _fmt.rightMargin = margin;

        _box.multiline = true;
        _box.embedFonts = true;
        _box.cacheAsBitmap = true;
        _box.type = TextFieldType.INPUT;
        addChild(_box);

        setFormat();

        if(edit)
        {
            text = DEFAULT_TEXT;
            x = Main.dragManager.target.mouseX;
            y = Main.dragManager.target.mouseY;
            Main.dragManager.target.addChild(this);
        }

        _sprite = new Sprite();
        Utils.drawRect(_sprite,0,0,_box.width,_box.height);
        _sprite.alpha = .0;
        addChild(_sprite);

        editable = false;

        init();

        changeText();

        //_sprite.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDwon);
        setTimeout(focus,100);

        this.addEventListener(MouseEvent.MOUSE_OVER, onOver);
        this.addEventListener(MouseEvent.MOUSE_OUT, onOut);
    }

    private function onOut(event:MouseEvent=null):void
    {
        Utils.tint(this,0);
        _sprite.alpha = 0;
    }

    private function onOver(event:MouseEvent):void
    {
        if(!editable)
        {
            Utils.tint(this,1);
            _sprite.alpha = .05;
        }
    }

    private function focus():void
    {
        editable = true;
    }
    /*
    private function onMouseDwon(event:MouseEvent):void
    {
        trace(y, _y, _box.y);
        Main.STAGE.addEventListener(MouseEvent.MOUSE_UP, onMouseUp)
        startDrag();
    }

    private function onMouseUp(event:MouseEvent):void
    {
        Main.STAGE.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
        stopDrag();
        changed;
    }
*/
    private function SETFOCUS(event:Event = null):void
    {
        if(stage)
        {
            editable = true;
            editable = false;
            removeEventListener(Event.ADDED_TO_STAGE, SETFOCUS)
        }
        else
        {
            addEventListener(Event.ADDED_TO_STAGE, SETFOCUS)
        }
    }




    private function StopType(event:ContextMenuEvent):void
    {
        _stopType = Utils.time;
    }

    private function StartType(event:ContextMenuEvent):void
    {
        _startType = Utils.time;
    }

    private function addTypeEffect():void
    {
        _typeEffect.checked = true;
        trace('addTypeEffect');
    }

    private function removeTypeEffect():void
    {
        _typeEffect.checked = false;
        trace('removeTypeEffect');
    }


    private function init():void
    {
        if(!stage)
        {
            setTimeout(init, 10);
            return;
        }

        _sprite.doubleClickEnabled = true;
        _sprite.addEventListener(MouseEvent.DOUBLE_CLICK, double);
    }


    private function double(e:MouseEvent):void
    {
        editable = true;
    }

    private function changeText(event:Event = null):void
    {
        _w = _box.textWidth + margin;
        _h = _box.textHeight + margin;

        if(_w < minWidth) _w = minWidth;
        if(_h < minHeight) _h = minHeight;

        if(Math.abs(_box.width - _w) > 5)
        {
            correctFormat()
            _box.width = _w;
            _sprite.width = _w;
            _box.x = -_box.width;
            _sprite.x = _box.x;
            correctFormat()
        }

        if(Math.abs(_box.height - _h) > 5)
        {
            correctFormat()
            _box.height = _h;
            _sprite.height = _h;
            //_box.y = -_box.height/2;
            //_sprite.y = _box.y;
            correctFormat()
        }

    }

    private function get formats():Array
    {
        var formats:Array = new Array();
        var f1:TextFormat = new TextFormat();
        var f2:TextFormat
        var length:int = _box.length;

        for(var i:int=0; i<length; i++)
        {
            f2 = _box.getTextFormat(i, i+1);

            if(formatCompare(f1,f2))
            {
                formats[formats.length-1].index2 = i+1;
            }
            else
            {
                var obj:Object = new Object();
                obj.size = f2.size;
                obj.font = f2.font;
                obj.color = f2.color;
                obj.leading = f2.leading;
                obj.letterSpacing = f2.letterSpacing;
                formats.push({format:obj, index1:i, index2:i})
            }
            f1 = f2
        }

        return formats;
    }

    private function set formats(list:Array):void
    {
        var len:int = list.length;
        var format:TextFormat = new TextFormat();

        for(var i:int=0; i<len; i++)
        {
            for(var p:String in list[i].format)
            {
                format[p] =  list[i].format[p];
            }

            _box.setTextFormat(format, list[i].index1, list[i].index2);
        }
    }

    private function formatCompare(f1:TextFormat, f2:TextFormat):Boolean
    {
        for(var i:int=0; i<5; i++)
        {
            if(f1[formatProps[i]] != f2[formatProps[i]])
                    return false
        }

        return true;
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
        correctFormat();
    }

    private function correctFormat():void
    {
        _box.direction = Direction.RTL;
        _box.condenseWhite = false;
        _box.wordWrap = false;
        _box.embedFonts = true;
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

    private function set selectable(value:Boolean):void
    {
        _box.selectable = value;
    }

    public function set editable(value:Boolean):void
    {
        if(value == editable)
                return;



        if(value)
        {
            updateTransform();
            _box.border = true;
            //_box.type = TextFieldType.INPUT;
            _sprite.visible = false;
            //addEventListener(Event.ENTER_FRAME, ef);
            _box.addEventListener(Event.CHANGE, changeTextt);
            Main.transformer.select(null);
            Main.STAGE.addEventListener(MouseEvent.MOUSE_DOWN, onStage);
            //Main.panel.show(this);
            Main.timePanel.show(this);
            setFocus();
        }
        else
        {
            _box.border = false;
            //removeEventListener(Event.ENTER_FRAME, ef);
            _box.removeEventListener(Event.CHANGE, changeTextt);
            //_box.type = TextFieldType.DYNAMIC;
            selectable = false;
            _sprite.visible = true;
            Main.panel.hide();
            Main.timePanel.hide();
            setFocusOut();
        }

        onOut();

    }

    private function setFocusOut():void
    {
        stage.focus = null
    }

    public function setFocus():void
    {
        _box.textFlow.interactionManager = new EditManager();
        _box.textFlow.interactionManager.selectRange(_box.text.length, _box.text.length);


        if(_box.text == DEFAULT_TEXT)
            _box.textFlow.interactionManager.selectRange(0, _box.text.length);

        _box.textFlow.interactionManager.setFocus();
    }

    private function changeTextt(event:Event):void
    {
        Main.changed = true;
    }

    private function ef(event:Event):void
    {
        changeText();
    }



    public function get editable():Boolean
    {
        return !_sprite.visible;
    }

    private function onStage(e:MouseEvent):void
    {
        //Utils.traceParents(e.target as DisplayObject);
        if(
                e.target == this
                ||
                Utils.isParentOf(stage, this, e.target as DisplayObject)
                ||
                Utils.isParentOf(stage, Panel, e.target as DisplayObject)
                ||
                Main.panel.opened
                ||
                e.target is TextLine
                                                                            )
        {
            //Main.transformer.select(null);
            return;
        }

        stage.removeEventListener(MouseEvent.MOUSE_DOWN, onStage);
        editable = false;
    }

    public function set backgroundColor(value:int):void
    {
        _box.backgroundColor = value;
    }

    public function set align(direction:String):void
    {
        direction = direction.toLowerCase();

        switch (direction)
        {
            case 'left':
                _fmt.align = TextFormatAlign.LEFT;
                break;

            case  'right':
                _fmt.align = TextFormatAlign.RIGHT;
                break;

            case 'justify':
                _fmt.align = TextFormatAlign.JUSTIFY;
                break;

            case  'center':
                _fmt.align = TextFormatAlign.CENTER;
                break;

            default:
                trace('Error: Direction ' + direction + '!');
                return;
                break;
        }

        setFormat();
    }


    public function setColor(color:uint):void
    {
        setTextFormat('color', color);
    }

    public function setLeading(value:Number):void
    {
        setTextFormat('leading', value);
    }

    public function setSpace(value:Number):void
    {
        setTextFormat('letterSpacing', value);
    }

    public function setSize(value:Number):void
    {
        setTextFormat('size', value);
    }

    public function setFont(font:String):void
    {
        setTextFormat('font', font);
    }

    private function setTextFormat(prop:String, value:Object):void
    {
        Main.changed = true;

        var i1:int = _box.selectionBeginIndex;
        var i2:int = _box.selectionEndIndex;

        if(i1 == i2)
        {
            _fmt[prop] = value;
            setFormat();
            changeText();
        }
        else
        {
            var format:TextFormat =_box.getTextFormat(i1, i2);
            format[prop] = value;
            format.leftMargin = margin;
            format.rightMargin = margin;
            correctFormat();
            _box.setTextFormat(format, i1, i2);
            correctFormat();
            changeText();
            padding();
            /*
            var name:String = String(i1) +'_' + String(i2);
            for(var i:int=0; i<_formats.length; i++)
            {
                if(_formats[i][0] == name)
                {
                    Utils.removeItemAtIndex(_formats, i);
                    break;
                }
            }
            _formats.push({name, format, i1, i2})
            */
        }

        updateTransform();
    }

    public function getSize():Number
    {
        return getProp('size') as Number;
    }

    public function getLeading():Number
    {
        return getProp('leading') as Number;
    }

    public function getSpace():Number
    {
        return getProp('letterSpacing') as Number;
    }

    public function getColor():uint
    {
        return getProp('color') as uint;
    }

    public function getProp(prop:String):Object
    {
        var format:TextFormat;

        var i1:int = _box.selectionBeginIndex;
        var i2:int = _box.selectionEndIndex;

        if(i1 == i2)
        {
            format = _fmt;
        }
        else
        {
            format = _box.getTextFormat(i1, i2)
        }

        return format[prop];
    }

    ///////////////// all //////////////////////////
    public override function get all():Object
    {
        var obj:Object = super.all;
        obj.text = text;
        obj.formats = formats;
        obj.type = 'text';
        obj.textWidth = _box.textWidth;
        obj.textHeight = _box.textHeight;
        //obj.textX = _box.x;
        //obj.textY = _box.y;
        obj.defaultTextFormat = _fmt;
        return obj;
    }

    public override function set all(obj:Object)
    {
        _box.text = obj.text;
        _box.width = obj.textWidth;
        _box.height = obj.textHeight;
        //_box.x = obj.textX;
        //_box.y = obj.textY;
        //_sprite.x = _box.x;
        //_sprite.y = _box.y;
        _sprite.width = _box.width;
        _sprite.height = _box.height;
        _formats = obj.formats;

        _fmt = new TextFormat();
        for(var p:String in obj.defaultTextFormat)
        {
            _fmt[p] =  obj.defaultTextFormat[p];
        }
        setFormat();

        super.all = obj;

        setTimeout(SETFOCUS,1000);
    }
    ///////////////// load //////////////////////////
    public override function load():void
    {
        formats = _formats;
        dispatchComplete();
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
    public override function set visible(visible:Boolean):void
    {
        if(visible == super.visible && visible == false)
                return;

        if(visible)
            addEventListener(Event.ENTER_FRAME, ef);
        else
            removeEventListener(Event.ENTER_FRAME, ef);

        super.visible = visible;
    }



}
}
