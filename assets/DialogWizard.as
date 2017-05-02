package  {
	
	import flash.display.Sprite;
	import fl.text.TLFTextField;
	import flash.text.TextFormat;
	
	
	public class DialogWizard extends Sprite
	{
		private var _tlf:TLFTextField;		
		private var _format:TextFormat;
		private var _holder:Sprite;
		private var fnt:BYekan;
		
		
		public function DialogWizard()
		{
			fnt = new BYekan();
			// constructor code
			_tlf = new TLFTextField();
			_tlf.x = -250 + 15;
			_tlf.y = -100 + 15;
			_tlf.width = 500 - 30;
			_tlf.height = 130;
			_tlf.embedFonts = true;
			_tlf.wordWrap = true;
			_tlf.selectable = false;
			addChild(_tlf);
			
			_format = new TextFormat();
			_format.font = "B Yekan";
			_format.align = 'center'
			_format.color = 0x444444;
			_format.size = 20;
			
			_holder = new Sprite();
			_holder.y = 50;
			addChild(_holder);
		}
		
		public function show(text:String, buttons:Array)
		{
			_holder.removeChildren();
			_holder.scaleX = _holder.scaleY = 1;
			
			this.text = text;
			
			for(var i:int = 0; i<buttons.length; i++)
			{
				addButton(buttons[i].text, buttons[i].handler)
			}
			visible = true;
		}
		
		public function hide():void
		{
			visible = false;
		}
		
		private function set text(string:String):void
		{
			_tlf.text = string;
			_tlf.setTextFormat(_format);
			_tlf.direction = 'rtl';
		}
		
		private function addButton(text:String, handler:Function)
		{
			var btn:DialogButton = new DialogButton(text, handler);
			if(_holder.width > 0)
				btn.x = _holder.width + 20
			_holder.addChild(btn);
			if(_holder.width > 475)
			{
				_holder.width = 475;
				_holder.scaleY = _holder.scaleX;
			}
			_holder.x = -_holder.width/2;
		}
	}
	
}
