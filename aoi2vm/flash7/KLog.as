/**
 * KLog.as - ActionScript 2.0 Log System
 * @author kujirahand.com ( http://kujirahand.com )
 */

/* --- USAGE ---
// output "KLogServer.exe"
KLog.use_server = true;
KLog.write("hoge");

// output textfield
KLog.use_textfield = true;
KLog.use_server    = false;
KLog.write("hoge");

// trace object
KLog.print_r(obj);

*/

class KLog
{
    function KLog() { /* 空だけど必要 */ }
    
    // KLog setting
    // var use_server:Boolean    = true;      // サーバーに出力するか? (実態はアクセサ)
    // var use_textfield:Boolean = false;     // TextFieldに出力するか?(実態はアクセサ)
    static var isTest:Boolean    = true;      // 不要になったら、isTest = false にする
    static var LOG_SIZE:Number   = 1024 * 32; // log size (32KB)
    
    private static var socket_url:String  = "127.0.0.1"; // serverのIPアドレス
    private static var socket_port:Number = 36979;
    
    // static function
    static function write(str:String)
    {
        var r = KLog.getInstance();
        r._write(str);
    }
    static function err(str:String) {
        KLog.write("[ERROR]" + str);
    }
    static function print_r(obj:Object)
    {
        var r = KLog.getInstance();
        r._print_r(obj);
    }
    
    static function getInstance():KLog
    {
        // create instance
        if (!_global._klog) {
            _global._klog = new KLog();
        }
        return _global._klog;
    }
    
    //
    public static var txt:TextField;
    public static var sender:XMLSocket;
    
    function _write(str:String)
    {
        // [ERROR] があれば、isTest == false でも出力する
        if (KLog.isTest == false) {
            if (str.indexOf("[ERROR]", 0) < 0) { return; }
        }
        if (txt.text == undefined) txt.text = "";
        
        if (use_server) {
            create_socket();
            sender.send(str);
        }
        
        if (use_textfield) {
            create_textfiled();
            var ss:String = str + "\n" + txt.text;
            if (ss.length > LOG_SIZE) {
                ss = ss.substr(0, Math.floor(LOG_SIZE / 2));
            }
            txt.text = str + "\n" + txt.text;
            txt.swapDepths(txt._parent.getNextHighestDepth());
        }
    }
    
    static function _typeof(obj):String {
        var s:String = typeof(obj);
        if (s == "object") {
            if (obj instanceof Array) {
                s = "array";
            }
        }
        return s;
    }
    
    function _tabout(level:Number) {
        var s:String = "";
        for (var i = 0; i < level; i++) {
            s += "\t";
        }
        return s;
    }
    
    function _print_r(obj):Void {
        if (KLog.isTest == false) return;
        var s:String = _description(obj, 0);
        if (obj._name) {
            s = obj._name + "=" + s;
        }
        _write(s);
    }
    
    static function _replace(str:String, a:String, b:String):String {
        var ary:Array = str.split(a);
        return ary.join(b);
    }
    
    function _description(obj, level:Number):String // like JSON
    {
        if (level > 2) return "..";
        var result:String = _tabout(level);
        
        var t:String = _typeof(obj);
        if (t == "number") {
            return result + obj;
        }
        else if (t == "string") {
            var str:String = String(obj);
            str = str.substr(0,24);
            str = _replace(str, "\n", "\\n");
            str = _replace(str, "\r", "\\r");
            str = _replace(str, "\t", "\\t");
            return result + '"' + str + '"';
        }
        else if (t == "array") {
            result += "[\n";
            var ary:Array = Array(obj);
            for (var i = 0; i < ary.length; i++) {
                if (typeof(ary[i]) == "object") {
                    result += _description(ary[i], level + 1) + ",\n";
                } else {
                    result += _tabout(level + 1) + _description(ary[i], 0) + ",\n";
                }
            }
            if (ary.length > 0) result = result.substr(0, result.length - 2);
            result += "\n" + _tabout(level) + "]";
            return result;
        }
        else if (t == "object" || t == "movieclip") {
            result += "{\n";
            var obj_cnt:Number = 0;
            for (var key in obj) {
                result += _tabout(level + 1) + key + ":";
                if (typeof(obj[key]) == "object") {
                    result += "\n" + _description(obj[key], level + 1) + ",\n";
                } else {
                    result += _description(obj[key], 0) + ",\n";
                }
                obj_cnt++;
            }
            if (obj_cnt > 0) result = result.substr(0, result.length - 2);
            result += "\n" + _tabout(level) + "}";
            return result;
        }
        else if (t == "undefined") {
            return result + "undefined";
        }
        else if (t == "boolean") {
            return result + "" + obj;
        }
        else if (t == "null") {
            return result + "null";
        }
        else if (t == "function") {
            return result + "function";
        }
        else {
            return result + "(" + obj + ":" + _typeof(obj) + ")";
        }
    }
    
    // default
    private static var f_use_server:Boolean    = true;
    private static var f_use_textfield:Boolean = false;
    
    static function get use_server():Boolean {
        return f_use_server;
    }
    static function set use_server(v:Boolean):Void {
        if (v) {
            create_socket();
        } else {
            if (sender) {
                sender.close();
                delete sender;
            }
        }
        f_use_server = v;
    }
    private static function create_socket() {
        if (!sender) {
            System.security.loadPolicyFile("xmlsocket://" + socket_url + ":" + socket_port);
            sender = new XMLSocket();
            sender.connect(socket_url, socket_port);
        }
    }
    
    static function get use_textfield():Boolean {
        return f_use_textfield;
    }
    static function set use_textfield(v:Boolean):Void {
        if (v) {
            create_textfiled();
        } else {
            if (txt) {
                txt._visible = false;
                txt.text = "";
            }
        }
        f_use_textfield = v;
    }
    private static function create_textfiled() {
        if (txt) return;
        var name = "__KLog_txt";
        _root.createTextField(name, _root.getNextHighestDepth(), 
            0, 0, Stage.width, Stage.height);
        txt = _root[name];
        txt.text = "";
        txt.autoSize = true;
        var tf:TextFormat = new TextFormat();
        tf.font = "_等幅";
        txt.setNewTextFormat(tf);
    }
}
