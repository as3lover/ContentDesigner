/**
 * Created by Morteza on 5/12/2017.
 */
package
{
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.MouseEvent;

import src2.assets;

public class Cursor extends Sprite
{
    public static const MOVE:String = 'move';
    public static const NORMAL:String = 'normal';
    public static const ROTATE_1:String = 'rotate1';
    public static const ROTATE_2:String = 'rotate2';
    public static const ROTATE_3:String = 'rotate3';
    public static const ROTATE_4:String = 'rotate4';
    public static const ARROW_1:String = 'arrow 1';
    public static const ARROW_2:String = 'arrow 2';
    public static const ARROW_3:String = 'arrow 3';
    public static const ARROW_4:String = 'arrow 4';
    public static const ARROW_5:String = 'arrow 5';
    public static const ARROW_6:String = 'arrow 6';
    public static const ARROW_7:String = 'arrow 7';
    public static const ARROW_8:String = 'arrow 8';
    public static const POINT:String = 'point';


    private var _move:Sprite;
    private var _arrow:Sprite;
    private var _rotate:Sprite;
    private var _type:String;
    private var _point:Sprite;

    public function Cursor()
    {
        var bit:Bitmap;

        _move = new Sprite();
        bit = new assets.Move();
        bit.smoothing = true;
        bit.x = - bit.width / 2;
        bit.y = - bit.height / 2;
        _move.addChild(bit);
        addChild(_move);

        _point = new Sprite();
        bit = new assets.Point();
        bit.smoothing = true;
        bit.x = - bit.width / 2;
        bit.y = - bit.height / 2;
        _point.addChild(bit);
        addChild(_point);

        _arrow = new Sprite();
        bit = new assets.Arrow();
        bit.smoothing = true;
        bit.x = - bit.width / 2;
        bit.y = - bit.height / 2;
        _arrow.addChild(bit);
        addChild(_arrow);

        _rotate = new Sprite();
        bit = new assets.Rotate();
        bit.smoothing = true;
        bit.x = - bit.width / 2;
        bit.y = - bit.height / 2;
        _rotate.addChild(bit);
        addChild(_rotate);
    }

    public function get type():String
    {
        return _type;
    }

    public function set type(type:String):void
    {
        _type = type;

        _move.visible = false;
        _arrow.visible = false;
        _rotate.visible = false;
        _point.visible = false;

        switch (type)
        {
            case MOVE:
                _move.visible = true;
                break;

            case POINT:
                _point.visible = true;
                break;

            case ARROW_1:
                _arrow.rotation = +45;
                _arrow.visible = true;
                break;

            case ARROW_2:
                _arrow.rotation = 90;
                _arrow.visible = true;
                break;

            case ARROW_3:
                _arrow.rotation = -45;
                _arrow.visible = true;
                break;

            case ARROW_4:
                _arrow.rotation = 0;
                _arrow.visible = true;
                break;

            case ARROW_5:
                _arrow.rotation = +45;
                _arrow.visible = true;
                break;

            case ARROW_6:
                _arrow.rotation = 90;
                _arrow.visible = true;
                break;

            case ARROW_7:
                _arrow.rotation = -45;
                _arrow.visible = true;
                break;

            case ARROW_8:
                _arrow.rotation = 0;
                _arrow.visible = true;
                break;

            case ROTATE_1:
                _rotate.visible = true;
                _rotate.rotation = 0;
                break;

            case ROTATE_2:
                _rotate.visible = true;
                _rotate.rotation = 90;
                break;

            case ROTATE_3:
                _rotate.visible = true;
                _rotate.rotation = 180;
                break;

            case ROTATE_4:
                _rotate.visible = true;
                _rotate.rotation = -90;
                break;

            case NORMAL:
                if(parent)
                    parent.removeChild(this);

                Main.STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
                return;
                break;
        }

        Main.STAGE.addChild(this);
        Main.STAGE.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
        onMove(null);
    }

    private function onMove(e:MouseEvent):void
    {
        x = Main.STAGE.mouseX + 25;
        y = Main.STAGE.mouseY + 25;
        if(e) e.updateAfterEvent();
    }
}
}
