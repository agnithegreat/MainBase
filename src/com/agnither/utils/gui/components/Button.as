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
        public static const DISABLED: String = "gray";

        public function get label():Label
        {
            return getChild("tf_label") as Label;
        }

        public function get icon():AbstractComponent
        {
            return getChild("icon");
        }

        public function get normal():AbstractComponent
        {
            return getChild("back.normal");
        }

        public function get down():AbstractComponent
        {
            return getChild("back.down");
        }

        public function get gray():AbstractComponent
        {
            return getChild("back.gray");
        }
        
        private var _mode: String;
        public function set mode(value: String):void
        {
            _mode = value;
        }

        private var _defaultScale: Number;
        private var _scaleMod: Number = 1.2;
        
        private var _enabled: Boolean = true;
        public function set enabled(value: Boolean):void
        {
            if (_enabled == value) return;
            
            _enabled = value;
            if (gray != null)
            {
                setState(_enabled ? NORMAL : DISABLED);
            } else {
                alpha = _enabled ? 1 : 0.5;
            }
            touchable = _enabled;
        }
        public function get enabled():Boolean
        {
            return _enabled;
        }

        private var _on: Boolean = true;
        public function set on(value: Boolean):void
        {
            _on = value;
            if (icon != null)
            {
                icon.alpha = _on ? 1 : 0.5;
            }
        }
        public function get on():Boolean
        {
            return _on;
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

            _mode = down ? ButtonMode.STATE : ButtonMode.SCALE;
        }
        
        private function handleTouch(e: TouchEvent):void
        {
            if (!_enabled) return;
            
            var touch: Touch = e.getTouch(this);
            if (touch) {
                switch (touch.phase) {
                    case TouchPhase.BEGAN:
                        if (_mode == ButtonMode.STATE)
                        {
                            setState(DOWN);
                        } else if (_mode == ButtonMode.SCALE)
                        {
                            animateBegan();
                        }
                        break;
                    case TouchPhase.ENDED:
                        if (_mode == ButtonMode.STATE)
                        {
                            setState(NORMAL);
                        } else if (_mode == ButtonMode.SCALE)
                        {
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
            if (gray != null)
            {
                gray.visible = state == DISABLED;
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
