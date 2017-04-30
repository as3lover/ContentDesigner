/**
 * Created by Morteza on 4/28/2017.
 */
package src2
{
import flash.display.Shape;

public class Snap extends Shape
{
    public function Snap(height:int)
    {
        with (graphics)
        {
            lineStyle(1, 0xDEAD57);
            moveTo(0,0);
            lineTo(1,0);
            lineTo(1,height);
            lineTo(-1,height);
            lineTo(-1,0);
            lineTo(0,0);
        }
    }
}
}
