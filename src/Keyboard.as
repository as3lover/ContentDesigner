/**
 * Created by Morteza on 4/23/2017.
 */
package
{
import flash.display.Stage;
import flash.events.KeyboardEvent;

public class Keyboard
{
    public function Keyboard(stage:Stage)
    {
        stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown)
    }

    private function onKeyDown(e:KeyboardEvent):void
    {
        if(Main.panel.visible && !Main.transformer._target)
                return;

        switch (e.keyCode)
        {
            case 37://Left Arrow
                    if(Main.transformer._target)
                        Main.transformer.moveLeft(e.ctrlKey, e.shiftKey);
                    else
                        Main.timeLine.stepBackward(e.ctrlKey, e.shiftKey);
                break;

            case 39://Right Arrow
                if(Main.transformer._target)
                    Main.transformer.moveRight(e.ctrlKey, e.shiftKey);
                else
                Main.timeLine.stepForward(e.ctrlKey, e.shiftKey);
                break;

            case 38://Up
                Main.transformer.moveUp(e.ctrlKey, e.shiftKey);
                break;

            case 40://Down
                Main.transformer.moveDown(e.ctrlKey, e.shiftKey);
                break;

            case 32://Down
                Main.timeLine.onPausePlayBtn();
                break;

            case 67:// ctrl + C
                if(e.ctrlKey)
                    Main.transformer.Copy();
                break;

            case 86:// ctrl + V
                if(e.ctrlKey)
                    Main.transformer.Paste();
                break;

            case 88:// ctrl + X
                if(e.ctrlKey)
                    Main.transformer.Cut();
                break;
        }
    }
}
}