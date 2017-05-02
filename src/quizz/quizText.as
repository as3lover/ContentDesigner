/**
 * Created by Morteza on 4/30/2017.
 */
package quizz
{
import fl.text.TLFTextField;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextFormat;
import flash.utils.setTimeout;

import src2.Utils;

public class quizText extends Sprite
{
    private var f:TextFormat;
    private var txt:TLFTextField;
    private var _box:Sprite;
    private var _select:Boolean;

    public function quizText(width:int, answer:Boolean = true)
    {
        txt = new TLFTextField();
        txt.width = width - 10;
        txt.x = 10;
        txt.height = 1;
        txt.multiline = true;
        txt.embedFonts = true;
        txt.wordWrap = true;
        txt.direction = 'rtl';
        addChild(txt)

        f = new TextFormat();
        f.font = 'B Yekan';
        f.size = 14;
        f.align = 'right';

        txt.defaultTextFormat = f;
        txt.addEventListener(Event.CHANGE, changeText);

        if(answer)
        {
            _box = new Sprite();
            //Utils.drawRect(_box, width + 10, 5, 20, 20, 0xffffff);
            Utils.drawCirc(_box, width + 20, 15, 10, 0xffffff);
            _box.alpha = .5;
             addChild(_box);
            _box.addEventListener(MouseEvent.CLICK, onBox);
        }
    }

    private function onBox(e:MouseEvent):void
    {
        trace('on box')
        if(parent)
            QuizPage(parent).select(parent.getChildIndex(this));
    }

    private function changeText(event:Event):void
    {
        checkHeight();
        setTimeout(checkHeight,100);
    }

    private function checkHeight(event:Event = null):void
    {
        if(txt.height != txt.textHeight + 10)
        {
            txt.height = txt.textHeight + 10;
            if(parent && parent is QuizPage)
                QuizPage(parent).sort();
        }
    }

    public function get text():String
    {
        return txt.text;
    }

    public function set text(text:String):void
    {
        if(txt.text == text)
                return;

        txt.text = text;
        txt.setTextFormat(f);
        txt.direction = 'rtl';

    }

    public function get select():Boolean
    {
        return _select;
    }

    public function set select(value:Boolean):void
    {
        _select = value;

        if(!_box)
            return;

        if(value)
            _box.alpha = 1;
        else
            _box.alpha = .5
    }
}
}
