/**
 * Created by kirillvirich on 30.01.15.
 */
package com.agnither.utils.gui.components {
import flash.geom.Point;

import starling.display.Image;
import starling.textures.Texture;

public class Picture extends AbstractComponent {

    private var _image: Image;

    public function set color(value: uint):void {
        _image.color = value;
    }

    public function Picture(texture: Texture, pivot: Point = null) {
        _image = new Image(texture);
        addChild(_image);

        if (pivot) {
            _image.pivotX = pivot.x;
            _image.pivotY = pivot.y;
        }
    }

    override public function dispose():void {
        removeChild(_image, true);
        _image = null;

        super.dispose();
    }
}
}
