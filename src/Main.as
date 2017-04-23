package {

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.ContextMenuEvent;
import flash.events.MouseEvent;
import flash.filesystem.File;
import flash.ui.ContextMenu;
import flash.ui.ContextMenuItem;

import items.Item;
import items.TextItem;

import saveLoad.LoadFile;

import saveLoad.SaveFile;

import src2.AnimateObject;

import src2.Buttons;
import src2.HightLigher;
import src2.Topics;
import src2.Utils;

import texts.MainTextEditor;

import texts.TextEditor;


[SWF(width="800", height="450", frameRate=60, backgroundColor='0x444444')]

public class Main extends Sprite
{
    public static var timeLine:TimeLine;
    public static var dragManager:DragManager;
    public static var transformer:TransformManager;
    public static var animationControl:AnimationControl;
    public static var topics:Topics;
    public static var textEditor:TextEditor;
    private static var _sprite:Sprite;
    public static var panel:Panel;
    public static var _progress:progressBar;

    public function Main()
    {
        new Keyboard(stage);
        //new FileReferenceExample2();
        //return;
        animationControl = new AnimationControl();

        topics = new Topics();
        topics.x = 650
        topics.y = 100;
        addChild(topics);

        dragManager = new DragManager(20,40,600, 337, addObject, stage, removeAnimation);
        addChild(dragManager);

        transformer = new TransformManager(stage, dragManager.target);

        timeLine = new TimeLine(transformer, updateAnimation);
        addChild(timeLine);

        new TitleBar(stage, this);


        var _buttons:Buttons = new Buttons(stage);
        addChild(_buttons);
        _buttons.x = 700;
        _buttons.y = 20;


        //////////// MENU //////////
        var menu = new ContextMenu();

        var textbox = new ContextMenuItem("Add Text");
        textbox.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, addText);
        menu.customItems.push(textbox);
        function addText(e:ContextMenuEvent):void
        {
            addObject(new TextItem(removeAnimation, true))
        }

        var topic = new ContextMenuItem("Add Topic");
        topic.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, addTopic);
        menu.customItems.push(topic);
        function addTopic(e:ContextMenuEvent):void
        {
            Main.topics.add(Utils.time);
        }

        var hideAll = new ContextMenuItem("Hide All");
        hideAll.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, HideAll);
        menu.customItems.push(hideAll);
        function HideAll(e:ContextMenuEvent):void
        {
            animationControl.hideAll();
        }

        var hideSome = new ContextMenuItem("Hide Items by Click");
        hideSome.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, HideSome);
        menu.customItems.push(hideSome);
        function HideSome(e:ContextMenuEvent):void
        {
            HightLigher.add(dragManager, .1)
            stage.addEventListener(MouseEvent.MOUSE_DOWN, onDown, true);
            function onDown(e:MouseEvent):void
            {
                var item;

                if(e.target is Item)
                        item = e.target;
                else
                    item = Utils.isParentOf(stage, Item, e.target as DisplayObject);

                if(item)
                {
                    item.Hide();
                    item.alpha = 0;
                }
                else
                {
                    trace(e.target, e.target.parent, e.target.parent.parent);
                    HightLigher.add(null);
                    stage.removeEventListener(MouseEvent.MOUSE_DOWN, onDown, true);
                    timeLine.setTimeByTopic(Utils.time+.1);
                }
                e.stopImmediatePropagation();
            }
        }

        dragManager.target.contextMenu = menu;

        ////////////////////
        _sprite = new Sprite();
        _sprite.alpha = 0;
        _sprite.visible = false;
        Utils.drawRect(_sprite, 0, 0, 800, 450);
        addChild(_sprite);
        ///////////
        textEditor = new MainTextEditor();
        addChild(textEditor);

        //////////////
        panel = new Panel();
        panel.x = dragManager.target.x + dragManager.target.width;
        panel.y = dragManager.target.y;
        addChild(panel);


        _progress = new progressBar();
        addChild(_progress);

        LoadFile.load();
    }

    public static function addObject(object:Item):void
    {
        transformer.add(object);
        animationControl.add(object, timeLine.currentSec)
    }


    private function updateAnimation(seconds:Number):void
    {
        transformer.deselect();
        animationControl.time = seconds;
        topics.time = seconds;
    }

    public static function removeAnimation(item:Item):void
    {
       animationControl.removeAnimation(item)
    }

    public static function hightLight(Class = null):void
    {
        var obj = null;
        switch(Class)
        {
            case TimeLine:
                obj = timeLine;
                break;
        }

        HightLigher.add(obj)
    }


    public static function close(closeFunc:Function):void
    {
        transformer.deselect();
        SaveFile.save(animationControl.saveObject, Utils.time, closeFunc, animationControl.savedDirectory, true)
    }

    public static function save():void
    {
        transformer.deselect();
    }

    public static function saveFiles(directory:File):void
    {
        animationControl.saveFiles(directory.nativePath);
    }

    public static function setDir(path:String):void
    {
        animationControl.savedDirectory = path;
    }

    public static function reset():void
    {
        animationControl.reset();
        transformer.reset();
        dragManager.reset();
    }

    public static function set active(value:Boolean):void
    {
        _sprite.visible = !value;
    }

}
}
