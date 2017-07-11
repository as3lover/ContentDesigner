package
{
import flash.display.DisplayObject;
import flash.display.MovieClip;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
import flash.display.Stage;
import flash.events.Event;
	import flash.events.MouseEvent;

	public class FileMenu
	{
		private var _contextMenu:NativeMenu;
        private var _stage:Stage;

        private const NEW:String = 'New';
        private const OPEN:String = 'Open ...';
        private const SAVE:String = 'Save';
        private const SAVE_AS:String = 'Save As ...';
        private const EXPORT:String = 'Export...';
        private const PDF:String = 'PDF...';

		public function FileMenu(stage:Stage, target:DisplayObject)
		{
            _stage = stage;
            _contextMenu = createMenu();
            _contextMenu.addEventListener(Event.SELECT, selectItem);
			target.addEventListener(MouseEvent.MOUSE_UP, openMenu);
		}

        private function createMenu():NativeMenu
        {
            var menu:NativeMenu = new NativeMenu();
            addItem(menu,NEW);
            addItem(menu, OPEN);
            addItem(menu, SAVE);
            addItem(menu, SAVE_AS);
            //addItem(menu, EXPORT);
            addItem(menu, PDF);
            return menu;
        }

        private function addItem(menu:NativeMenu, s:String):void
        {
            var item:NativeMenuItem = menu.addItem(new NativeMenuItem(s));
            item.data = {};
        }

        private function openMenu(event:MouseEvent):void
        {
            _contextMenu.display(_stage, 0, 24);
        }

        private function selectItem(menuEvent:Event):void
        {
            switch(menuEvent.target.label)
			{
                case NEW:
                    FileManager.newFile();
                    break;
                case OPEN:
                    FileManager.openFile();
                    break;

                case SAVE:
                    FileManager.saveFile();
                    break;

                case SAVE_AS:
                    FileManager.saveAsFile();
                    break;

                case EXPORT:
                    FileManager.exportFile();
                    break;

                case PDF:
                    FileManager.exportPDF();
                    break;

            }
        }




	}
}
