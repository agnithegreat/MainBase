/**
 * Created by kirillvirich on 09.02.15.
 */
package com.agnither.utils.gui.atlas {
import flash.display.BitmapData;

public class AtlasData {

    protected var _texture: BitmapData;
    public function get texture():BitmapData {
        return _texture;
    }

    protected var _map: Object;
    public function get map():Object {
        return _map;
    }

    public function AtlasData(texture: BitmapData, map: Object) {
        _texture = texture;
        _map = map;
    }

    public function dispose():void {
        _texture.dispose();
        _texture = null;

        _map = null;
    }
}
}
