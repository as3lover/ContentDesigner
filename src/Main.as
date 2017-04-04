package {

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

[SWF(width="800", height="450", frameRate=60, backgroundColor='0xabcde')]

public class Main extends Sprite
{
    private var _timeLine:TimeLine;

    private var _animation:TweenLine;
    private var _workArea:DragManager;

    public function Main()
    {
        _workArea = new DragManager(20,40,600, 337);
        addChild(_workArea);

        _animation = new TweenLine();
        _timeLine = new TimeLine();
        _timeLine.updateFunc = updateFunc;
        addChild(_timeLine);

       new TitleBar(stage, this);
    }

    private function updateFunc(seconds:Number):void
    {
        _animation.seek(seconds);
    }


}
}
