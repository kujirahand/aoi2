
class GuiParts.KGuiObj {
    
    var root:MovieClip;
    var _mc:MovieClip;
    var _enabled:Boolean = true;
    var _w:Number;
    var _h:Number;
    
    function init() {
        _mc = root.createEmptyMovieClip("_mc", root.getNextHighestDepth());
    }
    function resize() {}
    function redraw() {}
    function remove() {
        _mc.removeMovieClip();
    }
    // --- (x,y)
    function get x():Number {
        return _mc._x;
    }
    function set x(v:Number):Void {
        _mc._x = v;
    }
    function get y():Number {
        return _mc._y;
    }
    function set y(v:Number):Void {
        _mc._y = v;
    }
    function get width():Number {
        return _w;
    }
    function set width(v:Number):Void {
        _w = v;
        resize();
    }
    function get height():Number {
        return _h;
    }
    function set height(v:Number):Void {
        _h = v;
        resize();
    }
    function get enabled():Boolean {
        return _enabled;
    }
    function set enabled(v:Boolean):Void {
        _enabled = v;
        redraw();
    }
    
}

