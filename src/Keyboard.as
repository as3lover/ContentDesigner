/**
 * Created by Morteza on 4/23/2017.
 */
package
{
import flash.display.Stage;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.text.TextField;

public class Keyboard
{
    private var _lastTextField:Object;
    private var stage:Stage;

    public function Keyboard(stage:Stage)
    {
        this.stage = stage;
        stage.addEventListener(MouseEvent.MOUSE_DOWN, onClick, true)

        stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
    }

    private function onClick(e:MouseEvent):void
    {
        if(e.target is TextField)
        {
            _lastTextField = e.target
        }
        else if(stage.focus == _lastTextField)
        {
            _lastTextField = null
            stage.focus = null
        }
    }

    private function onKeyDown(e:KeyboardEvent):void
    {
        if(Main.textEditor.visible)
        {
            if(e.keyCode == 13 && e.ctrlKey)
                Main.textEditor.register();
            else if(e.keyCode == 27)
                Main.textEditor.onCancel(null);

            return;
        }

        if(Main._progress.visible)
                return;

        if(Main.STAGE.focus is TextField && !(Main.STAGE.focus.parent is TitleBar))
                return;


        if(Main.panel.visible && !Main.transformer.target)
            return;

        /*
        if(Main.panel.visible && Main.STAGE.focus is TextField&& !(Main.STAGE.focus.parent is TitleBar))
            return;
            */



        switch (e.keyCode)
        {
            case 37://Left Arrow
                    if(Main.transformer.target)
                        Main.transformer.moveLeft(e.ctrlKey, e.shiftKey);
                    else
                        Main.timeLine.stepBackward(e.ctrlKey, e.shiftKey);
                break;

            case 39://Right Arrow
                if(Main.transformer.target)
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

            case 83:// ctrl + S
                if(e.ctrlKey)
                    FileManager.saveFile();
                break;

            case 13:// Enter
                Main.transformer.EnterKey();
                break;

            case 187:// Plus: +/=
                Main.timeLine.zoom(+.1);
                break;

            case 189:// Mines: -/_
                Main.timeLine.zoom(-.1);
                break;

            case 107:// Plus: +
                Main.timeLine.zoom(+.1);
                break;

            case 109:// Mines: -
                Main.timeLine.zoom(-.1);
                break;

            case 35:// End
                Main.timeLine.changePercent(1);
                break;

            case 36:// Home
                Main.timeLine.changePercent(0);
                break;

            case 33:// Page up
                Main.timeLine.stepUp();
                break;

            case 34:// Page Down
                Main.timeLine.stepDown();
                break;

            case 27:// Esc
                Main.transformer.deselect();
                break;
        }
    }
}
}
