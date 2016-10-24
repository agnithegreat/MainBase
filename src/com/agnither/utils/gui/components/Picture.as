/**
 * Created by kirillvirich on 30.01.15.
 */
package com.agnither.utils.gui.components
{
    import flash.geom.Matrix;
    import flash.geom.Rectangle;

    import starling.display.Image;
    import starling.textures.Texture;
    
    public class Picture extends AbstractComponent
    {
        private var _image: Image;
        public function get texture():Texture
        {
            return _image.texture;
        }
        public function set texture(value:Texture):void
        {
            _image.texture = value;
            _image.readjustSize();
        }
    
        public function set color(value: uint):void
        {
            _image.color = value;
        }

//        override public function set transformationMatrix(matrix: Matrix):void
//        {
//            x = matrix.tx;
//            y = matrix.ty;
//            width = _image.tW * matrix.a;
//            height = _image.tH * matrix.d;
//        }

        override public function set width(value: Number):void
        {
            _image.width = value;
        }
        override public function get width():Number
        {
            return _image.width;
        }

        override public function set height(value: Number):void
        {
            _image.height = value;
        }
        override public function get height():Number
        {
            return _image.height;
        }
    
        public function Picture(texture: Texture, scaleGrid: Rectangle = null)
        {
            _image = new Image(texture);
            addChild(_image);
            
            if (scaleGrid)
            {
                _image.scale9Grid = scaleGrid;
            }
        }
    
        override public function dispose():void
        {
            removeChild(_image, true);
            _image = null;
    
            super.dispose();
        }
    }
}
