package {

import flash.display.Sprite;
import flash.filesystem.File;


[SWF(width="800", height="450", frameRate=60, backgroundColor='0xabcde')]

public class Main extends Sprite
{
    public static var _timeLine:TimeLine;
    public static var _dragManager:DragManager;
    public static var _transformer:TransformManager;
    public static var _animationControl:AnimationControl;

    public function Main()
    {

        //new FileReferenceExample2();
        //return;
        _animationControl = new AnimationControl();

        _dragManager = new DragManager(20,40,600, 337, onAddObject, stage, removeAnimation);
        addChild(_dragManager);

        _transformer = new TransformManager(stage, _dragManager.target);

        _timeLine = new TimeLine(_transformer, updateAnimation);
        addChild(_timeLine);

        new TitleBar(stage, this);


        LoadFile.load();

        var _buttons:Buttons = new Buttons(stage);
        addChild(_buttons);
        _buttons.x = 700;
        _buttons.y = 20;
    }

    private function onAddObject(object:Item):void
    {
        _transformer.add(object);
        _animationControl.add(object, _timeLine.currentSec)
    }


    private function updateAnimation(seconds:Number):void
    {
        _transformer.deselect();
        _animationControl.time = seconds;
    }

    public static function removeAnimation(item:Item):void
    {
       _animationControl.removeAnimation(item)
    }

    public static function hightLight(Class = null):void
    {
        var obj = null;
        switch(Class)
        {
            case TimeLine:
                obj = _timeLine;
                break;
        }

        HightLigher.add(obj)
    }


    public static function close(closeFunc:Function):void
    {
        _transformer.deselect();
        SaveFile.save(_animationControl.saveObject, Utils.time, closeFunc, _animationControl.savedDirectory, true)
    }

    public static function save():void
    {
        _transformer.deselect();
    }

    public static function saveFiles(directory:File):void
    {
        _animationControl.saveFiles(directory.nativePath);
    }

    public static function setDir(path:String):void
    {
        _animationControl.savedDirectory = path;
    }

    public static function reset():void
    {
        _animationControl.reset();
        _transformer.reset();
        _dragManager.reset();
    }
}
}
