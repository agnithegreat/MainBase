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

        private var _filename: String;

        public function SWFLoader()
        {
            _assets = new AssetManager();
            _assets.verbose = true;
        }

        public function load(filename: String):void
        {
            _filename = filename;

            _assets.enqueue(File.applicationDirectory.resolvePath(_filename + ".swf"));
            _assets.loadQueue(handleProgress);
        }

        private function handleProgress(value: Number):void
        {
            if (value == 1)
            {
                var loader: Loader = new Loader();
                var context: LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
                context.allowCodeImport = true;
                loader.loadBytes(_assets.getByteArray(_filename), context);
                loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleSWFConverted);
            }
        }

        private function handleSWFConverted(event: Event):void
        {
            dispatchEvent(event);
        }
    }
}
