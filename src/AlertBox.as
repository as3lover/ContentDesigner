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
    private var _save:DialogWizard;
    private var _qustion:DialogWizard;
    private var _wrongFileName:DialogWizard;

    public function AlertBox():void
    {
        this.addEventListener(Event.ADDED_TO_STAGE, init)
    }

    private function init(e:Event):void
    {
        visible = false;

        x = Main.target.x + Main.target.w/2;
        y = Main.target.y + Main.target.h/2;

        _save = new DialogWizard();
        addChild(_save);

        _save.show('آیا تغییرات را ذخیره می کنید؟',
                [{text:'لغو', handler:cancelFunc}, {text:'خیر', handler:dontSaveFunc}, {text:'بلی', handler:saveFunc}
                ]);


        _qustion = new DialogWizard();
        addChild(_qustion);

        _qustion.show('سوال را حذف می کنید؟',
                [{text:'خیر', handler:cancelFunc}, {text:'بلی', handler:Main.quiz.confirmDelete}
                ]);


        _wrongFileName = new DialogWizard();
        addChild(_wrongFileName);
        var str:String =
                "\t\t\t\t\t\t\t\t\t\t"
                + 'نام یا مسیر فایل نامعتبر است'

        _wrongFileName.show(str,
                [{text:'قبول', handler:cancelFunc}]
        );

    }

    private function saveFunc():void
    {
        hide();
        FileManager.saveFile();

    }

    private function dontSaveFunc():void
    {
        hide();
        FileManager.retry();
    }

    private function cancelFunc():void
    {
        hide();
    }

    public function hide():void
    {
        Main.enable();
        visible = false;
    }


    public function alert(type:String):void
    {
        for(var i:int = 0; i<numChildren; i++)
            getChildAt(i).visible = false;

        if(type == 'save')
            _save.visible = true;
        else if(type == 'question')
            _qustion.visible = true;
        else if(type == 'wrongFile')
            _wrongFileName.visible = true;
        else
            return;

        Main.disable();
        parent.setChildIndex(this, parent.numChildren-1);
        visible = true;
    }
}
}