package {

import flash.desktop.ClipboardFormats;
import flash.desktop.NativeDragManager;
import flash.display.Bitmap;
import flash.display.Loader;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.NativeDragEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.utils.ByteArray;

public class DragManager extends Sprite
{
    private var target:Sprite;
    private var moveBitmap:Bitmap;
    private var loader:Loader;
    public function DragManager()
    {
        target = new Sprite();
        target.graphics.lineStyle(1, 0x0, 1);
        target.graphics.beginFill(0xffffff, 1);
        target.graphics.drawRect(0, 0, 100, 100);
        target.x = 100;
        target.y = 100;
        this.addChild(target);
        //
        moveBitmap = new Bitmap();
        moveBitmap.x = target.x;
        moveBitmap.y = target.y;
        this.addChild(moveBitmap);
        //
        loader = new Loader();
        //
        target.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, dragEnterHandler);
    }

    private var currentFile:File;
    private function dragEnterHandler(event:NativeDragEvent):void
    {
        moveBitmap.bitmapData = null;
        //
        var files:Array = event.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
        currentFile = files[0];
        var arrPath:Array = currentFile.name.split('.');
        var type:String = arrPath[arrPath.length-1];
        if (!currentFile.isDirectory && (type == 'png' || type == 'jpg')) {
            NativeDragManager.acceptDragDrop(target);
            //
            var stream:FileStream = new FileStream();
            stream.open(currentFile, FileMode.READ);
            var bytes:ByteArray = new ByteArray();
            stream.readBytes(bytes);
            stream.close();
            //
            loader.loadBytes(bytes);
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadCompleteHandler);
            //
            target.addEventListener(NativeDragEvent.NATIVE_DRAG_OVER, dragOverHandler);
            target.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP, dragDropHandler);
            target.addEventListener(NativeDragEvent.NATIVE_DRAG_EXIT, dragExitHandler);
        }
    }
    private function loadCompleteHandler(event:Event):void
    {
        var content:Bitmap = (loader.content) as Bitmap;
        moveBitmap.bitmapData = content.bitmapData;
        moveBitmap.width = target.width;
        moveBitmap.height = target.height;
        moveBitmap.smoothing = true;
        moveBitmap.alpha = 0.8;
    }
    private function dragOverHandler(event:NativeDragEvent):void
    {

    }
    private function dragDropHandler(event:NativeDragEvent):void
    {
        moveBitmap.alpha = 1;
        //
        target.removeEventListener(NativeDragEvent.NATIVE_DRAG_OVER, dragOverHandler);
        target.removeEventListener(NativeDragEvent.NATIVE_DRAG_DROP, dragDropHandler);
        target.removeEventListener(NativeDragEvent.NATIVE_DRAG_EXIT, dragExitHandler);
    }
    private function dragExitHandler(event:NativeDragEvent):void
    {
        moveBitmap.bitmapData = null;
        //
        target.removeEventListener(NativeDragEvent.NATIVE_DRAG_OVER, dragOverHandler);
        target.removeEventListener(NativeDragEvent.NATIVE_DRAG_DROP, dragDropHandler);
        target.removeEventListener(NativeDragEvent.NATIVE_DRAG_EXIT, dragExitHandler);
    }
}
}