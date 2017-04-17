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

public class SaveFile
{
    private static var _streams:Array = [];
    public function SaveFile()
    {
    }

    public static function save(obj:Object, time:Number, func:Function = null, directory:String = '', saved:Boolean = false):void
    {
        var file:File;
        file = File.documentsDirectory.resolvePath("Content Designer/project.rian");
        obj.time = time;


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
        for(var i :int = 0; i<_streams.length; i++)
        {
            if(_streams[i].path == String(file.nativePath))
            {
                myStream = _streams[i].stream;
            }
        }


        if(myStream == null)
        {
            myStream = new FileStream();
            myStream.openAsync(file, FileMode.WRITE);
            _streams.push({stream:myStream, path:file.nativePath})
        }

        myStream.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS, write);
        myStream.addEventListener(Event.CLOSE, ff);
        myStream.writeObject(obj);
        myStream.close();

        function write(e:OutputProgressEvent):void
        {
            if(e.bytesPending == 0 && func != null)
            {
                myStream.removeEventListener(OutputProgressEvent.OUTPUT_PROGRESS, write);
                //myStream.close();
                func();
            }
        }

        function ff(event:Event):void
        {
            trace('ff')
        }
    }






}
}
