/**
 * Created by Morteza on 4/5/2017.
 */
package
{
import flash.display.Sprite;

public class Item extends Sprite
{
    private var _removeAnimation:Function;
    public function Item(removeAnimataion:Function)
    {
        super();
        _removeAnimation = removeAnimataion;
    }

    public function remove():void
    {
        if(parent)
        {
            parent.removeChild(this)
        }

        if(_removeAnimation)
        {
            _removeAnimation(this)
        }
    }
}
}
