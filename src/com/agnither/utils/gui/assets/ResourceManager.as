/**
 * Created by alekseykabanov on 30.06.16.
 */
package com.agnither.utils.gui.assets
{
    import flash.utils.Dictionary;
    
    public class ResourceManager
    {
        private var _resources: Dictionary = new Dictionary(true);
        
        public function isAdded(name: String):Boolean
        {
            return _resources[name] != null;
        }
        
        public function isLoaded(name: String):Boolean
        {
            return isAdded(name) && _resources[name].loaded;
        }
        
        public function countResources(loaded: Boolean, filter: String = null):int
        {
            if (filter == null)
            {
                filter = "";
            }
            var count: int = 0;
            for each (var controller: ResourceController in _resources)
            {
                if (controller != null && controller.name.search(filter) >= 0 && (!loaded || controller.loaded))
                {
                    count++;
                }
            }
            return count;
        }

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

