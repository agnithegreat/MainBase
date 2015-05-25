/**
 * Created by desktop on 21.05.2015.
 */
package com.agnither.utils.gui
{
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.filesystem.File;
    import flash.utils.ByteArray;

    import starling.utils.AssetManager;

    public class DBSWFLoader extends EventDispatcher
    {
        private var _assets: AssetManager;
        public function get file():ByteArray
        {
            return _assets.getByteArray(_filename);
        }

        private var _filename: String;

        public function DBSWFLoader()
        {
            _assets = new AssetManager();
            _assets.verbose = true;
        }

        public function load(filename: String):void
        {
            _filename = filename;

            _assets.enqueue(File.applicationDirectory.resolvePath(_filename + ".dbswf"));
            _assets.loadQueue(handleProgress);
        }

        private function handleProgress(value: Number):void
        {
            if (value == 1)
            {
                dispatchEvent(new Event(Event.COMPLETE));
            }
        }
    }
}
