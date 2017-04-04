package {

import flash.desktop.ClipboardFormats;
import flash.desktop.NativeDragManager;
import flash.display.Bitmap;
import flash.display.Loader;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.NativeDragEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.geom.Point;
import flash.utils.ByteArray;

import org.log5f.air.extensions.mouse.NativeMouse;

public class DragManager extends Sprite
{
    private var _target:Sprite;
    private var _moveBitmap:Bitmap;
    private var _loader:Loader;

    public function DragManager(x:int, y:int, width:int, height:int)
    {
        _target = new Sprite();
        _target.graphics.lineStyle(1, 0x0, 1);
        _target.graphics.beginFill(0xffffff, 1);
        _target.graphics.drawRect(0, 0, 1920, 1080);
        _target.x = x;
        _target.y = y;
        _target.width = width;
        _target.height = height;
        this.addChild(_target);

        var mask:Shape = new Shape();
        Utils.drawRect(mask, x, y, width, height);
        this.addChild(mask);
        _target.mask = mask;
        //
        _loader = new Loader();
        //
        addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, dragEnterHandler);
    }

    private var currentFile:File;
    private function dragEnterHandler(event:NativeDragEvent):void
    {
        if(_moveBitmap)
        {
            _target.addChild(_moveBitmap);
            NativeDragManager.acceptDragDrop(_target);
            addListeners();
            return;
        }

        var files:Array = event.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
        currentFile = files[0];
        var arrPath:Array = currentFile.name.split('.');
        var type:String = arrPath[arrPath.length-1];
        if (!currentFile.isDirectory && (type == 'png' || type == 'jpg')) {
            NativeDragManager.acceptDragDrop(_target);
            //
            _moveBitmap = new Bitmap();
            _moveBitmap.x = 0;
            _moveBitmap.y = 0;
            _target.addChild(_moveBitmap);
            //
            var stream:FileStream = new FileStream();
            stream.open(currentFile, FileMode.READ);
            var bytes:ByteArray = new ByteArray();
            stream.readBytes(bytes);
            stream.close();
            //
            _loader.loadBytes(bytes);
            _loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadCompleteHandler);
            //
            addListeners();
        }

    }

    private function enterFrame(event:Event):void
    {
        if (NativeMouse.isSupported())
        {
            var info:Object = new NativeMouse().getMouseInfo();
            var point:Point = new Point(int(info.mouseX - stage.nativeWindow.x), int(info.mouseY-stage.nativeWindow.y));
            point = _target.globalToLocal(point);
            _moveBitmap.x = point.x;
            _moveBitmap.y = point.y;
        }
    }

    private function loadCompleteHandler(event:Event):void
    {
        _loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadCompleteHandler);

        var content:Bitmap = (_loader.content) as Bitmap;
        _moveBitmap.bitmapData = content.bitmapData;
        _moveBitmap.smoothing = true;
        _moveBitmap.alpha = 0.8;
    }
    private function dragOverHandler(event:NativeDragEvent):void
    {

    }
    private function dragDropHandler(event:NativeDragEvent):void
    {
        _moveBitmap.alpha = 1;
        _moveBitmap = null;
        removeListenrs();

    }
    private function dragExitHandler(event:NativeDragEvent):void
    {
        if(_moveBitmap.parent)
            _moveBitmap.parent.removeChild(_moveBitmap);

        removeListenrs();
    }

    private function addListeners():void
    {
        _target.addEventListener(NativeDragEvent.NATIVE_DRAG_OVER, dragOverHandler);
        _target.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP, dragDropHandler);
        _target.addEventListener(NativeDragEvent.NATIVE_DRAG_EXIT, dragExitHandler);
        stage.addEventListener(Event.ENTER_FRAME, enterFrame)
    }

    private function removeListenrs():void
    {
        _target.removeEventListener(NativeDragEvent.NATIVE_DRAG_OVER, dragOverHandler);
        _target.removeEventListener(NativeDragEvent.NATIVE_DRAG_DROP, dragDropHandler);
        _target.removeEventListener(NativeDragEvent.NATIVE_DRAG_EXIT, dragExitHandler);
        stage.removeEventListener(Event.ENTER_FRAME, enterFrame);
    }
}
}