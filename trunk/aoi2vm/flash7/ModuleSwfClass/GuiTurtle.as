/*
 * GuiTurtle.as 
 */

import ModuleSwfClass.GuiObject;

class ModuleSwfClass.GuiTurtle extends GuiObject
{
    var imagefile:String = "turtle.swf";
    var turtle_mc:MovieClip;
    
    var EVENT_BORN       = 1;
    var EVENT_FORWARD    = 2;
    var EVENT_TURN_LEFT  = 3;
    var EVENT_TURN_RIGHT = 4;
    var EVENT_DRAW_COLOR = 5;
    var EVENT_DRAW_FLAG  = 6;
    var EVENT_DRAW_WIDTH = 7;
    var EVENT_SET_SPEED  = 8;
    var EVENT_SET_DIR    = 9;
    
    var turtle_interval:Number    = 1000 / 24;
    var turtle_dir:Number         = 0;
    var turtle_frame_speed:Number = 2;
    var turtle_frame_index:Number = 0;
    var turtle_speed = 8;//4;
    var turtle_move  = 0;
    var turtle_cmd:Array;
    var turtle_cmd_args:Array;
    var turtle_w:Number;
    var turtle_h:Number;
    var turtle_cmd_max:Number   = -1;
    var turtle_cmd_index:Number = -1;
    var target_x:Number;
    var target_y:Number;
    var flag_ready:Boolean = false;
    var draw_flag:Boolean = true;
    var draw_width:Number = 2;
    var draw_color:Number = 0xFF0000;
    var draw_x:Number;
    var draw_y:Number;
    var turtle_timerid:Number = 0;
    
    var loader:MovieClipLoader;
    var loader_event:Object;
    
    function GuiTurtle(gui_root:MovieClip, no:Number) {
        init(gui_root, no);
        _w = 32;
        _h = 32;
    }
    
    private function turtle_onLoadInit(e:MovieClip) {
        flag_ready = true;
        turtle_event();
    }
    
    private function turtle_load() {
        var path:String = _root._url;
        path = KUtils.getModulePath(imagefile);
        KLog.write("TutleLoad:"+path);
        if (!loader.loadClip(path, turtle_mc)) {
            KLog.write("loadClip.error imagefile=" + path);
        }
        turtle_cmd.push(EVENT_BORN);
        turtle_cmd_args.push(0);
    }
    
    private function turtle_onEnterFrame() {
        // event check
        if (flag_ready == false) return;
        if (turtle_cmd.length == 0) return;
        // speed
        turtle_frame_index++;
        if (turtle_frame_index < turtle_frame_speed) return;
        turtle_frame_index = 0;
        // event
        turtle_event();
    }
    
    // --------------------------------------------
    // TURTLE EVENT
    // --------------------------------------------
    private function turtle_event() {
        while (true) {
            var cmd = turtle_cmd[0];
            switch (cmd) {
                case EVENT_BORN         :   turtle_event_born();    break;
                case EVENT_FORWARD      :   turtle_event_forward(); break;
                case EVENT_TURN_LEFT    :   turtle_event_left();    break;
                case EVENT_TURN_RIGHT   :   turtle_event_right();   break;
                case EVENT_DRAW_COLOR   :   turtle_event_draw_color();  break;
                case EVENT_DRAW_FLAG    :   turtle_event_draw_flag();   break;
                case EVENT_DRAW_WIDTH   :   turtle_event_draw_width();  break;
                case EVENT_SET_SPEED    :   turtle_event_set_speed();   break;
                case EVENT_SET_DIR      :   turtle_event_set_dir();     break;
                default                 :   turtle_cmd_index = turtle_cmd_max;
            }
            // quit event ?
            if (turtle_cmd_index > turtle_cmd_max) {
                turtle_cmd       = turtle_cmd.slice(1);
                turtle_cmd_args  = turtle_cmd_args.slice(1);
                turtle_cmd_index = -1;
                turtle_cmd_max   = -1;
            }
            if (turtle_cmd.length == 0)  break;
            if (turtle_frame_speed == 0) continue;
            break;
        }
    }
    
