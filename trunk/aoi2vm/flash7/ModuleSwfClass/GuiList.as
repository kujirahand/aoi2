/*
 * GuiList.as 
 */

import GuiParts.KList;
import ModuleSwfClass.GuiObject;

class ModuleSwfClass.GuiList extends GuiObject
{
    var _list:KList;
    
    function GuiList(gui_root:MovieClip, no:Number) {
        init(gui_root, no);
        _w = 140;
        _h = 120;
    }
    
    public function createObject() {
        // create
        _list = new KList(this._mc);
        _list.x = 0;
        _list.y = 0;
        _list.width  = _w;
        _list.height = _h;
        _list.redraw();
        // event
        var self:GuiList = this;
        _list.onClick = function () {
            self.execEvent(self._event);
        };
    }
    
    function redraw() {
        _list.redraw();
    }
    
    function resize() {
        _list.width = _w;
        _list.height = _h;
        redraw();
    }
    
    public function setProperty(prop:String, value:Object):Void {
        prop = prop.toUpperCase();
        super.setProperty(prop, value);
        
        if (prop == "X"||prop == "左") {
            redraw();
        }
        if (prop == "Y"||prop == "上") {
            redraw();
        }
        
        if (prop == "ITEMS" || prop == "アイテム") {
            _list.items = new Array();
            var v:Object = AValue.getLink(value);
            if (v instanceof Array) {
                for (var i = 0; i < v.length; i++) {
                    var vi:String = AValue.convString(v[i]);
                    _list.items.push(vi);
                }
                _list.redraw();
            } else {
                _list.setText(AValue.convString(v));
            }
        }
        if (prop == "INDEX" || prop == "値") {
            _list.index = AValue.convNumber(value);
        }
        if (prop == "TEXT" || prop == "テキスト") {
            _list.setSelectedText(AValue.convString(value));
        }
    }
    
    public function getProperty(prop:String):Object {
        prop = prop.toUpperCase();
        var v:Object = super.getProperty(prop);
        if (v != null) return v;
        if (prop == "ITEMS" || prop == "アイテム") {
            var o:Array = new Array();
            for (var i = 0; i < _list.items.length; i++) {
                o.push(_list.items[i]);
            }
            return o;
        }
        if (prop == "TEXT" || prop == "テキスト") {
            return AValue.create(_list.getSelectedText());
        }
        return null;
    }
}
