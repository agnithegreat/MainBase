/**
 * Created by kirillvirich on 29.01.15.
 */
package com.agnither.utils.gui.components {
import com.agnither.utils.gui.GUIFactory;

import flash.geom.Matrix;

import flash.geom.Rectangle;
import flash.utils.Dictionary;

import starling.display.DisplayObject;
import starling.display.Sprite;
import starling.events.Event;

public dynamic class AbstractComponent extends Sprite {

    private static const RESOURCES: Dictionary = new Dictionary(true);

    public var scale9Grid: Rectangle;

    public function AbstractComponent() {
        addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
    }

    protected function initialize():void {

    }

    private function handleAddedToStage(e: Event):void {
        removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);

        initialize();
    }

    public function createFromFlash(ResourceClass: Class, atlas: String = null):void {
        if (!RESOURCES[ResourceClass]) {
            RESOURCES[ResourceClass] = new ResourceClass();
        }
        GUIFactory.createView(this, RESOURCES[ResourceClass], atlas);
    }

    override public function addChild(child: DisplayObject):DisplayObject {
        if (child && child.name) {
            this[child.name] = child;
        }
        return super.addChild(child);
    }

    override public function removeChild(child: DisplayObject, dispose: Boolean = false):DisplayObject {
        if (child && child.name) {
            delete this[child.name];
        }
        return super.removeChild(child, dispose);
    }

    public function transformChildren(matrix: Matrix):void {
        for (var i:int = 0; i < numChildren; i++) {
            var child: DisplayObject = getChildAt(i);
            child.x = matrix.tx;
            child.y = matrix.ty;
            child.width = child.width * matrix.a;
            child.height = child.height * matrix.d;
        }
    }

    public function destroy():void {
        for (var key:String in this) {
            if (this[key] is AbstractComponent) {
                this[key].destroy();
            }
            removeChild(this[key], true);
            delete this[key];
            this[key] = null;
        }

        removeFromParent(true);
    }
}
}
