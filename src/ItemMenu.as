/**
 * Created by mkh on 2017/04/08.
 */
package
{
import flash.display.NativeMenu;
import flash.display.NativeMenuItem;
import flash.events.ContextMenuEvent;
import flash.events.Event;
import flash.ui.ContextMenu;
import flash.ui.ContextMenuItem;

public class ItemMenu
{
    public var menu:ContextMenu;

    public static var currentItem:Item;

    public function ItemMenu()
    {
        menu = new ContextMenu();

        var hide = new ContextMenuItem("Hide Now");
        hide.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, Hide);

        var hideTime = new ContextMenuItem("Hide At New Time");
        hideTime.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, HideNew);

        var show = new ContextMenuItem("Show Now");
        show.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, Show);
        show.separatorBefore = true;

        var showTime = new ContextMenuItem("Show At New Time");
        showTime.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, ShowNew);




        var motion = new ContextMenuItem("Motion");
        //
        motion.submenu = new NativeMenu();
        motion.submenu.addItem(subMenu('',setMotion, Consts.fade));
        motion.submenu.addItem(subMenu('',setMotion, Consts.upToDown));
        motion.submenu.addItem(subMenu('',setMotion, Consts.downToUp));
        motion.submenu.addItem(subMenu('',setMotion, Consts.leftToRight));
        motion.submenu.addItem(subMenu('',setMotion, Consts.rightToLeft));
        motion.submenu.addItem(subMenu('',setMotion, Consts.rightUp));
        motion.submenu.addItem(subMenu('',setMotion, Consts.leftUp));
        motion.submenu.addItem(subMenu('',setMotion, Consts.rightDown));
        motion.submenu.addItem(subMenu('',setMotion, Consts.leftDown));
        motion.submenu.addItem(subMenu('',setMotion, Consts.zoom));
        motion.submenu.addItem(subMenu('',setMotion, Consts.rotate));
        //
        menu.customItems.push(hide);
        menu.customItems.push(hideTime);
        menu.customItems.push(show);
        menu.customItems.push(showTime);
        menu.customItems.push(motion);


    }

    private function ShowNew(e:ContextMenuEvent):void
    {
        Item(e.contextMenuOwner).ShowNew();
    }

    private function Show(e:ContextMenuEvent):void
    {
        Item(e.contextMenuOwner).Show();
    }

    private function subMenu(label:String, Func:Function, data:Object = null):NativeMenuItem
    {
        if(label == '')
            label = data.toString();

        var item:NativeMenuItem = new NativeMenuItem(label)
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
        if(currentItem)
            currentItem.newMotion(e.target.data);
    }
}
}
