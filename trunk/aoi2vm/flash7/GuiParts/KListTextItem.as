import GuiParts.KList;
import GuiParts.KGuiObj;
import GuiParts.KSkin;

class GuiParts.KListTextItem
{
    var _txt:TextField;
    var _mc:MovieClip;
    var _parent:KList;
    var _status:Number;
    var _w:Number;
    var _h:Number;
    var _tag:Number;
    //
    var onClick;
    //
    static var STATUS_NORMAL = 0;
    static var STATUS_SELECTED = 1;
    static var STATUS_NONE = 2;
    
    function KListTextItem(parent:KList, x:Number, y:Number, width:Number, height:Number) {
        _status = 0;
        _parent = parent;
        _w = width;
        _h = height;
        _tag = -1;
        // create
        _mc  = _parent._mc.createEmptyMovieClip("_mc", _parent._mc.getNextHighestDepth());
        _mc._x = x;
        _mc._y = y;
        _mc.createTextField("_txt", _mc.getNextHighestDepth(), 
            _parent._item_margin, 0, width - (_parent._item_margin*2), height);
        _txt = _mc["_txt"];
        _txt.selectable = false;
        _txt.type = "dynamic";
        _txt.autoSize = false;
        var tf:TextFormat = new TextFormat();
        tf.font = "_ゴシック";
        tf.size = 24;
        _txt.setNewTextFormat(tf);
        // event
        var self = this;
        _mc.onRelease = function () {
            self.onClick(self);
        };
        // 境界を描画
        drawStatus();
    }
    
    function get text():String {
        return _txt.text;
    }
    
    function set text(v:String):Void {
        _txt.text = v;
    }
    
    function drawStatus() {
        _mc._visible  = true;
        _txt._visible = true;
        if (_status == STATUS_NORMAL) {
            KDraw.rectangle(_mc, 1, 1, _w-2, _h, KSkin.C_WINDOW, KSkin.C_WINDOW, 0);
            KDraw.line(_mc, 1, _h, _w-2, _h, KSkin.C_LIST_BORDER);
            _txt.textColor = KSkin.C_BUTTON_TEXT;
            return;
        }
        if (_status == STATUS_SELECTED) {
            KDraw.rectangle_g(_mc, 1, 1, _w-2, _h, [0x0000FF,0xCCCCFF], 90, 0xFFFFFF, 1);
            _txt.textColor = KSkin.C_BUTTON_SELECTED_TEXT;
            return;
        }
        if (_status == STATUS_NONE) {
            KDraw.rectangle(_mc, 1, 1, _w-2, _h, KSkin.C_WINDOW, KSkin.C_WINDOW, 0);
            _txt._visible = false;
            return;
        }
    }
    
    function remove() {
        _mc.removeMovieClip();
        _txt.removeTextField();
    }
}

