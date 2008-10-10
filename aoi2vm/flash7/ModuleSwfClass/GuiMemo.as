/*
 * GuiEdit.as 
 */

import ModuleSwfClass.GuiObject;
import GuiParts.KBar;
import GuiParts.KSkin;

class ModuleSwfClass.GuiMemo extends GuiObject
{
    var state:Number = 0;
    var bar_w:Number = 16;
    var _bar:KBar;
    
    function GuiMemo(gui_root:MovieClip, no:Number) {
        init(gui_root, no);
        _w = 140;
        _h = 140;
    }
    
    public function createObject() {
        // self
        var self:GuiMemo = this;
        // text
        _mc.createTextField("cap_txt", 100, 0,0,_w-bar_w,_h);
        cap_txt = _mc["cap_txt"];
        cap_txt.autoSize = false;
        cap_txt.text = "";
        cap_txt.selectable = true;
        cap_txt.multiline = true;
        cap_txt.textColor = KSkin.C_BUTTON_TEXT;
        cap_txt.border = false;
        cap_txt.type = "input";
        cap_txt.wordWrap = true;
        var tf:TextFormat = new TextFormat();
        tf.font = "_等幅";
        tf.size = 26;
        cap_txt.setNewTextFormat(tf);
        // bar
        _bar = new KBar(this._mc);
        _bar.width  = bar_w;
        _bar.height = _h - 2;
        _bar._max = cap_txt.maxscroll;
        _bar.onChanged = function () {
            self.cap_txt.scroll = self._bar._index;
        };
        // event
        cap_txt.onChanged = function () {
            self._bar._max = self.cap_txt.maxscroll;
            self.execEvent(self._event);
        };
        redraw();
    }
    
    function redraw() {
        clearDraw();
        cap_txt._width  = (_w - bar_w - 1);
        cap_txt._height = _h;
        _bar.y = 1;
        _bar.x = cap_txt._width;
        _bar.height = _h - 2;
        KDraw.rectangle(_mc, 0,0,_w,_h,KSkin.C_WINDOW, KSkin.C_WINDOW_BORDER, 1);
    }
    
    public function setProperty(prop:String, value:Object):Void {
        prop = prop.toUpperCase();
        super.setProperty(prop, value);
        if (prop == "TEXT" || prop == "テキスト") {
            cap_txt.text = AValue.convString(value);
            _bar._max = cap_txt.maxscroll;
            _bar.index = _bar.index;
            redraw();
        }
    }
    
    public function getProperty(prop:String):Object {
        prop = prop.toUpperCase();
        var v:Object = super.getProperty(prop);
        if (v != null) return v;
        return null;
    }
}
