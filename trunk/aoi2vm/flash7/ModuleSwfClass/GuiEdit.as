/*
 * GuiEdit.as 
 */

import ModuleSwfClass.GuiObject;
import GuiParts.KSkin;

class ModuleSwfClass.GuiEdit extends GuiObject
{
    var state:Number = 0;
    
    function GuiEdit(gui_root:MovieClip, no:Number) {
        init(gui_root, no);
        _w = 140;
        _h = 32;
    }
    
    public function createObject() {
        // text
        _mc.createTextField("cap_txt", 100, 0,0,_w,_h);
        cap_txt = _mc["cap_txt"];
        cap_txt.autoSize = false;
        cap_txt.text = "";
        cap_txt.selectable = true;
        cap_txt.multiline = false;
        cap_txt.textColor = KSkin.C_BUTTON_TEXT;
        cap_txt.border = false;
        cap_txt.type = "input";
        var tf:TextFormat = new TextFormat();
        tf.font = "_等幅";
        tf.size = 26;
        cap_txt.setNewTextFormat(tf);
        // event
        var self:GuiEdit = this;
        cap_txt.onChanged = function () {
            self.execEvent(self._event);
        };
    }
    
    function redraw() {
        clearDraw();
        cap_txt._width  = _w;
        cap_txt._height = _h;
        KDraw.rectangle(_mc, 0,0,_w,_h,
            KSkin.C_WINDOW, KSkin.C_WINDOW_BORDER, 1);
    }
    
    public function setProperty(prop:String, value:AValue):Void {
        prop = prop.toUpperCase();
        super.setProperty(prop, value);
        if (prop == "TEXT" || prop == "テキスト") {
            cap_txt.autoSize = true;
            cap_txt.text = AValue.convString(value);
            _h = cap_txt._height * 1.3;
            cap_txt.autoSize = false;
            redraw();
        }
        if (prop == "PASSWORD" || prop == "パスワード") {
            cap_txt.password = (AValue.convNumber(value) != 0);
            redraw();
        }
    }
    
    public function getProperty(prop:String):Object {
        prop = prop.toUpperCase();
        var v:Object = super.getProperty(prop);
        if (prop == "PASSWORD" || prop == "パスワード") {
            v = cap_txt.password;
        }
        if (v != null) return v;
        return null;
    }
}
