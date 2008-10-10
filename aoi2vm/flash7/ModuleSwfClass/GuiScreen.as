/*
 * GuiScreen
 */
 
import ModuleSwfClass.GuiObject;
class ModuleSwfClass.GuiScreen extends GuiObject
{
    public function GuiScreen(gui_root:MovieClip, no:Number) {
        init(gui_root, no);
    }
    
    public function createObject() {
    }
    
    public function clearDraw() {
        _mc.clear();
    }
    
    public function redraw() {
    }
    
    public function setProperty(prop:String, value:AValue):Void {
        prop = prop.toUpperCase();
        //super.setProperty(prop, value);
    }
    
    public function getProperty(prop:String):Object {
        prop = prop.toUpperCase();
        if (prop == "XMOUSE"||prop == "マウスX") {
            return AValue.create(_mc._xmouse);
        }
        if (prop == "YMOUSE"||prop == "マウスY") {
            return AValue.create(_mc._ymouse);
        }
        if (prop == "X") {
            return AValue.create(0);
        }
        if (prop == "Y") {
            return AValue.create(0);
        }
        if (prop == "W") {
            return AValue.create(ModuleSwfFunc.stage_w);
        }
        if (prop == "H") {
            return AValue.create(ModuleSwfFunc.stage_h);
        }
        if (prop == "TAG"||prop == "タグ") {
            return AValue.create(_tag);
        }
        return null;
    }
}

