/**
 * Created by desktop on 21.05.2015.
 */
package com.agnither.utils.gui
{
    import flash.display.Loader;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.filesystem.File;
    import flash.system.ApplicationDomain;
    import flash.system.LoaderContext;

    import starling.utils.AssetManager;

    public class SWFLoader extends EventDispatcher
    {
        private var _assets: AssetManager;

        private var _files: Array;
        private var _converted: int;

        public function SWFLoader()
        {
            _assets = new AssetManager();
            _assets.verbose = true;

            _files = [];
        }

        public function addFile(filename: String):void
        {
            _files.push(filename);
            _assets.enqueue(File.applicationDirectory.resolvePath(filename + ".swf"));
        }

        public function load():void
        {
            _assets.loadQueue(handleProgress);
        }

        private function handleProgress(value: Number):void
        {
            if (value == 1)
            {
                var context: LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
                context.allowCodeImport = true;
                for (var i:int = 0; i < _files.length; i++)
                {
                    var loader: Loader = new Loader();
                    var filename: String = _files[i].split("/").reverse()[0];
                    loader.loadBytes(_assets.getByteArray(filename), context);
                    loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleSWFConverted);
                }
            }
        }

        private function handleSWFConverted(event: Event):void
        {
            _converted++;
            if (_converted >= _files.length)
            {
                dispatchEvent(event);
            }
        }
    }
}
