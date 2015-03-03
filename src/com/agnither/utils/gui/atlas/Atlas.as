/**
 * Created by kirillvirich on 09.02.15.
 */
package com.agnither.utils.gui.atlas {
import com.agnither.utils.gui.font.FontBuilder;
import com.agnither.utils.gui.font.FontData;

import flash.display.BitmapData;
import flash.display.DisplayObject;

import starling.text.BitmapFont;
import starling.text.TextField;
import starling.textures.Texture;
import starling.textures.TextureAtlas;

public class Atlas {

    private var _textures: Object = {};

    private var _fontsParams: Object = {};
    private var _fonts: Object = {};

    private var _textureAtlas: TextureAtlas;
    public function get created():Boolean {
        return Boolean(_textureAtlas);
    }

    public function getAtlas():Texture {
        return _textureAtlas ? _textureAtlas.texture : null;
    }

    public function getTexture(name: String):Texture {
        return _textureAtlas ? _textureAtlas.getTexture(name) : null;
    }

    public function Atlas() {

    }

    public function addGraphics(className: String, graphics: DisplayObject):void {
        var bd: BitmapData = new BitmapData(graphics.width, graphics.height, true, 0);
        bd.draw(graphics);

        addBitmapData(className, bd);
    }

    public function addBitmapData(className: String, bitmapData: BitmapData):void {
        _textures[className] = bitmapData;
    }

    public function addFont(className: String, chars: String, font: String, size: int, color: uint, bold: Boolean):void {
        _fontsParams[className] = [chars, font, size, color, bold];
    }

    public function build():void {
        for (var name: String in _fontsParams) {
            var font: FontData = FontBuilder.buildFontFromChars.apply(this, _fontsParams[name]);
            _fonts[name] = font;
            _textures[name] = font.texture;
        }

        var atlasData: AtlasData = TextureAtlasBuilder.buildTextureAtlas(_textures);
        var texture: Texture = Texture.fromBitmapData(atlasData.texture, false);
        var xml: XML = TextureAtlasBuilder.getTextureXml(atlasData);

        _textureAtlas = new TextureAtlas(texture, xml);

        for (name in _fonts) {
            font = _fonts[name];
            texture = getTexture(name);

            TextField.registerBitmapFont(new BitmapFont(texture, font.xml), name);
        }

        disposeTemporaryData();
    }

    private function disposeTemporaryData():void {
        if (_textures) {
            for (var name: String in _textures) {
                var bitmapData: BitmapData = _textures[name];
                if (bitmapData) {
                    bitmapData.dispose();
                }
                delete _textures[name];
            }
            _textures = null;
        }

        if (_fonts) {
            for (name in _fonts) {
                var font: FontData = _fonts[name];
                font.dispose();
                delete _fonts[name];
            }
            _fonts = null;
        }
    }


    public function dispose():void {
        for (var name: String in _fontsParams) {
            TextField.unregisterBitmapFont(name);
            delete _fontsParams[name];
        }

        disposeTemporaryData();

        if (_textureAtlas) {
            _textureAtlas.dispose();
            _textureAtlas = null;
        }
    }
}
}
