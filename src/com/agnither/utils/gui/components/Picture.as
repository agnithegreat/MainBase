/**
 * Created by kirillvirich on 30.01.15.
 */
package com.agnither.utils.gui.components {
import starling.display.Image;
import starling.textures.Texture;

public class Picture extends AbstractComponent {

    private var _image: Image;

    public function Picture(texture: Texture) {
        _image = new Image(texture);
        addChild(_image);
    }

    override public function destroy():void {
        removeChild(_image, true);
        _image = null;

        super.destroy();
    }
}
}
