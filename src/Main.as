package {

import components.ColorPicker;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.ContextMenuEvent;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.ui.ContextMenu;
import flash.ui.ContextMenuItem;
import items.Item;
import items.ItemText;
import items.TextItem;
import items.TimePanel;

import quizz.Quiz;

import src2.HightLigher;
import src2.SnapList;
import src2.ToolTip;
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
    private static var _changed:Boolean = false;
    public static var _alert:AlertBox;
    public static var STAGE:Stage;
    public static var MAIN:Main;
    public static var colorPicker:ColorPicker;
    public static var timePanel:TimePanel;
    public static var snapList:SnapList;
    public static var quiz:Quiz;
    public static const target:Object = {x:20, y:40, w:600, h:337};
    public static var loadedTime:Number;

    public function Main()
    {
        colorPicker = new ColorPicker();
        addChild(colorPicker);
        colorPicker.x = target.x + target.w/2;
        colorPicker.y = target.y + target.h/2;

        this.addEventListener(Event.ADDED_TO_STAGE, init);
    }

    private function init(event:Event):void
    {
        STAGE = stage;
        MAIN = this;

        quiz = new Quiz();

        ToolTip.start(stage);

        _alert = new AlertBox();
        addChild(_alert);

        new Keyboard(stage);
        //new FileReferenceExample2();
        //return;
        animationControl = new AnimationControl();


        dragManager = new DragManager(20,40,600, 337, addObject, stage, removeAnimation);
        addChild(dragManager);

        topics = new Topics();
        topics.x = 680
        topics.y = dragManager.target.y;
        addChild(topics);
        topics.init();

        snapList = new SnapList();
        snapList.x = 640;
        snapList.y = dragManager.target.y;
        addChild(snapList);
        snapList.init();



        transformer = new TransformManager(stage, dragManager.target);

        timeLine = new TimeLine(transformer, updateAnimation);
        addChild(timeLine);

        new TitleBar(stage, this);


        //////////// MENU //////////
        var menu = new ContextMenu();

        var textbox = new ContextMenuItem("Add Text");
        textbox.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, addText);
        menu.customItems.push(textbox);
        function addText(e:ContextMenuEvent):void
        {
            Main.changed = true;
            //addObject(new TextItem(removeAnimation, true))
            addObject(new ItemText(removeAnimation, true))
        }

        var topic = new ContextMenuItem("Add Topic");
        topic.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, addTopic);
        menu.customItems.push(topic);
        function addTopic(e:ContextMenuEvent):void
        {
            Main.changed = true;
            Main.topics.add(Utils.time);
        }

        var quize = new ContextMenuItem("Add Quiz");
        quize.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, addQuiz);
        menu.customItems.push(quize);
        function addQuiz(e:ContextMenuEvent):void
        {
            Main.changed = true;
            Main.topics.addQuiz(Utils.time);
        }

        var timeSnap = new ContextMenuItem("Snapshot");
        timeSnap.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, TimeSnap);
        menu.customItems.push(timeSnap);
        function TimeSnap(e:ContextMenuEvent):void
        {
            Main.changed = true;
            snapList.add();
        }

        var hideAll = new ContextMenuItem("Hide All");
        hideAll.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, HideAll);
        menu.customItems.push(hideAll);
        function HideAll(e:ContextMenuEvent):void
        {
            Main.changed = true;
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

        var back = new ContextMenuItem("Background Image ...");
        back.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, Back);
        menu.customItems.push(back);

        var bit:bitmapBrowser = new bitmapBrowser();
        function Back(event:ContextMenuEvent):void
        {
            bit.addEventListener(bitmapBrowser.LOADED, loadedBack);
            bit.chooseFile();
        }
        function loadedBack(e):void
        {
            bit.removeEventListener(bitmapBrowser.LOADED, loadedBack);
            dragManager.setBack(bit.image);
        }

        back = new ContextMenuItem("Remove Background");
        back.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, Back1);
        menu.customItems.push(back);

        function Back1(e):void
        {
            dragManager.setBack(null);
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

        timePanel = new TimePanel();
        timePanel.x = dragManager.target.x + dragManager.target.width;
        timePanel.y = dragManager.target.y;
        addChild(timePanel);

        panel = new Panel();
        panel.x = timePanel.x
        panel.y = timePanel.y + timePanel.height - 10;
        addChild(panel);


        _progress = new progressBar();
        addChild(_progress);

        //LoadFile.load();
    }


    public static function addObject(object:Item):void
    {
        Main.changed = true;
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
        Main.changed = true;
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
        FileManager.closeFile();
    }

    public static function save():void
    {
        transformer.deselect();
    }

    public static function saveFiles():void
    {
        Main.changed = false;
        animationControl.saveFiles();
    }

    public static function setDir(path:String):void
    {
        animationControl.savedDirectory = path;
    }

    public static function reset():void
    {
        timeLine.reset();
        animationControl.reset();
        transformer.reset();
        dragManager.reset();
        topics.reset();
        snapList.reset();
        Main.changed = false;
    }

    public static function set active(value:Boolean):void
    {
        _sprite.visible = !value;
    }

    public static function set changed(value:Boolean):void
    {
        //trace('changed', value)
        _changed = value;
        TitleBar.changed = value;
    }

    public static function get changed():Boolean
    {
        return _changed;
    }


    public static function alert(type:String = 'save'):void
    {
        _alert.alert(type);

    }

    public static function disable():void
    {
        _progress.disableApp();
    }

    public static function enable():void
    {
        _progress.enableApp();
    }
}
}
