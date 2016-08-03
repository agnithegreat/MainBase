/**
 * Created by kirillvirich on 30.01.15.
 */
package com.agnither.utils.gui.components
{
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
    
        public function Picture(texture: Texture)
        {
            _image = new Image(texture);
            addChild(_image);
        }
    
        override public function dispose():void
        {
            removeChild(_image, true);
            _image = null;
    
            super.dispose();
        }
    }
}
