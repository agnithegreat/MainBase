/**
 * Created by kirillvirich on 30.01.15.
 */
package com.agnither.utils.gui.components {
import starling.text.TextField;

public class Label extends AbstractComponent {

    private var _label: TextField;

    public function set text(value: String):void {
        _label.text = value;
    }

    public function get text():String {
        return _label.text;
    }

    public function Label(width:int, height:int, text:String, fontName:String, fontSize:Number = -1, color:uint = 0xFFFFFF, bold:Boolean = false) {
        _label = new TextField(width, height, text, fontName, fontSize, color, bold);
        _label.batchable = true;
        addChild(_label);
    }

    override public function destroy():void {
        _label.removeChildren(0, -1, true);
        _label.removeFromParent(true);
        _label = null;

        super.destroy();
    }
}
}
