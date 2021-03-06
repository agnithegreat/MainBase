/**
 * Created by kirillvirich on 30.01.15.
 */
package com.agnither.utils.gui.components
{
    import starling.text.TextField;
    import starling.utils.HAlign;
    import starling.utils.VAlign;

    public class Label extends AbstractComponent
    {
        private var _label: TextField;

        override public function set width(value: Number):void
        {
            _label.width = value;
        }
        override public function get width():Number
        {
            return _label.width;
        }

        override public function set height(value: Number):void
        {
            _label.height = value;
        }
        override public function get height():Number
        {
            return _label.height;
        }

        public function set text(value: String):void
        {
            _label.text = value;
        }
        public function get text():String
        {
            return _label.text;
        }

        public function set color(value: uint):void
        {
            _label.color = value;
        }
        
        public function set vAlign(value: String):void
        {
            _label.vAlign = value;
        }

        public function set hAlign(value: String):void
        {
            _label.hAlign = value;
        }

        public function Label(width:int, height:int, text:String, fontName:String, fontSize:Number = -1, color:uint = 0xFFFFFF, bold:Boolean = false, align: String = HAlign.CENTER)
        {
            _label = new TextField(width, height, text);

            _label.fontName = fontName;
            _label.fontSize = fontSize;
            _label.color = color;
            _label.bold = bold;
            _label.isHtmlText = true;

            _label.vAlign = VAlign.TOP;
            _label.hAlign = align;
            _label.autoScale = true;
            addChild(_label);

            var gap: Number = height * 0.15;
            _label.y -= gap;
            _label.height += gap * 2;
        }

        public function setFilters(filters: Array, scale: Number = 1):void
        {
            if (scale <= 0.25) scale = 0.25;
            else if (scale <= 0.5) scale = 0.5;
            else scale = 1;

            var properties: Array = ["blurX", "blurY", "distance", "strength"];
//            var properties: Array = ["blurX", "blurY", "distance"];
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
            _label.nativeFilters = filters;
        }

        override public function destroy():void
        {
            _label = null;

            super.dispose();
        }
    }
}