    private function turtle_event_set_speed() {
        turtle_frame_speed = turtle_cmd_args[0];
        turtle_cmd_max   = 1; turtle_cmd_index = 2;
    }
    private function turtle_event_draw_color() {
        draw_color = turtle_cmd_args[0];
        turtle_cmd_max   = 1; turtle_cmd_index = 2;
    }
    private function turtle_event_draw_flag() {
        draw_flag = (turtle_cmd_args[0] != 0);
        turtle_cmd_max   = 1; turtle_cmd_index = 2;
    }
    private function turtle_event_draw_width() {
        draw_width = turtle_cmd_args[0];
        turtle_cmd_max   = 1; turtle_cmd_index = 2;
    }
    private function turtle_event_set_dir() {
        turtle_dir = turtle_cmd_args[0];
        turtle_setRotation();
        turtle_cmd_max   = 1; turtle_cmd_index = 2;
    }
    private function turtle_event_born() {
        if (turtle_cmd_index < 0) { // first
            turtle_cmd_index = 0;
            turtle_cmd_max   = 10;
        }
        turtle_mc._xscale = turtle_cmd_index * 10;
        turtle_mc._yscale = turtle_cmd_index * 10;
        turtle_mc._rotation = ((turtle_cmd_index / turtle_cmd_max) * 360) % 360;
        if (turtle_cmd_index == 10) {
            turtle_setRotation();
        }
        turtle_cmd_index++;
        var self = this;
        if (turtle_timerid == 0) {
            turtle_timerid = setInterval(function(){
                self.turtle_onEnterFrame();
            }, turtle_interval);
        }
    }
    
    private function turtle_event_forward() {
        var r:Number  = (turtle_dir - 90) / 180 * Math.PI;
        if (turtle_cmd_index < 0) { // first
            var n:Number  = turtle_cmd_args[0];
            var px:Number = Math.cos(r) * n;
            var py:Number = Math.sin(r) * n;
            target_x = _mc._x + px;
            target_y = _mc._y + py;
            turtle_cmd_index = 0;
            turtle_cmd_max   = 10;
            turtle_move      = turtle_speed;
        } else {
            turtle_move *= 1.25;
            _mc._x += (target_x > _mc._x) ? turtle_move : (-1 * turtle_move);
            _mc._y += (target_y > _mc._y) ? turtle_move : (-1 * turtle_move);
        }
        var dx = Math.abs(_mc._x - target_x);
        var dy = Math.abs(_mc._y - target_y);
        if (dx < turtle_move*2) _mc._x = target_x;
        if (dy < turtle_move*2) _mc._y = target_y;
        var distance = dx + dy;
        if (distance < turtle_move * 4) {
            _mc._x = target_x;
            _mc._y = target_y;
            turtle_cmd_index = 11;
            turtle_cmd_max   = 10;
            // draw
            if (draw_flag) {
                var mc:MovieClip = ModuleSwfFunc.getDrawCanvas();
                KDraw.line(mc, draw_x, draw_y, _mc._x, _mc._y, draw_color, draw_width);
            }
            draw_x = _mc._x;
            draw_y = _mc._y;
        }
        //KLog.write("forward=" + distance);
        
    }
    
    private function turtle_setRotation() {
        turtle_mc._rotation = turtle_dir;
    }
    
    private function turtle_event_left() {
        turtle_dir -=  turtle_cmd_args[0];
        if (turtle_dir < 0) { turtle_dir += 360; }
        turtle_setRotation();
        
        turtle_cmd_max   = 1;
        turtle_cmd_index = 2;
    }
    private function turtle_event_right() {
        turtle_dir +=  turtle_cmd_args[0];
        turtle_dir = turtle_dir % 360;
        turtle_setRotation();
        
        turtle_cmd_max   = 1;
        turtle_cmd_index = 2;
    }
    public function turtle_forward(n:Number) {
        turtle_cmd.push(EVENT_FORWARD);
        turtle_cmd_args.push(n);
    }
    public function turtle_turnLeft(n:Number) {
        turtle_cmd.push(EVENT_TURN_LEFT);
        turtle_cmd_args.push(n);
    }
    public function turtle_turnRight(n:Number) {
        turtle_cmd.push(EVENT_TURN_RIGHT);
        turtle_cmd_args.push(n);
    }
    
