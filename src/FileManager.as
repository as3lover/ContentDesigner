/**
 * Created by SalmanPC3 on 4/24/2017.
 */
package
{
import flash.events.Event;
import flash.filesystem.File;
import flash.net.FileFilter;

import saveLoad.LoadFile;

import src2.Utils;

public class FileManager
{
    private static var _fileForSave:FileForSave = new FileForSave();
    private static var _fileForSavePDF:FileForSave = new FileForSave('pdf', ['pdf'], 'summary', 'Export PDF');

    private static var _file:File;
    public static var folder:File = File.documentsDirectory;
    private static var retryFunction:Function;
    private static var _itemsFolder:String;

    public function FileManager()
    {
    }

    public static function newFile():void
    {
        ObjectManager.deselect();

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
        ObjectManager.deselect();

        if(Main.changed)
        {
            retryFunction = openFile;
            Main.alert();
            return
        }

        var newFile:File;

        if(file)
            newFile = FileManager.file.clone();
        else
            newFile = FileManager.folder.clone();

        newFile.browseForOpen("Select Rian file", [ new FileFilter("RIAN Files", "*.rian")])
        newFile.addEventListener(Event.SELECT, selected);

        function selected(e:Event):void
        {
            file = e.target as File;

            if(Utils.pathIsWrong(file.nativePath))
            {
                Main.alert('wrongFile');
                return;
            }

            Main.changed = false;
            LoadFile.load();
        }
    }

    public static function saveFile():void
    {
        Main.toExport = false;
        ObjectManager.deselect();

        if(file)
            Main.saveFiles();
        else
            saveAsFile();
    }

    public static function exportFile():void
    {
        Main.toExport = true;
        saveAs();
    }

    public static function exportPDF():void
    {
        _fileForSavePDF.addEventListener(Event.COMPLETE, savePDF);
        _fileForSavePDF.Select();
    }

    private static function savePDF(event:Event):void
    {
        _fileForSavePDF.removeEventListener(Event.COMPLETE, savePDF);

        if(Utils.pathIsWrong(_fileForSavePDF.file.nativePath))
        {
            Main.alert('wrongFile');
            return;
        }

        PdfGenerator.start(_fileForSavePDF.file);
    }


    public static function saveAsFile():void
    {
        Main.toExport = false;
        saveAs();
    }

    private static function saveAs():void
    {
        ObjectManager.deselect()//trace;

        _fileForSave.addEventListener(Event.COMPLETE, save);
        _fileForSave.Select();
    }

    private static function save(e:Event):void
    {
        _fileForSave.removeEventListener(Event.COMPLETE, save);
        file = _fileForSave.file;

        if(Utils.pathIsWrong(file.nativePath))
        {
            Main.alert('wrongFile');
            return;
        }

        folder = _fileForSave.folder;
        Main.changed = false;
        Main.saveFiles();
    }

    public static function closeFile():void
    {
        ObjectManager.deselect();

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
            + FileManager.file.name.split('.')[0] + foldername;
            trace('item folder:', _itemsFolder)
        }
        else
        {
            TitleBar.file = 'New Project';
            _itemsFolder = null;
        }
    }

    private static function get foldername():String
    {
        if(Main.toExport)
                return '';

        return '_files';
    }

    public static function get itemsFolder():String
    {
        return _itemsFolder;
    }
}
}
