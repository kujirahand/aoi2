/*
 * GuiEdit.as 
 */

import ModuleSwfClass.GuiObject;
import GuiParts.KBar;
import GuiParts.KSkin;
import GuiParts.KGrid;

class ModuleSwfClass.GuiGrid extends GuiObject
{
    var state:Number = 0;
    var _grid:KGrid;
    
    function GuiGrid(gui_root:MovieClip, no:Number) {
        init(gui_root, no);
        _w = 240;
        _h = 240;
    }
    
    public function createObject() {
        // self
        var self:GuiGrid = this;
        
        _grid = new KGrid(this._mc);
        
        // event
        cap_txt.onChanged = function () {
            self.execEvent(self._event);
        };
        redraw();
    }
    
    function redraw() {
        clearDraw();
        _grid.redraw();
    }
    
    function resize() {
        _grid.width  = _w;
        _grid.height = _h;
        _grid.resize();
    }
    
    public function setProperty(prop:String, value:Object):Void {
        prop = prop.toUpperCase();
        super.setProperty(prop, value);
        if (prop == "TEXT" || prop == "テキスト") {
            _grid.setSelectedText(AValue.convString(value));
            redraw();
        }
        if (prop == "ITEMS" || prop == "アイテム") {
            var csv:Array   = new Array();
            var lines:Array = AValue.convArray(value);
            for (var yy = 0; yy < lines.length; yy++) {
                var line:Array = AValue.convArray(lines[yy]);
                csv[yy] = new Array();
                for (var xx = 0; xx < line.length; xx++) {
                    csv[yy][xx] = AValue.convString(line[xx]);
                }
            }
            _grid.setItems(csv);
            redraw();
        }
    }
    
    public function getProperty(prop:String):Object {
        prop = prop.toUpperCase();
        var v:Object = super.getProperty(prop);
        if (v != null) return v;
        if (prop == "TEXT" || prop == "テキスト") {
            return _grid.getSelectedText();
        }
        if (prop == "ITEMS" || prop == "アイテム") {
            return _grid.getItems();
        }
        return null;
    }
}
