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

    private var _items : Array;
    private var _texture : Texture;

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

    private function apply9Scale(x:Number, y:Number):void {
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

    public function get tW():Number {
        return _tW;
    }

    public function get tH():Number {
        return _tH;
    }
}
}
