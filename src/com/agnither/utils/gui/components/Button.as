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

        public function get icon():Picture
        {
            return getChild("icon") as Picture;
        }

        public function get normal():Picture
        {
            return getChild("back.normal") as Picture;
        }

        public function get down():Picture
        {
            return getChild("back.down") as Picture;
        }

        public function get gray():Picture
        {
            return getChild("back.gray") as Picture;
        }

        private var _defaultScale: Number;
        private var _scaleMod: Number = 0.95;
        
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
                            setState(NORMAL);
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
