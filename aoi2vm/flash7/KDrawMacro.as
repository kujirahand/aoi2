//----------------------------------------------------------
// マクロ描画用クラス
//----------------------------------------------------------
class KDrawMacro
{
    var command_ary:Array = [];
    var x:Number = 0;
    var y:Number = 0;
    var mc:MovieClip;
    var wait:Number = 0;
    var draw_line_width:Number = 2;
    var draw_line_color:Number = 0;
    
    public function KDrawMacro(macro:String, wait:Number, mc:MovieClip) {
        this.wait = wait;
        this.mc   = mc;
        // 改行を削る
        macro = KUtils.str_replaceAll(macro, "\r", "");
        macro = KUtils.str_replaceAll(macro, "\n", "");
        macro = KUtils.str_replaceAll(macro, "\t", "");
        macro = KUtils.str_replaceAll(macro, " ", "");
        // マクロの解析
        var o:Object = {str:macro};
        while (o.str.length > 0) {
            // skip space
            // command
            var cmd:String;
            var p1:Number = 0;
            var p2:Number = 0;
            cmd   = o.str.charAt(0);
            o.str = o.str.substr(1);
            // param
            p1 = KUtils.str_getNumber(o);
            if (o.str.charAt(0) == ",") {
                o.str = o.str.substr(1);
                p2 = KUtils.str_getNumber(o);
            }
            //KLog.write("***"+cmd + "," + p1 + "," + p2);
            command_ary.push([cmd, p1, p2]);
        }
    }
    
    public function draw() {
        var self:KDrawMacro = this;
        if (wait > 0) {
            var tid;
            tid = setInterval(function(){
                self.draw_macro_one();
                if (self.command_ary.length == 0) {
                    clearInterval(tid);
                }
            }, wait);
        } else {
            while(command_ary.length > 0) {
                draw_macro_one();
            }
        }
    }
    
    private function draw_macro_one():Void {
        if (command_ary.length == 0) return;
        var o = command_ary.shift();
        var c:String  = o[0];
        var p1:Number = parseFloat(o[1]);
        var p2:Number = parseFloat(o[2]);
        //KLog.write("***"+c + "," + p1 + "," + p2);
        var nx:Number;
        var ny:Number;
        switch (c) {
            case 'w':
                draw_line_width = p1;
                draw_macro_one();
                break;
            case 'c':
                draw_line_color = p1;
                draw_macro_one();
                break;
            case 'p':
                x = p1;
                y = p2;
                break;
            case 'm':
                nx = x;
                ny = y;
                x += p1;
                y += p2;
                KDraw.line(mc, nx, ny, x, y, draw_line_color, draw_line_width);
                break;
            case 'l':
                nx = x;
                ny = y;
                x -= p1;
                KDraw.line(mc, nx, ny, x, y, draw_line_color, draw_line_width);
                break;
            case 'r':
                nx = x;
                ny = y;
                x += p1;
                KDraw.line(mc, nx, ny, x, y, draw_line_color, draw_line_width);
                break;
            case 'u':
                nx = x;
                ny = y;
                y -= p1;
                KDraw.line(mc, nx, ny, x, y, draw_line_color, draw_line_width);
                break;
            case 'd':
                nx = x;
                ny = y;
                y += p1;
                KDraw.line(mc, nx, ny, x, y, draw_line_color, draw_line_width);
                break;
            case '幅':
                draw_line_width = p1;
                draw_macro_one();
                break;
            case '色':
                draw_line_color = p1;
                draw_macro_one();
                break;
            case '点':
                x = p1;
                y = p2;
                break;
            case '動':
                nx = x;
                ny = y;
                x += p1;
                y += p2;
                KDraw.line(mc, nx, ny, x, y, draw_line_color, draw_line_width);
                break;
            case '左':
                nx = x;
                ny = y;
                x -= p1;
                KDraw.line(mc, nx, ny, x, y, draw_line_color, draw_line_width);
                break;
            case '右':
                nx = x;
                ny = y;
                x += p1;
                KDraw.line(mc, nx, ny, x, y, draw_line_color, draw_line_width);
                break;
            case '上':
                nx = x;
                ny = y;
                y -= p1;
                KDraw.line(mc, nx, ny, x, y, draw_line_color, draw_line_width);
                break;
            case '下':
                nx = x;
                ny = y;
                y += p1;
                KDraw.line(mc, nx, ny, x, y, draw_line_color, draw_line_width);
                break;
        }
    }
}

