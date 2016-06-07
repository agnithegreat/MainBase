/**
 * Created by desktop on 21.05.2015.
 */
package com.agnither.utils.gui
{
    import flash.display.Loader;
    import flash.display.LoaderInfo;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.ProgressEvent;
    import flash.filesystem.File;
    import flash.system.ApplicationDomain;
    import flash.system.LoaderContext;

    import starling.utils.AssetManager;

    public class SWFLoader extends EventDispatcher
    {
        private var _assets: AssetManager;

        private var _files: Array;
        private var _converted: int;
        
        private var _info: Vector.<LoaderInfo>;
        public function get progress():Number
        {
            var progress: Number = 0;
            for (var i:int = 0; i < _info.length; i++)
            {
                progress += _info[i].bytesLoaded / _info[i].bytesTotal;
            }
            return progress;
        }

        public function SWFLoader()
        {
            _assets = new AssetManager();
            _assets.verbose = true;

            _files = [];
            _info = new <LoaderInfo>[];
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
                    loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, handleSWFProgress);
                    loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleSWFConverted);
                    _info.push(loader.contentLoaderInfo);
                }
            }
        }

        private function handleSWFProgress(event: ProgressEvent):void
        {
            dispatchEvent(event);
        }

        private function handleSWFConverted(event: Event):void
        {
            _converted++;
            if (_converted >= _files.length)
            {
                dispatchEvent(event);
            }
        }
        
        public function destroy():void
        {
            while (_info.length > 0)
            {
                var info: LoaderInfo = _info.shift();
                info.removeEventListener(ProgressEvent.PROGRESS, handleSWFProgress);
                info.removeEventListener(Event.COMPLETE, handleSWFConverted);
            }
            _files = null;
            _assets = null;
        }
    }
}
