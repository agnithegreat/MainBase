/**
 * Created by kirillvirich on 09.02.15.
 */
package com.agnither.utils.gui.font {
import com.agnither.utils.gui.atlas.AtlasData;
import com.agnither.utils.gui.atlas.TextureAtlasBuilder;

import flash.display.BitmapData;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.engine.ElementFormat;
import flash.text.engine.FontDescription;
import flash.text.engine.FontWeight;
import flash.text.engine.TextBlock;
import flash.text.engine.TextElement;
import flash.text.engine.TextLine;

public class FontBuilder {

    public static function buildFontFromChars(text: String, font: String, size: int, color: uint, bold: Boolean, advance: int = 0):FontData {
        var fontDescription: FontDescription = new FontDescription(font, bold ? FontWeight.BOLD : FontWeight.NORMAL);
        var elementFormat: ElementFormat = new ElementFormat(fontDescription, size, color);
        var textElement: TextElement = new TextElement(text, elementFormat);

        var textBlock: TextBlock = new TextBlock();
        textBlock.content = textElement;

        var textLine: TextLine = textBlock.createTextLine();
        var baseline: Number = textLine.ascent;

        var texture: BitmapData = new BitmapData(Math.ceil(textLine.width), Math.ceil(textLine.height), true, 0);
        texture.draw(textLine, new Matrix(1, 0, 0, 1, 0, Math.ceil(baseline)));

        var charsMap: Object = {};
        var textureMap: Object = {};
        var lastX: Number = 0;
        for (var i:int = 0; i < textLine.atomCount; i++) {
            var code: int = text.charCodeAt(i);
            var charBounds: Rectangle = textLine.getAtomBounds(i);
            charBounds.y = 0;

            var charTexture: BitmapData = new BitmapData(Math.ceil(charBounds.width), Math.ceil(charBounds.height), true, 0);
            charTexture.copyPixels(texture, charBounds, new Point());

            charBounds.x -= lastX;
            charBounds.y = textLine.descent * 0.6;
            lastX += charBounds.width;

            charBounds.x = Math.round(charBounds.x);
            charBounds.y = Math.round(charBounds.y);
            charBounds.width = Math.floor(charBounds.width);
            charBounds.height = Math.floor(charBounds.height);

            var charData: CharData = new CharData(charTexture, charBounds);
            charsMap[code] = charData;
            textureMap[code] = charTexture;
        }

        var atlas: AtlasData = TextureAtlasBuilder.buildTextureAtlas(textureMap, 2, false, false);

        var xml: XML = <font />;

        var info: XML = <info />;
        info.@face = font;
        info.@size = size;
        xml.appendChild(info);

        var common: XML = <common />;
        common.@lineHeight = size;
//        common.@base = baseline;
        xml.appendChild(common);

        var pages: XML = <pages />;
        var page: XML = <page id="0" file="texture.png" />;
        pages.appendChild(page);
        xml.appendChild(pages);

        var chars: XML = <chars />;
        for (code in charsMap) {
            charData = charsMap[code];
            var rect: Rectangle = atlas.map[code];

            var char: XML = <char />;
            char.@id = code;
            char.@x = rect.x;
            char.@y = rect.y;
            char.@width = rect.width;
            char.@height = rect.height;
            char.@xoffset = charData.bounds.x;
            char.@yoffset = charData.bounds.y;
            char.@xadvance = charData.bounds.width + advance;
            chars.appendChild(char);
        }
        xml.appendChild(chars);

        return new FontData(atlas.texture, atlas.map, xml);
    }
}
}
