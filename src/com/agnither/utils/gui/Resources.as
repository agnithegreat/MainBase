/**
 * Created by kirillvirich on 10.02.15.
 */
package com.agnither.utils.gui {
import com.agnither.utils.gui.atlas.Atlas;

import flash.utils.Dictionary;

import starling.textures.Texture;

public class Resources {

    private static var _atlases: Dictionary = new Dictionary();

    public static function addAtlas(name: String, atlas: Atlas):void {
        _atlases[name] = atlas;
        atlas.build();
    }

    public static function disposeAtlas(name: String):void {
        if (_atlases[name]) {
            (_atlases[name] as Atlas).dispose();
            delete _atlases[name];
        }
    }

    public static function dispose():void {
        for (var name: String in _atlases) {
            disposeAtlas(name);
        }
    }

    public static function getAtlas(name: String):Texture {
        return _atlases[name] ? (_atlases[name] as Atlas).getAtlas() : null;
    }

    public static function getTexture(name: String, atlas: String = null):Texture {
        if (atlas && _atlases[atlas]) {
            return (_atlases[atlas] as Atlas).getTexture(name);
        }
        for (atlas in _atlases) {
            var texture: Texture = getTexture(name, atlas);
            if (texture) {
                return texture;
            }
        }
        return null;
    }
}
}
