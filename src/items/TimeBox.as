/**
 * Created by Morteza on 4/27/2017.
 */
package items
{
import fl.controls.NumericStepper;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.text.TextField;
import flash.text.TextFormat;

import src2.Utils;


public class TimeBox extends Sprite
{
    private var _text:TextField;
    private var _format:TextFormat;
    private var change:Event;
    private var _time:Number;
    private var _oldText:String;

    public function TimeBox()
    {
        change = new Event('edited');

        _text = new TextField();
        _text.width = 74;
        _text.height = 20;
        _text.type = 'input';
        _text.backgroundColor = 0xffffff;
        _text.background = true;
        addChild(_text);

        _format = new TextFormat();
        _format.font = 'Tahoma';
        _format.align = 'left';


        _text.addEventListener(FocusEvent.FOCUS_IN, onFocus);
        _text.addEventListener(FocusEvent.FOCUS_OUT, out);

        _time = 0;
        time = 0;
    }

    private function onFocus(event:FocusEvent):void
    {
        _oldText = _text.text;
        if(_text.text == 'no time')
                _text.setSelection(0,_text.length);

        stage.addEventListener(KeyboardEvent.KEY_DOWN, onDown)
    }

    private function onDown(e:KeyboardEvent):void
    {
        if(e.keyCode == 13)
        {
            out();
            stage.focus = null;
        }
    }

    private function out(event:FocusEvent=null):void
    {
        stage.removeEventListener(KeyboardEvent.KEY_DOWN, onDown);
        if(_oldText == _text.text)
                return;
        _oldText = _text.text;
        var seconds:Number = Utils.timeToSec(_text.text);

        if(seconds > Main.timeLine.totalSec)
            seconds = Main.timeLine.totalSec-1;
        else if(seconds<0)
            seconds = 0;

        time = seconds;

    }

    public function set time(seconds:Number):void
    {
        var value:String = Utils.timeFormat(seconds*1000);

        if(value.length == 7)
                value = '00 : ' + value;

        if(seconds == -1)
            _text.text = 'no time';
        else
            _text.text = value;

        _text.setTextFormat(_format);

        if(_time == seconds)
            return;

        _time = seconds;
        dispatchEvent(change);
    }

    public function get time():Number
    {
        return _time;
    }
}
}
