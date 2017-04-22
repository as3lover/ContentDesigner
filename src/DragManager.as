package {

import fl.controls.ColorPicker;
import fl.events.ColorPickerEvent;

import flash.desktop.ClipboardFormats;
import flash.desktop.NativeDragManager;
import flash.display.Bitmap;
import flash.display.Loader;
import flash.display.Shape;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.events.NativeDragEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.geom.Point;
import flash.utils.ByteArray;

import items.Item;

import org.log5f.air.extensions.mouse.INativeMouse;

import org.log5f.air.extensions.mouse.NativeMouse;
import org.log5f.air.extensions.mouse.events.NativeMouseEvent;

import src2.Utils;

public class DragManager extends Sprite
{
    private var _target:Sprite;
    private var _moveBitmap:Bitmap;
    private var _loader:Loader;
    private var onAddObject:Function;
    private var lastFile:String;
    private var _mask:Shape;
    private var _removeAnimation:Function;
    private var _soundPath:String;
    private var numOfObject:int = 0;
    private var _width:int;
    private var _height:int;
    private var _color:uint;

    public function DragManager(x:int, y:int, width:int, height:int, onAddObject:Function, stage:Stage, removeAnimation:Function)
    {
        this.onAddObject = onAddObject;
        this._removeAnimation = removeAnimation;

        _width = width;
        _height = height;

        _target = new Sprite();
        this.color = 0xffffff;
        _target.x = x;
        _target.y = y;
        _target.width = width;
        _target.height = height;
        _target.name = 'target';
        this.addChild(_target);

        _mask = new Shape();
        Utils.drawRect(_mask, x, y, width, height);
        this.addChild(_mask);
        _target.mask = _mask;
        //
        _loader = new Loader();
        //
        stage.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, dragEnterHandler);

        _nativeMouse = new NativeMouse();

        var color:ColorPicker = new ColorPicker();
        color.editable = true;
        color.move(10, 10);
        color.x = _target.x;
        color.y = _target.y + _target.height + 10;
        Main.topics.parent.addChild(color);
        color.addEventListener(ColorPickerEvent.CHANGE, changeColor);
    }

    private function changeColor(e:ColorPickerEvent):void
    {
        color = uint("0x" + e.target.hexValue);
    }

    public function set color(color:uint):void
    {
        _color = color;
        _target.graphics.lineStyle(1, 0x0, 1);
        _target.graphics.beginFill(color, 1);
        _target.graphics.drawRect(0, 0, _width, _height);
    }

    public function get color():uint
    {
        return _color;
    }

    private var currentFile:File;
    private var _nativeMouse:NativeMouse;
    private var _inTarget:Boolean;

    private function dragEnterHandler(event:NativeDragEvent):void
    {
        //trace('dragEnterHandler');

        var files:Array = event.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
        currentFile = files[0];
        var arrPath:Array = currentFile.name.split('.');
        var type:String = String(arrPath[arrPath.length-1]).toLowerCase();
        if (!currentFile.isDirectory && (type == 'mp3'))
        {
            NativeDragManager.acceptDragDrop(_target);
            _soundPath = String(currentFile.nativePath);
            stage.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP, dropSound);
        }
        else if (!currentFile.isDirectory && (type == 'png' || type == 'jpg' || type == 'jpeg' || type == 'bmp'))
        {
            NativeDragManager.acceptDragDrop(_target);
            addListeners();

            if(_moveBitmap != null && lastFile == currentFile.nativePath)
            {
                _target.addChild(_moveBitmap);
                return;
            }
            //
            trace('\t new');
            lastFile = currentFile.nativePath;

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

            if (NativeMouse.isSupported())
            {
                _nativeMouse.addEventListener(NativeMouseEvent.NATIVE_MOUSE_UP, nativeMouseHandler);
                _nativeMouse.captureMouse();
            }

        }

    }

    private function nativeMouseHandler(event:NativeMouseEvent):void
    {
        //trace('up')
        _nativeMouse.removeEventListener(NativeMouseEvent.NATIVE_MOUSE_DOWN, nativeMouseHandler);
        _nativeMouse.releaseMouse();

        if(_inTarget)
        {
            dragDropHandler();
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
            _moveBitmap.scaleX = .5;
            _moveBitmap.scaleY = .5;
        }
    }

    private function loadCompleteHandler(event:Event):void
    {
        //trace('loadCompleteHandler');

        _loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadCompleteHandler);

        var content:Bitmap = (_loader.content) as Bitmap;
        if(!content)
        {
            removeListenrs();
            return;
        }
        _moveBitmap.bitmapData = content.bitmapData;
        _moveBitmap.smoothing = true;
        _moveBitmap.alpha = .8;

        _moveBitmap.scaleX = .5;
        _moveBitmap.scaleY= .5;
    }
    private function dragOverHandler(event:NativeDragEvent):void
    {
       // //trace('dragOverHandler');

    }
    private function dragDropHandler(event:NativeDragEvent=null):void
    {
        //trace('dragDropHandler');

        removeListenrs();

        _inTarget = false;

        if(_moveBitmap == null)
                return;

        _moveBitmap.alpha = 1;

        var holder:Item = new Item(_removeAnimation,lastFile);
        holder.name = 'object_(' + String(++numOfObject) + ')';
        holder.x = _moveBitmap.x + _moveBitmap.width/2;
        holder.y = _moveBitmap.y + _moveBitmap.height/2;
        _target.addChild(holder);

        _moveBitmap.x = -_moveBitmap.width/2;
        _moveBitmap.y = -_moveBitmap.height/2;
        holder.bitmap = _moveBitmap;

        onAddObject(holder);

        _moveBitmap = null;

    }

    private function dragExitHandler(e:NativeDragEvent):void
    {
        //trace('dragExitHandler');
        if(_moveBitmap.parent)
        {
            if (e.stageX < _mask.x || e.stageX > _mask.x + _mask.width ||
                e.stageY < _mask.y || e.stageY > _mask.y + _mask.height)
            {
                _moveBitmap.parent.removeChild(_moveBitmap);
                _inTarget = false;
            }
            else
            {
                _inTarget = true;
                //dragDropHandler();
                return;
            }
        }

        removeListenrs();
    }

    private function addListeners():void
    {
        stage.addEventListener(NativeDragEvent.NATIVE_DRAG_OVER, dragOverHandler);
        stage.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP, dragDropHandler);
        stage.addEventListener(NativeDragEvent.NATIVE_DRAG_EXIT, dragExitHandler);
        stage.addEventListener(Event.ENTER_FRAME, enterFrame)
    }

    private function removeListenrs():void
    {
        stage.removeEventListener(NativeDragEvent.NATIVE_DRAG_OVER, dragOverHandler);
        stage.removeEventListener(NativeDragEvent.NATIVE_DRAG_DROP, dragDropHandler);
        stage.removeEventListener(NativeDragEvent.NATIVE_DRAG_EXIT, dragExitHandler);
        stage.removeEventListener(Event.ENTER_FRAME, enterFrame);
    }

    public function get target():Sprite
    {
        return _target;
    }

    private function dropSound(event:NativeDragEvent):void
    {
        stage.removeEventListener(NativeDragEvent.NATIVE_DRAG_DROP, dropSound);
        Main.timeLine.sound = _soundPath;
    }

    public function reset():void
    {
        var i:int = _target.numChildren - 1;
        for(i; i>-1; i--)
        {
            if(_target.getChildAt(i) is Item)
            {
                _target.removeChildAt(i);
            }
        }
    }

}
}