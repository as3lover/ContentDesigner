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
    public static var toExport:Boolean;
    public static var count:int=0;
    public static var matched:int=0;

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


        timeLine = new TimeLine(updateAnimation);
        addChild(timeLine);

        new TitleBar(stage, this);


        //////////// MENU //////////
        var menu:ContextMenu = new ContextMenu();

        var textbox:ContextMenuItem = new ContextMenuItem("Text");
        textbox.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, addText);
        menu.customItems.push(textbox);
        function addText(e:ContextMenuEvent):void
        {
            Main.changed = true;
            //addObject(new TextItem(removeAnimation, true))
            //addObject(new ItemText(removeAnimation, true))
            new ItemText(removeAnimation, true);
        }

        var topic:ContextMenuItem = new ContextMenuItem("Topic");
        topic.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, addTopic);
        menu.customItems.push(topic);
        function addTopic(e:ContextMenuEvent):void
        {
            Main.changed = true;
            Main.topics.add(Utils.time);
        }

        var quize:ContextMenuItem = new ContextMenuItem("Quiz");
        quize.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, addQuiz);
        menu.customItems.push(quize);
        function addQuiz(e:ContextMenuEvent):void
        {
            Main.changed = true;
            Main.topics.addQuiz(Utils.time);
        }

        var timeSnap:ContextMenuItem = new ContextMenuItem("Snapshot");
        timeSnap.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, TimeSnap);
        menu.customItems.push(timeSnap);
        function TimeSnap(e:ContextMenuEvent):void
        {
            Main.changed = true;
            snapList.add();
        }

        var hideAll:ContextMenuItem = new ContextMenuItem("Hide All", true);
        hideAll.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, HideAll);
        menu.customItems.push(hideAll);
        function HideAll(e:ContextMenuEvent):void
        {
            Main.changed = true;
            animationControl.hideAll();
        }

        var showAll:ContextMenuItem = new ContextMenuItem("Show All");
        showAll.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, ShowAll);
        menu.customItems.push(showAll);
        function ShowAll(e:ContextMenuEvent):void
        {
            Main.changed = true;
            animationControl.showAll();
        }

        var hideAllNew:ContextMenuItem = new ContextMenuItem("Hide All (New Time)");
        hideAllNew.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, HideAllNew);
        menu.customItems.push(hideAllNew);
        function HideAllNew(e:ContextMenuEvent):void
        {
            Main.changed = true;
            animationControl.hideAllNew();
        }

        var showAllNew:ContextMenuItem = new ContextMenuItem("Show All (New Time)");
        showAllNew.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, ShowAllNew);
        menu.customItems.push(showAllNew);
        function ShowAllNew(e:ContextMenuEvent):void
        {
            Main.changed = true;
            animationControl.showAllNew();
        }

        var hideSome:ContextMenuItem = new ContextMenuItem("Hide Items by Click");
        hideSome.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, HideSome);
        menu.customItems.push(hideSome);
        function HideSome(e:ContextMenuEvent):void
        {
            HightLigher.add(dragManager, .1);
            stage.addEventListener(MouseEvent.MOUSE_DOWN, onDown, true);
            function onDown(e:MouseEvent):void
            {
                var item:Object;

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
                    //trace(e.target, e.target.parent, e.target.parent.parent);
                    HightLigher.add(null);
                    stage.removeEventListener(MouseEvent.MOUSE_DOWN, onDown, true);
                    timeLine.setTimeByTopic(Utils.time+.1);
                }
                e.stopImmediatePropagation();
            }
        }

        var back:ContextMenuItem = new ContextMenuItem("Background Image ...", true);
        back.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, Back);
        menu.customItems.push(back);

        var bit:bitmapBrowser = new bitmapBrowser();
        function Back(event:ContextMenuEvent):void
        {
            dragManager.loadNewBack();
            //bit.addEventListener(bitmapBrowser.LOADED, loadedBack);
            // bit.chooseFile();
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


        var paste:ContextMenuItem = new ContextMenuItem("Paste", true);
        paste.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, Paste);
        menu.customItems.push(paste);

        function Paste(e):void
        {
            ObjectManager.Paste(false, true);
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

        ObjectManager.start();


        _progress = new progressBar();
        addChild(_progress);

        //LoadFile.load();
        tabEnabled = false;
        tabChildren = false;
    }


    public static function addObject(object:Item, time:Number = -1):void
    {
        if(time == -1)
                time = timeLine.currentSec;

        Main.changed = true;
        object.setProps();
        animationControl.add(object, time)
    }


    private function updateAnimation(seconds:Number):void
    {
        ObjectManager.deselect();
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
        ObjectManager.deselect();
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
        ObjectManager.reset();
        dragManager.reset();
        topics.reset();
        snapList.reset();
        History.reset();
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
