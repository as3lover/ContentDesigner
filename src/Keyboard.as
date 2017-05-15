/**
 * Created by Morteza on 4/23/2017.
 */
package
{
import flash.display.InteractiveObject;
import flash.display.Stage;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.text.TextField;

import items.Item;

import src2.Consts;
import src2.Utils;

public class Keyboard
{
    private var _lastTextField:Object;
    private var stage:Stage;
    private static var _ctrl:Boolean;
    private static var _shift:Boolean;

    public function Keyboard(stage:Stage)
    {
        this.stage = stage;
        stage.addEventListener(MouseEvent.MOUSE_DOWN, onClick, true);

        stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, true);
        stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
    }

    private function onClick(e:MouseEvent):void
    {
        if(e.target is TextField)
        {
            _lastTextField = e.target
        }
        else if(stage.focus == _lastTextField)
        {
            _lastTextField = null;
            stage.focus = null;
        }
    }

    private function onKeyUp(e:KeyboardEvent):void
    {
        if(e.keyCode == 17)
            _ctrl = false;
        if(e.keyCode == 16)
            _shift = false;
    }

    private function onKeyDown(e:KeyboardEvent):void
    {
        trace('onKeyDown', e.charCode);

        if(e.keyCode == 17) //ctrl
            _ctrl = true;
        else if(e.keyCode == 16) //shift
            _shift = true;
        if(e.keyCode == 27)//Esc
        {
            ObjectManager.deselect();
        }

        //Delete
        if(e.charCode == 127 || e.keyCode == 46)
        {
            if(ObjectManager.target)
                ObjectManager.DeleteKey();
        }


        if(Main.textEditor.visible)
        {
            if(e.keyCode == 13 && e.ctrlKey)
                Main.textEditor.register();
            else if(e.keyCode == 27)
                Main.textEditor.onCancel(null);

            return;
        }

        if(Main.quiz.visible)
        {
            trace('Main.quiz.visible')
            return;
        }

        if(Main._progress.visible)
        {
            trace('Main._progress.visible');
            return;
        }

        if(Main.STAGE.focus is TextField && !(Main.STAGE.focus.parent is TitleBar) && Utils.isVisible(Main.STAGE.focus))
        {
            trace('stage focus', Main.STAGE.focus)
            return;
        }


        if(Main.panel.visible && !ObjectManager.target)
        {
            trace('Main.panel.visible && !ObjectManager.target');
            return;
        }

        /*
        if(Main.panel.visible && Main.STAGE.focus is TextField&& !(Main.STAGE.focus.parent is TitleBar))
            return;
            */



        switch (e.keyCode)
        {
            case 37://Left Arrow
                    if(ObjectManager.target)
                        ObjectManager.moveLeft(e.ctrlKey, e.shiftKey);
                    else
                        Main.timeLine.stepBackward(e.ctrlKey, e.shiftKey);
                break;

            case 39://Right Arrow
                if(ObjectManager.target)
                    ObjectManager.moveRight(e.ctrlKey, e.shiftKey);
                else
                Main.timeLine.stepForward(e.ctrlKey, e.shiftKey);
                break;

            case 38://Up
                ObjectManager.moveUp(e.ctrlKey, e.shiftKey);
                break;

            case 40://Down
                ObjectManager.moveDown(e.ctrlKey, e.shiftKey);
                break;

            case 32://Down
                Main.timeLine.onPausePlayBtn();
                break;

            case 67:// ctrl + C
                if(e.ctrlKey)
                    ObjectManager.Copy();
                break;

            case 86:// ctrl + V
                if(e.ctrlKey)
                    ObjectManager.Paste(e.shiftKey);
                break;

            case 88:// ctrl + X
                if(e.ctrlKey)
                    ObjectManager.Cut();
                break;

            case 83:// ctrl + S
                if(e.ctrlKey)
                {
                    if(e.shiftKey)
                            FileManager.saveAsFile()
                    else
                        FileManager.saveFile();
                }
                break;

            case 79:// ctrl + O
                if(e.ctrlKey)
                    FileManager.openFile();
                break;


            case 13:// Enter
                ObjectManager.EnterKey();
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
                if(ObjectManager.target)
                    Item.setIndexByUser(Consts.ARRANGE.BACK,ObjectManager.target);
                else
                    Main.timeLine.changePercent(1);
                break;

            case 36:// Home
                if(ObjectManager.target)
                    Item.setIndexByUser(Consts.ARRANGE.FRONT,ObjectManager.target);
                else
                    Main.timeLine.changePercent(0);
                break;

            case 33:// Page up
                    if(ObjectManager.target)
                        Item.setIndexByUser(Consts.ARRANGE.FRONT_LEVEL,ObjectManager.target);
                    else
                        Main.timeLine.stepUp();

                break;

            case 34:// Page Down
                if(ObjectManager.target)
                    Item.setIndexByUser(Consts.ARRANGE.BACK_LEVEL,ObjectManager.target);
                else
                    Main.timeLine.stepDown();
                break;

            case 27:// Esc
                ObjectManager.deselect();
                break;

            case 89:// Y >> Redo
                if(e.ctrlKey)
                    History.redo();
                break;

            case 90:// Z >> Undo
                if(e.ctrlKey)
                    History.undo();
                break;
        }
    }

    public static function get CTRL():Boolean
    {
        return _ctrl;
    }

    public static function get SHIFT():Boolean
    {
        return _shift;
    }
}
}
