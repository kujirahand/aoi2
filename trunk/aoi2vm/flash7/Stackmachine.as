
class Stackmachine
{
    static var frame_speed = 256;
    
    var loader_txt:TextField = undefined; // Loader info text
    var parent:ALoader;
    var ir:/*IRCode*/Array;
    var _name:String = "Stackmachine";
    // for module loader
    var module_loader:MovieClipLoader;
    var module_loader_event:Object;
    var module_load_count:Number = 0;
    var module_load_index:Number = 0;
    var module_load_items:Array;
    var module_load_cur:AModule;
    var aoimodule:MovieClip;
    // stack
    var stack:/*Object*/Array;
    var funcstack:/*FuncFrame*/Array;
    // table
    var string_table:/*String*/Array;
    var func_table:/*AFunction*/Array;
    var module_table:/*AModule*/Array;
    var module_table_name:Object;
    var globalvar:/*Object*/Array;
    var varname_table:/*String*/Array;
    // current code
    var index:Number;
    var cur:IRCode;
    var cur_frame:FuncFrame;
    var event_stack:/*String*/Array;
    // flag
    var flag_quit:Boolean = false;
    var flag_wait:Boolean = false;
    var flag_reflesh:Boolean = false;
    
    function Stackmachine(parent:ALoader) {
        this.parent = parent;
        ir = new Array();
        string_table = new Array();
        module_table = new Array();
        module_table_name = new Object();
        globalvar = new Array();
        varname_table = new Array();
        stack = new Array();
        funcstack = new Array();
        cur_frame = new FuncFrame();
        funcstack.push(cur_frame);
        event_stack = new Array();
        setModuleLoader();
        flag_wait = false;
        //
        index = 0;
    }
    
    private function setModuleLoader() {
        var self:Stackmachine = this;
        // --- set system for module
        _root.aoisystem = this;
        module_load_count = 0;
        module_load_index = 0;
        module_load_items = new Array();
    }
    
    var event_cache:Object = {};
    
    function run_event(ename:String) {
        //KLog.write("run_event=" + ename);
        if (ename == undefined) return;
        // テーブルから関数を探す
        var f:AFunction = event_cache[ename];
        // 関数を探す
        if (f == undefined) {
            for (var i = 0; i < func_table.length; i++) {
                var ff = func_table[i];
                if (ff.name == ename) {
                    f = ff;
                    event_cache[ename] = f;
                    break;
                }
            }
        }
        // なければ戻る
        if (f == null) return;
        
        // フレームを追加する
        var return_index = this.index;
        
        this.cur_frame = new FuncFrame();
        this.funcstack.push(this.cur_frame);
        
        //this.cur_frame.return_index = -1;
        this.cur_frame.return_index = return_index;
        this.cur_frame.is_void_function = true;
        
        index = f.addr;
        flag_wait = false;
        flag_quit = false;
        
        //KLog.write("func.name=" + f.name);
        //KLog.write("func.addr=" + f.addr);
        //KLog.write("return=" + this.cur_frame.return_index);
    }
    
    function run_frame() {
        flag_reflesh = false;
        
        if (flag_wait) {
            if (event_stack.length > 0) {
                var ename:String = String(event_stack.pop());
                run_event(ename);
                return;
            }
        }
        
        for (var i = 0; i < frame_speed; i++) {
            if (flag_quit || flag_wait || flag_reflesh) return;
            if (ir.length <= index || index < 0) {
                this.flag_wait = true;
                return;
            }
            var old_index = index;
            cur = ir[index];
            // debug code
            if (0) {
                var line:String = "";
                if (isNaN(cur.value)) {
                    line = index + ":" + cur.name;
                } else {
                    if (cur.f == run_LOAD || cur.f == run_STORE) {
                        var varname:String = varname_table[cur.value];
                        if (varname == undefined) varname = String(cur.value);
                        line = index + ":" + cur.name + "=" + varname;
                    } else {
                        line = index + ":" + cur.name + "=" + cur.value;
                    }
                }
                KLog.write(line);
            }
            cur.f(this, Number(cur.value));
            if (old_index == index) index++;
        }
    }
    
