/**
 * Created by Morteza on 4/19/2017.
 */
package
{
import flash.events.ContextMenuEvent;
import flash.text.TextFormat;
import flash.ui.ContextMenu;
import flash.ui.ContextMenuItem;

public class TextItem extends Item
{
    private var _text:String;
    private var _format:TextFormat;
    private var _editor:TextEditor;

    public function TextItem(removeAnimataion:Function, edit:Boolean = false)
    {
        super(removeAnimataion, null);

        _editor = Main.textEditor;
        //_editor = new MainTextEditor();
       //Main.timeLine.parent.addChild(_editor);


        var editor = new ContextMenuItem("Edit Text");
        editor.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, editText);
        var menu:ContextMenu = new ItemMenu().menu;
        menu.customItems.push(editor);
        this.contextMenu = menu;

        if(edit)
        {
            x = Main.dragManager.target.mouseX;
            y = Main.dragManager.target.mouseX;
            x = y = 100;
            Main.dragManager.target.addChild(this);
            editText();
        }
    }

    private function editText(event:ContextMenuEvent = null):void
    {
        _editor.show(_text, afterEdit)
    }

    private function afterEdit(txt:String):void
    {
        text = txt;
    }

    ///////////////// all //////////////////////////
    public override function get all():Object
    {
        var obj:Object = super.all;
        obj.text = text;
        obj.format = format;
        obj.type = 'text';
        return obj;
    }

    public override function set all(obj:Object)
    {
        _text = obj.text;
        _editor.text = _text;
        format = obj.format;
        super.all = obj;
    }
    ///////////////// text //////////////////////////

    public function get text():String
    {
        return _text;
    }

    public function set text(value:String):void
    {
        if(_text == value)
                return;

        _text = value;
        load();
    }
    ///////////////// format //////////////////////////

    public function get format():TextFormat
    {
        return _format;
    }

    public function set format(value:TextFormat):void
    {
        _format = value;
    }
    ///////////////// load //////////////////////////
    public override function load():void
    {
        if(_bitmap)
            _bitmap.parent.removeChild(_bitmap);

        _bitmap = _editor.bitmap;

        _bitmap.x = -_bitmap.width/2;
        _bitmap.y = -_bitmap.height/2;
        addChild(_bitmap);

        dispatchComplete();
    }
    ///////////////// save //////////////////////////
    public override function save(dir:String):void
    {
        dispatchComplete();
    }
    ///////////////// move //////////////////////////
    public override function move():void
    {
        dispatchComplete();
    }



}
}
