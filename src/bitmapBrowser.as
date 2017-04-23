package  {

import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.display.Sprite;


import flash.display.Loader;
import flash.events.EventDispatcher;
import flash.events.ProgressEvent;
import flash.display.LoaderInfo;
import flash.net.FileFilter;
import flash.net.FileReference;
import flash.events.Event;
import flash.events.MouseEvent;

public class bitmapBrowser extends EventDispatcher
{
    //some event constants
    public static const LOADED:String = "eventImageLoaded";

    //actual image
    private var _image:Bitmap;
    protected var fileRef:FileReference;

    public function bitmapBrowser()
    {
        fileRef = new FileReference();
    }

    public function chooseFile(event:MouseEvent = null):void
    {
        fileRef.browse([new FileFilter("Images (*.jpg, *.jpeg, *.png, *.JPG)", "*.jpg;*.jpeg;*.png; *.JPG")]);
        fileRef.addEventListener(Event.SELECT, onFileSelect);
    }

    protected function onFileSelect(event:Event):void
    {
        fileRef.removeEventListener(Event.SELECT, onFileSelect);
        fileRef.addEventListener(Event.COMPLETE, onFileLoad);
        fileRef.addEventListener(ProgressEvent.PROGRESS, reportProgress);
        fileRef.load();
    }

    private function reportProgress(event:ProgressEvent):void
    {
        this.dispatchEvent(event.clone());
    }

    protected function onFileLoad(event:Event):void
    {
        fileRef.removeEventListener(Event.COMPLETE, onFileLoad);
        var image:Loader = new Loader();
        image.loadBytes(fileRef.data);
        image.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageParse);
    }

    protected function onImageParse(event:Event):void {
        var content:DisplayObject = LoaderInfo(event.target).content;
        _image = Bitmap(content);
        _image.smoothing = true;
        this.dispatchEvent(new Event(bitmapBrowser.LOADED));
    }

    public function get image():Bitmap{
        return _image;
    }

}
}