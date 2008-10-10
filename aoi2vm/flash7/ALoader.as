/**
 * ALoader.as
 * -------------------------------
 * memo:
 *   Wii screen size -- 800x500 px
 */

class ALoader
{
    static var VERSION = 1000;
    static var mainfile:String;
    static var mainsource:String;
    var machine:Stackmachine;
    
    function ALoader() {
        init();
    }
    
    function init() {
        machine = new Stackmachine(this);
        vmtable.init(machine);
        KDraw.stage_height = Stage.height;
        KDraw.stage_width  = Stage.width;
        setRoot();
    }
    
    function checkFlashVars() {
        // --- check main file & library
        mainfile     = _root.mainfile;
        // --- check main source
        mainsource = _root.mainsource;
        // --- check library_path
        if (_root.library_path) {
            var lib:String = _root.library_path;
            KUtils.getInstance().library_path = lib;
            KLog.write("library_path=" + lib);
        }
    }
    
    function setRoot() {
        var e:KEventHandler = new KEventHandler(_root);
    }
    
    function toString() {
        return "ALoader";
    }
    
    function loadMainFile(url:String) {
        var self:ALoader = this;
        var a_lv:LoadVars = new LoadVars();
        a_lv.onData = function (dat:String) {
            KLog.write("mainfile.load.ok");
            self.setMainCodeStr(dat);
        };
        url = KUtils.getAbsolutePathFromRoot(url);
        KLog.write("@mainfile.load=" + url);
        if (!a_lv.load(url)) {
            KLog.err("LOAD MAINFILE : " + url);
        }
    }
    
    function setMainCodeStr(dat:String) {
        var self:ALoader = this;
        // check error
        if (dat == undefined || dat.length == 0) {
            KLog.write("[ERROR] NO PROGRAM : " + mainfile);
            return;
        }
        var obj:Object;
        // parse
        try {
            obj = JSON.parse(dat);
        } catch (ex) {
            KLog.write("[ERROR] JSON : " + ex.name + ":" + ex.message + ":" + ex.at + ":" + ex.text);
            return;
        }
        setMainCode(obj);
    }
    
    function setMainCode(obj:Object) {
        var self:ALoader = this;
        // check code
        if (obj["type"] != "aoi" || obj["version"] < 1000) {
            KLog.write("[ERROR] : BROKEN PROGRAM :" + mainfile);
            return;
        }
        // set code
        self.machine.string_table = obj["string_table"];
        self.analizeIRCode(obj["ir"]);
        self.machine.func_table = obj["func_table"];
        self.getModuleTable(obj["module_table"]);
        self.getVariableTable(obj["variable_table"]);
        // run
        self.run();
    }
    
    function getVariableTable(vtable:Array):Void {
        if (vtable == null) return;
        for (var i = 0; i < vtable.length; i++) {
            var key:String = vtable[i];
            this.machine.varname_table[i] = key;
        }
    }
    
    function getModuleTable(modules:Array):Void {
        // Check module
        for (var i = 0; i < modules.length; i++) {
            var m:AModule = new AModule(modules[i]["name"]);
            machine.module_table.push(m);
            machine.module_table_name[m.name] = m;
            // already loaded ?
            if (_root[m.name].getFunctionList != undefined) {
                KLog.write("module already included:" + m.name);
                m.mc = _root[m.name];
                m.getFunctionList();
                // KLog.write("func_ary=" + (m.func_ary instanceof Array));
                continue;
            }
            // load
            machine.module_load_count++;
            KLog.write("module load:" + m.name);
            machine.module_load_items.push(m);
        }
        machine.module_load_index = 0;
        machine.loadNextModule();
    }
    
    function analizeIRCode(irstr:String):Void {
        var ls:Array = irstr.split(",");
        for (var i = 0; i < ls.length; i++) {
            var cur:String  = ls[i];
            var code:IRCode = new IRCode();
            var ch:Number   = cur.charCodeAt(0);
            cur = cur.substr(1,cur.length-1);
            code.f = vmtable.ftable[ch];
            code.name = vmtable.ntable[ch];
            if (cur.indexOf(".") > 0) {
                code.value = parseFloat(cur);
            } else {
                code.value = parseInt(cur);
            }
            machine.ir[i] = code;
        }
    }
    
    function run() {
        machine.run();
    }
}
