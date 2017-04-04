package {

import flash.display.Sprite;

[SWF(width="800", height="450", frameRate=60, backgroundColor='0xabcde')]

public class Main extends Sprite
{
    private var _timeLine:TimeLine;

    public function Main()
    {
        _timeLine = new TimeLine();
        _timeLine.updateFunc = updateFunc;
        addChild(_timeLine)
    }

    private function updateFunc():void
    {

    }

}
}
