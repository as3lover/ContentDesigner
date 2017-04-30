/**
 * Created by mkh on 2017/04/08.
 */
package src2
{
import flash.display.NativeMenu;
import flash.display.NativeMenu;
import flash.display.NativeMenuItem;
import flash.display.NativeMenuItem;
import flash.events.ContextMenuEvent;
import flash.events.Event;
import flash.ui.ContextMenu;
import flash.ui.ContextMenuItem;

import items.Item;

public class TopicMenu
{
    public var menu:ContextMenu;

    public static var currentItem:Item;
    private var _motion:ContextMenuItem;

    public function TopicMenu(type:String)
    {
        menu = new ContextMenu();

        var setTime = new ContextMenuItem("Set Current Time");
        setTime.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, setCurTime);
        menu.customItems.push(setTime);

        if(type == 'topic')
        {
            var Text = new ContextMenuItem("Change Text");
            Text.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, text);
            menu.customItems.push(Text);
        }

        var Time = new ContextMenuItem("Change Time");
        Time.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, time);
        menu.customItems.push(Time);

        var Delete = new ContextMenuItem("Delete");
        Delete.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, deleteTopic);
        menu.customItems.push(Delete);

    }

    private function setCurTime(e:ContextMenuEvent):void
    {
        TopicItem(e.contextMenuOwner).setTime(Utils.time);
    }

    private function text(e:ContextMenuEvent):void
    {
        TopicItem(e.contextMenuOwner).changeText();
    }

    private function time(e:ContextMenuEvent):void
    {
        TopicItem(e.contextMenuOwner).changeTime();
    }

    private function deleteTopic(e:ContextMenuEvent):void
    {
        TopicItem(e.contextMenuOwner).remove();
    }

}
}
