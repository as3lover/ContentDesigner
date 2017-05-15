/**
 * Created by Morteza on 4/10/2017.
 */
package saveLoad
{
import flash.events.Event;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

import items.Item;
import items.ItemText;
import items.TextItem;

public class LoadFile
{
    public function LoadFile()
    {
    }

    public static function load():void
    {
        Main.reset();
        loadObject(FileManager.file);
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
        trace('afterLoad on LoadFile')
        Main.topics.reset();

        var obj:Object;
        var number:int;
        var sound:String;
        for(var i:String in object)
        {
            obj = object[i];

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

            if(i == 'snapList')
            {
                Main.snapList.object = obj;
                continue;
            }

            if(i == 'color')
            {
                Main.dragManager.color = obj as uint;
                continue;
            }

            var holder:Item

            if(obj.type == 'text')
                holder = new ItemText(Main.removeAnimation);
            else
                holder = new Item(Main.removeAnimation, obj.path);

            holder.all = obj;
            Main.dragManager.target.addChild(holder);
            Main.animationControl.addLoaded(holder, obj.startTime, obj.stopTime, obj.showDuration, obj.hideDuration, obj.typingEndTime);
        }

        Main.loadedTime = time;
        Main.animationControl.loadItems();
        Main.animationControl.number = number;
        Main.changed = false;
        if(sound)
        {
            if (sound)
            {
                if(sound == 'file.voice')
                {
                    trace('new Sound:', FileManager.itemsFolder + '/' + sound);
                    sound = FileManager.itemsFolder + '/' + sound;
                }

                Main.timeLine.sound = sound;
            }
        }
    }
}
}
