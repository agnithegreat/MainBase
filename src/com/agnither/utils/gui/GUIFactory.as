/**
 * Created by kirillvirich on 29.01.15.
 */
package com.agnither.utils.gui {
import com.agnither.utils.gui.components.AbstractComponent;
import com.agnither.utils.gui.components.Button;
import com.agnither.utils.gui.components.Label;
import com.agnither.utils.gui.components.Picture;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Shape;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.text.TextFormat;

import starling.textures.Texture;

import starling.utils.AssetManager;

public class GUIFactory {

    private static var assetManager: AssetManager;

    public static function init(inAssetManager: AssetManager):void {
        assetManager = inAssetManager;
    }

    public static function createView(parent: AbstractComponent, inView: DisplayObjectContainer):AbstractComponent {
        for (var i:int = 0; i < inView.numChildren; i++) {
            var child: DisplayObject = inView.getChildAt(i);

            var newChild: AbstractComponent;
            if (child is Shape) {
                var shape: Shape = child as Shape;
                var rect: Rectangle = shape.getBounds(shape);
                var bitmapData: BitmapData = new BitmapData(shape.width, shape.height, true, 0);
                bitmapData.draw(shape, new Matrix(1, 0, 0, 1, -rect.x, -rect.y));
                shape.transform.matrix = new Matrix(1, 0, 0, 1, rect.x, rect.y);
                newChild = new Picture(Texture.fromBitmapData(bitmapData));
            } else if (child is Bitmap) {
                var bitmap:Bitmap = child as Bitmap;
                bitmapData = new BitmapData(bitmap.width + 2, bitmap.height + 2, true, 0);
                bitmapData.draw(bitmap, new Matrix(1, 0, 0, 1, 1, 1));
                newChild = new Picture(Texture.fromBitmapData(bitmapData));
//                var bitmapName:String = getQualifiedClassName(bitmap.bitmapData);
//                newChild = new Picture(assetManager.getTexture(bitmapName));
            } else if (child is TextField) {
                var textField: TextField = child as TextField;
                var textFormat: TextFormat = textField.getTextFormat();
                newChild = new Label(textField.width, textField.height, textField.text, textFormat.font, int(textFormat.size), int(textFormat.color), textFormat.bold);
            } else if (child is DisplayObjectContainer) {
                if (child.name.search("btn_") == 0) {
                    newChild = new Button();
                } else {
                    newChild = new AbstractComponent();
                }
                newChild.createFromFlash(child as DisplayObjectContainer);
            }

            trace(child, child.name, newChild);
            if (newChild) {
                newChild.name = child.name;
                newChild.transformationMatrix = child.transform.matrix;
                parent.addChild(newChild);
            }
        }

        return parent;
    }
}
}
