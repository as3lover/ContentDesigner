/**
 * Created by mkh on 2017/04/09.
 */
package
{
public class HightLigher
{
    import com.greensock.*;
    import com.greensock.plugins.*;

    private static var _obj;

    public static function add(obj):void
    {
        TweenPlugin.activate([TintPlugin, ColorTransformPlugin]);

        if(_obj != null)
            TweenMax.to(_obj, 0, {colorTransform:{tint:0xff0000, tintAmount:0}});

        if(obj == null)
                return;

        _obj = obj;
        TweenMax.to(_obj, .3, {colorTransform:{tint:0xff0000, tintAmount:.5}});
    }
}
}
