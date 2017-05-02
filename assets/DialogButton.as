package  {
	
	import flash.display.Sprite;
	import fl.text.TLFTextField;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	
	public class DialogButton extends Sprite
	{
		private var _tlf:TLFTextField;		
		private var _handler:Function;
		private var _format:TextFormat;
		
		public function DialogButton(text:String, handler:Function)
		{
			_tlf = new TLFTextField();
			_tlf.text = text;
			_tlf.width = 100;
			_tlf.height = 30;
			_tlf.embedFonts = true;
			_tlf.wordWrap = true;
			_tlf.selectable = false;
			_format = new TextFormat
			_format.font = "B Yekan";
			_format.align = 'center';
			_format.size = 16;
			_tlf.setTextFormat(_format);
			_tlf.direction = 'rtl';
			addChild(_tlf);
			
			_handler = handler;
			
			this.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		private function onClick(e:MouseEvent)
		{
			_handler();
		}
	}
	
}
