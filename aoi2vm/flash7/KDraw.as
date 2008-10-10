
class KDraw
{
    static function rectangle(mc:MovieClip, x1, y1, x2, y2, bg_color, line_color, line_width) {
        if (line_width == undefined) { line_width = 1; }
        if (line_width == 0) { line_color = bg_color; }
        mc.beginFill(bg_color);
        mc.lineStyle(line_width, line_color);
        mc.moveTo(x1,y1);
        mc.lineTo(x2,y1);
        mc.lineTo(x2,y2);
        mc.lineTo(x1,y2);
        mc.lineTo(x1,y1);
        mc.endFill();
    }
    static function line(mc:MovieClip, x1, y1, x2, y2, line_color, line_width, alpha) {
        if (line_width == undefined) { line_width = 1; }
        if (alpha == undefined) { alpha = 100; }
        mc.beginFill(line_color, alpha);
        mc.lineStyle(line_width, line_color, alpha);
        mc.moveTo(x1,y1);
        mc.lineTo(x2,y2);
        mc.endFill();
    }
    static function rectangle_g(mc:MovieClip, x1, y1, x2, y2, bg_colors, rad, line_color, line_width) {
        if (line_width == undefined) { line_width = 1; }
        if (line_width == 0) { line_color = bg_colors[0]; }
        var matrix = {
            matrixType: "box", x: x1, y: y1,
            w: (x2-x1), h: (y2-y1), r: (rad  * Math.PI / 180)};
        mc.beginGradientFill("linear",bg_colors,[100,100],[0,255],matrix);
        mc.lineStyle(line_width, line_color);
        mc.moveTo(x1,y1);
        mc.lineTo(x2,y1);
        mc.lineTo(x2,y2);
        mc.lineTo(x1,y2);
        mc.lineTo(x1,y1);
        mc.endFill();
    }
    static function poly(mc:MovieClip, xy_ary, bg_color, line_color, line_width) {
        if (line_width == undefined) { line_width = 1; }
        if (line_width == 0) { line_color = bg_color; }
        mc.beginFill(bg_color);
        mc.lineStyle(line_width, line_color);
        mc.moveTo(xy_ary[0][0], xy_ary[0][1]);
        for (var i = 1; i < xy_ary.length; i++) {
            mc.lineTo(xy_ary[i][0], xy_ary[i][1]);
        }
        mc.lineTo(xy_ary[0][0], xy_ary[0][1]);
        mc.endFill();
    }
    /**
     * MovieClip : move to center
     */
    static var stage_width:Number;
    static var stage_height:Number;
    static function moveToCenter(mc:MovieClip) {
        if (stage_width == undefined) {
            stage_width = Stage.width;
            stage_height = Stage.height;
        }
        //KLog.write("stage_width=" + stage_width);
        mc._x = (stage_width - mc._width) / 2;
        mc._y = (stage_height - mc._height) / 2;
    }
    
    static function fadeout(mc:MovieClip, vfrom:Number, vto:Number, speed:Number) {
        if (speed == undefined || speed < 1) { speed = 1; }
        var timer_id:Number;
        timer_id = setInterval(function(){
            if (vfrom < vto) {
                mc._alpha += 10;
                if (mc._alpha > vto) {
                    clearInterval(timer_id);
                }
            } else {
                mc._alpha -= 10;
                if (mc._alpha < vto) {
                    clearInterval(timer_id);
                }
            }
        }, speed);
    }
    
    /**
     * blackout
     */
    private static var blackout_mc:MovieClip;
    static function blackout(onoff:Boolean):Void {
        if (blackout_mc == undefined) {
            _root.createEmptyMovieClip("blackout_mc",_root.getNextHighestDepth());
            blackout_mc = _root["blackout_mc"];
            rectangle(blackout_mc, 0, 0, Stage.width,Stage.height, 0x000000, 0xCCCCCC, 4);
            blackout_mc.onPress = function () {};
        }
        if (onoff == true) {
            blackout_mc._alpha = 0;
            fadeout(blackout_mc, 0, 60, 50);
            blackout_mc._visible = true;
        } else {
            fadeout(blackout_mc, 60, 0, 50);
            blackout_mc._visible = false;
        }
    }
    
    static function RGB(r,g,b):Number {
        return (r << 16) | (b << 8) | b;
    }
}

