/**
 * Created by Morteza on 4/30/2017.
 */
package
{
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import src2.Utils;

public class Quiz extends Sprite
{
    private var _list:Object;
    private var _num:int;
    private var _quiz:Array;
    public function Quiz()
    {
        _list = {};
        Utils.drawRect(this, Main.target.x, Main.target.y, Main.target.w, Main.target.h, 0x123456);

        
    }

    public function add(id:String):void
    {
        var quiz:Array = new Array();
        quiz.push(['سوال','پاسخ 1','پاسخ 2','پاسخ 3','پاسخ 4',1]);
        _list[id] = quiz;
        show(id);
    }

    public function show(id:String):void
    {
        Main.MAIN.addChild(this);
        visible = true;
        _num = 0;
        _quiz = _list[id];
        showQestion();
    }

    private function showQestion():void
    {
        question.text = _quiz[_num][0];
        answer_1.text = _quiz[_num][1];
        answer_2.text = _quiz[_num][2];
        answer_3.text = _quiz[_num][3];
        answer_4.text = _quiz[_num][4];
        select(_quiz[_num][5]);
    }

    public function select(num:int):void
    {
        _answer_1.select = false;
        _answer_2.select = false;
        _answer_3.select = false;
        _answer_4.select = false;
        this['_answer_'+String(num)].select = true;
        
    }

    private function hide(e:Event = null):void
    {
        visible = false;
    }
}
}
