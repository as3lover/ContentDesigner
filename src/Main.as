package {

import flash.display.Sprite;

[SWF(width="800", height="450", frameRate=60, backgroundColor='0xabcde')]

public class Main extends Sprite
{
    private static var _timeLine:TimeLine;
    private var _dragManager:DragManager;
    private var _transformer:TransformManager;
    public static var _animationControl:AnimationControl;

    public function Main()
    {
        _animationControl = new AnimationControl();

        _dragManager = new DragManager(20,40,600, 337, onAddObject, stage, removeAnimation);
        addChild(_dragManager);

        _transformer = new TransformManager(stage, _dragManager.target);

        _timeLine = new TimeLine(_transformer, updateAnimation);
        addChild(_timeLine);

        new TitleBar(stage, this);

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

    private function updateTimeLine():void
    {
        //_timeLine.currentSec = _animation.time;
    }

    private function removeAnimation(item:Item):void
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
}
}
