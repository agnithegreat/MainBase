/**
 * Created by kirillvirich on 29.01.15.
 */
package com.agnither.utils.gui.components {
import com.agnither.utils.gui.GUIFactory;

import flash.utils.Dictionary;

import starling.display.DisplayObject;
import starling.display.Sprite;
import starling.events.Event;

public dynamic class AbstractComponent extends Sprite {

    private static const RESOURCES: Dictionary = new Dictionary(true);

    public function AbstractComponent() {
        addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
    }

    protected function initialize():void {

    }

    private function handleAddedToStage(e: Event):void {
        removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);

        initialize();
    }

    public function createFromFlash(ResourceClass: Class):void {
        if (!RESOURCES[ResourceClass]) {
            RESOURCES[ResourceClass] = new ResourceClass();
        }
        GUIFactory.createView(this, RESOURCES[ResourceClass]);
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
