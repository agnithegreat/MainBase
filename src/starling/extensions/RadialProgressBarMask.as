/**
 * Created by agnither on 02.08.16.
 */
package starling.extensions
{
    import starling.display.Canvas;
    import starling.display.Sprite;
    import starling.geom.Polygon;

    public class RadialProgressBarMask extends Sprite
    {
        private var _baseAngle: Number;
        private var _deltaAngle: Number;
        private var _radius: Number;

        private var _canvas: Canvas;
        private var _polygon:Polygon;

        private var _sides:Number;
        private var _value:Number;

        public function RadialProgressBarMask(baseAngle: Number, deltaAngle: Number, radius: int)
        {
            _baseAngle = baseAngle;
            _deltaAngle = deltaAngle;
            _radius = radius;

            _sides = 8;
            _value = 0;

            super();

            _canvas = new Canvas();
            _canvas.pivotX = _radius;
            _canvas.pivotY = _radius;
            addChild(_canvas);
        }

        public function get value():Number
        {
            return _value;
        }

        public function set value(value:Number):void
        {
            if (_value != value)
            {
                _value = value;
            }
            update();
        }

        private function update():void
        {
            _polygon = new Polygon();
            updatePolygon(_value, _radius, _radius, _radius, _baseAngle);

            _canvas.clear();
            _canvas.beginFill(0xFFFF0000);
            _canvas.drawPolygon(_polygon);
            _canvas.endFill();
        }

        [Inline]

        private function lineToRadians(rads:Number, radius:Number, x:Number, y:Number):void
        {
            _polygon.addVertices(Math.cos(rads) * radius + x, Math.sin(rads) * radius + y);
        }

        private function updatePolygon(percentage:Number, radius:Number = 50, x:Number = 0, y:Number = 0, rotation:Number = 0):void
        {
            _polygon.addVertices(x, y);
            // 3 sides minimum
            if (_sides < 3)
            {
                _sides = 3;
            }

            radius /= Math.cos(1 / _sides * Math.PI);

            var sidesToDraw:int = Math.floor(percentage * _sides);
            for (var i:int = 0; i <= sidesToDraw; i++)
            {
                lineToRadians((i / _sides) * _deltaAngle + rotation, radius, x, y);
            }

            if (percentage * _sides != sidesToDraw)
            {
                lineToRadians(percentage * _deltaAngle + rotation, radius, x, y);
            }
        }

    }

}
