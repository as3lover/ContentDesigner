/**
 * Created by Morteza on 4/28/2017.
 */
package src2
{

public class SnapList extends Topics
{
    public function SnapList()
    {
        super();
    }

    public override function add(seconds:Number=-1, text:String = '1', type:String = 'snap'):void
    {
        super.add(seconds,String(numChildren+1), 'snap');
    }
}
}
