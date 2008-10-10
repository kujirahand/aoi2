/*
 * GuiBar.as 
 */

import ModuleSwfClass.GuiObject;
import GuiParts.KBar;
import GuiParts.KSkin;

class ModuleSwfClass.GuiBar extends GuiObject
{
    var _bar:KBar;
    
    function GuiBar(gui_root:MovieClip, no:Number) {
        init(gui_root, no);
        _w = 16;
        _h = 64;
    }
    
    public function createObject() {
        // self
        var self:GuiBar = this;
        // bar
        
        _bar = new KBar(this._mc);
        _bar.width  = _w;
        _bar.height = _h;
        // event
        _bar.onChanged = function () {
            self.execEvent(self._event);
        };
        redraw();
    }
    
    function redraw() {
        clearDraw();
        _bar.width  = _w;
        _bar.height = _h;
        _bar.redraw();
    }
    
    function resize() {
        redraw();
    }
    
    public function setProperty(prop:String, value:Object):Void {
        prop = prop.toUpperCase();
        super.setProperty(prop, value);
        if (prop == "INDEX" || prop == "値") {
            _bar._index = AValue.convNumber(value);
        }
        if (prop == "MAX" || prop == "最大値") {
            _bar._max = AValue.convNumber(value);
        }
        if (prop == "VERTICAL" || prop == "縦向") {
            _bar.vertical = (AValue.convNumber(value) != 0);
            _w = _bar.width;
            _h = _bar.height;
        }
    }
    
    public function getProperty(prop:String):Object {
        prop = prop.toUpperCase();
        var v:Object = super.getProperty(prop);
        if (v != null) return v;
        if (prop == "INDEX" || prop == "値") {
            return new Number(_bar._index);
        }
        if (prop == "MAX" || prop == "最大値") {
            return _bar._max;
        }
        if (prop == "VERTICAL" || prop == "縦向") {
            return new Number(_bar.vertical ? 1 : 0);
        }
        return null;
    }
}
