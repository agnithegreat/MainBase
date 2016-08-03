/**
 * Created by desktop on 20.05.2015.
 */
package com.agnither.utils.gui.components
{
    import flash.display.MovieClip;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.Dictionary;

    import starling.animation.IAnimatable;
    import starling.display.Image;
    import starling.textures.Texture;

    public class SpriteAnimation extends AbstractComponent implements IAnimatable
    {
        private var _frames: Vector.<Texture>;
        private var _pivots: Vector.<Point>;
        private var _labels: Dictionary;

        private var _currentTime: Number;
        private var _currentFrame: int;

        private var _view: Image;

        public function SpriteAnimation(frames: Vector.<Texture>, mc: MovieClip, scale: Number = 1)
        {
            _frames = frames;

            _pivots = new <Point>[];
            _labels = new Dictionary();

            var bounds: Rectangle;
            for (var i:int = 1; i <= mc.totalFrames; i++)
            {
                mc.gotoAndStop(i);
                if (mc.currentFrameLabel != null && _labels[mc.currentFrameLabel] != null)
                {
                    _labels[mc.currentFrameLabel] = mc.currentFrame;
                }
                bounds = mc.getBounds(mc);
                _pivots[i-1] = new Point(-bounds.topLeft.x * scale, -bounds.topLeft.y * scale);
            }

            super();

            _view = new Image(_frames[0]);
            addChild(_view);

            _currentTime = 0;
            gotoFrame(1);
        }

        public function gotoFrame(frame: *):void
        {
            var currentFrame: int;
            if (frame is int)
            {
                currentFrame = frame;
            } else {
                currentFrame = _labels[frame];
            }
            _currentFrame = Math.max(1, Math.min(currentFrame, _frames.length));
            _view.texture = _frames[_currentFrame-1];
            _view.pivotX = _pivots[_currentFrame-1].x;
            _view.pivotY = _pivots[_currentFrame-1].y;
            _view.readjustSize();
        }

        public function advanceTime(time:Number):void
        {
            _currentTime += time;

            var frame: int = (_currentTime * 24) % _frames.length;
            if (_currentFrame != frame+1)
            {
                gotoFrame(frame+1);
            }
        }
    }
}
