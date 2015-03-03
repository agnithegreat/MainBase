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
import flash.utils.getQualifiedClassName;

public class GUIFactory {

    public static function createView(parent: AbstractComponent, inView: DisplayObjectContainer, atlas: String = null):void {
        for (var i:int = 0; i < inView.numChildren; i++) {
            var child: DisplayObject = inView.getChildAt(i);
            var newChild: AbstractComponent = getChild(child, inView, atlas);
            parent.addChild(newChild);
        }
    }

    private static function getChild(view: DisplayObject, parent: DisplayObjectContainer, atlas: String = null):AbstractComponent {
        var newChild: AbstractComponent;

        if (parent.scale9Grid) {
            newChild = new Scale9Picture(Resources.getTexture(getQualifiedClassName(parent), atlas), parent.scale9Grid);
        } else if (view is Shape) {
            newChild = new Picture(Resources.getTexture(getQualifiedClassName(parent), atlas));
        } else if (view is Bitmap) {
            newChild = new Picture(Resources.getTexture(getQualifiedClassName(parent), atlas));
        } else if (view is TextField) {
            newChild = new Label(view.width, view.height, "", getQualifiedClassName(parent));
        } else if (view is DisplayObjectContainer) {
            if (view.name.search("btn_") == 0) {
                newChild = new Button();
            } else {
                newChild = new AbstractComponent();
            }

            var child: DisplayObject;
            var childContainer: DisplayObjectContainer = view as DisplayObjectContainer;
            for (var i:int = 0; i < childContainer.numChildren; i++) {
                child = childContainer.getChildAt(i);
                var tempChild: AbstractComponent = getChild(child, childContainer, atlas);
                if (child.name.search("instance") == 0) {
                    newChild = tempChild;
                    break;
                } else {
                    newChild.addChild(tempChild);
                }
                child = null;
            }
        }
        newChild.transformationMatrix = view.transform.matrix;
        newChild.name = view.name;
        return newChild;
    }
}
}
