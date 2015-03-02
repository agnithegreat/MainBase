/**
 * Created by kirillvirich on 29.01.15.
 */
package com.agnither.utils.gui.components {
import com.agnither.utils.gui.GUIFactory;

import flash.geom.Matrix;
import flash.utils.Dictionary;

import starling.display.DisplayObject;
import starling.display.Sprite;
import starling.events.Event;

public class AbstractComponent extends Sprite {

    private static const RESOURCES: Dictionary = new Dictionary(true);

    private var _children: Dictionary;

    private var _baseWidth: int;
    private var _baseHeight: int;

    public function AbstractComponent() {
        _children = new Dictionary(true);

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
            _children[child.name] = child;
        }
        return super.addChild(child);
    }

    override public function removeChild(child: DisplayObject, dispose: Boolean = false):DisplayObject {
        if (child && child.name) {
            delete _children[child.name];
        }
        return super.removeChild(child, dispose);
    }

    public function transformFromMatrix(matrix: Matrix):void {
        if (!_baseWidth) {
            _baseWidth = width;
        }
        if (!_baseHeight) {
            _baseHeight = height;
        }

        x = matrix.tx;
        y = matrix.ty;
        width = _baseWidth * matrix.a;
        height = _baseHeight * matrix.d;
    }

    override public function dispose():void {
        for (var key:String in this) {
            if (_children[key] is AbstractComponent) {
                (_children[key] as AbstractComponent).destroy();
            }
            _children[key] = null;
            delete _children[key];
        }
        _children = null;

        super.dispose();
    }

    public function destroy():void {
        removeFromParent(true);
    }
}
}
