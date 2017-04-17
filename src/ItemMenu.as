/**
 * Created by mkh on 2017/04/08.
 */
package
{
import flash.display.NativeMenu;
import flash.display.NativeMenu;
import flash.display.NativeMenuItem;
import flash.display.NativeMenuItem;
import flash.events.ContextMenuEvent;
import flash.events.Event;
import flash.ui.ContextMenu;
import flash.ui.ContextMenuItem;

public class ItemMenu
{
    public var menu:ContextMenu;

    public static var currentItem:Item;
    private var _motion:ContextMenuItem;

    public function ItemMenu()
    {
        menu = new ContextMenu();

        var hide = new ContextMenuItem("Hide Now");
        hide.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, Hide);

        var hideTime = new ContextMenuItem("Hide At New Time");
        hideTime.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, HideNew);

        var show = new ContextMenuItem("Show Now");
        show.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, Show);

        var showTime = new ContextMenuItem("Show At New Time");
        showTime.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, ShowNew);
        //
        var motion = _motion = new ContextMenuItem("Motion");
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
        arrange.submenu.addItem(subMenu('پایین ترین', this.arrange, 'back'));
        arrange.submenu.addItem(subMenu('بالاترین', this.arrange, 'front'));
        arrange.submenu.addItem(new NativeMenuItem("", true));
        arrange.submenu.addItem(subMenu('پایین تر', this.arrange, 'backLevel'));
        arrange.submenu.addItem(subMenu('بالاتر', this.arrange, 'frontLevel'));
        //
        menu.customItems.push(hide);
        menu.customItems.push(hideTime);
        show.separatorBefore = true;
        menu.customItems.push(show);
        menu.customItems.push(showTime);
        motion.separatorBefore = true;
        menu.customItems.push(motion);
        arrange
        menu.customItems.push(arrange);


    }

    private function ShowNew(e:ContextMenuEvent):void
    {
        Item(e.contextMenuOwner).ShowNew();
    }

    private function Show(e:ContextMenuEvent):void
    {
        Item(e.contextMenuOwner).Show();
    }

    private function subMotion(motion:ContextMenuItem, type:String, checked:Boolean = false)
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

        switch(e.target.data)
        {
            case 'front':
                currentItem.index = -100;
                break;

            case 'back':
                currentItem.index = 0;
                break;

            case 'frontLevel':
                currentItem.index++;
                break;

            case 'backLevel':
                currentItem.index--;
                break;
        }

    }
}
}
