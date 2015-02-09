/**
 * Created by kirillvirich on 09.02.15.
 */
package com.agnither.utils.gui.atlas {
import flash.display.BitmapData;

public class TextureData {

    protected var _name: String;
    public function get name():String {
        return _name;
    }

    protected var _texture: BitmapData;
    public function get texture():BitmapData {
        return _texture;
    }

    public function TextureData(name: String, texture: BitmapData) {
        _name = name;
        _texture = texture;
    }
}
}
