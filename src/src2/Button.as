/**
 * Created by Morteza on 4/5/2017.
 */
package src2
{
import flash.display.Sprite;
import flash.text.TextField;

import texts.Text;


public class Button extends Sprite
{
    public function Button(text:String = '.', x:int = 0, y:int = 2, width:int = 20, height:int = 20, textColor:uint = 0xeeeeee, backColor:uint = 0x333333)
    {
        super();
        Utils.drawRect(this, x, y, width, height, backColor);
        addChild(Text.sprite(text,textColor,"B Yekan", 12, width, height))
    }
}
}
