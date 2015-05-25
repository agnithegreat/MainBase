/**
 * Created by kirillvirich on 13.02.15.
 */
package com.agnither.utils.gui.atlas {
import com.agnither.utils.gui.font.CharsetUtil;

import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
    import flash.display.MovieClip;
    import flash.display.Shape;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.utils.Dictionary;
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;

public class AtlasFactory {

    private static const RESOURCES: Dictionary = new Dictionary(true);

    public static function fromAtlasDefinition(definition: String):Atlas {
        var ResourceClass: Class = getDefinitionByName(definition) as Class;
        return fromAtlasMC(ResourceClass);
    }

    public static function fromAtlasMC(ResourceClass: Class):Atlas {
        if (!RESOURCES[ResourceClass]) {
            RESOURCES[ResourceClass] = new ResourceClass();
        }

        var atlas: Atlas = new Atlas();
        checkChild(RESOURCES[ResourceClass], null, atlas);
        return atlas;
    }

    public static function checkChild(child: DisplayObject, parent: DisplayObjectContainer, atlas: Atlas):void {
        child.scaleX = 1;
        child.scaleY = 1;

        var className: String = parent ? getQualifiedClassName(parent) : "";

        if (child is DisplayObjectContainer) {
            parent = child as DisplayObjectContainer;
            if (parent is MovieClip) {
                var mc: MovieClip = parent as MovieClip;
                for (var i:int = 0; i < mc.totalFrames; i++) {
                    mc.gotoAndStop(i+1);
                    checkContainer(mc, atlas);
                }
            } else {
                checkContainer(parent, atlas);
            }
        } else if (child is Shape) {
            atlas.addGraphics(className, child);
        } else if (child is Bitmap) {
            var bitmap: Bitmap = child as Bitmap;
            atlas.addBitmapData(className, bitmap.bitmapData);
            bitmap = null;
        } else if (child is TextField) {
            var textfield: TextField = child as TextField;
            var format: TextFormat = textfield.defaultTextFormat;
//            atlas.addFont(format.font+format.size, CharsetUtil.getChars(textfield.text), format.font, int(format.size), uint(format.color), format.bold);
            atlas.addFont(className, CharsetUtil.getChars(textfield.text), format.font, int(format.size), uint(format.color), format.bold);
            format = null;
            textfield = null;
        }
    }

    private static function checkContainer(container: DisplayObjectContainer, atlas: Atlas):void {
        for (var i:int = 0; i < container.numChildren; i++) {
            checkChild(container.getChildAt(i), container, atlas);
        }
    }
}
}
