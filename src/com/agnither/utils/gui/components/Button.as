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
        public static const NORMAL: String = "normal";
        public static const DOWN: String = "down";
        public static const DISABLED: String = "grey";
        public static const OFF: String = "off";
        
        public function get label():Label
        {
            return getChild("tf_label") as Label;
        }

        public function get normal():Picture
        {
            return getChild("normal") as Picture;
        }

        public function get down():Picture
        {
            return getChild("down") as Picture;
        }

        public function get off():Picture
        {
            return getChild("off") as Picture;
        }

        public function get grey():Picture
        {
            return getChild("grey") as Picture;
        }

        private var _defaultScale: Number;
        private var _scaleMod: Number = 0.95;
        
        private var _enabled: Boolean = true;
        public function set enabled(value: Boolean):void
        {
            _enabled = value;
            if (grey != null)
            {
                setState(_enabled ? _current : DISABLED);
            } else {
                alpha = _enabled ? 1 : 0.5;
            }
            touchable = _enabled;
        }
        public function get enabled():Boolean
        {
            return _enabled;
        }

        private var _current: String = NORMAL;
        public function set on(value: Boolean):void
        {
            _current = value ? NORMAL : OFF;
            setState(_current);
        }
        public function get on():Boolean
        {
            return _current == NORMAL;
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
                        if (down != null)
                        {
                            setState(DOWN);
                        } else {
                            animateBegan();
                        }
                        break;
                    case TouchPhase.ENDED:
                        if (down != null)
                        {
                            setState(_current);
                        } else {
                            animateEnded();
                        }
                        dispatchEventWith(Event.TRIGGERED, true);
                        break;
                }
            }
        }
        
        private function setState(state: String):void
        {
            if (normal != null)
            {
                normal.visible = state == NORMAL;
            }
            if (down != null)
            {
                down.visible = state == DOWN;
            }
            if (off != null)
            {
                off.visible = state == OFF;
            }
            if (grey != null)
            {
                grey.visible = state == DISABLED;
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
