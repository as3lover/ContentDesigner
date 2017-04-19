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
        Main.topics.reset();

        var obj:Object;
        var number:int;
        var sound:String;
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
                continue;
            }

            if(i == 'number')
            {
                number = obj as int;
                continue;
            }

            if(i == 'sound')
            {
                sound = obj as String;
                continue;
            }

            if(i == 'topics')
            {
                Main.topics.object = obj;
                continue;
            }

            var holder:Item

            if(obj.type == 'text')
                holder = new TextItem(Main.removeAnimation);
            else
                holder = new Item(Main.removeAnimation, obj.path);

            holder.all = obj;
            Main.dragManager.target.addChild(holder);
            Main.transformer.add(holder, true);
            Main.animationControl.addLoaded(holder, obj.startTime, obj.stopTime, obj.showDuration, obj.hideDuration);
        }

        Main.animationControl.loadItems();
        Main.animationControl.number = number;
        Main.timeLine.currentSec = time
        if(sound)
                Main.timeLine.sound = sound;
    }
}
}
