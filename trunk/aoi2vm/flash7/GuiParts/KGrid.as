
import GuiParts.*;

class GuiParts.KGrid extends KGuiObj
{
    var _w:Number;
    var _h:Number;
    var _index:Number;
    private var items:Array;
    var _hbar:KBar;
    var _vbar:KBar;
    var rows:Number;
    var cols:Number;
    var _row:Number;
    var _col:Number;
    var _disp_left:Number;
    var _disp_top:Number;
    var _disp_rows:Number;
    var _disp_cols:Number;
    var _cell_def_width:Number;
    var _cell_height:Number;
    var cap_txt:TextField;
    var text_ary:/*TextField*/Array;
    var _back_mc:MovieClip;
    
    // event
    var onClick;
    
    function KGrid(root:MovieClip) {
        this.root = root;
        init();
    }
    
    function init() {
        super.init();
        // default
        _w = 240;
        _h = 240;
        // back
        _mc.createEmptyMovieClip("_back",50, 0, 0,_w,_h);
        _back_mc = _mc["_back"];
        // bar
        _vbar = new KBar(_mc);
        _hbar = new KBar(_mc); 
        //
        _vbar.vertical = true;
        _vbar.width = KSkin.W_BAR;
        _hbar.vertical = false;
        _hbar.height = KSkin.W_BAR;
        // cursor
        _row = -1;
        _col = 0;
        _disp_top  = 0;
        _disp_left = 0;
        //
        items = new Array();
        text_ary = new Array();
        // misc
        _mc.createTextField("grid_cap_txt",1000,0,0,10,10);
        cap_txt = _mc["grid_cap_txt"];
        cap_txt.autoSize = true;
        cap_txt._visible = false;
        cap_txt.text = "•Ò";
        _cell_height    = cap_txt._height + 6;
        _cell_def_width = cap_txt._width * 4;
        resize();
    }
    function clearObject():Void {
        _mc.clear();
        for (var i = 0; i < text_ary.length; i++) {
            var txt:TextField = text_ary[i];
            txt.removeTextField();
        }
        text_ary = new Array();
    }
    
    function resize() {
        clearObject();
        // background
        KDraw.rectangle(_mc, 0, 0, _w, _h, KSkin.C_WINDOW, KSkin.C_WINDOW_BORDER, 1);
        //
        _disp_rows = Math.floor( _h / _cell_height );
        _disp_cols = Math.floor( _w / _cell_def_width );
        
        // text
        text_ary = new Array();
        for (var irow = 0; irow < _disp_rows; irow++) {
            for (var icol = 0; icol < _disp_cols; icol++) {
                var no:Number = irow * _disp_rows + icol;
                // back
                var xx:Number = icol * _cell_def_width + 1;
                var yy:Number = irow * _cell_height + 1;
                var x2:Number = xx + _cell_def_width - 2;
                var y2:Number = yy + _cell_height - 2;
                // text
                _mc.createTextField("txt" + no, 3000 + no, xx + 2, yy + 2, x2, y2);
                var txt:TextField = _mc["txt" + no];
                text_ary[no] = txt;
                txt.autoSize = true;
                txt.text = "";
                txt.selectable = false;
            }
        }
        // bar
        _vbar.x         = _w - _vbar.width - 1;
        _vbar.y         = 1;
        _vbar.height    = _h - 2 - KSkin.W_BAR;
        _vbar._max      = _disp_rows - 2;
        //
        _hbar.x         = 1;
        _hbar.y         = _h - 1;
        _hbar.width     = _w - 2 - KSkin.W_BAR;
        _hbar.height    = KSkin.W_BAR;
        _hbar._max      = _disp_cols - 2;
        // back
        _back_mc._x = 1;
        _back_mc._y = 1;
        KDraw.rectangle(_back_mc,
            0,0,_w - _vbar.width - 1,_h - _hbar.height - 1,KSkin.C_WINDOW,KSkin.C_WINDOW,1);
        //
        var self:KGrid = this;
        _vbar.onChanged = function () {
            self._disp_top = self._vbar.index;
            self.redraw();
        };
        _hbar.onChanged = function () {
            self._disp_left = self._hbar.index;
            self.redraw();
        };
        redraw();
        // background
    }
    
