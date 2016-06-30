/**
 * Created by agnither on 24.06.16.
 */
package com.agnither.utils.gui.components
{
    import com.agnither.utils.gui.AssetController;

    public class Screen extends AbstractComponent
    {
        public var assetController: AssetController;

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
            if (assetController != null)
            {
                assetController.destroy();
            }
            super.destroy();
        }

    }
}
