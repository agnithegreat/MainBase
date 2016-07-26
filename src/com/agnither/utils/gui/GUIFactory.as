/**
 * Created by kirillvirich on 29.01.15.
 */
package com.agnither.utils.gui
{
    import com.agnither.utils.gui.components.AbstractComponent;
    import com.agnither.utils.gui.components.Button;
    import com.agnither.utils.gui.components.Label;
    import com.agnither.utils.gui.components.Picture;
    import com.agnither.utils.gui.components.Scale9Picture;
    import com.agnither.utils.gui.components.SpriteAnimation;

    import flash.display.Bitmap;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.MovieClip;
    import flash.display.Shape;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.text.TextField;
    import flash.utils.Dictionary;
    import flash.utils.getQualifiedClassName;

    import starling.textures.Texture;

    public class GUIFactory
    {
        public static function createView(inView: DisplayObjectContainer, scale: Number = 1, manifest: Dictionary = null):AbstractComponent
        {
            return getChild(inView, inView, scale, manifest);
        }

        public static function createChildren(parent: AbstractComponent, inView: DisplayObjectContainer, scale: Number = 1, manifest: Dictionary = null):void
        {
            for (var i:int = 0; i < inView.numChildren; i++) {
                var child: DisplayObject = inView.getChildAt(i);
                var newChild: AbstractComponent = getChild(child, inView, scale, manifest);
                parent.addChild(newChild);
            }
        }

        private static function getChild(view: DisplayObject, parent: DisplayObjectContainer, scale: Number = 1, manifest: Dictionary = null, scale9GridTarget: DisplayObject = null):AbstractComponent
        {
            if (view.scale9Grid != null && scale9GridTarget == null)
            {
                scale9GridTarget = view;
            }

            var newChild: AbstractComponent;

            var pivotRect: Rectangle = view.getBounds(view);
            var pivot: Point = new Point(-pivotRect.x * scale, -pivotRect.y * scale);

            var className: String = getQualifiedClassName(view);
            if (manifest && manifest[className])
            {
                var ComponentClass: Class = manifest[className];
                newChild = new ComponentClass();
            } else if (view is Shape)
            {
//                newChild = new Picture(Resources.getTexture(getQualifiedClassName(parent), atlas), pivot);
                newChild = new Picture(Texture.fromColor(view.width * scale, view.height * scale, 0xFF000000), pivot);
            } else if (view is Bitmap)
            {
                if (scale9GridTarget != null)
                {
                    newChild = new Scale9Picture(Resources.getTexture(getQualifiedClassName((view as Bitmap).bitmapData)), getScaledRect(scale9GridTarget.scale9Grid, scale), pivot);
                } else {
                    newChild = new Picture(Resources.getTexture(getQualifiedClassName((view as Bitmap).bitmapData)), pivot);
                }
                (view as Bitmap).bitmapData.dispose();
            } else if (view is TextField)
            {
                var tf:TextField = view as TextField;
//                newChild = new Label(view.width * scale, view.height * scale, tf.text, getQualifiedClassName(parent), -1, 0xFFFFFF, false, pivot);
//                newChild = new Label(view.width * scale, view.height * scale, "", tf.defaultTextFormat.font+tf.defaultTextFormat.size, -1, 0xFFFFFF, false, pivot);
                newChild = new Label(view.width * scale, view.height * scale, tf.text, tf.defaultTextFormat.font, int(tf.defaultTextFormat.size) * scale, uint(tf.defaultTextFormat.color), false, tf.defaultTextFormat.align, pivot);
                (newChild as Label).setFilters(tf.filters, scale);
            } else if (view is MovieClip && (view as MovieClip).totalFrames > 1)
            {
                newChild = new SpriteAnimation(Resources.getTextures(getQualifiedClassName(parent)), view as MovieClip, pivot, scale);
            } else if (view is DisplayObjectContainer)
            {
                if (view.name.search("btn_") == 0)
                {
                    newChild = new Button();
                } else {
                    newChild = new AbstractComponent();
                }

                var child: DisplayObject;
                var childContainer: DisplayObjectContainer = view as DisplayObjectContainer;
                for (var i:int = 0; i < childContainer.numChildren; i++)
                {
                    child = childContainer.getChildAt(i);
                    var tempChild: AbstractComponent = getChild(child, childContainer, scale, manifest, scale9GridTarget);
                    if (child.name.search("instance") == 0)
                    {
                        newChild = tempChild;
                        break;
                    } else {
                        newChild.addChild(tempChild);
                    }
                    child = null;
                }
            }

            newChild.transformationMatrix = view.transform.matrix;
            if (scale9GridTarget != null)
            {
                if (newChild is Scale9Picture)
                {
                    newChild.width = scale9GridTarget.width * scale;
                    newChild.height = scale9GridTarget.height * scale;
                } else {
                    newChild.scaleX = 1;
                    newChild.scaleY = 1;
                }
            }
            newChild.x *= scale;
            newChild.y *= scale;
            newChild.name = view.name;
            return newChild;
        }

        private static function getScaledRect(rect: Rectangle, scale: Number):Rectangle
        {
            var rect: Rectangle = rect.clone();
            rect.x *= scale;
            rect.y *= scale;
            rect.width *= scale;
            rect.height *= scale;
            return rect;
        }
    }
}
