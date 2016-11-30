/**
 * Created by agnither on 24.06.16.
 */
package com.agnither.utils.gui.components
{
    import flash.geom.Point;

    public class Popup extends AbstractComponent
    {
        public static const SHOW: String = "Popup.SHOW";
        public static const HIDE: String = "Popup.HIDE";
        public static const CLOSE: String = "Popup.CLOSE";
        
        private var _showing: Boolean;
        public function get showing():Boolean
        {
            return _showing;
        }
        
        private var _alive: Boolean;
        public function get alive():Boolean
        {
            return _alive;
        }

        public var tweenPosition: Point;
        
        public function Popup(tweenX: int, tweenY: int)
        {
            _alive = true;
            
            super();

            tweenPosition = new Point(tweenX, tweenY);
        }

        public function setup():void
        {
        }
        
        public function tryClose():Boolean
        {
            return true;
        }
        
        final public function show():void
        {
            if (_showing) return;
            _showing = true;
            dispatchEventWith(SHOW);
            showHandler();
        }

        final public function hide():void
        {
            if (!_showing) return;
            _showing = false;
            dispatchEventWith(HIDE);
            hideHandler();
        }

        final public function close():void
        {
            if (!_alive) return;
            _alive = false;
            dispatchEventWith(CLOSE);
            closeHandler();
            destroy();
        }
        
        protected function showHandler():void
        {
        }

        protected function hideHandler():void
        {
        }

        protected function closeHandler():void
        {
        }
    }
}
