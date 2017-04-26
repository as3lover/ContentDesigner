/**
 * Created by Morteza on 4/26/2017.
 */
package
{
import flash.display.Sprite;

public class Handle extends Sprite
{
    public function Handle(height:int)
    {
        graphics.lineStyle(2,0xff0000);
        graphics.moveTo(-2,-2-height/2);
        graphics.lineTo(2,-2-height/2);
        graphics.moveTo(-2,+2+height/2);
        graphics.lineTo(2,+2+height/2);
        graphics.moveTo(0,-2-height/2);
        graphics.lineTo(0,+2+height/2);
    }
}
}
