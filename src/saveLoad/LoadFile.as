/**
 * Created by Morteza on 4/10/2017.
 */
package saveLoad
{
import flash.events.Event;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.utils.setTimeout;

import items.Item;
import items.ItemText;

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

    private static function loadObject(file:File, time:Number = 0, json:Boolean = false):void
    {
        Main._progress.percent = 0;
        Main._progress.text = 'Loading...\n' + file.nativePath;
        setTimeout(loadObject2,10, file, time, json);
        trace('loadObject')
    }
    private static function loadObject2(file:File, time:Number = 0, json:Boolean = false):void
    {
        trace('loadObject2')
        var fileStream:FileStream = new FileStream();
        fileStream.open(file, FileMode.READ);
        var str:String = fileStream.readUTFBytes(file.size);
        fileStream.close();
        if(str.indexOf('{') == 0)
        {
            afterLoad(JSON.parse(str), time);
        }
        else
        {
            trace('stream')
            var myStream:FileStream = new FileStream();
            myStream.addEventListener(Event.COMPLETE, onCompleteLoad);
            myStream.openAsync(file, FileMode.READ);
        }

        function onCompleteLoad(evt:Event):void
        {
            trace('onCompleteLoad')
            afterLoad(evt.target.readObject(), time);
            evt.target.close();
        }



        /*
        var myStream:FileStream = new FileStream();
        var myText:String = '';
        myStream.addEventListener(Event.COMPLETE, onCompleteLoad);
        myStream.addEventListener(ProgressEvent.PROGRESS, onProgress);
        myStream.openAsync(file, FileMode.READ);

        function onProgress(event:ProgressEvent):void
        {
            if (myStream.bytesAvailable)
            {
                myText += myStream.readUTFBytes(myStream.bytesAvailable);
            }
        }

        function onCompleteLoad(evt:Event):void
        {
            if(myText.indexOf('{"time":') != -1)
                afterLoad(JSON.parse(myText), time);
            else
                afterLoad(myStream.readObject(), time);

            myStream.close();
        }
        */
        /*
        var myStream:FileStream = new FileStream();
        myStream.addEventListener(Event.COMPLETE, onCompleteLoad);
        myStream.openAsync(file, FileMode.READ);


        function onCompleteLoad(evt:Event):void
        {
            afterLoad(evt.target.readObject(), time);
            evt.target.close();
        }
        */
    }


    private static function afterLoad(object:Object, time:Number = 0):void
    {
        for (var ss:String in object)
        {
            trace(ss)
        }
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

            var holder:Item;

            if(obj.type == 'text')
                holder = new ItemText(Main.removeAnimation);
            else
                holder = new Item(Main.removeAnimation, obj.path);

            holder.all = obj;
            Main.dragManager.target.addChild(holder);
            Main.animationControl.addLoaded(holder, obj.startTime, obj.stopTime, obj.showDuration, obj.hideDuration, obj.typingEndTime);
        }

        trace('loaded time', time)
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
