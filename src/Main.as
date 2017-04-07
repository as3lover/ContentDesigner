package {

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;

[SWF(width="800", height="450", frameRate=60, backgroundColor='0xabcde')]

public class Main extends Sprite
{
    private var _timeLine:TimeLine;

    private var _animation:Animations;
    private var _workArea:DragManager;

    private var _transformer:TransformManager;
    private var _objectManager:ObjectManager;


    public function Main()
    {
        _objectManager = new ObjectManager();

        _workArea = new DragManager(20,40,600, 337, onAddObject, stage, removeAnimation);
        addChild(_workArea);

        _animation = new Animations(updateTimeLine);

        _timeLine = new TimeLine(_animation);
        _timeLine.updateFunc = updateAnimation;
        addChild(_timeLine);

        _transformer = new TransformManager(stage, _workArea.target);

        new TitleBar(stage, this);

    }

    private function onAddObject(object:DisplayObject):void
    {
        _transformer.add(object);
        _objectManager.add(object, _timeLine.currentSec);
        _animation.build(_objectManager.list, _timeLine.currentSec)
    }

    private function updateAnimation(seconds:Number):void
    {
        _transformer.deselect();
        if(_animation.paused)
            _animation.seek(seconds);
    }

    private function updateTimeLine():void
    {
        _timeLine.currentSec = _animation.time;
    }

    private function removeAnimation(item:Item):void
    {
        _objectManager.removeAnimation(item)
    }
}
}
