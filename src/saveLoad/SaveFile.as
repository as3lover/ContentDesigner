/**
 * Created by Morteza on 4/10/2017.
 */
package saveLoad
{
import flash.events.Event;
import flash.events.OutputProgressEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.utils.getTimer;

public class SaveFile
{
    public function SaveFile()
    {
    }

    public static function save(obj:Object, time:Number, func:Function = null):void
    {
        var file:File = FileManager.file;
        obj.time = time;
        if(Main.timeLine.soundFile)
        {
            if(Main.timeLine.fileName)
                obj.sound = Main.timeLine.fileName;
            else
                obj.sound = Main.timeLine.soundFile;

            trace('save sound',obj.sound)
        }

        obj.color = Main.dragManager.color;


        var myStream:FileStream = null;
        myStream = new FileStream();
        myStream.openAsync(file, FileMode.WRITE);
        myStream.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS, write);
        myStream.addEventListener(Event.CLOSE, ff);
        var t:Number = getTimer();
        //myStream.writeObject(obj);
        myStream.writeUTFBytes(JSON.stringify(obj));
        myStream.close();


        function write(e:OutputProgressEvent):void
        {
            if(e.bytesPending == 0 && func != null)
            {
                myStream.removeEventListener(OutputProgressEvent.OUTPUT_PROGRESS, write);
                func();
            }
        }

        function ff(event:Event):void
        {
            trace('finish', getTimer()-t);
        }
    }






}
}
