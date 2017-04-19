/**
 * Created by Morteza on 4/5/2017.
 */
package
{
import flash.display.Sprite;
import flash.text.TextField;


public class Button extends Sprite
{
    public function Button(text:String = '.', x:int = 0, y:int = 2, width:int = 20, height:int = 20, color:uint = 0xeeeeee)
    {
        super();
        Utils.drawRect(this, x, y, width, height);
        addChild(Text.sprite(text,color,"B Yekan", 12, width, height))
    }
}
}
