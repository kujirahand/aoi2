/*
 * GuiLabel.as 
 */

import ModuleSwfClass.GuiObject;
import GuiParts.KSkin;

class ModuleSwfClass.GuiLabel extends GuiObject
{
    var state:Number = 0;
    
    function GuiLabel(gui_root:MovieClip, no:Number) {
        init(gui_root, no);
        _w = 100;
        _h = 28;
    }
    
    public function createObject() {
        // text
        _mc.createTextField("cap_txt", 100, 0,0,_w,_h);
        cap_txt = _mc["cap_txt"];
        cap_txt.autoSize = false;
        cap_txt.text = "Label";
        cap_txt.selectable = true;
        cap_txt.multiline = false;
        cap_txt.textColor = KSkin.C_BUTTON_TEXT;
        cap_txt.border = false;
        cap_txt.autoSize = true;
        cap_txt.type = "dynamic";
        var tf:TextFormat = new TextFormat();
        tf.font = "_等幅";
        tf.size = 26;
        cap_txt.setNewTextFormat(tf);
        // event
        var self:GuiLabel = this;
        cap_txt.onRelease = function () {
            self.execEvent(self._event);
        };
    }
    
    function redraw() {
        clearDraw();
        cap_txt._width  = _w;
        cap_txt._height = _h;
        //KDraw.rectangle(_mc, 0,0,_w,_h,GuiObject.C_WINDOW, GuiObject.C_BTNSHADOW, 1);
    }
    
    public function setProperty(prop:String, value:AValue):Void {
        prop = prop.toUpperCase();
        super.setProperty(prop, value);
        if (prop == "TEXT" || prop == "テキスト") {
            cap_txt.html = false;
            _w = cap_txt._width;
            _h = cap_txt._height;
            redraw();
            setDefPos();
            return;
        }
        if (prop == "HTMLTEXT" || prop == "HTMLテキスト") {
            cap_txt.html = true;
            cap_txt.htmlText = AValue.convString(value);
            _w = cap_txt._width;
            _h = cap_txt._height;
            redraw();
            setDefPos();
            return;
        }
    }
    
    public function getProperty(prop:String):Object {
        prop = prop.toUpperCase();
        var v:Object = super.getProperty(prop);
        if (v != null) return v;
        if (prop == "HTMLTEXT" || prop == "HTMLテキスト") {
            return AValue.create(cap_txt.htmlText);
        }
        return null;
    }
}
