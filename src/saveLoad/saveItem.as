/**
 * Created by Morteza on 4/18/2017.
 */
package saveLoad
{
import com.greensock.motionPaths.PathFollower;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.filesystem.File;
import flash.utils.setTimeout;

public class saveItem extends EventDispatcher
{
    public function saveItem()
    {
    }

    public static function copyAndRename(currentPath:String, newDir:String, newName:String, pathHolder:Object, afterCopy:Function):void
    {
        trace('copy', currentPath);
        var newPath:String = newDir + newName;
        if(newPath == currentPath)
        {
            pathHolder.newPath = newPath;
            pathHolder.currentPath = currentPath;
            afterCopy();
            return;
        }

        var file = new File(currentPath);
        var temp:File = File.createTempDirectory();
        var des:File = new File(temp.nativePath + '/' + file.name);

        if(currentPath.search(newDir) >= 0)
            file.moveTo(des, true);
        else
            file.copyTo(des, true);


        setTimeout(t,10);
        function t()
        {
            if(des.exists)
                rename();
            else
                setTimeout(t,10);
        }

        function rename()
        {
            file = des;
            des = new File(temp.nativePath + '/' + newName);

            try
            {
                file.moveTo(des, true);
                trace('rename from', file.nativePath);
                trace('rename to', des.nativePath);
            }
            catch (e){}

            setTimeout(tt,10);
            function tt()
            {
                if(des.exists)
                {
                    pathHolder.currentPath = des.nativePath;
                    pathHolder.newPath = newDir + '/' + newName;
                    afterCopy();
                }
                else
                {
                    setTimeout(tt,10);
                }
            }
        }
    }

    public static function move(path1:String, path2:String, afterMove:Function)
    {
        var file1:File = new File(path1);
        if(!file1.exists || path1 == path2)
        {
            afterMove();
            return;
        }

        var file2:File = new File(path2);

        file1.moveTo(file2, true);

        setTimeout(t,10);
        function t()
        {
            if(file2.exists)
            {
                afterMove();
            }
            else
            {
                setTimeout(t,10);
            }
        }
    }
}
}
