/**
 * Created by Morteza on 4/30/2017.
 */
package quizz
{
import fl.text.TLFTextField;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.text.TextFormat;
import flash.utils.setTimeout;

public class quizText extends Sprite
{
    private var f:TextFormat;
    private var txt:TLFTextField;
    public function quizText(width:int)
    {
        txt = new TLFTextField();
        txt.width = width;
        txt.height = 40;
        txt.multiline = true;
        txt.embedFonts = true;
        addChild(txt)

        f = new TextFormat();
        f.font = 'B Yekan';
        f.size = 16;

        txt.defaultTextFormat = f;
        txt.addEventListener(FocusEvent.FOCUS_IN, focusIn);
        txt.addEventListener(FocusEvent.FOCUS_OUT, focusOut);
    }

    private function focusOut(e:FocusEvent):void
    {
        this.addEventListener(Event.ENTER_FRAME, checkHeight);
    }

    private function focusIn(e:FocusEvent):void
    {
        this.removeEventListener(Event.ENTER_FRAME, checkHeight);
    }

    private function checkHeight(event:Event = null):void
    {
        if(txt.height < txt.textHeight + 10 || txt.height > txt.textHeight+20)
        {
            txt.height = txt.textHeight;
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

        setTimeout(checkHeight, 100);
    }
}
}
