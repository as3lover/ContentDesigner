/**
 * Created by Morteza on 4/28/2017.
 */
package src2
{
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;

public class SnapList extends Topics
{
    public function SnapList()
    {
        super();
    }

    public override function init():void
    {
        _scroll = new Scroll(this, x, y, 20, 13*28-8, stage);
    }

    public override function add(seconds:Number=-1, text:String = '1', type:String = 'snap'):TopicItem
    {
        return super.add(seconds,String(numChildren+1), 'snap');
    }


    public function getSnapShot(i:int, scale:int = 1):Bitmap
    {
        ObjectManager.deselect();
        gotoItemTime(i);

        var obj:Sprite = Main.dragManager;
        var parent:DisplayObjectContainer = obj.parent
        var x:Number = obj.x;
        var y:Number = obj.y;
        var index:int = parent.getChildIndex(obj);

        var sprite = new Sprite();
        obj.x = - Main.target.x;
        obj.y = - Main.target.y;
        sprite.addChild(obj);

        var mask:Sprite = new Sprite();
        Utils.drawRect(mask, 0, 0, Main.target.w, Main.target.h);
        sprite.addChild(mask);
        obj.mask = mask;

        var holder:Sprite = new Sprite();
        sprite.scaleX = 2;
        sprite.scaleY = 2;
        holder.addChild(sprite);

        var bitmapData:BitmapData = new BitmapData(mask.width * 2, mask.height * 2, true, 0);
        bitmapData.draw(holder);
        var bitmap:Bitmap = new Bitmap(bitmapData);

        parent.addChildAt(obj, index);
        obj.x = x;
        obj.y = y;

        return bitmap;
    }

}
}
