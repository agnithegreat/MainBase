/**
 * Created by kirillvirich on 30.01.15.
 */
package com.agnither.utils.gui.components {
import starling.text.TextField;

public class Label extends AbstractComponent {

    private var _label: TextField;

    override public function set width(value: Number):void {
        _label.width = value;
    }
    override public function get width():Number {
        return _label.width;
    }

    override public function set height(value: Number):void {
        _label.height = value;
    }
    override public function get height():Number {
        return _label.height;
    }

    public function set text(value: String):void {
        _label.text = value;
    }
    public function get text():String {
        return _label.text;
    }

    public function set color(value: uint):void {
        _label.color = value;
    }

    public function Label(width:int, height:int, text:String, fontName:String, fontSize:Number = -1, color:uint = 0xFFFFFF, bold:Boolean = false) {
        _label = new TextField(width, height, text, fontName, fontSize, color, bold);
        _label.batchable = true;
        addChild(_label);
    }

    override public function dispose():void {
        _label.removeChildren(0, -1, true);
        _label.removeFromParent(true);
        _label = null;

        super.dispose();
    }
}
}
