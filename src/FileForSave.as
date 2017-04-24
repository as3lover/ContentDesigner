/**
 * Created by SalmanPC3 on 4/24/2017.
 */
package
{
import flash.events.EventDispatcher;

public class FileForSave extends EventDispatcher
{
    import flash.filesystem.File;
    import flash.events.Event;

    private var _directory:File;
    private const EXTENSION:String = "rian";
    private const VALID_EXTENSIONS_LIST:Array = ["rian"];
    private const NAME:String = 'project';
    public var file:File;
    public var folder:File;

    public function Select():void
    {
        if(FileManager.file)
                _directory = FileManager.file.clone();
        else
            _directory = File.documentsDirectory.resolvePath(NAME + '.' + EXTENSION);

        _directory.browseForSave("Save As");
        _directory.addEventListener(Event.SELECT, mySaveHandler);
    }
    private function mySaveHandler(event:Event):void
    {
        _directory.removeEventListener(Event.SELECT, mySaveHandler);
        //Split the returned File native path to retrieve file name
        var tmpArr:Array = File(event.target).nativePath.split(File.separator);
        var fileName:String = tmpArr.pop();//remove last array item and return its content
        //Check if the extension given by user is valid, if not the default on is put.
        //(for example if user put himself/herself an invalid file extension it is removed in favour of the default one)
        var conformedFileDef:String = conformExtension(fileName);//comment: updated 17.11.2008 removed the typo
        tmpArr.push(conformedFileDef);
        //Create a new file object giving as input our new path with conformed file extension
        file = new File("file:///" + tmpArr.join(File.separator));
        getFolderFromFile(file);
        dispatchEvent(new Event(Event.COMPLETE));
        //Make save
        /*
        var stream:FileStream = new FileStream();
        stream.open(conformedFile, FileMode.WRITE);
        stream.writeUTFBytes("demo demo demo demo demo demo demo demo demo");
        stream.close();
        */
    }

    private function getFolderFromFile(file:File):void
    {
        var path:String = file.nativePath;
        var name:String = file.name;
        var path:String = path.slice(0, - name.length);
        folder = new File(path);
    }
    private function conformExtension(fileDef:String):String
    {
        var fileExtension:String = fileDef.split(".")[1];
        for each(var it:String in VALID_EXTENSIONS_LIST){
            if( fileExtension == it)
                return fileDef;

        }
        return fileDef.split(".")[0] + "." + EXTENSION;
    }
}
}
