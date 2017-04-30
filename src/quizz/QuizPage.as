/**
 * Created by Morteza on 4/30/2017.
 */
package quizz
{
import flash.display.DisplayObject;
import flash.display.Sprite;

public class QuizPage extends Sprite
{
    public function QuizPage()
    {
    }

    public function sort():void
    {
        trace('sort auiz')
        var t:DisplayObject;
        for (var i:int = 1; i < numChildren; i++)
        {
            t = getChildAt(i) as DisplayObject;
            t.y = getChildAt(i-1).y + getChildAt(i-1).height;
        }
    }
}
}
