/**
 * Created by kirillvirich on 29.01.15.
 */
package com.agnither.utils.gui.components {
import com.agnither.utils.gui.GUIFactory;

import flash.utils.Dictionary;

import starling.display.DisplayObject;
import starling.display.Sprite;
import starling.events.Event;

public class AbstractComponent extends Sprite {

    private static const RESOURCES: Dictionary = new Dictionary(true);

    protected var _links: Object;

    public function AbstractComponent() {
        _links = {};

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
            _links[child.name] = child;
        }
        return super.addChild(child);
    }

    override public function removeChild(child: DisplayObject, dispose: Boolean = false):DisplayObject {
        if (child && child.name) {
            delete _links[child.name];
        }
        return super.removeChild(child, dispose);
    }

    public function destroy():void {
        for (var key:String in _links) {
            if (_links[key] is AbstractComponent) {
                _links[key].destroy();
            }
            removeChild(_links[key], true);
            delete _links[key];
        }
        _links = null;
    }
}
}
