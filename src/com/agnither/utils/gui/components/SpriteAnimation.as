/**
 * Created by desktop on 20.05.2015.
 */
package com.agnither.utils.gui.components
{
    public class SpriteAnimation extends AbstractComponent
    {
        private var _frames: Vector.<AbstractComponent>;
        private var _labels: Object;

        private var _currentFrame: int;

        public function SpriteAnimation(frames: Vector.<AbstractComponent>, labels: Object)
        {
            _frames = frames;
            _labels = labels;

            super();

            gotoFrame(1);
        }

        public function gotoFrame(frame: *):void
        {
            removeChildren();

            var currentFrame: int;
            if (frame is int)
            {
                currentFrame = frame;
            } else {
                currentFrame = _labels[frame];
            }
            _currentFrame = Math.max(1, Math.min(currentFrame, _frames.length));
            addChild(_frames[_currentFrame-1]);
        }
    }
}