    function loadNextModule():Void {
        var self:Stackmachine = this;
        
        KLog.write("items.length=" + module_load_items.length);
        if (module_load_items.length == 0) return;
        
        // event
        if (module_loader_event == undefined) {
            module_loader_event = new Object();
            module_loader_event.onLoadStart = function (mc:MovieClip) {
                KLog.write("module_loader.onLoadStrat=" + mc);
            };
            module_loader_event.onLoadInit = function (mc:MovieClip) {
                self.module_load_index++;
                KLog.write("module_loader.onLoadInit=" + mc._name);
                KLog.print_r(mc);
                KLog.write("*");
                var m:AModule = self.module_table_name[mc._name];
                m.getFunctionList();
                self.loadNextModule();
            };
            module_loader_event.onLoadError = function (mc_body:MovieClip, error_str:String, http_status:Number) {
                KLog.write("[ERROR] LoadError :" + mc_body + "\n[ERROR]" + error_str + '(' + http_status + ')');
                self.module_load_index++;
            };
            module_loader = new MovieClipLoader();
            module_loader.addListener(module_loader_event);
        }
        //
        var m:AModule = AModule(module_load_items.shift());
        var module_path:String = KUtils.getModulePath(m.name + ".swf");
        if (!KUtils.is_local()) {
            module_path += "?version=" + ALoader.VERSION;
        }
        KLog.write("load.module_path=" + module_path);
        module_load_cur = m;
        var r = module_loader.loadClip(module_path, m.mc);
        if (!r) {
            module_load_index++;
            KLog.write("[ERROR] module load error : " + m.name);
        }
    }
    
    function stack_push(v:Object) {
        stack.push(v);
        // KLog.write("  |-PUSH>" + AValue.convString(v));
    }
    function stack_pop():Object {
        var v:Object = stack.pop();
        // KLog.write("  |-POP >" + AValue.convString(v));
        return v;
    }
    
    function run() {
        var self:Stackmachine = this;
        // loading module
        if (module_load_index < module_load_count) {
            // show loader
            _root.createTextField("loader_txt", _root.getNextHighestDepth(),10,10,640,32);
            self.loader_txt = _root["loader_txt"];
            _root.onEnterFrame = function () {
                // KLog.write("onEnterFrame");
                if (self.module_load_index < self.module_load_count) {
                    var d:Date = new Date();
                    self.loader_txt.text = "[AOIVM] Now Loading ... [" + self.module_load_cur.name +
                        "] (" + self.module_load_index + "/" + self.module_load_count + ")";
                } else {
                    // ---
                    // module all loaded
                    KLog.write("module all loaded");
                    self.loader_txt.removeTextField();
                    //
                    _root.onEnterFrame = function () { self.run_frame(); }
                }
            }
            return;
        }
        // run
        KLog.write("run_frame()");
        _root.onEnterFrame = function () { self.run_frame(); };
    }
    
