/**
 * KBar
 *
 */

import GuiParts.KGuiObj;
import GuiParts.KSkin;

class GuiParts.KBar extends KGuiObj
{
    //
    var root:MovieClip;
    var _mc:MovieClip;
    var _w:Number;
    var _h:Number;
    var _index:Number;
    var _thumb:MovieClip;
    var _isDrag:Boolean;
    var _thumb_h:Number;
    var _thumb_mode:Number = 0;
    var _max:Number;
    var _oldindex:Number;
    // button
    var up_btn:MovieClip;
    var down_btn:MovieClip;
    var btn_h:Number = 16;
    var btn_w:Number = 16;
    var _vertical:Boolean = true;
    // event
    var onChanged;
    
    function KBar(root:MovieClip) {
        this.root = root;
        init();
    }
    function init() {
        super.init();
        _w = KSkin.W_BAR;
        _h = 120;
        _thumb_h = 16;
        _isDrag = false;
        _max = 10;
        // create
        var self:KBar = this;
        // up button
        up_btn = _mc.createEmptyMovieClip("up_btn", _mc.getNextHighestDepth());
        up_btn.onPress = function () {
            if (0 < self.index) {
                self.index--;
                self.onChanged(self.index);
            }
        };
        // down button
        down_btn = _mc.createEmptyMovieClip("down_btn", _mc.getNextHighestDepth());
        down_btn.onPress = function () {
            if (self._max > self.index) {
                self.index++;
                self.onChanged(self.index);
            }
        };
        
        // thumb
        _thumb = _mc.createEmptyMovieClip("_thumb", _mc.getNextHighestDepth());
        _thumb._y = btn_h;
        _thumb_draw();
        _thumb.onPress = function () {
            self._thumb.startDrag(false, 0, self.btn_h, 0, self._h - self._thumb_h - self.btn_h);
            self._isDrag = true;
            self._oldindex = self.index;
        };
        _thumb.onMouseMove = function () {
            if (self._isDrag == false) return;
            if (self._oldindex != self.index) {
                self.onChanged(self.index);
                self._index = self.index;
                self._oldindex = self.index;
            }
        };
        _thumb.onMouseUp = function () {
            if (self._isDrag == false) return;
            self._thumb.stopDrag();
            self._isDrag = false;
            self.index = self.index;
            self._thumb_mode = 0; self._thumb_draw();
        };
        _thumb.onRollOver = function () {
            self._thumb_mode = 1; self._thumb_draw();
        };
        _thumb.onRollOut = function () {
            self._thumb_mode = 0; self._thumb_draw();
        };
        //
        redraw();
    }
    
    function _thumb_draw() {
        // thumb
        if (_thumb_mode != 0) {
            KDraw.rectangle(_thumb, 1, 1, _w-1, btn_h-1, KSkin.C_SCROLL_BUTTON_FACEOVER, KSkin.C_SCROLL_BUTTON_BORDER, 1);
        } else {
            KDraw.rectangle(_thumb, 1, 1, _w-1, btn_h-1, KSkin.C_SCROLL_BUTTON_FACE, KSkin.C_SCROLL_BUTTON_BORDER, 1);
        }
        KDraw.line(_thumb,1,btn_h,_w-1,btn_h,KSkin.C_SCROLL_BUTTON_SHADOW);
        // thumb pick
        var ly:Number = 6;
        var tw = 8;
        var tx1 = (_w - tw) / 2;
        var tx2 = _w - tx1;
        for (var i = 0; i < 3; i++) {
            KDraw.line(_thumb,tx1,ly,tx2,ly,KSkin.C_SCROLL_BUTTON_BORDER); ly++;
            KDraw.line(_thumb,tx1,ly,tx2,ly,KSkin.C_SCROLL_BUTTON_SHADOW);
            ly += 1;
        }
        // up button
        var bw = 6;
        var bx1 = (_w - bw) / 2;
        var bx2 = _w - bx1;
        KDraw.rectangle(up_btn, 1,1,_w-1,btn_h-1,KSkin.C_SCROLL_BUTTON_FACE,KSkin.C_SCROLL_BUTTON_BORDER,1);
        KDraw.line(up_btn,1,btn_h,_w-1,btn_h,KSkin.C_SCROLL_BUTTON_SHADOW);
        KDraw.poly(up_btn,[[bx1,btn_h-6],[bx2,btn_h-6],[_w/2,6]],KSkin.C_SCROLL_BUTTON_ARROW,KSkin.C_SCROLL_BUTTON_ARROW,1);
        // down button
        KDraw.rectangle(down_btn, 1,1,_w-1,btn_h-1,KSkin.C_SCROLL_BUTTON_FACE,KSkin.C_SCROLL_BUTTON_BORDER,1);
        KDraw.line(down_btn,1,btn_h,_w-1,btn_h,KSkin.C_SCROLL_BUTTON_SHADOW);
        KDraw.poly(down_btn,[[bx1,6],[bx2,6],[_w/2,btn_h-6]],KSkin.C_SCROLL_BUTTON_ARROW,KSkin.C_SCROLL_BUTTON_ARROW,1);
    }
    
    function resize() {
        redraw();
    }
    
    function get index():Number {
        var hh = _h - _thumb_h - btn_h * 2;
        _index = Math.round( ((_thumb._y - btn_h) / hh) * _max );
        if (_index > _max) { _index = _max; }
        return _index;
    }
    
    function set index(n:Number):Void {
        var hh = _h - _thumb_h - btn_h * 2;
        _index = n;
        var yy = (_index / _max) * hh;
        _thumb._y = yy + btn_h;
    }
    
    function redraw() {
        _mc.clear();
        up_btn.clear();
        down_btn.clear();
        _thumb.clear();
        // back
        KDraw.rectangle_g(_mc, 0, 0, _w, _h, [KSkin.C_SCROLL_BACK_L,KSkin.C_SCROLL_BACK_R], 0, KSkin.C_SCROLL_BACK_BORDER, 1);
        up_btn._x = 0;
        up_btn._y = 0;
        down_btn._x = 0;
        down_btn._y = _h - btn_h;
        _thumb_draw();
        //
        _thumb._visible = _enabled;
    }
    
    function remove() {
        super.init();
    }
    
    function set enabled(v:Boolean):Void {
        _enabled = v;
        redraw();
    }
    
    function get vertical():Boolean {
        return _vertical;
    }
    
    function set vertical(b:Boolean):Void {
        // swap
        var tmp = _w;
        _w = _h;
        _h = tmp;
        _vertical = b;
        if (b) {
            _mc._rotation = 0;
            _mc._y = 0;
        } else {
            _mc._rotation = -90;
            _mc._y = _w;
        }
    }
    
    function get width():Number {
        return (_vertical) ? _w : _h;
    }
    function set width(v:Number):Void {
        if (_vertical) {
            _w = v;
        } else {
            _h = v;
        }
        resize();
    }
    function get height():Number {
        return (_vertical) ? _h : _w;
    }
    function set height(v:Number):Void {
        if (_vertical) {
            _h = v;
        } else {
            _w = v;
        }
        resize();
    }
    
}
