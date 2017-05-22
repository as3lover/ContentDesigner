/**
 * Created by Morteza on 5/17/2017.
 */
package
{
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.MouseEvent;
import flash.geom.Rectangle;

import items.Item;

import src2.AnimateObject;

public class SelectRange extends Sprite
{
    private static var _x:Number;
    private static var _y:Number;
    private static var _area:Sprite;
    public function SelectRange()
    {
    }

    public static function start():void
    {
        _x = Main.dragManager.target.mouseX;
        _y = Main.dragManager.target.mouseY;
        if(_area == null)
            _area = new Sprite();

        _area.graphics.clear();
        Main.dragManager.target.addChild(_area);
        Main.STAGE.addEventListener(MouseEvent.MOUSE_MOVE, move);
        Main.STAGE.addEventListener(MouseEvent.MOUSE_UP, up);
    }

    private static function up(event:MouseEvent):void
    {
        Main.STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, move);
        Main.STAGE.removeEventListener(MouseEvent.MOUSE_UP, up);

        var area:Rectangle = _area.getBounds(Main.STAGE);
        var list:Array = Main.animationControl.visibleList;
        var selection:Array = [];
        var obj:Item;
        var stage:Stage =  Main.STAGE;
        for(var i:int=0; i<list.length; i++)
        {
            obj = AnimateObject(list[i]).object;
            if(area.intersects(obj.getBounds(stage)))
                selection.push(obj);
        }

        if(_area.parent)
            _area.parent.removeChild(_area);

        if(selection.length == 1)
                ObjectManager.target = selection[0];
        else if(selection.length)
                ObjectManager.selectList = selection;

    }

    private static function move(e:MouseEvent):void
    {
        draw(_x, _y, Main.dragManager.target.mouseX, Main.dragManager.target.mouseY);
        e.updateAfterEvent();
    }

    private static function draw(x1:Number, y1:Number, x2:Number, y2:Number):void
    {
        with (_area.graphics)
        {
            clear();
            lineStyle(2, 0xffff00)
            moveTo(x1, y1);
            lineTo(x2, y1);
            lineTo(x2, y2);
            lineTo(x1, y2);
            lineTo(x1, y1);
        }
    }
}
}
