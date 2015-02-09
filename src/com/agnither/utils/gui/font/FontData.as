/**
 * Created by kirillvirich on 09.02.15.
 */
package com.agnither.utils.gui.font {
import com.agnither.utils.gui.atlas.AtlasData;

import flash.display.BitmapData;

public class FontData extends AtlasData {

    protected var _xml: XML;
    public function get xml():XML {
        return _xml;
    }

    public function FontData(name: String, texture:BitmapData, map:Object, xml: XML) {
        super(name, texture, map);

        _xml = xml;
    }
}
}
