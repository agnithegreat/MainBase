/**
 * Created by kirillvirich on 06.02.15.
 */
package {
import flash.display3D.Context3DRenderMode;
import flash.geom.Rectangle;
import flash.system.Capabilities;

import starling.core.Starling;
import starling.events.Event;

public class StarlingMainBase extends MainBase {

    private var _mainClass: Class;

    protected var _starling: Starling;

    public function StarlingMainBase(mainClass: Class, scale:String = null, align:String = null) {
        super(scale, align);

        if (mainClass is IStartable) {
            _mainClass = mainClass;
        } else {
            throw new Error(mainClass + " must implement " + IStartable);
        }
    }

    override protected function initialize():void {
        super.initialize();

        initializeStarling();
    }

    protected function initializeStarling():void {
        var ios: Boolean = (Capabilities.version.toLowerCase().indexOf("ios") > -1);
        var android: Boolean = (Capabilities.version.toLowerCase().indexOf("and") > -1);
        var mobile: Boolean = ios || android;

        Starling.handleLostContext = !ios;

        var viewport: Rectangle = mobile ? new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight) : new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);

        _starling = new Starling(_mainClass, stage, viewport, null, Context3DRenderMode.AUTO);
        _starling.showStats = true;

        _starling.addEventListener(Event.ROOT_CREATED, handleRootCreated);
    }

    protected function setSize(width: int, height: int):void {
        if (_starling) {
            _starling.stage.stageWidth = width;
            _starling.stage.stageHeight = height;
        } else {
            throw new Error("Starling is not instantiated yet. Wait for initialize().");
        }
    }

    private function handleRootCreated(event: Event,  app: IStartable):void {
        _starling.removeEventListener(Event.ROOT_CREATED, handleRootCreated);

        app.start();
        _starling.start();
    }
}
}
