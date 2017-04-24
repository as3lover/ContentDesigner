package
{
    import flash.desktop.Icon;
    import flash.display.Loader;
    import flash.events.Event;
    import flash.net.URLRequest;
      
    public class AIRMenuIcon extends Icon
    {      		
		private var imageURLs:Array = ['icons/AIRApp_16.png','icons/AIRApp_32.png',
										'icons/AIRApp_48.png','icons/AIRApp_128.png'];
										
        public function AIRMenuIcon():void{
            super();
            bitmaps = new Array();
        }
        
        public function loadImages(event:Event = null):void{
        	if(event != null){
        		bitmaps.push(event.target.content.bitmapData);
			event.target.removeEventListener(Event.COMPLETE,loadImages);
        	}
        	if(imageURLs.length > 0){
        		var urlString:String = imageURLs.pop();
        		var loader:Loader = new Loader();
        		loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadImages);
				loader.load(new URLRequest(urlString));
        	} else {
        		var complete:Event = new Event(Event.COMPLETE,false,false);
        		dispatchEvent(complete);
        	}
        }
    }
}