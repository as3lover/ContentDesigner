/**
 * Created by Morteza on 4/30/2017.
 */
package quizz
{
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFormat;

import src2.Button;

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
    private var _text:TextField;
    private var _f:TextFormat;
    private var _removeBt:Button;
    private var _prv:Button;
    private var _nxt:Button;

    public function Quiz()
    {
        visible = false;

        _list = {};

        _back = new Sprite();
        addChild(_back)
        Utils.drawRect(_back, 0,0, Main.target.w, Main.target.h, 0x80d7ff);

        x = Main.target.x;
        y = Main.target.y;
        var w:int = Main.target.w - 40;

        _question = new quizText(w, false);
        _question.y = 50;
        _answer1 = new quizText(w);
        _answer2 = new quizText(w);
        _answer3 = new quizText(w);
        _answer4 = new quizText(w);

        quizPage = new QuizPage(select);
        addChild(quizPage);

        quizPage.addChild(_question);
        quizPage.addChild(_answer1);
        quizPage.addChild(_answer2);
        quizPage.addChild(_answer3);
        quizPage.addChild(_answer4);

        var close:Button = new Button('خروج', 0, 0, 40);
        close.handler = hide;
        close.x = Main.target.w - 10 - close.width;
        close.y = 10;
        addChild(close);

        _removeBt = new Button('حذف سؤال', 0, 0, 75);
        _removeBt.handler = delet;
        _removeBt.x = close.x - 10 - _removeBt.width;
        _removeBt.y = close.y;
        addChild(_removeBt);

        var Add:Button = new Button('سؤال جدید', 0, 0, 75);
        Add.handler = addQ;
        Add.x = _removeBt.x - 10 - Add.width;
        Add.y = _removeBt.y;
        addChild(Add);

        _prv = new Button('<', 0, 0);
        _prv.handler = prev;
        _prv.x = Main.target.w/2 - 50
        _prv.y = Main.target.h - 30;
        addChild(_prv)

        _nxt = new Button('>', 0, 0);
        _nxt.handler = next;
        _nxt.x = Main.target.w/2 + 30;
        _nxt.y = _prv.y;
        addChild(_nxt);

        _text = new TextField();
        _text.x = _prv.x + _prv.width;
        _text.width = _nxt.x - _text.x;
        _text.height = _nxt.height;
        _text.y = _nxt.y;
        _text.selectable = false;
        addChild(_text);

        _f = new TextFormat();
        _f.font = "B Yekan";
        _f.align = 'center';
    }

    private function addQ():void
    {
        saveTexts();
        var question:Array = ['سوال','پاسخ 1','پاسخ 2','پاسخ 3','پاسخ 4',1];
        _num++
        Utils.pushAtIndex(_quiz, _num, question);
        showQestion();
    }

    private function delet():void
    {
        Main.alert('question');
    }

    private function prev():void
    {
        saveTexts();
        _num--;
        showQestion();
    }

    private function next():void
    {
        saveTexts();
        _num++;
        showQestion();
    }

    public function add(id:String):void
    {
        var quiz:Array = new Array();
        quiz.push(['سوال','پاسخ 1','پاسخ 2','پاسخ 3','پاسخ 4',1]);
        _list[id] = quiz;
        show(id);
    }

    public function addLoaded(id:String, quiz:Array):void
    {
        _list[id] = quiz;
    }

    public function show(id:String):void
    {
        if(visible)
                hide();

        Main.MAIN.addChild(this);
        visible = true;
        _num = 0;
        _quiz = _list[id];
        showQestion();

        if(stage)
            stage.addEventListener(MouseEvent.MOUSE_DOWN, onStage)
    }

    private function onStage(e:MouseEvent):void
    {
        return;
        if(Utils.targetClass(e.target as DisplayObject, Quiz))
        {
            return;
        }
        else
        {
            hide();
        }
    }

    private function onClick(event:MouseEvent=null):void
    {
        hide();
    }

    private function showQestion():void
    {
        if(_num < 0)
            _num = 0;
        else if(_num > _quiz.length-1)
            _num = _quiz.length-1;

        _question.text = _quiz[_num][0];
        _answer1.text = _quiz[_num][1];
        _answer2.text = _quiz[_num][2];
        _answer3.text = _quiz[_num][3];
        _answer4.text = _quiz[_num][4];
        select(_quiz[_num][5]);

        _text.text = String(_num+1) + ' / ' + String(_quiz.length);
        _text.setTextFormat(_f);

        if(_num == 0)
                _prv.disable();
        else
                _prv.enable();

        if(_num == _quiz.length-1)
                _nxt.disable();
        else
                _nxt.enable();

        if(_quiz.length == 1)
                _removeBt.disable();
        else
                _removeBt.enable();
    }

    public function select(num:int):void
    {
        _answer1.select = false;
        _answer2.select = false;
        _answer3.select = false;
        _answer4.select = false;
        quizText(this['_answer'+String(num)]).select = true;

        _quiz[_num][5] = num;
    }

    private function hide(e:Event = null):void
    {
        saveTexts();
        visible = false;
        stage.removeEventListener(MouseEvent.MOUSE_DOWN, onStage)
    }

    private function saveTexts():void
    {
        _quiz[_num][0] = _question.text;
        _quiz[_num][1] =  _answer1.text;
        _quiz[_num][2] = _answer2.text;
        _quiz[_num][3] =  _answer3.text;
        _quiz[_num][4] = _answer4.text;
    }

    public function confirmDelete():void
    {
        Main._alert.hide();
        if(_quiz.length > 1)
        {
            Utils.removeItemAtIndex(_quiz, _num);
            showQestion();
        }
    }

    public function object(id:String):Array
    {
        return _quiz = _list[id];
    }
}
}
