package
{

//Imports


import flash.display.Bitmap;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filesystem.File;


import src2.Utils;
import src2.Button;
import src2.assets;

//Class
public class AlertBox extends Sprite
{
    //Constructor
    public function AlertBox():void
    {
        this.addEventListener(Event.ADDED_TO_STAGE, init)
    }

    private function init(e:Event):void
    {
        visible = false;

        x = 800/2;
        y = 450/2;

        var d:Dialog = new Dialog();
        d.addEventListener('save', saveFunc);
        d.addEventListener('cancel', cancelFunc);
        d.addEventListener('close', dontSaveFunc);

        addChild(d);

    }

    private function saveFunc(event):void
    {
        trace('save');
        hide();
        FileManager.saveFile();

    }

    private function dontSaveFunc(event):void
    {
        trace('dontSave');
        hide();
        FileManager.retry();
    }

    private function cancelFunc(event):void
    {
        trace('cancle');
        hide();
    }

    private function hide():void
    {
        Main.enable();
        visible = false;
    }


    public function alert():void
    {
        Main.disable();
        parent.setChildIndex(this, parent.numChildren-1);
        visible = true;
    }
}
}