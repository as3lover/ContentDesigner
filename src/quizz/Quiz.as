/**
 * Created by Morteza on 4/30/2017.
 */
package quizz
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
    private var _question:quizText;
    private var _answer1:quizText;
    private var _answer2:quizText;
    private var _answer3:quizText;
    private var _answer4:quizText;
    private var quizPage:QuizPage;
    private var _back:Sprite;

    public function Quiz()
    {
        hide();

        _list = {};

        _back = new Sprite();
        addChild(_back)
        Utils.drawRect(_back, 0,0, Main.target.w, Main.target.h, 0x123456);

        x = Main.target.x;
        y = Main.target.y;

        _question = new quizText(Main.target.w);
        _answer1 = new quizText(Main.target.w);
        _answer2 = new quizText(Main.target.w);
        _answer3 = new quizText(Main.target.w);
        _answer4 = new quizText(Main.target.w);

        quizPage = new QuizPage();
        addChild(quizPage);

        quizPage.addChild(_question);
        quizPage.addChild(_answer1);
        quizPage.addChild(_answer2);
        quizPage.addChild(_answer3);
        quizPage.addChild(_answer4);
    }

    public function add(id:String):void
    {
        trace('add quiz')
        var quiz:Array = new Array();
        quiz.push(['سوال','پاسخ 1','پاسخ 2','پاسخ 3','پاسخ 4',1]);
        _list[id] = quiz;
        show(id);
    }

    public function show(id:String):void
    {
        _back.addEventListener(MouseEvent.CLICK, onClick);
        trace('show auiz', id)
        Main.MAIN.addChild(this);
        visible = true;
        _num = 0;
        _quiz = _list[id];
        showQestion();
    }

    private function onClick(event:MouseEvent):void
    {
        hide();
    }

    private function showQestion():void
    {
        _question.text = _quiz[_num][0];
        _answer1.text = _quiz[_num][1];
        _answer2.text = _quiz[_num][2];
        _answer3.text = _quiz[_num][3];
        _answer4.text = _quiz[_num][4];
        select(_quiz[_num][5]);
    }

    public function select(num:int):void
    {
        /*
        _answer1.select = false;
        _answer2.select = false;
        _answer3.select = false;
        _answer4.select = false;
        this['_answer'+String(num)].select = true;
        */
        
    }

    private function hide(e:Event = null):void
    {
        visible = false;
    }
}
}
