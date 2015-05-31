/**
 * Created by desktop on 01.06.2015.
 */
package com.agnither.utils.gui
{
    import flash.geom.Point;

    import starling.display.Image;
    import starling.textures.Texture;

    public class DistortedImage extends Image
    {
        public function DistortedImage(texture: Texture)
        {
            super(texture);
        }

        public function distort(points: Array):void
        {
            for (var i:int = 0; i < 4; i++)
            {
                var p: Point = points[i];
                mVertexData.setPosition(i, p.x, p.y);
            }
            onVertexDataChanged();
        }
    }
}
