/**
 * Created by kirillvirich on 09.02.15.
 */
package com.agnither.utils.gui.atlas {
import com.dragonbones.core.utils.TextureUtil;

import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;

public class TextureAtlasBuilder {

    public static function buildTextureAtlas(textureMap: Object, padding: int = 2, isNearest2N: Boolean = true):AtlasData {
        var rectMap: Object = {};

        for (var key: String in textureMap) {
            var texture: BitmapData = textureMap[key];
            rectMap[key] = new Rectangle(0, 0, texture.width, texture.height);
        }

        var size: Rectangle = TextureUtil.packTextures(0, padding, rectMap, false, isNearest2N);
        var atlas: BitmapData = new BitmapData(size.width, size.height, true, 0);

        var textureRect: Rectangle = new Rectangle();
        var placeRect: Rectangle;
        for (key in rectMap) {
            texture = textureMap[key];
            textureRect.width = texture.width;
            textureRect.height = texture.height;

            placeRect = rectMap[key];

            atlas.copyPixels(texture, textureRect, placeRect.topLeft);
            extrudeTexture(atlas, placeRect);
        }

        return new AtlasData(atlas, rectMap);
    }

    private static function extrudeTexture(atlas: BitmapData, rect: Rectangle):void {
        const thickness: int = 1;

        // sides
        atlas.copyPixels(atlas, new Rectangle(rect.x, rect.y, rect.width, thickness), new Point(rect.x, rect.y-thickness));
        atlas.copyPixels(atlas, new Rectangle(rect.x, rect.y+rect.height-thickness, rect.width, thickness), new Point(rect.x, rect.y+rect.height));
        atlas.copyPixels(atlas, new Rectangle(rect.x, rect.y, thickness, rect.height), new Point(rect.x-thickness, rect.y));
        atlas.copyPixels(atlas, new Rectangle(rect.x+rect.width-thickness, rect.y, thickness, rect.height), new Point(rect.x+rect.width, rect.y));

        // corners
        atlas.copyPixels(atlas, new Rectangle(rect.x, rect.y, thickness, thickness), new Point(rect.x-thickness, rect.y-thickness));
        atlas.copyPixels(atlas, new Rectangle(rect.x, rect.y+rect.height-thickness, thickness, thickness), new Point(rect.x-thickness, rect.y+rect.height));
        atlas.copyPixels(atlas, new Rectangle(rect.x+rect.width-thickness, rect.y, thickness, thickness), new Point(rect.x+rect.width, rect.y-thickness));
        atlas.copyPixels(atlas, new Rectangle(rect.x+rect.width-thickness, rect.y+rect.height-thickness, thickness, thickness), new Point(rect.x+rect.width, rect.y+rect.height));
    }

    public static function getTextureXml(atlas: AtlasData, path: String = null):XML {
        var xml: XML = <TextureAtlas />;
        xml.@imagePath = path ? path : "";

        for (var key: String in atlas.map) {
            var subTexture: XML = <SubTexture />;
            var rect: Rectangle = atlas.map[key];
            subTexture.@name = key;
            subTexture.@x = rect.x;
            subTexture.@y = rect.y;
            subTexture.@width = rect.width;
            subTexture.@height = rect.height;
            xml.appendChild(subTexture);
        }

        return xml;
    }
}
}
