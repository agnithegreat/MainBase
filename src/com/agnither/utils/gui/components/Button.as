/**
 * Created by kirillvirich on 30.01.15.
 */
package com.agnither.utils.gui.components {
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class Button extends AbstractComponent {

    public function get label():Label {
        return getChild("label") as Label;
    }

    public function Button() {
        super();
    }

    override protected function initialize():void {
        addEventListener(TouchEvent.TOUCH, handleTouch);

        useHandCursor = true;
    }

    private function handleTouch(e: TouchEvent):void {
        var touch: Touch = e.getTouch(this);
        if (touch) {
            switch (touch.phase) {
                case TouchPhase.ENDED:
                    dispatchEventWith(Event.TRIGGERED, true);
                    break;
            }
        }
    }

    override public function dispose():void {
        removeEventListener(TouchEvent.TOUCH, handleTouch);

        super.dispose();
    }
}
}
