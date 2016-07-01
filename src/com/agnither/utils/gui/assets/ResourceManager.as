/**
 * Created by alekseykabanov on 30.06.16.
 */
package com.agnither.utils.gui.assets
{
    import flash.utils.Dictionary;
    
    public class ResourceManager
    {
        private var _resources: Dictionary = new Dictionary(true);

        public function ResourceManager()
        {
        }

        public function addController(controller: ResourceController):void
        {
            _resources[controller.name] = controller;
        }

        public function removeController(name : String):void
        {
            var controller: ResourceController = _resources[name];
            controller.destroy();
            delete _resources[name];
        }

        public function destroy():void
        {
            for (var name : String in _resources)
            {
                removeController(name);
            }
            _resources = null;
        }

    }
}

