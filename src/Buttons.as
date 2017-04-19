/**
 * Created by Morteza on 4/10/2017.
 */
package
{
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filesystem.File;
import flash.net.FileFilter;

public class Buttons extends Sprite
{
    private var _stage:Stage;
    private var _save:Button;
    private var _load:Button;

    public function Buttons(stage:Stage)
    {
        _stage = stage;

        _save = new Button('ذخیره',0,0,60,20);
        _save.addEventListener(MouseEvent.CLICK, onSave)
        _save.y = 20;
        addChild(_save);

        _load = new Button('باز کردن',0,0,60,20);
        _load.addEventListener(MouseEvent.CLICK, onLoad);
        _load.y = 45;
        addChild(_load);
    }

    private function onSave(event:MouseEvent):void
    {
        var myFile:File = File.documentsDirectory;
        myFile.browseForDirectory("Save Location");
        myFile.addEventListener(Event.SELECT, fileSelected);

        function fileSelected(e:Event):void
        {
            var file:File = e.target as File;
            file = new File(file.nativePath + '/Project/')
            trace(file.nativePath);
            Main.saveFiles(file);
            return;
            /*
            var path:String = e.target.nativePath;
            var name:String = e.target.name;

            var dir:String = path.substr(0, path.length - name.length);
            trace(dir)

            var arr:Array = path.split('.')
            if(arr[arr.length-1] != 'rian')
                    path += '.rian';

            trace(path)
            */
        }
    }

    private function onLoad(event:MouseEvent):void
    {
        var myFile:File = File.documentsDirectory;
        myFile.browseForOpen("Select one file", [ new FileFilter("RIAN Files", "*.rian")])
        myFile.addEventListener(Event.SELECT, selected);

        function selected(e:Event):void{
            trace("File: " + e.target.name + ", " + e.target.size + " bytes, Full path: " + e.target.nativePath);
            LoadFile.load(e.target.nativePath);
        }
    }
}
}
