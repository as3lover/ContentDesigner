package {

import flash.display.DisplayObject;
import flash.display.Sprite;

[SWF(width="800", height="450", frameRate=60, backgroundColor='0xabcde')]

public class Main extends Sprite
{
    private var _timeLine:TimeLine;

    private var _animation:TweenLine;
    private var _workArea:DragManager;

    private var _transformer:TransformManager;
    private var _objectManager:ObjectManager;

    public function Main()
    {
        _objectManager = new ObjectManager();

        _workArea = new DragManager(20,40,600, 337, onAddObject, stage, removeAnimation);
        addChild(_workArea);

        _animation = new TweenLine();
        _timeLine = new TimeLine();
        _timeLine.updateFunc = updateFunc;
        addChild(_timeLine);

        _transformer = new TransformManager(stage, _workArea.target);

        new TitleBar(stage, this);

    }

    private function onAddObject(object:DisplayObject):void
    {
        _transformer.add(object);
        _objectManager.add(object, _timeLine.currentMSec/1000);
        _animation.build(_objectManager.list, _timeLine.currentMSec/1000)
    }

    private function updateFunc(seconds:Number):void
    {
        _transformer.deselect();
        _animation.seek(seconds);
    }

    private function removeAnimation(item:Item):void
    {
        _objectManager.removeAnimation(item)
    }


}
}
