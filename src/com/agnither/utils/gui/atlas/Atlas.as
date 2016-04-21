/**
 * Created by kirillvirich on 09.02.15.
 */
package com.agnither.utils.gui.atlas {
import com.agnither.utils.gui.font.FontBuilder;
import com.agnither.utils.gui.font.FontData;

import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.geom.Matrix;
import flash.geom.Rectangle;

import starling.text.BitmapFont;
import starling.text.TextField;
import starling.textures.Texture;
import starling.textures.TextureAtlas;

public class Atlas {

    public static function fromTextureAtlas(textureAtlas: TextureAtlas, scale: Number = 1):Atlas
    {
        var atlas: Atlas = new Atlas(scale);
        atlas.textureAtlas = textureAtlas;
        return atlas;
    }

    private var _textures: Object = {};

    private var _fontsParams: Object = {};
    private var _fonts: Object = {};

    private var _textureAtlas: TextureAtlas;
    public function set textureAtlas(value: TextureAtlas):void
    {
        _textureAtlas = value;
    }
    public function get created():Boolean {
        return Boolean(_textureAtlas);
    }

    private var _scale: Number;
    public function get scale():Number
    {
        return _scale;
    }

    public function getAtlas():Texture {
        return _textureAtlas ? _textureAtlas.texture : null;
    }

    public function getTexture(name: String):Texture {
        return _textureAtlas ? _textureAtlas.getTexture(name) : null;
    }

    public function getTextures(name: String):Vector.<Texture> {
        return _textureAtlas ? _textureAtlas.getTextures(name) : null;
    }

    public function Atlas(scale: Number = 1) {
        _scale = scale;
    }

    public function addGraphics(className: String, graphics: DisplayObject):void {
        graphics.scaleX *= scale;
        graphics.scaleY *= scale;

        var rect: Rectangle = graphics.getBounds(graphics);
        var bd: BitmapData = new BitmapData(graphics.width, graphics.height, true, 0);
        bd.draw(graphics, new Matrix(scale,0,0,scale,-rect.x*scale,-rect.y*scale));

        addBitmapData(className, bd, true);

        graphics.scaleX /= scale;
        graphics.scaleY /= scale;
    }

    public function addBitmapData(className: String, bitmapData: BitmapData, preScaled: Boolean = false):void {
//        trace(className + " texture added");
        _textures[className] = preScaled ? bitmapData : scaleBitmapData(bitmapData, scale);
    }

    public function addFont(className: String, chars: String, font: String, size: int, color: uint, bold: Boolean, advance: int = 1):void {
        _fontsParams[className] = [chars, font, size * scale, color, bold, advance];
    }

    public function build(debug: Boolean = false):void {
//        for (var name: String in _fontsParams) {
//            var params: Array = _fontsParams[name].slice();
//            params.push(scale);
//            var font: FontData = FontBuilder.buildFontFromChars.apply(this, params);
//            var font: FontData = FontBuilder.buildFontFromChars.apply(this, _fontsParams[name]);
//            _fonts[name] = font;
//            _textures[name] = font.texture;
//        }

        var atlasData: AtlasData = TextureAtlasBuilder.buildTextureAtlas(_textures, 2, true, true, debug);
        var texture: Texture = Texture.fromBitmapData(atlasData.texture, false, true);
        var xml: XML = TextureAtlasBuilder.getTextureXml(atlasData);

        _textureAtlas = new TextureAtlas(texture, xml);

//        for (name in _fonts) {
//            font = _fonts[name];
//            texture = getTexture(name);
//
//            TextField.registerBitmapFont(new BitmapFont(texture, font.xml), name);
//        }

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

    private static function scaleBitmapData(bitmapData:BitmapData, scale:Number):BitmapData {
        scale = Math.abs(scale);
        var width:int = (bitmapData.width * scale) || 1;
        var height:int = (bitmapData.height * scale) || 1;
        var transparent:Boolean = bitmapData.transparent;
        var result:BitmapData = new BitmapData(width, height, transparent, 0x00000000);
        var matrix:Matrix = new Matrix();
        matrix.scale(scale, scale);
        result.draw(bitmapData, matrix);
        return result;
    }
}
}
