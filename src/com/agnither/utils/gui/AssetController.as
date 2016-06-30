/**
 * Created by alekseykabanov on 30.06.16.
 */
package com.agnither.utils.gui
{
import flash.utils.Dictionary;

public class AssetController
    {
        public var _assets : Dictionary = new Dictionary();

        public function AssetController()
        {
        }

        public function addAssets(assetsDestructor : AssetsDestructor):void
        {
            _assets[assetsDestructor.name] = assetsDestructor;
        }

        public function removeAssets(name : String):void
        {
            delete _assets[name];
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

