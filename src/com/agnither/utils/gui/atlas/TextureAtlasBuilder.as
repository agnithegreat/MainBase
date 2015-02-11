/**
 * Created by kirillvirich on 09.02.15.
 */
package com.agnither.utils.gui.atlas {
import com.dragonbones.core.utils.TextureUtil;

import flash.display.BitmapData;
import flash.display.Shape;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

public class TextureAtlasBuilder {

    public static function buildTextureAtlas(textureMap: Object, padding: int = 2, isNearest2N: Boolean = true, extrude: Boolean = true, drawBorders: Boolean = false):AtlasData {
        var rectMap: Object = {};

        var texture: BitmapData;
        for (var key: String in textureMap) {
            texture = textureMap[key];
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

            texture.dispose();

            if (extrude) {
                extrudeTexture(atlas, placeRect);
            }

            if (drawBorders) {
                drawBorder(atlas, placeRect);
            }
        }

        return new AtlasData(atlas, rectMap);
    }

    private static function drawBorder(atlas: BitmapData, rect: Rectangle, thickness: int = 1):void {
        var border: Shape = new Shape();
        border.graphics.beginFill(0xFF0000);
        border.graphics.drawRect(0,0,rect.width, rect.height);
        border.graphics.drawRect(thickness,thickness,rect.width-2*thickness, rect.height-2*thickness);

        atlas.draw(border, getTemporaryMatrix(rect.x, rect.y));

        border.graphics.clear();
    }

    private static function extrudeTexture(atlas: BitmapData, rect: Rectangle):void {
        const thickness: int = 1;

        // sides
        atlas.copyPixels(atlas, getTemporaryRect(rect.x, rect.y, rect.width, thickness), getTemporaryPoint(rect.x, rect.y-thickness));
        atlas.copyPixels(atlas, getTemporaryRect(rect.x, rect.y+rect.height-thickness, rect.width, thickness), getTemporaryPoint(rect.x, rect.y+rect.height));
        atlas.copyPixels(atlas, getTemporaryRect(rect.x, rect.y, thickness, rect.height), getTemporaryPoint(rect.x-thickness, rect.y));
        atlas.copyPixels(atlas, getTemporaryRect(rect.x+rect.width-thickness, rect.y, thickness, rect.height), getTemporaryPoint(rect.x+rect.width, rect.y));

        // corners
        atlas.copyPixels(atlas, getTemporaryRect(rect.x, rect.y, thickness, thickness), getTemporaryPoint(rect.x-thickness, rect.y-thickness));
        atlas.copyPixels(atlas, getTemporaryRect(rect.x, rect.y+rect.height-thickness, thickness, thickness), getTemporaryPoint(rect.x-thickness, rect.y+rect.height));
        atlas.copyPixels(atlas, getTemporaryRect(rect.x+rect.width-thickness, rect.y, thickness, thickness), getTemporaryPoint(rect.x+rect.width, rect.y-thickness));
        atlas.copyPixels(atlas, getTemporaryRect(rect.x+rect.width-thickness, rect.y+rect.height-thickness, thickness, thickness), getTemporaryPoint(rect.x+rect.width, rect.y+rect.height));
    }

    private static var temporaryRect: Rectangle;
    private static function getTemporaryRect(x: int, y: int, width: int, height: int):Rectangle {
        if (!temporaryRect) {
            temporaryRect = new Rectangle();
        }
        temporaryRect.x = x;
        temporaryRect.y = y;
        temporaryRect.width = width;
        temporaryRect.height = height;
        return temporaryRect;
    }

    private static var temporaryPoint: Point;
    private static function getTemporaryPoint(x: int, y: int):Point {
        if (!temporaryPoint) {
            temporaryPoint = new Point();
        }
        temporaryPoint.x = x;
        temporaryPoint.y = y;
        return temporaryPoint;
    }

    private static var temporaryMatrix: Matrix;
    private static function getTemporaryMatrix(dx: int, dy: int):Matrix {
        if (!temporaryMatrix) {
            temporaryMatrix = new Matrix();
        }
        temporaryMatrix.translate(dx, dy);
        return temporaryMatrix;
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
