/**
 * Created by kirillvirich on 06.02.15.
 */
package {
    import com.agnither.utils.Screen;

import flash.display3D.Context3DProfile;

import flash.display3D.Context3DRenderMode;
import flash.geom.Rectangle;
import flash.system.Capabilities;

import starling.core.Starling;
    import starling.events.Event;

    public class StarlingMainBase extends MainBase {

    private var _mainClass: Class;

    private var _mobile: Boolean;
    private var _starling: Starling;

    public function StarlingMainBase(mainClass: Class, scale:String = null, align:String = null) {
        _mainClass = mainClass;

        super(scale, align);
    }

    override protected function initialize():void {
        super.initialize();

        initializeStarling();
    }

    protected function initializeStarling():void {
        var ios: Boolean = (Capabilities.version.toLowerCase().indexOf("ios") > -1);
        var android: Boolean = (Capabilities.version.toLowerCase().indexOf("and") > -1);
        _mobile = ios || android;

        Starling.handleLostContext = !ios;

        _starling = new Starling(_mainClass, stage, null, null, Context3DRenderMode.AUTO, Context3DProfile.BASELINE_EXTENDED);
        handleResize(null);

        _starling.addEventListener(Event.ROOT_CREATED, handleRootCreated);
        _starling.stage.addEventListener(Event.RESIZE, handleResize);
    }

    private function handleRootCreated(event: Event,  app: IStartable):void {
        _starling.removeEventListener(Event.ROOT_CREATED, handleRootCreated);

        if (app) {
            app.start();
        } else {
            throw new Error(_mainClass + " must implement " + IStartable)
        }
        _starling.start();
    }

    private function handleResize(event: Event):void
    {
        _starling.viewPort = _mobile ? new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight) : new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
        _starling.stage.stageWidth = _starling.viewPort.width;
        _starling.stage.stageHeight = _starling.viewPort.height;

        Screen.viewport.width = _starling.stage.stageWidth;
        Screen.viewport.height = _starling.stage.stageHeight;
    }



    protected function get starling():Starling {
        if (!_starling) {
            throw new Error("Starling is not instantiated yet. Wait for initialize().");
        }
        return _starling;
    }

    protected function set showStats(value: Boolean):void {
        starling.showStats = value;
    }

    protected function setSize(width: int, height: int):void {
        starling.stage.stageWidth = width;
        starling.stage.stageHeight = height;
    }
}
}
