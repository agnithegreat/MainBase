/**
 * Created by kirillvirich on 30.01.15.
 */
package com.agnither.utils.gui.components {
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public dynamic class Button extends AbstractComponent {

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
}
}
