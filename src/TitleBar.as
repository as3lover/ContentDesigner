/**
 * Created by Morteza on 4/5/2017.
 */
package
{
import com.greensock.TweenLite;

import flash.display.Bitmap;

import flash.display.DisplayObject;

import flash.display.Shape;
import flash.display.Sprite;
import flash.display.Stage;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;
import com.greensock.layout.*;

import flash.text.TextFormat;

import flash.utils.setTimeout;

import org.log5f.air.extensions.mouse.NativeMouse;

import src2.Button;
import src2.Utils;

import src2.assets;


public class TitleBar extends Sprite
{
    private var _back:Shape;
    private var _minBt:Sprite;
    private var _maxBt:Sprite;
    private var _closeBt:Sprite;

    private var maximized:Boolean;
    private var _x:int;
    private var _y:int;

    private var _main:Sprite;
    private var _area:Shape;
    private var _sizeBt:Button;
    private var _mouseX:Number;
    private var _mouseY:Number;
    private var _width:Number;
    private var _height:Number;
    private var _newWidth:Number;
    private var _newHeight:Number;
    private var _oldWidth:Number;
    private var _oldHeight:Number;
    private static var _file:String;
    public static var _title:TextField;
    private static var _format:TextFormat;
    private static var _activatedTitle:Boolean;
    private static const appName:String = 'Content Designer - ';

    public function TitleBar(stage:Stage, main:Sprite)
    {
        _main = main;
        stage.addChild(this);
        addEventListener(MouseEvent.MOUSE_DOWN, down);

        _area = new Shape();
        _area.visible = false;
        stage.addChildAt(_area, 0)
        Utils.drawRect(_area, 0, 0, 800, 450);

        _back = new Shape();
        addChild(_back);
        Utils.drawRect(_back, 0, 0, 800, 24, 0xcccccc);

        var t:TextField;

        var bit:Bitmap;

        _minBt = new Sprite();
        bit = new assets.Min();
        bit.smoothing = true;
        _minBt.addChild(bit)
        addChild(_minBt);

        _closeBt = new Sprite();
        bit = new assets.Close();
        bit.smoothing = true;
        _closeBt.addChild(bit)
        addChild(_closeBt);

        _maxBt = new Sprite();
        bit = new assets.Restore();
        bit.smoothing = true;
        _maxBt.addChild(bit)
        addChild(_maxBt);

        _minBt.width = _maxBt.width = _closeBt.width = 25;
        _minBt.height = _maxBt.height = _closeBt.height = 25;


        var file:Sprite = new Sprite();
        bit = new assets.File();
        bit.smoothing = true;
        file.addChild(bit)
        bit.height = 24;
        bit.scaleX = bit.scaleY;
        new FileMenu(stage, file);
        addChild(file);

        _title = new TextField();
        _title.x = file.width + 10;
        _title.y = 3;
        _title.height = 20;
        _title.width = stage.fullScreenWidth;
        _title.selectable = false;
        addChildAt(_title,1);

        _format = new TextFormat();
        _format.font = "Tahoma";
        _format.size = 12;
        _format.color = 0x898989;


        _sizeBt = new Button('.');
        addChild(_sizeBt);
        _sizeBt.addEventListener(MouseEvent.MOUSE_DOWN, onSizeBt);


        _minBt.addEventListener(MouseEvent.CLICK, minimize);
        _maxBt.addEventListener(MouseEvent.CLICK, maximize_restore);
        _closeBt.addEventListener(MouseEvent.CLICK, close);

        setPositions();

        stage.scaleMode = StageScaleMode.NO_SCALE;
        //stage.addEventListener(Event.RESIZE, onResize);
        stage.align = StageAlign.TOP_LEFT;

        maximized = false;

        TitleBar.file = 'New Project';

        addEventListener(Event.ACTIVATE, initWindowName);
    }

    protected function initWindowName(event:Event):void
    {


        _activatedTitle = true;
        changed = Main.changed;
    }

    private function onSizeBt(e:MouseEvent = null):void
    {
        if (!NativeMouse.isSupported())
            return;


        var info:Object = new NativeMouse().getMouseInfo();
        _mouseX = info.mouseX
        _mouseY = info.mouseY;
        _width = stage.nativeWindow.width;
        _height = stage.nativeWindow.height;
        trace('start', _width, _height);
        addEventListener(Event.ENTER_FRAME, resizing);
        stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
    }

    private function resizing(event:Event):void
    {
        var info:Object = new NativeMouse().getMouseInfo();
        _newWidth = _width + info.mouseX - _mouseX;
        _newHeight = _height + info.mouseY - _mouseY;

        if(_newWidth != _oldWidth || _newHeight != _oldHeight)
        {
            stage.nativeWindow.width = _newWidth;
            stage.nativeWindow.height = _newHeight;
            _oldWidth = _newWidth;
            _oldHeight = _newHeight;
            onResize();
        }


    }

    private function onUp(event:MouseEvent):void
    {
        removeEventListener(Event.ENTER_FRAME, resizing);
        stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
    }


    private function onResize(event:Event=null):void
    {
        _back.width = stage.nativeWindow.width;
        setPositions();
    }

    private function setPositions():void
    {
        _closeBt.x =  _back.width - _closeBt.width - 4;
        _minBt.x =  _closeBt.x - _minBt.width - 4;
        _maxBt.x =  _minBt.x - _maxBt.width - 4;

        _sizeBt.x = _closeBt.x;
        _sizeBt.y = stage.nativeWindow.height - 30;

        resizeMain();

    }

    private function resizeMain():void
    {
        var area:AutoFitArea = new AutoFitArea(stage, 0, 0, stage.nativeWindow.width, stage.nativeWindow.height);
        area.attach(_area);

        _main.x = _area.x;
        _main.y = _area.y;
        _main.scaleX = _area.scaleX;
        _main.scaleY = _area.scaleY;

        //TweenLite.to(_main, .25, {x:_area.x, y:_area.y, scaleX:_area.scaleX, scaleY:_area.scaleY})
    }

    private function down(e:MouseEvent):void
    {
        if(mouseY <= _back.height)
            stage.nativeWindow.startMove();
    }

    private function minimize(e:MouseEvent = null):void
    {
        stage.nativeWindow.minimize();
    }

    private function maximize_restore(e:MouseEvent = null):void
    {
        if(maximized)
        {
            maximized = false;
            restore();
        }
        else
        {
            maximized = true;
            maximize();
        }

    }

    private function restore(e:MouseEvent = null):void
    {
        /*
         stage.nativeWindow.x = _x;
         stage.nativeWindow.y = _y;
         stage.nativeWindow.width = 800;
         stage.nativeWindow.height = 450;
         stage.nativeWindow.restore();
         */
        TweenLite.to(stage.nativeWindow, .45, {x:_x, y:_y, width:800, height:450, onComplete:stage.nativeWindow.restore})
        TweenLite.to(_main, .5, {onUpdate:onResize})
    }

    private function maximize():void
    {
        _x = stage.nativeWindow.x;
        _y = stage.nativeWindow.y;
        /*
         stage.nativeWindow.x = 0;
         stage.nativeWindow.y = 0;
         stage.nativeWindow.width = stage.fullScreenWidth;
         stage.nativeWindow.height = stage.fullScreenHeight;
         stage.nativeWindow.maximize();
         */
        TweenLite.to(stage.nativeWindow, .45, {x:0, y:0, width:stage.fullScreenWidth, height:stage.fullScreenHeight-30, onComplete:stage.nativeWindow.maximize})
        TweenLite.to(_main, .5, {onUpdate:onResize})
    }

    private function close(e:MouseEvent = null):void
    {
        Main.close(stage.nativeWindow.close);
        //stage.nativeWindow.close();
    }

    public static function set file(file:String):void
    {
        _file = file;
        changed = Main.changed;
    }

    public static function set changed(changed:Boolean):void
    {
        if(changed)
            title = appName +_file + '*';
        else
            title = appName +_file;
    }

    private static function set title(text:String):void
    {
        if(_title)
        {
            _title.text = text;
            _title.setTextFormat(_format);
        }
        else
                trace('No')

        if(_activatedTitle && Main.STAGE)
            Main.STAGE.nativeWindow.title = text;
    }
}
}
