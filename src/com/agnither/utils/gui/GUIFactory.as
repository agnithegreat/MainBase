/**
 * Created by kirillvirich on 29.01.15.
 */
package com.agnither.utils.gui {
import com.agnither.utils.gui.components.AbstractComponent;
import com.agnither.utils.gui.components.Button;
import com.agnither.utils.gui.components.Label;
import com.agnither.utils.gui.components.Picture;
import com.agnither.utils.gui.components.Scale9Picture;

import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Shape;
import flash.text.TextField;

public class GUIFactory {

    public static function createView(parent: AbstractComponent, inView: DisplayObjectContainer, atlas: String = null):AbstractComponent {
        var child: DisplayObject;
        var newChild: AbstractComponent;
        for (var i:int = 0; i < inView.numChildren; i++) {
            child = inView.getChildAt(i);

            if (child is Shape) {
                newChild = new Picture(Resources.getTexture(parent.name, atlas));
            } else if (child is Bitmap) {
                newChild = new Picture(Resources.getTexture(parent.name, atlas));
            } else if (child is TextField) {
                newChild = new Label(child.width, child.height, "", child.name);
            } else if (child is DisplayObjectContainer) {
                if (child.scale9Grid) {
                    newChild = new Scale9Picture(Resources.getTexture(child.name, atlas), child.scale9Grid);
                } else if (child.name.search("btn_") == 0) {
                    newChild = new Button();
                } else {
                    newChild = new AbstractComponent();
                }
                newChild.name = child.name;

                if (!child.scale9Grid) {
                    createView(newChild, child as DisplayObjectContainer, atlas);
                }
            }

            if (newChild) {
                newChild.name = child.name;
                if (child.scale9Grid) {
                    newChild.transformFromMatrix(child.transform.matrix);
                } else {
                    newChild.transformationMatrix = child.transform.matrix;
                }
                parent.addChild(newChild);
            }

            child = null;

            newChild = null;
        }

        return parent;
    }
}
}