    public static function run_NOP(mac:Stackmachine, arg:Number) {}
    public static function run_EOL(mac:Stackmachine, arg:Number) {
        var fileid:Number = (arg >> 16);
        var lineno:Number = (arg & 0xFF);
        // KLog.write("EOL=" + fileid + "," + lineno);
    }
    public static function run_PUSH_NULL(mac:Stackmachine, arg:Number) {
        mac.stack_push(null);
    }
    public static function run_CONST_INT(mac:Stackmachine, arg:Number) {
        mac.stack_push(new Number(arg));
    }
    public static function run_CONST_NUM(mac:Stackmachine, arg:Number) {
        mac.stack_push(new Number(arg));
    }
    public static function run_CONST_STR(mac:Stackmachine, arg:Number) {
        var s = mac.string_table[arg];
        mac.stack_push(new String(s));
    }
    public static function run_LOAD(mac:Stackmachine, arg:Number) {
        var vv = mac.globalvar[arg];
        if (vv == undefined) {
            mac.globalvar[arg] = new AValueLink();
        }
        mac.stack_push(mac.globalvar[arg]);
    }
    public static function run_LOAD_LOCAL(mac:Stackmachine, arg:Number) {
        var vv = mac.cur_frame.localvar[arg];
        if (vv == undefined) {
            mac.cur_frame.localvar[arg] = new AValueLink();
        }
        mac.stack_push(mac.cur_frame.localvar[arg]);
    }
    public static function run_POP(mac:Stackmachine) {
        var vv = mac.stack_pop();
        delete vv;
    }
    public static function run_GET_ARRAY(mac:Stackmachine, arg:Number) {}
    public static function run_GET_HASH(mac:Stackmachine, arg:Number) {
        // pop
        var result:Object;
        var index:Object    = mac.stack_pop();
        var variable:Object = mac.stack_pop();
        index = AValue.getLink(index);
        
        // 変数の型を優先して、ハッシュか配列かを判断する
        var direct_value:Object  = AValue.getLink(variable);
        var vtype:Number = AValue.getType(direct_value);
        if (vtype != AValue.typeArray && vtype != AValue.typeHash) {
            // ハッシュでも配列でもない場合、キーの型で判断する
            vtype = AValue.getType(index);
            if (vtype == AValue.typeInt || vtype == AValue.typeNum) {
                vtype = AValue.typeArray;
                direct_value = new Array();
            }
            else {
                vtype = AValue.typeHash;
                direct_value = new Object();
            }
            AValue.changeLinkValue(variable, direct_value);
        }
        
        // 値を得る。値が無ければ作る
        if (vtype == AValue.typeArray) {
            if (undefined == direct_value[index]) {
                direct_value[index] = new AValueLink();
            }
            result = direct_value[index];
        }
        else {
            if (undefined == direct_value[index]) {
                direct_value[index] = new AValueLink();
            }
            result = direct_value[index];
        }
        
        // push
        mac.stack_push(result);
    }
    public static function run_STORE(mac:Stackmachine, arg:Number) {
        var vv = mac.stack_pop();
        mac.globalvar[arg] = new AValueLink(vv);
    }
    public static function run_STORE_LOCAL(mac:Stackmachine, arg:Number) {
        var vv:Object = mac.stack_pop();
        mac.cur_frame.localvar[arg] = new AValueLink(vv);
    }
    public static function run_LET(mac:Stackmachine, arg:Number) {
        var v_var:Object = mac.stack_pop();
        var v_exp:Object = mac.stack_pop();
        AValue.changeLinkValue(v_var, AValue.cloneObject(v_exp));
        //KLog.write("-LET:var="+v_var.getDescript());
        //KLog.write("-LET:exp="+v_exp.getDescript());
        //KLog.write("-LET:var="+v_var.getDescript());
        
    }
    public static function run_AND(mac:Stackmachine, arg:Number) {
        var v2:Object = mac.stack_pop();
        var v1:Object = mac.stack_pop();
        var n2:Number = AValue.convNumber(v2);
        var n1:Number = AValue.convNumber(v1);
        mac.stack_push(n1 && n2);
    }
    public static function run_OR(mac:Stackmachine, arg:Number) {
        var v2:Object = mac.stack_pop();
        var v1:Object = mac.stack_pop();
        var n2:Number = AValue.convNumber(v2);
        var n1:Number = AValue.convNumber(v1);
        mac.stack_push(n1 || n2);
    }
    public static function run_ADD(mac:Stackmachine, arg:Number) {
        var v2:Object = mac.stack_pop();
        var v1:Object = mac.stack_pop();
        var n2:Number = AValue.convNumber(v2);
        var n1:Number = AValue.convNumber(v1);
        mac.stack_push(n1 + n2);
    }
    public static function run_SUB(mac:Stackmachine, arg:Number) {
        var v2:Object = mac.stack_pop();
        var v1:Object = mac.stack_pop();
        var n2:Number = AValue.convNumber(v2);
        var n1:Number = AValue.convNumber(v1);
        mac.stack_push(n1 - n2);
    }
    public static function run_MUL(mac:Stackmachine, arg:Number) {
        var v2:Object = mac.stack_pop();
        var v1:Object = mac.stack_pop();
        var n2:Number = AValue.convNumber(v2);
        var n1:Number = AValue.convNumber(v1);
        mac.stack_push(n1 * n2);
    }
    public static function run_DIV(mac:Stackmachine, arg:Number) {
        var v2:Object = mac.stack_pop();
        var v1:Object = mac.stack_pop();
        var n2:Number = AValue.convNumber(v2);
        var n1:Number = AValue.convNumber(v1);
        mac.stack_push(n1 / n2);
    }
    public static function run_MOD(mac:Stackmachine, arg:Number) {
        var v2:Object = mac.stack_pop();
        var v1:Object = mac.stack_pop();
        var n2:Number = AValue.convNumber(v2);
        var n1:Number = AValue.convNumber(v1);
        mac.stack_push(n1 % n2);
    }
    public static function run_POWER(mac:Stackmachine, arg:Number) {
        var v2:Object = mac.stack_pop();
        var v1:Object = mac.stack_pop();
        var n2:Number = AValue.convNumber(v2);
        var n1:Number = AValue.convNumber(v1);
        mac.stack_push(Math.pow(n1,  n2));
    }
    public static function run_ADDSTR(mac:Stackmachine, arg:Number) {
        var v2:Object = mac.stack_pop();
        var v1:Object = mac.stack_pop();
        var n2:String = AValue.convString(v2);
        var n1:String = AValue.convString(v1);
        mac.stack_push(n1 + n2);
    }
    public static function run_GT(mac:Stackmachine, arg:Number) {
        var v2:Object = mac.stack_pop();
        var v1:Object = mac.stack_pop();
        var n2:Number = AValue.convNumber(v2);
        var n1:Number = AValue.convNumber(v1);
        mac.stack_push((n1 > n2) ? 1 : 0);
    }
    public static function run_GTEQ(mac:Stackmachine, arg:Number) {
        var v2:Object = mac.stack_pop();
        var v1:Object = mac.stack_pop();
        var n2:Number = AValue.convNumber(v2);
        var n1:Number = AValue.convNumber(v1);
        mac.stack_push((n1 >= n2) ? 1 : 0);
    }
    public static function run_LT(mac:Stackmachine, arg:Number) {
        var v2:Object = mac.stack_pop();
        var v1:Object = mac.stack_pop();
        var n2:Number = AValue.convNumber(v2);
        var n1:Number = AValue.convNumber(v1);
        mac.stack_push((n1 < n2) ? 1 : 0);
    }
    public static function run_LTEQ(mac:Stackmachine, arg:Number) {
        var v2:Object = mac.stack_pop();
        var v1:Object = mac.stack_pop();
        var n2:Number = AValue.convNumber(v2);
        var n1:Number = AValue.convNumber(v1);
        mac.stack_push((n1 <= n2) ? 1 : 0);
    }
    public static function run_EQEQ(mac:Stackmachine, arg:Number) {
        var v2:Object = mac.stack_pop();
        var v1:Object = mac.stack_pop();
        v2 = AValue.getLink(v2);
        v1 = AValue.getLink(v1);
        if (AValue.isIntOrNum(v1)) {
            var n2:Number = AValue.convNumber(v2);
            var n1:Number = AValue.convNumber(v1);
            mac.stack_push((n1 == n2) ? 1 : 0);
        }
        else {
            var s2:String = AValue.convString(v2);
            var s1:String = AValue.convString(v1);
            mac.stack_push((s1 == s2) ? 1 : 0);
        }
    }
    public static function run_NOTEQ(mac:Stackmachine, arg:Number) {
        var v2:Object = mac.stack_pop();
        var v1:Object = mac.stack_pop();
        v2 = AValue.getLink(v2);
        v1 = AValue.getLink(v1);
        if (AValue.isIntOrNum(v1)) {
            var n2:Number = AValue.convNumber(v2);
            var n1:Number = AValue.convNumber(v1);
            mac.stack_push((n1 != n2) ? 1 : 0);
        }
        else {
            var s2:String = AValue.convString(v2);
            var s1:String = AValue.convString(v1);
            mac.stack_push((s1 != s2) ? 1 : 0);
        }
    }
    public static function run_NOT(mac:Stackmachine, arg:Number) {
        var v1:Object = mac.stack_pop();
        var n1:Number = AValue.convNumber(v1);
        mac.stack_push((n1 == 0) ? 1 : 0);
    }
    public static function run_RET(mac:Stackmachine, arg:Number) {
        // stack pop
        var oldstack:FuncFrame = FuncFrame(mac.funcstack.pop());
        mac.cur_frame = mac.funcstack[mac.funcstack.length-1];
        mac.index = oldstack.return_index;
        
        // set $_
        var v = oldstack.localvar[0]; // value of function's result
        mac.cur_frame.localvar[0] = v; // $_
        
        // push value
        if (!oldstack.is_void_function) {
            mac.stack_push(v);
        }
        
        // wait ?
        if (mac.index < 0) {
            mac.flag_wait = true;
        }
        //KLog.write("-- -> "+mac.index);
        //KLog.write("-- sore="+v.value);
        //KLog.write("-- funcstack.length="+mac.funcstack.length);
        //KLog.write("-- return_index="+mac.cur_frame.return_index);
    }
    public static function run_JUMP(mac:Stackmachine, arg:Number) {
        mac.index = arg;
    }
    public static function run_JUMP_ZERO(mac:Stackmachine, arg:Number) {
        var v1:Object = mac.stack_pop();
        var n1:Number = AValue.convNumber(v1);
        if (n1 == 0) {
            mac.index = arg;
        }
    }
    public static function run_JUMP_NON_ZERO(mac:Stackmachine, arg:Number) {
        var v:Number = AValue.convNumber(mac.stack_pop());
        if (v != 0) {
            mac.index = arg;
        }
    }
    
