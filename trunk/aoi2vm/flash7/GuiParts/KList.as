/**
 * KList
 *
 */

import GuiParts.KListTextItem;
import GuiParts.KGuiObj;
import GuiParts.KBar;
import GuiParts.KSkin;

class GuiParts.KList extends KGuiObj
{
    //
    var _tf_array:/*KListTextItem*/Array;
    var _w:Number;
    var _h:Number;
    var _item_height:Number;
    var _disp_item_count:Number; // Count of text item that is showed
    var _disp_top:Number; // list top index
    var _item_margin:Number;
    var _index:Number;
    var _bar:KBar;
    var items:Array;/*String*/
    // event
    var onClick;
    
    function KList(root:MovieClip) {
        this.root = root;
        init();
    }
    
    function init() {
        super.init();
        // default
        _w = 140;
        _h = 120;
        _item_height = 30;
        _item_margin = 4;
        _index = 0;
        _disp_top = 0;
        // thumb
        _bar = new KBar(_mc);
        //
        items = new Array();
        resize();
    }
    function clearObject():Void {
        _mc.clear();
        // remove TextField
        for (var i = 0; i < _tf_array.length; i++) {
            var g:KListTextItem = _tf_array[i];
            g.remove();
            delete g;
        }
        _tf_array = new Array();
    }
    
    function resize() {
        clearObject();
        // create text item
        var self:KList = this;
        _disp_item_count = Math.floor( _h / _item_height );
        for (var i = 0; i < _disp_item_count; i++) {
            var item_name:String = "item_txt" + i;
            var yy = i * _item_height;
            var ww = _w - _bar._w;
            var t:KListTextItem = new KListTextItem(this, 
                1, yy+1, ww-2, _item_height-2);
            t.text = "item" + i;
            t.onClick = function (g) { self._onClick(g); };
            _tf_array[i] = t;
        }
        // bar
        _bar.x = _w - _bar._w - 1;
        _bar.y = 1;
        _bar.height = _h - 2;
        redraw();
        // background
        KDraw.rectangle(_mc, 0, 0, _w, _h + 1, KSkin.C_WINDOW, KSkin.C_WINDOW_BORDER, 1);
    }
    
    function useBar():Boolean {
        return (items.length > _disp_item_count);
    }
    
    function bar_onChanged(idx) {
        _disp_top = idx;
        redraw();
    }
    
    function redraw() {
        var self:KList = this;
        _bar.enabled = useBar();
        _bar.onChanged = function (idx) { self.bar_onChanged(idx); };
        // set text
        for (var i = 0; i < _disp_item_count; i++) {
            var g:KListTextItem = _tf_array[i];
            var j = i + _disp_top;
            if (j >= items.length) {
                g._status = KListTextItem.STATUS_NONE;
                g._tag = -1;
            } else {
                g._status = KListTextItem.STATUS_NORMAL;
                if (j == _index) {
                    g._status = KListTextItem.STATUS_SELECTED;
                }
                g._tag = j;
                g.text = items[j];
            }
            g.drawStatus();
        }
        //
        _bar._max = items.length - _disp_item_count;
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
        items = s.split("\n");
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
        return items[index];
    }
    
    function setSelectedText(v:String):Void {
        if (index >= 0) {
            items[index] = v;
        }
    }
}