    function bar_onChanged(idx) {
        _disp_top = idx;
        redraw();
    }
    
    function redraw() {
        var self:KGrid = this;
        
        //TODO: cell_width ‚ÌŒvŽZ
        for (var irow = 0; irow < _disp_rows; irow++) {
            for (var icol = 0; icol < _disp_cols; icol++) {
                // text
                var no:Number = irow * _disp_rows + icol;
                var txt:TextField = text_ary[no];
                var s:String = "";
                if (irow == 0) {
                    s = items[irow][icol + _disp_left];
                } else {
                    s = items[irow + _disp_top][icol + _disp_left];
                }
                if (s == undefined) s = "";
                if (s.length > 6) s = s.substr(0,6);
                txt.text =  s;
                
                // back
                var xx:Number = icol * _cell_def_width;
                var yy:Number = irow * _cell_height;
                var x2:Number = xx + _cell_def_width;
                var y2:Number = yy + _cell_height;
                //
                var c1:Number = KSkin.C_GRID_CELL;
                var c2:Number = KSkin.C_GRID_CELL_SHADOW;
                var c_text:Number = KSkin.C_BUTTON_TEXT;
                var border:Number = 1;
                //
                if (irow == 0) {
                    c1 = KSkin.C_GRID_HEAD;
                    c2 = KSkin.C_GRID_HEAD_SHADOW;
                    c_text   = KSkin.C_GRID_HEAD_TEXT;
                    txt._x   = xx + (_cell_def_width - txt._width) / 2;
                    var tf:TextFormat = new TextFormat();
                    tf.bold = true;
                    txt.setTextFormat(tf);
                }
                if (irow == (_row - _disp_top) && icol == (_col - _disp_left) && (irow > 0)) {
                    c1 = KSkin.C_SELECTED;
                    c2 = KSkin.C_SELECTED_SHADOW;
                    c_text = KSkin.C_BUTTON_SELECTED_TEXT;
                    border = 2;
                }
                KDraw.rectangle_g(_back_mc, xx, yy, x2, y2, 
                    [c1,c2], 90,
                    KSkin.C_GRID_CELL_BORDER, border);
                txt.textColor = c_text;
            }
        }
        _back_mc.onPress = function () {
            self._row = Math.floor( self._back_mc._ymouse / self._cell_height );
            self._col = Math.floor( self._back_mc._xmouse / self._cell_def_width );
            self.redraw();
        };
    }
    
    function remove() {
        super.remove();
        clearObject();
    }
    
    function _onClick(g:KListTextItem) {
        if (g._tag < 0) return;
        _index = g._tag;
        onClick();
        redraw();
    }
    
    function setText(s:String) {
        var lines:Array = s.split("\n");
        for (var i = 0; i < lines.length; i++) {
            lines = lines[i].split(",");
        }
        items = lines;
        redraw();
    }
    
    function get index():Number {
        return _index;
    }
    
    function set index(v:Number):Void {
        _index = v;
        redraw();
    }
    
    function getSelectedText():String {
        if (index < 0) {
            return "";
        }
        return items[_row][_col];
    }
    
    function setSelectedText(v:String):Void {
        if (index >= 0) {
            items[_row][_col] = v;
        }
    }
    
    function changeItem():Void {
        // count rows, cols
        rows = items.length;
        cols = 0;
        for (var i = 0; i < items.length; i++) {
            var line:Array = items[i];
            if (line.length > cols) cols = line.length;
        }
        resize();
    }
    
    function setItems(csv:Array):Void {
        //
        items = csv;
        changeItem();
    }
    function getItems():Array {
        return items;
    }
}


