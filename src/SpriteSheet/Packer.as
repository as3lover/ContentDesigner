/**
 * Rectangle Packer demo
 *
 * Copyright 2012 Ville Koskela. All rights reserved.
 *
 * Email: ville@villekoskela.org
 * Blog: http://villekoskela.org
 * Twitter: @villekoskelaorg
 *
 * You may redistribute, use and/or modify this source code freely
 * but this copyright statement must not be removed from the source files.
 *
 * The package structure of the source code must remain unchanged.
 * Mentioning the author in the binary distributions is highly appreciated.
 *
 * If you use this utility it would be nice to hear about it so feel free to drop
 * an email.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. *
 *
 */
package SpriteSheet
{
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.geom.Rectangle;

import org.villekoskela.utils.IntegerRectangle;
import org.villekoskela.utils.RectanglePacker;

public class Packer extends Sprite
{
    private static var mPacker:RectanglePacker;
    public function Packer()
    {

    }

    public function create(objs:Vector.<DisplayObject>,ids:Vector.<int>,after:Function, width:int = 1024, height:int = 1024, padding:int = 1):void
    {
        while(numChildren)
            removeChildAt(0);

        if (mPacker == null)
            mPacker = new RectanglePacker(width, height, padding);
        else
            mPacker.reset(width, height, padding);

        var length:int = objs.length;

        var byID:Object = new Object();

        for (var i:int = 0; i < length; i++)
        {
            mPacker.insertRectangle(objs[i].width, objs[i].height, ids[i]);
            byID['id_' + String(ids[i])] =  objs[i];
        }

        mPacker.packRectangles(func, true);

        function func(list:Vector.<IntegerRectangle>):void
        {
            if(list == null)
            {
                after(null,null);
                return;
            }
            var holder:Sprite = new Sprite();

            var i:int = list.length-1;
            for(i; i>-1; i--)
            {
                var rect:IntegerRectangle = list[i];
                var obj:DisplayObject = byID['id_' + String(list[i].id)];
                obj.x = rect.x;
                obj.y = rect.y;
                holder.addChild(obj);
            }

            after(objectToBitmap(holder), list.concat());
        }

    }



    public static function objectToBitmap(obj:DisplayObject):Bitmap
    {
        var bitmapData:BitmapData = new BitmapData(obj.width, obj.height, true, 0x00000000);
        bitmapData.draw(obj);
        return new Bitmap(bitmapData);
    }
}
}
