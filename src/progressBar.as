/**
 * Created by Morteza on 4/23/2017.
 */
package
{
import fl.text.TLFTextField;

import flash.display.DisplayObject;

import flash.display.Shape;
import flash.display.Sprite;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFormat;

import src2.Utils;

public class progressBar extends Sprite
{
    private var _bar:Shape;
    private var _text:TextField;
    private var _format:TextFormat;

    public function progressBar()
    {
        Utils.drawRect(this, -10, -10, 720, 120);
        x = 100/2;
        y = 350/2;

        Utils.drawRect(this, 0, 80, 700, 20, 0x000000);

        _bar = new Shape();
        Utils.drawRect(_bar, 0, 80, 700, 20, 0xffffff);
        addChild(_bar);

        _text = new TextField();
        _text.width = 700;
        _text.height = 80;
        addChild(_text)

        _format = new TextFormat();
        _format.font = 'Arial';
        _format.size = 20;

        visible = false;
    }


    public function show():void
    {
        disableApp();
        _bar.scaleX = 0;
        text = '';
        visible = true;
    }

    public function hide():void
    {
        enableApp();
        visible = false;
    }

    public function set percent(n:Number):void
    {
        if(!visible)
            show();

        _bar.scaleX = n;

        if(n == 1)
                hide();
    }

    public function set text(text:String):void
    {
        _text.text = text;
        _text.setTextFormat(_format);
    }


    public function disableApp():void
    {
        stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouse, true);
        stage.addEventListener(MouseEvent.CLICK, onMouse, true);
        stage.addEventListener(MouseEvent.MOUSE_UP, onMouse, true);
        stage.addEventListener(MouseEvent.RIGHT_CLICK, onMouse, true);

        stage.addEventListener(KeyboardEvent.KEY_DOWN, onKey, true);
        stage.addEventListener(KeyboardEvent.KEY_UP, onKey, true);
    }

    public function enableApp():void
    {
        stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouse, true);
        stage.removeEventListener(MouseEvent.CLICK, onMouse, true);
        stage.removeEventListener(MouseEvent.MOUSE_UP, onMouse, true);
        stage.removeEventListener(MouseEvent.RIGHT_CLICK, onMouse, true);

        stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKey, true);
        stage.removeEventListener(KeyboardEvent.KEY_UP, onKey, true);
    }

    private function onMouse(e:MouseEvent):void
    {
        if(Utils.isParentOf(stage, AlertBox, e.target as DisplayObject))
            return;

        e.stopImmediatePropagation();
    }

    private function onKey(e:KeyboardEvent):void
    {
        e.stopImmediatePropagation();
    }


}
}
