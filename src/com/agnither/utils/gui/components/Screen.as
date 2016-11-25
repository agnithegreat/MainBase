/**
 * Created by agnither on 24.06.16.
 */
package com.agnither.utils.gui.components
{
    import com.agnither.utils.gui.assets.ResourceManager;

    public class Screen extends Popup
    {
        public static const READY: String = "Screen.READY";
        
        public var resourceManager: ResourceManager;
        
        public function Screen(tweenX: int, tweenY: int)
        {
            super(tweenX, tweenY);
        }
        
        public function init():void
        {
            ready();
        }
        
        protected function ready():void
        {
            dispatchEventWith(READY);
        }
        
        public function freeze():void
        {
        }
        
        public function unfreeze():void
        {
        }

        override public function destroy():void
        {
            if (resourceManager != null)
            {
                resourceManager.destroy();
            }
            super.destroy();
        }

    }
}
