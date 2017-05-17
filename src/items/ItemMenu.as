/**
 * Created by mkh on 2017/04/08.
 */
package items
{
import flash.display.NativeMenu;
import flash.display.NativeMenu;
import flash.display.NativeMenuItem;
import flash.display.NativeMenuItem;
import flash.events.ContextMenuEvent;
import flash.events.Event;
import flash.ui.ContextMenu;
import flash.ui.ContextMenuItem;

import src2.Consts;

public class ItemMenu
{
    public var menu:ContextMenu;

    public static var currentItem:Item;
    private var _motion:ContextMenuItem;

    public function ItemMenu()
    {
        menu = new ContextMenu();

        var hide:ContextMenuItem = new ContextMenuItem("Hide Now");
        hide.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, Hide);

        var hideTime:ContextMenuItem = new ContextMenuItem("Hide At New Time");
        hideTime.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, HideNew);

        var show:ContextMenuItem = new ContextMenuItem("Show Now");
        show.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, Show);

        var showTime:ContextMenuItem = new ContextMenuItem("Show At New Time");
        showTime.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, ShowNew);
        //

        var cut:ContextMenuItem = new ContextMenuItem("Cut");
        cut.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, Cut);

        var copy:ContextMenuItem = new ContextMenuItem("Copy");
        copy.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, Copy);

        //
        var motion:ContextMenuItem = _motion = new ContextMenuItem("Motion");
        motion.submenu = new NativeMenu();
        subMotion(motion, Consts.fade, true);
        subMotion(motion, Consts.upToDown);
        subMotion(motion, Consts.downToUp);
        subMotion(motion, Consts.leftToRight);
        subMotion(motion, Consts.rightToLeft);
        subMotion(motion, Consts.rightUp);
        subMotion(motion, Consts.leftUp);
        subMotion(motion, Consts.rightDown);
        subMotion(motion, Consts.leftDown);
        subMotion(motion, Consts.zoom);
        subMotion(motion, Consts.rotate);
        //
        var arrange:ContextMenuItem = new ContextMenuItem("Arrange");
        arrange.submenu = new NativeMenu();
        arrange.submenu.addItem(subMenu('پایین ترین', this.arrange, Consts.ARRANGE.BACK));
        arrange.submenu.addItem(subMenu('بالاترین', this.arrange, Consts.ARRANGE.FRONT));
        arrange.submenu.addItem(new NativeMenuItem("", true));
        arrange.submenu.addItem(subMenu('پایین تر', this.arrange, Consts.ARRANGE.BACK_LEVEL));
        arrange.submenu.addItem(subMenu('بالاتر', this.arrange, Consts.ARRANGE.FRONT_LEVEL));
        //
        menu.customItems.push(hide);
        menu.customItems.push(hideTime);
        show.separatorBefore = true;
        menu.customItems.push(show);
        menu.customItems.push(showTime);
        motion.separatorBefore = true;
        menu.customItems.push(motion);
        menu.customItems.push(arrange);
        cut.separatorBefore = true;
        menu.customItems.push(cut);
        menu.customItems.push(copy);
    }

    private function Cut(e:ContextMenuEvent):void
    {
        ObjectManager.Cut(Item(e.contextMenuOwner));
    }

    private function Copy(e:ContextMenuEvent):void
    {
        ObjectManager.Copy(Item(e.contextMenuOwner));
    }


    private function ShowNew(e:ContextMenuEvent):void
    {
        Item(e.contextMenuOwner).ShowNew();
    }

    private function Show(e:ContextMenuEvent):void
    {
        Item(e.contextMenuOwner).Show();
    }

    private function subMotion(motion:ContextMenuItem, type:String, checked:Boolean = false):void
    {
        motion.submenu.addItem(subMenu(type, setMotion, type,checked));
    }

    private function subMenu(label:String, Func:Function, data:Object = null, checked:Boolean = false):NativeMenuItem
    {
        var item:NativeMenuItem = new NativeMenuItem(label);
        item.checked = checked;
        item.data = data;
        item.addEventListener(Event.SELECT, Func);
        return item;
    }


    private function Hide(e:ContextMenuEvent):void
    {
        Item(e.contextMenuOwner).Hide();
    }

    private function HideNew(e:ContextMenuEvent):void
    {
        Item(e.contextMenuOwner).HideNew();
    }

    private function setMotion(e:Event):void
    {
        if(!currentItem)
                return;

        currentItem.newMotion(e.target.data);
        for (var i:int = 0; i <_motion.submenu.numItems; i++)
        {
            _motion.submenu.getItemAt(i).checked = false;
        }
        NativeMenuItem(e.target).checked = true;
    }

    private function arrange(e:Event):void
    {
        if(!currentItem)
                return;
        Item.setIndexByUser(e.target.data, currentItem)
    }


}
}
