/**
 * Created by kirillvirich on 30.01.15.
 */
package com.agnither.utils.gui.components
{
    import starling.core.Starling;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    
    public class Button extends AbstractComponent
    {
        public function get label():Label
        {
            return getChild("tf_label") as Label;
        }
    
        private var _defaultScale: Number;
        private var _scaleMod: Number = 0.95;
        
        private var _enabled: Boolean = true;
        public function set enabled(value: Boolean):void
        {
            _enabled = value;
            alpha = _enabled ? 1 : 0.5;
            touchable = _enabled;
        }
        public function get enabled():Boolean
        {
            return _enabled;
        }
    
        public function Button()
        {
            super();
        }
    
        override protected function initialize():void
        {
            addEventListener(TouchEvent.TOUCH, handleTouch);
    
            useHandCursor = true;
    
            _defaultScale = scaleX;
        }
    
        private function handleTouch(e: TouchEvent):void
        {
            if (!_enabled) return;
            
            var touch: Touch = e.getTouch(this);
            if (touch) {
                switch (touch.phase) {
                    case TouchPhase.BEGAN:
                        animateBegan();
                        break;
                    case TouchPhase.ENDED:
                        animateEnded();
                        dispatchEventWith(Event.TRIGGERED, true);
                        break;
                }
            }
        }
    
        override public function dispose():void
        {
            removeEventListener(TouchEvent.TOUCH, handleTouch);
    
            super.dispose();
        }
    
        private function animateBegan():void
        {
            Starling.juggler.removeTweens(this);
            Starling.juggler.tween(this, 0.1, {scaleX: _defaultScale * _scaleMod, scaleY: _defaultScale * _scaleMod});
        }
    
        private function animateEnded():void
        {
            Starling.juggler.removeTweens(this);
            Starling.juggler.tween(this, 0.1, {scaleX: _defaultScale, scaleY: _defaultScale});
        }
    }
}
