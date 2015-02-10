/**
 * Created by kirillvirich on 09.02.15.
 */
package com.agnither.utils.gui.font {
import com.agnither.utils.gui.atlas.AtlasData;
import com.agnither.utils.gui.atlas.TextureAtlasBuilder;

import flash.display.BitmapData;
import flash.geom.Rectangle;
import flash.text.AntiAliasType;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.text.TextLineMetrics;

public class FontBuilder {

    public static function buildFontFromChars(chars: String, font: String, size: int, color: uint, bold: Boolean):FontData {
        var tf: TextField = new TextField();
        tf.autoSize = TextFieldAutoSize.LEFT;
        tf.defaultTextFormat = new TextFormat(font, size, color, bold);
        tf.text = chars;
        return buildFontFromTextField(tf);
    }

    public static function buildFontFromTextField(textField: TextField):FontData {
        var format: TextFormat = textField.defaultTextFormat;
        format.leftMargin = 0;
        format.rightMargin = 0;
        var fontName: String = format.font;
        var fontSize: Object = format.size;


        var metrics: TextLineMetrics = textField.getLineMetrics(0);
        trace(metrics.ascent, metrics.descent, metrics.leading);
        var baseLine: int = metrics.ascent - metrics.descent;

        var text: String = textField.text + " ";

        var charsMap: Object = {};
        for (var i:int = 0; i < text.length; i++) {
            var code: Number = text.charCodeAt(i);
            charsMap[code] = text.charAt(i);
        }

        var textureMap: Object = {};
        for (var key: String in charsMap) {
            var tf: TextField = new TextField();
            tf.autoSize = TextFieldAutoSize.LEFT;
            tf.antiAliasType = AntiAliasType.ADVANCED;
            tf.defaultTextFormat = format;
            tf.text = charsMap[key];
            textureMap[key] = getCharTexture(tf);
        }

        var atlas: AtlasData = TextureAtlasBuilder.buildTextureAtlas(textureMap, 2, false, false, true);

        var xml: XML = <font />;

        var info: XML = <info />;
        info.@face = fontName;
        info.@size = fontSize;
        xml.appendChild(info);

        var common: XML = <common />;
        common.@lineHeight = fontSize;
//        common.@base = baseLine-20;
        xml.appendChild(common);

        var pages: XML = <pages />;
        var page: XML = <page id="0" file="texture.png" />;
        pages.appendChild(page);
        xml.appendChild(pages);

        var chars: XML = <chars />;
        for (key in charsMap) {
            var rect: Rectangle = atlas.map[key];
            var char: XML = <char />;
            char.@id = key;
            char.@x = rect.x;
            char.@y = rect.y;
            char.@width = rect.width;
            char.@height = rect.height;
            char.@xoffset = -2;
            char.@yoffset = metrics.ascent-metrics.descent;
            char.@xadvance = rect.width-4;
            chars.appendChild(char);
        }
        xml.appendChild(chars);

        return new FontData(atlas.texture, atlas.map, xml);
    }

    private static function getCharTexture(char: TextField):BitmapData {
        var texture:BitmapData = new BitmapData(char.width, char.height, true, 0);
        texture.draw(char);
        return texture;
    }
}
}
