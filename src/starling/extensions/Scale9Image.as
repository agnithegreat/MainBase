package starling.extensions {
import flash.geom.Matrix;
import flash.geom.Rectangle;

import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;

public class Scale9Image extends Sprite {

    private var _tl:Image;
    private var _tc:Image;
    private var _tr:Image;
    private var _cl:Image;
    private var _cc:Image;
    private var _cr:Image;
    private var _bl:Image;
    private var _bc:Image;
    private var _br:Image;

    private var _grid:Rectangle;
    private var _tW:Number;
    private var _tH:Number;

    private var _height:Number;
    private var _width:Number;

    private var _scaleIfSmaller:Boolean = true;
    private var _items : Array;
    private var _textureName : String;
    private var _texture : Texture;

    public function get scaleIfSmaller():Boolean {
        return _scaleIfSmaller;
    }

    public function set scaleIfSmaller(value:Boolean):void {
        if (_scaleIfSmaller == value) return;

        _scaleIfSmaller = value;
    }

    override public function get height():Number {
        return _height;
    }

    override public function set height(value:Number):void {
        if (_height == value) return;

        _height = value;
        apply9Scale(_width, _height);
    }

    override public function get width():Number {
        return _width;
    }

    override public function set width(value:Number):void {
        if (_width == value) return;

        _width = value;
        apply9Scale(_width, _height);
    }

    public function Scale9Image(texture:Texture, centerRect:Rectangle) {
        _texture = texture;
        _tW = texture.nativeWidth;
        _tH = texture.nativeHeight;
        _grid = centerRect;

        _width = _tW;
        _height = _tH;

        _tl = new Image(Texture.fromTexture(texture, new Rectangle(0, 0, _grid.x, _grid.y)));

        _tc = new Image(Texture.fromTexture(texture, new Rectangle(_grid.x, 0, _grid.width, _grid.y)));

        _tr = new Image(Texture.fromTexture(texture, new Rectangle(_grid.x + _grid.width, 0, texture.nativeWidth - (_grid.x + _grid.width), _grid.y)));

        _cl = new Image(Texture.fromTexture(texture, new Rectangle(0, _grid.y, _grid.x, _grid.height)));

        _cc = new Image(Texture.fromTexture(texture, new Rectangle(_grid.x, _grid.y, _grid.width, _grid.height)));

        _cr = new Image(Texture.fromTexture(texture, new Rectangle(_grid.x + _grid.width, _grid.y, texture.nativeWidth - (_grid.x + _grid.width), _grid.height)));

        _bl = new Image(Texture.fromTexture(texture, new Rectangle(0, _grid.y + _grid.height, _grid.x, texture.nativeHeight - (_grid.y + _grid.height))));

        _bc = new Image(Texture.fromTexture(texture, new Rectangle(_grid.x, _grid.y + _grid.height, _grid.width, texture.nativeHeight - (_grid.y + _grid.height))));

        _br = new Image(Texture.fromTexture(texture, new Rectangle(_grid.x + _grid.width, _grid.y + _grid.height, texture.nativeWidth - (_grid.x + _grid.width), texture.nativeHeight - (_grid.y + _grid.height))));

//        _tc.x = _cc.x = _bc.x = _grid.x;
//        _cl.y = _cc.y = _cr.y = _grid.y;

        _items = [
            [_tl, _cl, _bl],
            [_tc, _cc, _bc],
            [_tr, _cr, _br]
        ];

        addChild(_tl);
        addChild(_tc);
        addChild(_tr);

        addChild(_cl);
        addChild(_cc);
        addChild(_cr);

        addChild(_bl);
        addChild(_bc);
        addChild(_br);

        apply9Scale(_tW, _tH);
    }

    private function apply9Scale2(x:Number, y:Number):void {

        var cols : Array = [0, _grid.left, _grid.right, _tW];
        var rows : Array = [0, _grid.top, _grid.bottom, _tH];

        var dCols : Array = [0, _grid.left, x - (_tW - _grid.right), x];
        var dRows : Array = [0, _grid.top, y - (_tH - _grid.bottom), y];

        var origin : Rectangle;
        var draw : Rectangle;

        for (var cx : int = 0; cx < 3; cx++) {
            for (var cy : int = 0; cy < 3; cy++) {

                origin = new Rectangle(cols[cx], rows[cy], cols[cx + 1] - cols[cx], rows[cy + 1] - rows[cy]);
                draw = new Rectangle(dCols[cx], dRows[cy], dCols[cx + 1] - dCols[cx], dRows[cy + 1] - dRows[cy]);

                var img : Image = _items[cx][cy];
                img.x = draw.x;
                img.y = draw.y;
                img.scaleX = draw.width / origin.width;
                img.scaleY = draw.height / origin.height;
            }
        }
    }

    private function apply9Scale(x:Number, y:Number):void {

        apply9Scale2(x,y);
        return;

        var width:Number = x / scaleX;
        var height:Number = y / scaleY;

        if (width < _tW - _grid.width) {
            _tc.visible = false;
            _bc.visible = false;

            if (!_scaleIfSmaller) {
                var lw:Number = _grid.x;

                _tl.width = lw;
                _cl.width = lw;
                trace("CL WID 1", lw);
                _bl.width = lw;

                _tr.x = lw;
                _cr.x = lw;
                _br.x = lw;

                var rw:Number = (_tW - _grid.x - _grid.width);
                _tr.width = rw;
                _cr.width = rw;
                _br.width = rw;
            } else {
                var pct:Number = width / (_tW - _grid.width);
                lw = _grid.x * pct;
                _tl.width = lw;
                _cl.width = lw;
                _bl.width = lw;

                rw = (_tW - _grid.x - _grid.width) * pct;
                _tr.width = rw;
                _cr.width = rw;
                _br.width = rw;

                var rx:Number = width - rw;
                _tr.x = rx;
                _cr.x = rx;
                _br.x = rx;

            }
        } else {
            _tc.visible = true;
            _bc.visible = true;

            lw = _grid.x;
            _tl.width = lw;
            _cl.width = lw;
            _bl.width = lw;

            rw = (_tW - _grid.x - _grid.width);
            _tr.width = rw;
            _cr.width = rw;
            _br.width = rw;

            rx = width - rw;
            _tr.x = rx;
            _cr.x = rx;
            _br.x = rx;

            var cw:Number = rx - _grid.x;
            _tc.width = cw;
            _cc.width = cw;
            _bc.width = cw;
        }

        if (height < _tH - _grid.height) {
            _cl.visible = false;
            _cr.visible = false;

            if (!_scaleIfSmaller) {
                var tw:Number = _grid.y;

                _tl.height = tw;
                _tc.height = tw;
                _tr.height = tw;

                _br.y = tw;
                _bc.y = tw;
                _bl.y = tw;

                var bh:Number = (_tH - _grid.y - _grid.height);
                _br.height = bh;
                _bc.height = bh;
                _bl.height = bh;
            } else {
                pct = height / (_tH - _grid.height);

                tw = _grid.y * pct;
                _tl.height = tw;
                _tc.height = tw;
                _tr.height = tw;

                bh = (_tH - _grid.y - _grid.height) * pct;
                _br.height = bh;
                _bc.height = bh;
                _bl.height = bh;

                var bx:Number = height - bh;
                _br.y = bx;
                _bc.y = bx;
                _bl.y = bx;

            }
        } else {
            _cl.visible = true;
            _cr.visible = true;

            _tl.height = _grid.y;
            _tc.height = _grid.y;
            _tr.height = _grid.y;

            bh = (_tH - _grid.y - _grid.height);

            _bl.height = bh;
            _bc.height = bh;
            _br.height = bh;

            var by:Number = height - bh;
            _bl.y = by;
            _bc.y = by;
            _br.y = by;

            var ch:Number = by - _grid.y;
            _cl.height = ch;
            _cc.height = ch;
            _cr.height = ch;
        }

        _cc.visible = _cl.visible && _tc.visible;
    }

    override public function dispose():void {
        _grid = null;

        _tl.dispose();
        _tc.dispose();
        _tr.dispose();
        _cl.dispose();
        _cc.dispose();
        _cr.dispose();
        _bl.dispose();
        _bc.dispose();
        _br.dispose();

        _tl = null;
        _tc = null;
        _tr = null;
        _cl = null;
        _cc = null;
        _cr = null;
        _bl = null;
        _bc = null;
        _br = null;

        super.dispose();
    }

    public function get tW() : Number
    {
        return _tW;
    }

    public function get tH() : Number
    {
        return _tH;
    }
}
}
