/*
 * GuiObject
 */

class ModuleSwfClass.GuiObject
{
    //
    public var _mc:MovieClip;
    public var _no:Number;
    public var _x:Number;
    public var _y:Number;
    public var _w:Number;
    public var _h:Number;
    public var _event:String;
    public var _tag;
    public var root:MovieClip;
    public var cap_txt:TextField;
    //
    public var font_color:Number;
    public var font_size:Number;
    public var font_name:String;
    
    public function GuiObject(gui_root:MovieClip, no:Number) {
        init(gui_root, no);
    }
    public function init(gui_root:MovieClip, no:Number) {
        var name:String = "gui_parts_" + no;
        root = gui_root;
        _mc = gui_root.createEmptyMovieClip(name, gui_root.getNextHighestDepth());
        _no = no;
        _x = 0;
        _y = 0;
        _w = 100;
        _h = 100;
        _mc._x = _x;
        _mc._y = _y;
        createObject();
    }
    
    public function createObject() {
    }
    
    public function clearDraw() {
        _mc.clear();
    }
    
    public function redraw() {
        clearDraw();
        KDraw.rectangle(_mc, 0,0,_w,_h);
    }
    
    public function resize() {
        redraw();
    }
    
    public function setFont() {
        var tf:TextFormat = new TextFormat();
        tf.font  = font_name;
        tf.size  = font_size;
        tf.color = font_color;
        cap_txt.setNewTextFormat(tf);
        cap_txt.setTextFormat(tf);
    }
    
    public function setDefPos() {
        ModuleSwfFunc.gui_def_x = _x;
        ModuleSwfFunc.gui_def_y = _y + _h + ModuleSwfFunc.gui_def_margin_h;
    }
    
    public function setProperty(prop:String, value:Object):Void {
        prop = prop.toUpperCase();
        if (prop == "X"||prop == "左") {
            _x = AValue.convNumber(value);
            _mc._x = _x;
            setDefPos();
        }
        if (prop == "Y"||prop == "上") {
            _y = AValue.convNumber(value);
            _mc._y = _y;
            setDefPos();
        }
        if (prop == "W"||prop == "幅") {
            _w = AValue.convNumber(value);
            resize();
        }
        if (prop == "H"||prop == "高さ") {
            _h = AValue.convNumber(value);
            setDefPos();
            resize();
        }
        if (prop == "TEXT" || prop == "テキスト") {
            cap_txt.text = AValue.convString(value);
        }
        if (prop == "EVENT"||prop == "イベント") {
            _event = AValue.convString(value);
        }
        if (prop == "VISIBLE"||prop == "可視") {
            _mc._visible = (AValue.convNumber(value) != 0);
        }
        if (prop == "TAG"||prop == "タグ") {
            _tag = value;
        }
        // font
        if (prop == "FONT_NAME"||prop == "フォント名") {
            font_name = AValue.convString(value);
            setFont();
        }
        if (prop == "FONT_SIZE"||prop == "フォントサイズ") {
            font_size = AValue.convNumber(value);
            setFont();
        }
        if (prop == "FONT_COLOR"||prop == "フォント色") {
            font_color = AValue.convNumber(value);
            setFont();
        }
        if (prop == "ALPHA"||prop == "透明度") {
            _mc._alpha = AValue.convNumber(value);
        }
        if (prop == "ROTATION"||prop == "角度") {
            _mc._rotation = AValue.convNumber(value);
        }
    }
    
    public function getProperty(prop:String):Object {
        prop = prop.toUpperCase();
        if (prop == "XMOUSE"||prop == "マウスX") {
            return AValue.create(_mc._xmouse);
        }
        if (prop == "YMOUSE"||prop == "マウスY") {
            return AValue.create(_mc._ymouse);
        }
        if (prop == "X"||prop == "左") {
            return AValue.create(_x);
        }
        if (prop == "Y"||prop == "上") {
            return AValue.create(_y);
        }
        if (prop == "W"||prop == "幅") {
            return AValue.create(_w);
        }
        if (prop == "H"||prop == "高さ") {
            return AValue.create(_h);
        }
        if (prop == "TEXT" || prop == "テキスト") {
            return AValue.create(cap_txt.text);
        }
        if (prop == "TAG"||prop == "タグ") {
            return AValue.create(_tag);
        }
        if (prop == "VISIBLE"||prop == "可視") {
            return AValue.create(_mc._visible);
        }
        // font
        if (prop == "FONT_NAME"||prop == "フォント名") {
            return AValue.create(font_name);
        }
        if (prop == "FONT_SIZE"||prop == "フォントサイズ") {
            return AValue.create(font_size);
        }
        if (prop == "FONT_COLOR"||prop == "フォント色") {
            return AValue.create(font_color);
        }
        if (prop == "ALPHA"||prop == "透明度") {
            return new Number( _mc._alpha );
        }
        if (prop == "ROTATION"||prop == "角度") {
            return new Number(_mc._rotation);
        }
        return null;
    }
    
    public function execEvent(ename:String) {
        ModuleSwfFunc.gui_activeParts = this._no;
        ModuleFunctionApi.addEvent(ename);
    }
}

