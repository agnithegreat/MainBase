/**
 * Created by kirillvirich on 06.02.15.
 */
package
{
    import com.agnither.utils.ScreenUtil;

    import flash.display3D.Context3DProfile;
    import flash.display3D.Context3DRenderMode;
    import flash.geom.Rectangle;
    import flash.system.Capabilities;

    import starling.core.Starling;
    import starling.events.Event;

    public class StarlingMainBase extends MainBase
    {
        private var _mainClass: Class;

        protected var _viewport: Rectangle;
        
        protected var _ios: Boolean;
        protected var _android: Boolean;
        protected var _mobile: Boolean;

        protected var _resizeGraphics: Boolean;
        protected var _graphicsSize: Rectangle;
        protected var _fixedProportions: Boolean;
        protected var _starling: Starling;

        public function StarlingMainBase(mainClass: Class, graphicsSize: Rectangle = null, fixedProportions: Boolean = false, scale:String = null, align:String = null)
        {
            _mainClass = mainClass;

            _graphicsSize = graphicsSize;
            _resizeGraphics = _graphicsSize == null;
            _fixedProportions = fixedProportions;

            super(scale, align);
        }

        override protected function initialize():void
        {
            super.initialize();

            initializeStarling();
        }

        protected function initializeStarling():void
        {
            _ios = (Capabilities.version.toLowerCase().indexOf("ios") > -1);
            _android = (Capabilities.version.toLowerCase().indexOf("and") > -1);
            _mobile = _ios || _android;

            Starling.multitouchEnabled = true;
            Starling.handleLostContext = true;

            _starling = new Starling(_mainClass, stage, null, null, Context3DRenderMode.AUTO, [Context3DProfile.BASELINE_EXTENDED, Context3DProfile.BASELINE, Context3DProfile.BASELINE_CONSTRAINED]);
            handleResize(null);

            _starling.addEventListener(Event.ROOT_CREATED, handleRootCreated);
            _starling.stage.addEventListener(Event.RESIZE, handleResize);
        }

        private function handleRootCreated(event: Event,  app: IStartable):void
        {
            _starling.removeEventListener(Event.ROOT_CREATED, handleRootCreated);

            if (app)
            {
                app.start();
            } else {
                throw new Error(_mainClass + " must implement " + IStartable)
            }
            _starling.start();
        }

        private function handleResize(event: Event):void
        {
            if (_resizeGraphics)
            {
                _graphicsSize = _ios ? new Rectangle(0, 0, Capabilities.screenResolutionX, Capabilities.screenResolutionY) : new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
            }

            _viewport = _ios ? new Rectangle(0, 0, Capabilities.screenResolutionX, Capabilities.screenResolutionY) : new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
            var scaleX: Number = _viewport.width / _graphicsSize.width;
            var scaleY: Number = _viewport.height / _graphicsSize.height;
            var minScale: Number = Math.min(scaleX, scaleY);
            ScreenUtil.viewport.width = _fixedProportions ? _graphicsSize.width * minScale : _graphicsSize.width * scaleX;
            ScreenUtil.viewport.height = _fixedProportions ? _graphicsSize.height * minScale : _graphicsSize.height * scaleY;
            ScreenUtil.viewport.x = (_viewport.width - ScreenUtil.viewport.width)/2;
            ScreenUtil.viewport.y = (_viewport.height - ScreenUtil.viewport.height)/2;

            _starling.viewPort = ScreenUtil.viewport;

            _starling.stage.stageWidth = _graphicsSize.width;
            _starling.stage.stageHeight = _graphicsSize.height;
            ScreenUtil.viewport.width = _starling.stage.stageWidth;
            ScreenUtil.viewport.height = _starling.stage.stageHeight;
        }

        protected function get starling():Starling
        {
            if (!_starling)
            {
                throw new Error("Starling is not instantiated yet. Wait for initialize().");
            }
            return _starling;
        }

        protected function set showStats(value: Boolean):void
        {
            _starling.showStats = value;
        }

        protected function setSize(width: int, height: int):void
        {
            _starling.stage.stageWidth = width;
            _starling.stage.stageHeight = height;
        }
    }
}
