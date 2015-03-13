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

    protected function getManifest():Dictionary {
        return null;
    }

    protected var _children: Dictionary;

    public function getChild(path: String):AbstractComponent {
        if (path.length == 0) {
            return this;
        }

        var nodes: Array = path.split(".");
        var node: String = nodes.shift();
        if (_children.hasOwnProperty(node)) {
            return (_children[node] as AbstractComponent).getChild(nodes.join("."));
        }
        return null;
    }

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
        GUIFactory.createView(this, RESOURCES[ResourceClass], atlas, getManifest());
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
