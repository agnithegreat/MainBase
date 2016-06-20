/**
 * Created by kirillvirich on 10.02.15.
 */
package com.agnither.utils.gui {
    import com.agnither.utils.gui.atlas.Atlas;
    
    import flash.utils.Dictionary;
    
    import starling.textures.Texture;
    import starling.utils.AssetManager;

    public class Resources {

    public static var commonAssets: AssetManager;

    private static var _atlases: Dictionary = new Dictionary();

    public static function addAtlas(name: String, atlas: Atlas, debug: Boolean = false):void {
        _atlases[name] = atlas;
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

    public static function getAtlasScale(name: String):Number {
        return _atlases[name] ? (_atlases[name] as Atlas).scale : 0;
    }

    public static function getTexture(name: String, atlas: String = null):Texture {
        if (atlas && _atlases[atlas]) {
            var texture: Texture = (_atlases[atlas] as Atlas).getTexture(name+".png");
            if (texture != null)
            {
//                trace("no texture with name " + name + " in atlas " + atlas);
                return texture;
            }
        }
//        for (atlas in _atlases) {
//            texture = getTexture(name, atlas);
//            if (texture != null) {
//                return texture;
//            }
//        }
        texture = commonAssets ? commonAssets.getTexture(name) : null;
        if (texture == null)
        {
            texture = commonAssets ? commonAssets.getTexture(name + ".png") : null;
        }
        return texture;
    }

    public static function getTextures(name: String, atlas: String = null):Vector.<Texture> {
        if (atlas && _atlases[atlas]) {
            var textures: Vector.<Texture> = (_atlases[atlas] as Atlas).getTextures(name+".png");
            if (textures != null && textures.length > 0)
            {
                return textures;
            }
        }
//        for (atlas in _atlases) {
//            var textures: Vector.<Texture> = getTextures(name, atlas);
//            if (textures.length > 0) {
//                return textures;
//            }
//        }
        return commonAssets ? commonAssets.getTextures(name) : null;
    }
}
}