    public static function getArgs(mac:Stackmachine, count:Number):Array {
        var res:Array = new Array();
        for (var i = 0; i < count; i++) {
            var v:Object = mac.stack_pop();
            //KLog.write("@getArgs=" + AValue.convString(v));
            var k = count - i - 1;
            res[k] = v;
        }
        return res;
    }
    
    public static function swap_stacktop(mac:Stackmachine, v:Object) {
        mac.stack_pop();    // pop dummy value
        mac.stack_push(v);
        var sore:AValueLink = new AValueLink();
        sore.setLink(v);
        mac.cur_frame.localvar[0] = Object(sore);
    }
    
    public static function run_CALL_USR(mac:Stackmachine, arg:Number) {
        var f:AFunction = mac.func_table[arg];
        // create local stack
        mac.cur_frame = new FuncFrame();
        mac.funcstack.push(mac.cur_frame);
        // set local arguments
        for (var i = 0; i < f.args; i++) {
            var num = f.args - i;//-1//todo
            var val = mac.stack_pop();
            mac.cur_frame.localvar[num] = val;
            // KLog.write("-- set_localvar[" + num + "]=" + val.value);
        }
        // set return address
        mac.cur_frame.return_index = mac.index + 1;
        // set function address
        mac.index = f.addr;
    }
    public static function run_CALL_LIB(mac:Stackmachine, arg:Number) {
        // module no
        var mod_no  = (arg >> 8);
        var func_no = arg & 0xFF;
        var mod:AModule = mac.module_table[mod_no];
        var arg_count = mod.func_ary[func_no]["arg"];
        /*
        KLog.write("module.name="+mod.name);
        KLog.write("module.args="+arg_count);
        KLog.write("module.func_no="+func_no);
        */
        // arg setting
        var fa:FunctionArg = new FunctionArg();
        var res:Object;
        fa._args = getArgs(mac, arg_count);
        fa._mac  = mac;
        // call
        //KLog.write("call=" + typeof(mod.func_ary[func_no]["func"]));
        mod.func_ary[func_no]["func"](fa);
        // set result
        res = fa._result;
        if (res != undefined) {
            var sore:AValueLink = new AValueLink();
            sore.setLink(res);
            mac.cur_frame.localvar[0] = Object(sore);
            //KLog.write("  |-SORE=" + String(sore.value));
        }
        mac.stack_push(res);
    }
    
    public static function run_EXIT(mac:Stackmachine, arg:Number) {
        KLog.write("EXIT");
        mac.flag_wait = true;
        mac.cur_frame.return_index = -1;
        mac.index = -1;
    }


}

