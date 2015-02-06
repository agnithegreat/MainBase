/**
 * Created by kirillvirich on 06.02.15.
 */
package {
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;

public class MainBase extends Sprite {

    private static const defaultScale: String = StageScaleMode.NO_SCALE;
    private static const defaultAlign: String = StageAlign.TOP_LEFT;

    private var _defaultScale: String;
    private var _defaultAlign: String;

    public function MainBase(scale: String = null, align: String = null) {
        _defaultScale = scale ? scale : defaultScale;
        _defaultAlign = align ? align : defaultAlign;

        addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
    }

    private function handleAddedToStage(e: Event):void {
        removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);

        stage.scaleMode = _defaultScale;
        stage.align = _defaultAlign;
    }

    protected function initialize():void {

    }
}
}
