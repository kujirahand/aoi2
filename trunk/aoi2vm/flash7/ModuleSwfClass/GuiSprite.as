/*
 * GuiSprite.as 
 */

import ModuleSwfClass.GuiObject;

class ModuleSwfClass.GuiSprite extends GuiObject
{
    var imagefile:String;
    var _image_mc:MovieClip;
    var _onPress:String;
    var _onRelease:String;
    var loader:MovieClipLoader;
    var loaderEvent:Object;
    var _cell_index:Number = 0; /* anime cell no */
    var _cell_array:Array;
    var _anime_speed:Number = 0;
    var _anime_tid:Number = 0;
    
    function GuiSprite(gui_root:MovieClip, no:Number) {
        init(gui_root, no);
        _w = 32;
        _h = 32;
    }
    
    public function createObject() {
        var self:GuiSprite = this;
        /*
        _mc.onPress = function() {
            self.execEvent(self._event);
        };
        */
        loader = new MovieClipLoader();
        loaderEvent = new Object();
        //
        _cell_array = new Array();
        _cell_array[0] = _mc;
    }
    
    public function redraw() {
    }
    
    public function resize() {
        _image_mc._width  = _w;
        _image_mc._height = _h;
    }
    
    public function loadImage(url:String) {
        this.imagefile = url;
        if (_image_mc) {
            loader.unloadClip(_image_mc);
        }
        _mc.createEmptyMovieClip("_image_mc", _mc.getNextHighestDepth());
        _image_mc = _mc["_image_mc"];
        loaderEvent.onLoadInit = function (mc) {
            // ok
        };
        loaderEvent.onLoadError = function(target_mc:MovieClip, errorCode:String, httpStatus:Number) {
            KLog.write("loadError:" + errorCode + ":" + httpStatus + ":" + url);
        };
        loader.addListener(loaderEvent);
        KLog.write("image_mc=" + _mc._image_mc);
        if(!loader.loadClip(this.imagefile, _mc._image_mc)){
            KLog.write("loadClip failed :" + url);
        }
    }
    
    public function setCell(no:Number):Void {
        var mcx:Number = _mc._x;
        var mcy:Number = _mc._y;
        // cell の作成
        if (_cell_array[no] == undefined) {
            var n:String = "gui_parts_" + _no + "_" + no;
            root.createEmptyMovieClip(n, root.getNextHighestDepth());
            _cell_array[no] = root[n];
        }
        // change cell
        for (var i:Number = 0; i < _cell_array.length; i++) {
            _cell_array[i]._visible = (i == no) ? true : false;
        }
        _cell_index = no;
        _mc = _cell_array[no];
        _mc._x = mcx;
        _mc._y = mcy;
    }
    
    public function setAnime(speed:Number):Void {
        var self:GuiSprite = this;
        _anime_speed = speed;
        if (speed > 0) {
            _anime_tid = setInterval(function(){
                var idx:Number = self._cell_index + 1;
                if (self._cell_array.length <= idx) idx = 0;
                self.setCell(idx);
                //KLog.write("idx=" + idx + "/" + self._cell_array.length);
            },speed);
        }
        else {
            if (_anime_tid > 0) {
                clearInterval(_anime_tid);
            }
        }
    }
    
    public function setProperty(prop:String, value:Object):Void {
        var self:GuiSprite = this;
        prop = prop.toUpperCase();
        super.setProperty(prop, value);
        if (prop == "画像" || prop == "IMAGE") {
            KLog.write("loadImage=" + value.toString());
            loadImage(AValue.convString(value));
            return;
        }
        if (prop == "マウス押した時" || prop == "ONPRESS") {
            self._onPress = AValue.convString(value);
            _mc.onPress = function() {
                self.execEvent(self._onPress);
            };
            return;
        }
        if (prop == "マウス離した時" || prop == "ONPRESS") {
            self._onRelease = AValue.convString(value);
            _mc.onRelease = function() {
                self.execEvent(self._onPress);
            };
            return;
        }
        if (prop == "セル" || prop == "CELL") {
            self.setCell(AValue.convNumber(value));
            return;
        }
        if (prop == "アニメ速度" || prop == "SPEED") {
            self.setAnime(AValue.convNumber(value));
            return;
        }
    }
    
    public function getProperty(prop:String):Object {
        var self:GuiSprite = this;
        prop = prop.toUpperCase();
        var v:Object = super.getProperty(prop);
        if (v != null) return v;
        if (prop == "画像" || prop == "IMAGE") {
            return AValue.create(this.imagefile);
        }
        if (prop == "マウス押した時" || prop == "ONPRESS") {
            return AValue.create(self._onPress);
        }
        if (prop == "マウス離した時" || prop == "ONPRESS") {
            return AValue.create(self._onRelease);
        }
        if (prop == "セル" || prop == "CELL") {
            return AValue.create(self._cell_index);
        }
        if (prop == "アニメ速度" || prop == "SPEED") {
            return AValue.create(self._anime_speed);
        }
        return null;
    }
}
