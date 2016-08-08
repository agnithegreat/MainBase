/**
 * Created by alekseykabanov on 30.06.16.
 */
package com.agnither.utils.gui.assets
{
    import flash.utils.Dictionary;
    
    public class ResourceController
    {
        private var _name: String;
        public function get name():String
        {
            return _name;
        }
        
        private var _loaded: Boolean;
        public function get loaded():Boolean
        {
            return _loaded;
        }
        
        private var _assets: Dictionary = new Dictionary(true);

        public function ResourceController(name: String)
        {
            _name = name;
        }

        public function addAssets(assetsDestructor : AssetsDestructor):void
        {
            _assets[assetsDestructor.fullName] = assetsDestructor;
        }

        public function removeAssets(name : String):void
        {
            delete _assets[name];
        }
        
        public function setLoaded():void
        {
            _loaded = true;
        }

        public function destroy():void
        {
            for each(var assetDestructor : AssetsDestructor in _assets)
            {
                assetDestructor.execute();
            }
            _assets = null;
        }

    }
}

