/**
 * Created by Morteza on 6/8/2017.
 */
package
{
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.OutputProgressEvent;
import flash.events.ProgressEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.utils.setTimeout;

import org.alivepdf.layout.Mode;

import org.alivepdf.layout.Orientation;
import org.alivepdf.layout.Position;
import org.alivepdf.layout.Resize;
import org.alivepdf.pdf.PDF;
import org.alivepdf.saving.Method;

import src2.Utils;

public class PdfGenerator
{
    private static var pdf:PDF;
    private static var len:int;
    private static var i:int;
    private static var _file:File;

    public function PdfGenerator()
    {
    }

    public static function start(file:File):void
    {
        len = Main.snapList.nums;
        if(len == 0)
                return;

        Main._progress.percent = 0;
        Main._progress.text = 'Creating PDF ...';

        pdf = new PDF(Orientation.LANDSCAPE);
        i = 0;
        _file = file;

        ObjectManager.deselect();

        setTimeout(create, 100);
    }

    private static function create():void
    {
        var index:int = Main.dragManager.parent.getChildIndex(Main.dragManager);

        var sprite = new Sprite();
        Main.dragManager.x = - Main.target.x;
        Main.dragManager.y = - Main.target.y;
        sprite.addChild(Main.dragManager);

        var scale:Number = 1.5;

        var mask:Sprite = new Sprite();
        Utils.drawRect(mask, 0, 0, Main.target.w * scale, Main.target.h * scale);
        sprite.addChild(mask);
        sprite.scaleX = sprite.scaleY = scale;
        sprite.mask = mask;

        var holder:Sprite = new Sprite();
        holder.addChild(sprite);

        var shot:Bitmap;
        setTimeout(nextPage, 20);

        function nextPage()
        {
            if(i == len)
            {
                finish();
                return;
            }

            Main.snapList.gotoItemTime(i);
            setTimeout(creteSnapShot, 20);
        }


        function creteSnapShot():void
        {
            var bitmapData:BitmapData = new BitmapData(mask.width, mask.height, false);
            bitmapData.draw(holder);
            shot = new Bitmap(bitmapData);

            setTimeout(addPage, 20);
        }


        function addPage():void
        {
            pdf.addPage();
            pdf.addImage(shot, new Resize(Mode.RESIZE_PAGE, Position.CENTERED));
            i++;

            Main._progress.percent = i/len;
            Main._progress.text = String(i) + ' / ' + String(len);

            if(i == len)
            {
                Main._progress.percent = 0;
                Main._progress.text = 'Saving...';
            }

            setTimeout(nextPage, 20);
        }


        function finish():void
        {
            Main.timeLine.parent.addChildAt(Main.dragManager, index);
            Main.dragManager.x = 0;
            Main.dragManager.y = 0;

            var file:File = File.createTempDirectory().resolvePath(_file.name);

            pdf.end();

            var fileStream:FileStream = new FileStream();
            fileStream.open(file, FileMode.WRITE);
            fileStream.writeBytes(pdf.save(Method.LOCAL));
            fileStream.close();

            var i:int = 2;
            var folder:String = _file.nativePath;
            var name:String = _file.name;
            folder = folder.slice(0, - name.length);
            name = name.substring(0, name.length-4);

            save();

            function save()
            {
                try
                {
                    file.copyTo(_file, true);
                    Main._progress.percent = 1;
                }
                catch (e:Error)
                {
                    trace('فایل ذخیره نمی شود', _file.nativePath);

                    if(e.errorID == 3012)
                    {
                        var s:String = _file.nativePath;
                        s = folder + name + '_' + String(i++) + '.pdf';
                        _file = new File(s);
                        setTimeout(save, 10);
                    }
                    else
                    {
                        Main._progress.percent = 1;
                        trace(e.toString());
                    }
                }
            }



        }
    }


}
}
