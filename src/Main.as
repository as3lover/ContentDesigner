package {

import flash.display.Sprite;
import flash.events.ContextMenuEvent;
import flash.filesystem.File;
import flash.ui.ContextMenu;
import flash.ui.ContextMenuItem;


[SWF(width="800", height="450", frameRate=60, backgroundColor='0xabcde')]

public class Main extends Sprite
{
    public static var timeLine:TimeLine;
    public static var dragManager:DragManager;
    public static var transformer:TransformManager;
    public static var animationControl:AnimationControl;
    public static var topics:Topics;
    public static var textEditor:TextEditor;
    private static var _sprite:Sprite;

    public function Main()
    {
        //new FileReferenceExample2();
        //return;
        animationControl = new AnimationControl();

        topics = new Topics();
        topics.x = 650
        topics.y = 100;
        addChild(topics);

        dragManager = new DragManager(20,40,600, 337, onAddObject, stage, removeAnimation);
        addChild(dragManager);

        transformer = new TransformManager(stage, dragManager.target);

        timeLine = new TimeLine(transformer, updateAnimation);
        addChild(timeLine);

        new TitleBar(stage, this);


        var _buttons:Buttons = new Buttons(stage);
        addChild(_buttons);
        _buttons.x = 700;
        _buttons.y = 20;


        ////////////
        var menu = new ContextMenu();
        var topic = new ContextMenuItem("Add Topic");
        topic.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, addTopic);
        menu.customItems.push(topic);
        var textbox = new ContextMenuItem("Add Text");
        textbox.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, addText);
        menu.customItems.push(textbox);
        function addTopic(e:ContextMenuEvent):void
        {
            Main.topics.add(Utils.time);
        }
        function addText(e:ContextMenuEvent):void
        {
            onAddObject(new TextItem(removeAnimation, true))
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


        LoadFile.load();
    }

    private function onAddObject(object:Item):void
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
