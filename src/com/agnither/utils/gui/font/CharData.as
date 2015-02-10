/**
 * Created by kirillvirich on 10.02.15.
 */
package com.agnither.utils.gui.font {
import flash.display.BitmapData;
import flash.geom.Rectangle;

public class CharData {

    private var _texture: BitmapData;
    public function get texture():BitmapData {
        return _texture;
    }

    private var _bounds: Rectangle;
    public function get bounds():Rectangle {
        return _bounds;
    }

    public function CharData(texture: BitmapData, bounds: Rectangle) {
        _texture = texture;
        _bounds = bounds;
    }
}
}
