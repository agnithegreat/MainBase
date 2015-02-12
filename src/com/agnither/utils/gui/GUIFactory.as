/**
 * Created by kirillvirich on 29.01.15.
 */
package com.agnither.utils.gui {
import com.agnither.game2048.storage.Resources;
import com.agnither.utils.gui.components.AbstractComponent;
import com.agnither.utils.gui.components.Button;
import com.agnither.utils.gui.components.Label;
import com.agnither.utils.gui.components.Picture;

import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Shape;
import flash.text.TextField;

public class GUIFactory {

    public static function createView(parent: AbstractComponent, inView: DisplayObjectContainer):AbstractComponent {
        var child: DisplayObject;
        var newChild: AbstractComponent;
        for (var i:int = 0; i < inView.numChildren; i++) {
            child = inView.getChildAt(i);

            if (child is Shape) {
//                var shape: Shape = child as Shape;
//                var rect: Rectangle = shape.getBounds(shape);
//                var bitmapData: BitmapData = new BitmapData(shape.width, shape.height, true, 0);
//                bitmapData.draw(shape, new Matrix(1, 0, 0, 1, -rect.x, -rect.y));
//                shape.transform.matrix = new Matrix(1, 0, 0, 1, rect.x, rect.y);
//                newChild = new Picture(Texture.fromBitmapData(bitmapData));
                newChild = new Picture(Resources.getTexture(parent.name));
            } else if (child is Bitmap) {
                newChild = new Picture(Resources.getTexture(parent.name));
            } else if (child is TextField) {
                var textField: TextField = child as TextField;
                newChild = new Label(textField.width, textField.height, "", child.name);
                textField = null;
            } else if (child is DisplayObjectContainer) {
                if (child.name.search("btn_") == 0) {
                    newChild = new Button();
                } else {
                    newChild = new AbstractComponent();
                }
                newChild.name = child.name;
                createView(newChild, child as DisplayObjectContainer);
            }

            if (newChild) {
                newChild.name = child.name;
                newChild.transformationMatrix = child.transform.matrix;
                parent.addChild(newChild);
            }

            newChild = null;
        }

        return parent;
    }
}
}
