/**
 * Created by kirillvirich on 29.01.15.
 */
package com.agnither.utils.gui.components {
import com.agnither.utils.gui.GUIFactory;

import flash.display.DisplayObjectContainer;
import flash.utils.Dictionary;

import starling.display.DisplayObject;
import starling.display.Sprite;
import starling.events.Event;

public class AbstractComponent extends Sprite {

    protected var _links: Dictionary;

    public function AbstractComponent() {
        _links = new Dictionary();

        addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
    }

    protected function initialize():void {

    }

    private function handleAddedToStage(e: Event):void {
        removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);

        initialize();
    }

    public function createFromFlash(child: DisplayObjectContainer):void {
        GUIFactory.createView(this, child);
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
        }
        _links = null;
    }
}
}
