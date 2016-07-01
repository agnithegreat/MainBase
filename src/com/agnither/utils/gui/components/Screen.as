/**
 * Created by agnither on 24.06.16.
 */
package com.agnither.utils.gui.components
{
    import com.agnither.utils.gui.assets.ResourceManager;

    public class Screen extends AbstractComponent
    {
        public var resourceManager: ResourceManager;

        public function Screen()
        {
            super();
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
