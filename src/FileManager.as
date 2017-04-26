/**
 * Created by SalmanPC3 on 4/24/2017.
 */
package
{
import flash.events.Event;
import flash.filesystem.File;
import flash.net.FileFilter;

import saveLoad.LoadFile;

public class FileManager
{
    private static var _fileForSave:FileForSave = new FileForSave();

    private static var _file:File;
    public static var folder:File = File.documentsDirectory;
    private static var retryFunction:Function;
    private static var _itemsFolder:String;

    public function FileManager()
    {
    }

    public static function newFile():void
    {
        Main.transformer.deselect();

        if(Main.changed)
        {
            retryFunction = newFile;
            Main.alert();
            return;
        }

        file = null;
        Main.reset();
    }

    public static function openFile():void
    {
        Main.transformer.deselect();

        if(Main.changed)
        {
            retryFunction = openFile;
            Main.alert();
            return
        }

        var newFile:File

        if(file)
            newFile = FileManager.file.clone();
        else
            newFile = FileManager.folder.clone();

        newFile.browseForOpen("Select Rian file", [ new FileFilter("RIAN Files", "*.rian")])
        newFile.addEventListener(Event.SELECT, selected);

        function selected(e:Event):void
        {
            Main.changed = false;
            file = e.target as File;
            LoadFile.load();
        }
    }

    public static function saveFile():void
    {
        Main.transformer.deselect();

        if(file)
            Main.saveFiles();
        else
            saveAsFile();
    }

    public static function saveAsFile():void
    {
        Main.transformer.deselect();

        _fileForSave.addEventListener(Event.COMPLETE, save);
        _fileForSave.Select();
    }

    private static function save(e:Event):void
    {
        _fileForSave.removeEventListener(Event.COMPLETE, save);
        file = _fileForSave.file;
        folder = _fileForSave.folder;
        Main.changed = false;
        Main.saveFiles();
    }

    public static function closeFile():void
    {
        Main.transformer.deselect();

        if (Main.changed)
        {
            retryFunction = closeFile;
            Main.alert();
            return
        }

        Main.STAGE.nativeWindow.close();
    }

    public static function retry():void
    {
        Main.changed = false;
        retryFunction();
    }

    public static function get file():File
    {
        return _file;
    }

    public static function set file(value:File):void
    {
        _file = value;
        if(_file)
        {
            TitleBar.file = _file.nativePath;
            _itemsFolder = FileManager.file.nativePath.slice(0, FileManager.file.nativePath.length - FileManager.file.name.length)
            + FileManager.file.name.split('.')[0] + '_files';
            trace('item folder:', _itemsFolder)
        }
        else
        {
            TitleBar.file = 'New Project';
            _itemsFolder = null;
        }
    }

    public static function get itemsFolder():String
    {
        return _itemsFolder;
    }
}
}
