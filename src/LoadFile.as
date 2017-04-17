/**
 * Created by Morteza on 4/10/2017.
 */
package
{
import flash.events.Event;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

public class LoadFile
{
    public function LoadFile()
    {
    }

    public static function load(path:String = '', time:Number = 0):void
    {
        Main.reset();
        var file:File
        if(path == '')
        {
            file = File.documentsDirectory.resolvePath("Content Designer/project.rian");
        }
        else
        {
            file = new File(path);
        }

        if(file.exists)
            loadObject(file, time);
    }

    private static function loadObject(file:File, time:Number = 0):void
    {
        var myStream:FileStream = new FileStream();
        myStream.addEventListener(Event.COMPLETE, onCompleteLoad);
        myStream.openAsync(file, FileMode.READ);

        function onCompleteLoad(evt:Event):void
        {
            afterLoad(evt.target.readObject(), time);
            evt.target.close();
        }
    }

    private static function afterLoad(object:Object, time:Number = 0):void
    {
        trace('afterLoad', time);
        var obj:Object;
        var number:int;
        for(var i:String in object)
        {
            obj = object[i];

            if(i == 'path')
            {
                load(String(obj) + '/project.rian', object.time);
                Main.setDir(obj as String);
                return;
            }

            if(i == 'time')
            {
                time = obj as Number;
                trace('from file', time)
                continue;
            }

            if(i == 'number')
            {
                trace('number', obj)
                number = obj as int;
                continue;
            }

            var holder:Item = new Item(Main.removeAnimation, obj.path);
            holder.all = obj;
            Main._dragManager.target.addChild(holder);
            Main._transformer.add(holder, true);
            Main._animationControl.addLoaded(holder, obj.startTime, obj.stopTime, obj.showDuration, obj.hideDuration);
        }
        trace('loaded time', time);
        Main._animationControl.loadItems();
        Main._animationControl.number = number;
        Main._timeLine.currentSec = time;
    }
}
}
