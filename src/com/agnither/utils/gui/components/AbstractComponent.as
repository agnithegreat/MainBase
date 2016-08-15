/**
 * Created by kirillvirich on 29.01.15.
 */
package com.agnither.utils.gui.components
{
    import com.agnither.utils.gui.GUIFactory;

    import flash.display.DisplayObjectContainer;
    import flash.utils.Dictionary;
    import flash.utils.getDefinitionByName;

    import starling.animation.Transitions;

    import starling.core.Starling;

    import starling.display.DisplayObject;
    import starling.display.Sprite;
    import starling.events.Event;

    public class AbstractComponent extends Sprite
    {
        public static const SHOW_MARKER: String = "show";
        public static const HIDE_MARKER: String = "hide";
        
        private static const RESOURCES: Dictionary = new Dictionary(true);
        public static function getResource(definition: String):DisplayObjectContainer
        {
            if (!RESOURCES[definition])
            {
                var ResourceClass: Class = getDefinitionByName(definition) as Class;
                RESOURCES[definition] = new ResourceClass();
            }
            return RESOURCES[definition];
        }

        public static function fromFlash(definition: String, scale: Number = 1, manifest: Dictionary = null):AbstractComponent
        {
            return GUIFactory.createView(getResource(definition), scale, manifest);
        }

        public static function createContainerFromFlash(definition: String, scale: Number = 1):AbstractComponent
        {
            var container: AbstractComponent = new AbstractComponent();
            container.createFromFlash(definition, scale);
            return container;
        }

        protected function getManifest():Dictionary
        {
            return null;
        }

        protected var _children: Dictionary;

        public function getChild(path: String):AbstractComponent
        {
            if (path.length == 0)
            {
                return this;
            }

            var nodes: Array = path.split(".");
            var node: String = nodes.shift();
            if (_children.hasOwnProperty(node))
            {
                return (_children[node] as AbstractComponent).getChild(nodes.join("."));
            }
            return null;
        }

        public function AbstractComponent()
        {
            _children = new Dictionary(true);

            addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
        }

        protected function initialize():void
        {
        }
        
        protected function moveToMarker(name: String, time: Number = 0.4):void
        {
            var marker: AbstractComponent = getChild(name);
            if (marker == null)
            {
                throw new Error("there is no marker with name '" + name + "'");
            }
            
            if (time > 0)
            {
                Starling.juggler.tween(this, time, {"pivotX": marker.x, "pivotY": marker.y, transition: Transitions.EASE_OUT});
            } else {
                pivotX = marker.x;
                pivotY = marker.y;
            }
        }

        private function handleAddedToStage(e: Event):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);

            initialize();
        }

        public function createFromFlash(definition: String, scale: Number = 1):void
        {
            GUIFactory.createChildren(this, getResource(definition), scale, getManifest());
        }

        override public function addChild(child: DisplayObject):DisplayObject
        {
            if (child && child.name)
            {
                _children[child.name] = child;
            }
            return super.addChild(child);
        }

        override public function removeChild(child: DisplayObject, dispose: Boolean = false):DisplayObject
        {
            if (child && child.name)
            {
                delete _children[child.name];
            }
            return super.removeChild(child, dispose);
        }

        public function removeAllExcept(type: String):void
        {
            for (var i:int = numChildren-1; i >= 0; i--)
            {
                if (getChildAt(i).name != type)
                {
                    removeChildAt(i);
                }
            }
        }

        override public function dispose():void
        {
            for (var key:String in _children)
            {
                delete _children[key];
            }
            _children = null;

            super.dispose();
        }

        public function destroyChildren():void
        {
            while (numChildren > 0)
            {
                var child: DisplayObject = getChildAt(0);
                if (child is AbstractComponent)
                {
                    (child as AbstractComponent).destroy();
                }
                removeChild(child, true);
            }
        }

        public function destroy():void
        {
            destroyChildren();
            
            removeFromParent(true);
        }
    }
}
