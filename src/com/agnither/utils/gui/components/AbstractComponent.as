/**
 * Created by kirillvirich on 29.01.15.
 */
package com.agnither.utils.gui.components
{
    import com.agnither.utils.gui.GUIFactory;

    import flash.display.DisplayObjectContainer;
    import flash.utils.Dictionary;
    import flash.utils.getDefinitionByName;

    import starling.display.DisplayObject;
    import starling.display.Sprite;
    import starling.events.Event;

    public class AbstractComponent extends Sprite
    {
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

        private function handleAddedToStage(e: Event):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);

            initialize();
        }

        public function createFromFlash(definition: String, atlas: String = null):void
        {
            GUIFactory.createView(this, getResource(definition), atlas, getManifest());
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

        override public function dispose():void
        {
            for (var key:String in this)
            {
                if (_children[key] is AbstractComponent)
                {
                    (_children[key] as AbstractComponent).destroy();
                }
                _children[key] = null;
                delete _children[key];
            }
            _children = null;

            super.dispose();
        }

        public function destroy():void
        {
            removeFromParent(true);
        }
    }
}
