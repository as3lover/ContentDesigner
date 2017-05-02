/**
 * Created by Morteza on 5/2/2017.
 */
package items
{
import flash.display.Sprite;

import src2.Utils;

public class TextMask extends Sprite
{
    public function TextMask()
    {
        Utils.drawRect(this, 0, 0, 200, 200);
        alpha = 0;
    }
}
}
