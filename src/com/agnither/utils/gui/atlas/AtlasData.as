/**
 * Created by kirillvirich on 09.02.15.
 */
package com.agnither.utils.gui.atlas {
import flash.display.BitmapData;

public class AtlasData extends TextureData {

    protected var _map: Object;
    public function get map():Object {
        return _map;
    }

    public function AtlasData(name: String, texture: BitmapData, map: Object) {
        super(name, texture);

        _map = map;
    }
}
}
