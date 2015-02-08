/**
 * Created by kirillvirich on 30.01.15.
 */
package com.agnither.utils.gui.components {
import starling.text.TextField;

public class Label extends AbstractComponent {

    private var _label: TextField;

    public function Label(width:int,height:int,text:String,fontName:String = "Verdana",fontSize:Number = 12,color:uint = 0,bold:Boolean = false) {
        _label = new TextField(width, height, text, fontName, fontSize, color, bold);
        addChild(_label);
    }

    override public function destroy():void {
        removeChild(_label, true);
        _label = null;

        super.destroy();
    }
}
}
