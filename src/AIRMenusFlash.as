package {
	import flash.display.MovieClip;

	import flash.desktop.NativeApplication;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.NativeWindow;
	import flash.events.Event;

	public class AIRMenusFlash extends MovieClip
	{

		private var window:NativeWindow;
		private var application:NativeApplication = NativeApplication.nativeApplication;

		/** 
		* It's generally a good idea to wait until the movie clip is
		* added to the stage before accessing stage properties.
		*/ 
		public function AIRMenusFlash()
		{
			addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		/**
		* Creates menus, loads icon images, and sets up the UI event handlers.
		*/
		private function initialize(event:Event):void{
			window = stage.nativeWindow;

			
			if(NativeApplication.supportsMenu){
				application.menu = createRootMenu("Application menu");
			}

			if(NativeWindow.supportsMenu){
				window.menu = createRootMenu("Window menu");
			}

			window.activate();
		}

        /** Creates and returns a NativeMenu object **/
        private function createRootMenu(menuType:String):NativeMenu{
            var menu:NativeMenu = new NativeMenu();
            menu.addSubmenu(createFileMenu(menuType),"File");
            return menu;
        }

        /** Creates the File menu **/
        private function createFileMenu(menuType:String):NativeMenu
		{
            var menu:NativeMenu = new NativeMenu();

            var newCommand:NativeMenuItem = menu.addItem(new NativeMenuItem("New"));
            newCommand.keyEquivalent = 'n';
            newCommand.data = menuType;
            newCommand.addEventListener(Event.SELECT, newWindow);

            var closeCommand:NativeMenuItem = menu.addItem(new NativeMenuItem("Close window"));
            closeCommand.keyEquivalent = 'w';
            closeCommand.data = menuType;
            closeCommand.addEventListener(Event.SELECT, closeWindow);

            var quitCommand:NativeMenuItem = menu.addItem(new NativeMenuItem("Exit"));
            quitCommand.keyEquivalent = 'q';
            quitCommand.data = menuType;
            quitCommand.addEventListener(Event.SELECT, exitApplication);

            return menu;
        }

        /** Implements the File menu commands **/
        private function newWindow(event:Event):void
        {


        }

        private function closeWindow(event:Event):void
        {

        }

        private function exitApplication(event:Event):void
        {

        }

	}
}
