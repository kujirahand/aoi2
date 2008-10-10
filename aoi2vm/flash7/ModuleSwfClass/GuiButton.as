/*
 * GuiButton.as 
 */

import ModuleSwfClass.GuiObject;
import GuiParts.KSkin


class ModuleSwfClass.GuiButton extends GuiObject
{
    var state:Number = 0;
    
    function GuiButton(gui_root:MovieClip, no:Number) {
        init(gui_root, no);
        _w = 80;
        _h = 40;
    }
    
    public function createObject() {
        // text
        _mc.createTextField("cap_txt", 100, 0,0,_w,_h);
        cap_txt = _mc["cap_txt"];
        cap_txt.autoSize = true;
        cap_txt.text = "Button";
        cap_txt.selectable = false;
        cap_txt.multiline = true;
        cap_txt.textColor = KSkin.C_BUTTON_TEXT;
        var tf:TextFormat = new TextFormat();
        tf.font = "_ゴシック";
        tf.size = 26;
        cap_txt.setNewTextFormat(tf);
        
        // event
        var self:GuiButton = this;
        _mc.onRollOver = function () {
            self.state = 1;
            self.redraw();
        };
        _mc.onRollOut = function () {
            self.state = 0;
            self.redraw();
        };
        _mc.onPress = function () {
            self.state = 2;
            self.redraw();
        };
        _mc.onMouseUp = function () {
            if (self.state != 0) {
                self.state = 0;
                self.redraw();
            }
        };
        _mc.onRelease = function () {
            self.execEvent(self._event);
        };
    }
    
    function redraw() {
        clearDraw();
        if (state == 0) {
            KDraw.rectangle_g(_mc, 0, 0,_w,_h, 
                [KSkin.C_BUTTON_FACE, 0xD0D0E0], 90, KSkin.C_BUTTON_BORDER, 1);
            cap_txt.textColor = KSkin.C_BUTTON_TEXT;
        } else if (state == 1) {
            KDraw.rectangle(_mc, 0, 0,_w,_h, KSkin.C_BUTTON_FACE, KSkin.C_BUTTON_OVER, 2);
            cap_txt.textColor = KSkin.C_BUTTON_TEXT;
        } else if (state == 2) {
            KDraw.rectangle(_mc, 0, 0,_w,_h, KSkin.C_BUTTON_BORDER, KSkin.C_BUTTON_OVER, 2);
            cap_txt.textColor = KSkin.C_BUTTON_FACE;
        }
        cap_txt._x = (_w - cap_txt._width) / 2;
        cap_txt._y = (_h - cap_txt._height) / 2;
    }
    
    public function setProperty(prop:String, value:AValue):Void {
        prop = prop.toUpperCase();
        super.setProperty(prop, value);
        if (prop == "TEXT" || prop == "テキスト") {
            cap_txt.text = AValue.convString(value);
            _w = cap_txt._width + 16;
            _h = cap_txt._height + 8;
            if (_w < 32) _w = 32;
            if (_h < 24) _h = 24;
            redraw();
        }
    }
    
    public function getProperty(prop:String):Object {
        prop = prop.toUpperCase();
        var v:Object = super.getProperty(prop);
        if (v != null) return v;
        if (prop == "TEXT" || prop == "テキスト") {
            return AValue.create(cap_txt.text);
        }
        return null;
    }
}
