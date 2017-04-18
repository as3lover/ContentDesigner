/**
 * Created by Morteza on 4/10/2017.
 */
package
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

    public static function save(obj:Object, time:Number, func:Function = null, directory:String = '', saved:Boolean = false):void
    {
        var file:File;
        file = File.documentsDirectory.resolvePath("Content Designer/project.rian");
        obj.time = time;
        if(Main._timeLine.soundFile)
            obj.sound = Main._timeLine.soundFile;


        if(directory != '')
        {
            if(saved)
            {
                obj = {path:directory, time:time}
            }
            else
            {
                file = new File(directory + "/project.rian");
            }
        }

        var myStream:FileStream = null;
        myStream = new FileStream();
        myStream.openAsync(file, FileMode.WRITE);
        myStream.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS, write);
        myStream.addEventListener(Event.CLOSE, ff);
        var t:Number = getTimer();
        myStream.writeObject(obj);
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
