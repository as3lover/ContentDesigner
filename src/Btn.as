/**
 * Created by SalmanPC3 on 4/24/2017.
 */
package
{
import flash.display.Bitmap;
import flash.display.Sprite;

public class Btn
{
    public static function New(bitmapClass:Class, height:int = -1):Sprite
    {
        var bt:Sprite = new Sprite();
        var bit:Bitmap = new bitmapClass();
        bit.smoothing = true;
        if(height != -1)
        {
            bit.height = height;
            bit.scaleX = bit.scaleY;
        }
        bt.addChild(bit)
        return bt;
    }

    public function Btn():void
    {
    }
}
}
