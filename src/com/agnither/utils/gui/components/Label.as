/**
 * Created by kirillvirich on 30.01.15.
 */
package com.agnither.utils.gui.components {
    import flash.geom.Point;

    import starling.text.TextField;
    import starling.text.TextFieldAutoSize;

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

    public function Label(width:int, height:int, text:String, fontName:String, fontSize:Number = -1, color:uint = 0xFFFFFF, bold:Boolean = false, pivot: Point = null) {
        _label = new TextField(width, height, text);

        _label.fontName = fontName;
        _label.fontSize = fontSize;
        _label.color = color;
        _label.bold = bold;

        _label.autoSize = TextFieldAutoSize.VERTICAL;
        _label.autoScale = false;
        _label.batchable = true;
//        _label.border = true;
        addChild(_label);

        if (pivot) {
            _label.pivotX = pivot.x;
            _label.pivotY = pivot.y;
        }
    }

    public function setFilters(filters: Array, scale: Number = 1):void
    {
        var properties: Array = ["blurX", "blurY", "distance"];
        for (var i:int = 0; i < filters.length; i++)
        {
            var filter: Object = filters[i];
            for (var j:int = 0; j < properties.length; j++)
            {
                if (filter.hasOwnProperty(properties[j]))
                {
                    filter[properties[j]] = Math.round(filter[properties[j]] * scale);
                }
            }
        }
//        _label.nativeFilters = filters;
    }

    override public function destroy():void {
        _label = null;

        super.dispose();
    }
}
}
