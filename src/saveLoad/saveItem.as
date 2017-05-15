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
        var newPath:String = newDir +'/' +newName;
        if(newPath == currentPath)
        {
            pathHolder.newPath = newPath;
            pathHolder.currentPath = currentPath;
            afterCopy();
            return;
        }

        var file:File = new File(currentPath);
        var temp:File = File.createTempDirectory();
        var des:File = new File(temp.nativePath + '/' + file.name);

        try
        {
            file.copyTo(des, true);
        }
        catch (e)
        {
            trace('can not copy', file.nativePath);
            pathHolder.newPath = currentPath;
            pathHolder.currentPath = currentPath;
            afterCopy();
            return;
        }


        var n:int = 0;
        setTimeout(t,1);
        function t():void
        {
            if(des.exists)
                rename();
            else
            {
                trace('...RETRY...');
                n++;
                if(n < 300)
                {
                    setTimeout(t,10);
                }
                else
                {
                    pathHolder.newPath = currentPath;
                    pathHolder.currentPath = currentPath;
                    afterCopy();
                    return;
                }
            }
        }

        function rename():void
        {
            file = des;
            des = new File(temp.nativePath + '/' + newName);

            if(file.nativePath != des.nativePath)
            {
                try
                {
                    file.moveTo(des, true);
                }
                catch (e)
                {
                    trace('can not rename from', file.nativePath);
                    trace('                 to', des.nativePath);
                    pathHolder.newPath = currentPath;
                    pathHolder.currentPath = currentPath;
                    afterCopy();
                    return;
                }
            }

            var n:int = 0;
            setTimeout(tt,1);
            function tt():void
            {
                if(des.exists)
                {
                    pathHolder.currentPath = des.nativePath;
                    pathHolder.newPath = newDir + '/' + newName;
                    afterCopy();
                }
                else
                {
                    trace('...RETRY 2...');
                    n++;
                    if(n < 300)
                    {
                        setTimeout(tt,10);
                    }
                    else
                    {
                        trace('ERROR 5', des.nativePath , 'not Exists');
                        pathHolder.newPath = currentPath;
                        pathHolder.currentPath = currentPath;
                        afterCopy();
                        return;
                    }
                }
            }
        }
    }

    public static function move(path1:String, path2:String, afterMove:Function):void
    {
        var file1:File = new File(path1);
        if(!file1.exists || path1 == path2)
        {
            afterMove();
            return;
        }

        var file2:File = new File(path2);

        try
        {
            file1.moveTo(file2, true);
        }
        catch (e)
        {
            trace('can not move:');
            trace('move from', file1.nativePath);
            trace('move to  ', file2.nativePath);

            if(file2.exists)
            {
                trace('file2 exists');
                try
                {
                    file1.deleteFile();
                }
                catch (e)
                {
                    trace('can not delete file1', file1.nativePath)
                }
            }
            else
            {
                try
                {
                    file1.copyTo(file2, true);
                    trace('copy file1 to file2')
                }
                catch(e)
                {
                    trace('can not copy file:');
                    trace('file1:', file1.nativePath);
                    trace('file2:', file2.nativePath);
                }
            }
        }

        setTimeout(t,1);
        function t():void
        {
            if(file2.exists)
            {
                afterMove();
            }
            else
            {
                trace('...RETRY 3...');
                setTimeout(t,10);
            }
        }
    }
}
}
