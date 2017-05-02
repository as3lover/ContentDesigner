/**
 * Created by Morteza on 4/30/2017.
 */
package quizz
{
import flash.display.DisplayObject;
import flash.display.Sprite;

public class QuizPage extends Sprite
{
    private var selectFunction:Function;
    public function QuizPage(func:Function)
    {
        selectFunction = func
    }

    public function sort():void
    {
        var t:DisplayObject;
        for (var i:int = 1; i < numChildren; i++)
        {
            t = getChildAt(i) as DisplayObject;
            t.y = getChildAt(i-1).y + getChildAt(i-1).height;
        }
    }

    public function select(childIndex:int):void
    {
        selectFunction(childIndex);
    }
}
}
