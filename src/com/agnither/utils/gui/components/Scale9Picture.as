/**
 * Created by kirillvirich on 30.01.15.
 */
package com.agnither.utils.gui.components {
import flash.geom.Rectangle;

import starling.extensions.Scale9Image;
import starling.textures.Texture;

public class Scale9Picture extends AbstractComponent {

    private var _image: Scale9Image;

    override public function set width(value: Number):void {
        _image.width = value;
    }
    override public function get width():Number {
        return _image.width;
    }

    override public function set height(value: Number):void {
        _image.height = value;
    }
    override public function get height():Number {
        return _image.height;
    }

    public function Scale9Picture(texture: Texture, rect: Rectangle) {
        _image = new Scale9Image(texture, rect);
        _image.scaleIfSmaller = false;
        addChild(_image);
    }

    override public function destroy():void {
        removeChild(_image, true);
        _image = null;

        super.destroy();
    }
}
}
