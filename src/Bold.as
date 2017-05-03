/**
 * Created by Morteza on 5/3/2017.
 */
package
{
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.MouseEvent;

import src2.Utils;
import src2.assets;

public class Bold extends Sprite
{
    private var _func:Function;
    private var bt:Sprite;
    public function Bold(func:Function):void
    {
        _func = func;
        Utils.drawRect(this, 10, 10, 1, 1, 0);

        bt = new Sprite();
        var bit:Bitmap = new assets.Bold();
        bit.x = bit.y = 2;
        bit.width = height = 20;
        bit.smoothing = true;
        bt.addChild(bit);
        addChild(bt);

        bt = new Sprite();
        bit = new assets.Bold2();
        bit.x = bit.y = 2;
        bit.width = height = 20;
        bit.smoothing = true;
        bt.addChild(bit);
        addChild(bt);

    }

    private function onClick(event:MouseEvent):void
    {
        bold = !bold;
        _func(bold);
    }

    public function get bold():Boolean
    {
        return bt.visible;
    }

    public function set bold(bold:Boolean):void
    {
        bt.visible = bold;

        addEventListener(MouseEvent.CLICK, onClick);
        buttonMode = true;
        alpha = 1;
    }

    public function disable():void
    {
        removeEventListener(MouseEvent.CLICK, onClick);
        buttonMode = false;
        bt.visible = false;
        alpha = .3;
    }
}
}