    public function createObject() {
        if (_mc == undefined) return;
        var self:GuiTurtle = this;
        
        // set command
        turtle_cmd      = new Array();
        turtle_cmd_args = new Array();
        // create object
        _mc.createEmptyMovieClip("turtle_mc", 2000);
        turtle_mc = _mc["turtle_mc"];
        
        // load turtle init
        loader = new MovieClipLoader();
        loader_event = new Object();
        loader_event.onLoadInit = function(e) { self.turtle_onLoadInit(e); }
        loader_event.onLoadError = function () {
            KLog.write("LOAD ERROR : " + KUtils.getModulePath( self.imagefile ));
            // retry
            
        }
        loader.addListener(loader_event);
        turtle_load();
        
        // event
        _mc.onRollOver = function () {
        };
        _mc.onRollOut = function () {
        };
        _mc.onPress = function () {
            self.execEvent(self._event);
        };
        _mc.onMouseUp = function () {
        };
        _mc.onRelease = function () {
        };
        redraw();
    }
    
    public function redraw() {
    }
    
    public function resize() {
        turtle_mc._width  = _w;
        turtle_mc._height = _h;
    }
    
    public function loadImage(url:String) {
        loader.unloadClip(turtle_mc);
        this.imagefile = url;
        turtle_load();
    }
    
    public function setProperty(prop:String, value:Object):Void {
        prop = prop.toUpperCase();
        super.setProperty(prop, value);
        if (prop == "画像" || prop == "image") {
            loadImage(AValue.convString(value));
        } else
        if (prop == "X"||prop == "左") {
            draw_x = AValue.convNumber(value);
        } else
        if (prop == "Y"||prop == "上") {
            draw_y = AValue.convNumber(value);
        } else
        if (prop == "WAIT"||prop == "待機時間") {
            turtle_cmd.push(EVENT_SET_SPEED);
            turtle_cmd_args.push(AValue.convNumber(value));
        } else
        if (prop == "PEN_COLOR"||prop == "ペン色") {
            turtle_cmd.push(EVENT_DRAW_COLOR);
            turtle_cmd_args.push(AValue.convNumber(value));
        } else
        if (prop == "PEN_DOWN"||prop == "ペン") {
            turtle_cmd.push(EVENT_DRAW_FLAG);
            turtle_cmd_args.push(AValue.convNumber(value));
        } else
        if (prop == "PEN_WIDTH"||prop == "ペン太") {
            turtle_cmd.push(EVENT_DRAW_WIDTH);
            turtle_cmd_args.push(AValue.convNumber(value));
        }
        if (prop == "DIR"||prop == "方向") {
            turtle_cmd.push(EVENT_SET_DIR);
            turtle_cmd_args.push(AValue.convNumber(value));
        }
    }
    
    public function getProperty(prop:String):Object {
        prop = prop.toUpperCase();
        var v:Object = super.getProperty(prop);
        if (v != null) return v;
        if (prop == "画像" || prop == "image") {
            return AValue.create(this.imagefile);
        } else
        if (prop == "WAIT"||prop == "待機時間") {
            return turtle_frame_speed;
        } else
        if (prop == "PEN_COLOR"||prop == "ペン色") {
            return draw_color;
        } else
        if (prop == "PEN_DOWN"||prop == "ペン") {
            return draw_flag;
        } else
        if (prop == "PEN_WIDTH"||prop == "ペン太") {
            return draw_width;
        }
        if (prop == "DIR"||prop == "方向") {
            return this.turtle_dir;
        }
        return null;
    }
}
