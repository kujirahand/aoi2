/**
 * KUtils.as
 * Utility
 */

class KUtils {
    
    // _global instance
    var library_path:String;
    static function getInstance():KUtils {
        if (!_global.kutils) {
            _global.kutils = new KUtils();
        }
        return _global.kutils;
    }
    
    static function str_replaceAll(s:String, a:String, b:String):String {
        var s_ary:Array = s.split(a);
        s = s_ary.join(b);
        return s;
    }
    
    static function str_replaceOne(s:String, a:String, b:String):String {
        var i:Number = s.indexOf(a);
        if (i < 0) {
            return s;
        }
        // ex) 012*456
        var head:String = s.substr(0, i);
        var tail:String = s.substr(i+1, s.length - i - 1);
        return head + b + tail;
    }
    
    static function str_insert(s:String, i:Number, a:String):String {
        // ex) 0123*456
        var head:String = s.substr(0, i);
        var tail:String = s.substr(i, s.length - i);
        var res:String  = head + a + tail;
        return res;
    }
    
    static function str_delete(s:String, i:Number, cnt:Number):String {
        // ex) 012*34*56 : 3,2
        var head:String = s.substr(0, i);
        var li:Number   = i + cnt;
        var tail:String = s.substr(li, s.length - li);
        return (head + tail);
    }
    
    static function str_left(s:String, cnt:Number):String {
        return s.substr(0, cnt);
    }
    
    static function str_right(s:String, cnt:Number):String {
        // ex) 0123*456 len=7 n=3
        return ( s.substr(s.length - cnt, cnt) );
    }
    
    /**
     * 文字列オブジェクト {str} の区切り文字までの文字列を切り取って返す
     * @param   ss          {str:xxx}
     * @param   splitter    splitter string
     * ---
     * var ss:Object  = {str:"abc*efg"};
     * var res:String = str_getToken(ss, "*");
     * trace( "source=" + ss.str ); // efg
     * trace( "result=" + res );    // abc
     */
    static function str_getToken(ss:Object, splitter:String):String {
        // ex) 012*4567 *
        var s:String   = ss.str;
        var res:String;
        var i:Number = s.indexOf(splitter);
        if (i >= 0) {
            res = s.substr(0, i);
            var n:Number = i + splitter.length;
            s = s.substr(n, s.length - n);
        } else {
            res = s;
            s = "";
        }
        // set result
        ss.str = s;
        return res;
    }
    /**
     * 文字列オブジェクト {str} の数値部分を切り取って返す
     * @param   ss          {str:xxx}
     */
    static function str_getNumber(ss:Object):Number {
        var s:String   = ss.str;
        var res:String = "";
        var i:Number   = 0;
        var flg:Number = 1;
        // flag
        if (s.charAt(i) == "-") {
            i++; flg = -1;
        } else if (s.charAt(i) == "+") {
            i++;
        }
        while (1) {
            var c:String = s.charAt(i);
            if ('0' <= c && c <= '9') {
                res += c;
                i++;
            }
            else break;
        }
        if (s.charAt(i) == ".") {
            res += ".";
            i++;
            while (1) {
                var c:String = s.charAt(i);
                if ('0' <= c && c <= '9') {
                    res += c;
                    i++;
                }
                else break;
            }
        }
        // set result
        ss.str = s.substr(i);
        return Number(res) * flg;
    }
    
    static function str_trim(s:String):String {
        s = str_trimHead(s);
        s = str_trimTail(s);
        return s;
    }
    static function str_trimHead(s:String):String {
        var index:Number = 0;
        for (var i = 0; i < s.length; i++) {
            var c = s.charAt(i);
            if (c == " " || c == "\t" || c == "\n" || c == "\r") {
                index = i + 1;
                continue;
            }
            break;
        }
        if (index > 0) {
            return s.substr(index, s.length - index);
        }
        return s;
    }
    static function str_trimTail(s:String):String {
        var index:Number = -1;
        for (var i = 0; i < s.length; i++) {
            var j = s.length - i - 1;
            var c = s.charAt(j);
            if (c == " " || c == "\t" || c == "\n" || c == "\r") {
                index = i;
                continue;
            }
            break;
        }
        if (index >= 0) {
            return s.substr(0, s.length - index - 1);
        }
        return s;
    }
    static function formatYen(n:Number):String {
        var s:String = String(n);
        var r:String = "";
        for (var i = 0; i < s.length; i++) {
            var j = s.length - i - 1;
            var c = s.charAt(j);
            if (i % 3 == 2) {
                c = "," + c;
            }
            r = c + r;
        }
        return r;
    }
    static function formatZero(n:Number, keta:Number):String {
        var s:String = String(n);
        var i = 0;
        while (s.length < keta) {
            s = "0" + s;
        }
        return s;
    }
    
    static function date_add(base:String, ymd:String):String {
        var flag = 1;
        var base_ary:Array  = base.split("-");
        var base_y:Number   = parseInt(base_ary[0]);
        var base_m:Number   = parseInt(base_ary[1]) - 1;
        var base_d:Number   = parseInt(base_ary[2]);
        if (ymd.charAt(0) == "-") {
            ymd = ymd.substr(1, ymd.length-1);
            flag = -1;
        }
        var inc_ary:Array   = ymd.split("-");
        var inc_y:Number    = parseInt(inc_ary[0]);
        var inc_m:Number    = parseInt(inc_ary[1]);
        var inc_d:Number    = parseInt(inc_ary[2]);
        //
        var base_date:Date = new Date();
        if (flag > 0) {
            base_date.setFullYear(base_y + inc_y, base_m + inc_m, base_d + inc_d);
        } else {
            base_date.setFullYear(base_y - inc_y, base_m - inc_m, base_d - inc_d);
        }
        if (isNaN(base_date.getTime())){
            return "";
        }
        var res_y = formatZero(base_date.getFullYear(), 4);
        var res_m = formatZero(base_date.getMonth()+1, 2);
        var res_d = formatZero(base_date.getDate(), 2);
        var res = res_y + "-" + res_m + "-" + res_d;
        return res;
    }
    
    static function time_add(base:String, hns:String):String {
        var flag = 1;
        var base_ary:Array  = base.split(":");
        var base_h:Number   = parseInt(base_ary[0]);
        var base_n:Number   = parseInt(base_ary[1]);
        var base_s:Number   = parseInt(base_ary[2]);
        if (hns.charAt(0) == "-") {
            hns = hns.substr(1, hns.length-1);
            flag = -1;
        }
        var inc_ary:Array   = hns.split(":");
        var inc_h:Number    = parseInt(inc_ary[0]);
        var inc_n:Number    = parseInt(inc_ary[1]);
        var inc_s:Number    = parseInt(inc_ary[2]);
        //
        var base_time:Number = base_h * 60 * 60 + base_n * 60 + base_s;
        var inc_time:Number  = inc_h * 60 * 60 + inc_n * 60 + inc_s;
        if (flag > 0) {
            base_time += inc_time;
            base_time = base_time % (24 * 60 * 60);
        } else {
            base_time -= inc_time;
            if (base_time < 0) {
                base_time += 24 * 60 * 60;
            }
        }
        if (isNaN(base_time)){
            return "";
        }
        var m = Math.floor( base_time / 60 );
        var res_h = formatZero( Math.floor(m / 60), 2);
        var res_n = formatZero( m % 60, 2);
        var res_s = formatZero(base_time % 60, 2);
        var res = res_h + ":" + res_n + ":" + res_s;
        return res;
    }
    
    static function date_diff(s1:String, s2:String):Number {
        var a1:Array = s1.split("-");
        var a2:Array = s2.split("-");
        
        var d1:Date = new Date(a1[0], (a1[1]-1), a1[2]);
        var d2:Date = new Date(a2[0], (a2[1]-1), a2[2]);
        
        var sa = d1.getTime() - d2.getTime();
        sa = Math.floor( sa / (1000 * 24 * 60 * 60) );
        return sa;
    }
    
    static function time_diff(s1:String, s2:String):Number {
        var a1:Array = s1.split(":");
        var a2:Array = s2.split(":");
        
        var t1:Number = parseInt(a1[0]) * 60 * 60 + parseInt(a1[1]) * 60 + parseInt(a1[2]);
        var t2:Number = parseInt(a2[0]) * 60 * 60 + parseInt(a2[1]) * 60 + parseInt(a2[2]);
        
        var sa = t1 - t2;
        return sa;
    }
    
    static function array_reverse(a_ary:Array):Void {
        for (var i = 0; i < a_ary.length; i++) {
            var j = a_ary.length - i - 1;
            if (i > j) { break; }
            var tmp = a_ary[i];
            a_ary[i] = a_ary[j];
            a_ary[j] = tmp;
        }
    }
    
    static function array_random(a_ary:Array):Void {
        for (var i = 0; i < a_ary.length; i++) {
            var j = Math.floor(Math.random() * a_ary.length);
            var tmp = a_ary[i];
            a_ary[i] = a_ary[j];
            a_ary[j] = tmp;
        }
    }
    
    static function getHostFromUrl(url:String):String {
        var obj_url:Object  = {str:url};
        var protocol:String = str_getToken(obj_url, "://");
        var host:String     = str_getToken(obj_url, "/");
        return protocol + "://" + host + "/";
    }
    
    static function getProtocolFromUrl(url:String):String {
        var obj_url:Object  = {str:url};
        var protocol:String = str_getToken(obj_url, "://");
        return protocol;
    }
    
    static function is_local():Boolean {
        var s:String = _root._url;
        if (s.substr(0, 7) == "file://") {
            return true;
        }
        return false;
    }
    
    static function getDomain(url:String):String {
        var a:Array = url.split("/"); // http: / / xxx.com /
        return a[0] + "//" + a[3];
    }
    
    static function getAbsolutePathFromRoot(url:String):String {
        var root:String = _root._url;
        if (is_local(root)) {
            return url;
        }
        root = getUpDir(root); // get path
        return getAbsolutePath(root, url);
    }
    
    static function getAbsolutePath(base:String, url:String):String {
        // Is Absolute Path ?
        if (url.indexOf("://") > 0) {
            return url;
        }
        // From Root ?
        if (url.substr(0,1) == "/") {
            var root:String = getHostFromUrl(base);
            root = addLastPathFlag(root);
            root = root.substr(0, root.length - 1); // delete last "/"
            return root + url;
        }
        //
        var path_ary:Array = url.split("/");
        var path:String = addLastPathFlag(base);
        path = path.substr(0, path.length - 1);
        for (var i = 0; i < path_ary.length; i++) {
            var s:String = path_ary[i];
            if (s == "..") {
                path = getUpDir(path);
            } else {
                path += "/" + s;
            }
        }
        return path;
    }
    
    static function getUpDir(url:String) {
        var obj_url:Object  = {str:url};
        var protocol:String = str_getToken(obj_url, "://");
        var uri:String = str_getToken(obj_url, "?");;
        if (uri.substr(uri.length - 1, 1) == "/") {
            uri = uri.substr(0, uri.length-2);
        }
        var a:Array = uri.split("/");
        a = a.slice(0, a.length-1);
        return addLastPathFlag(protocol + "://" + a.join("/"));
    }
    
    static function addLastPathFlag(url:String) {
        if (url.substr(url.length-1, 1) != "/") {
            url += "/";
        }
        return url;
    }
    
    static function getModulePath(swfname:String) {
        // library_path is global
        // get module path ( swf same dir )
        if (!KUtils.is_local(_root._url)) {
            var s:String = _root._url;
            s = KUtils.getUpDir(s);
            return (s + swfname);
        } else {
            var lib:String = KUtils.getInstance().library_path;
            // check library_path
            if (lib) {
                lib = addLastPathFlag(lib);
                var libstr:String = getAbsolutePath(lib, swfname);
                return libstr;
            }
        }
        return swfname;
    }
    
    static var UCODE_A = 65313; static var ASCII_A = 65;
    static var UCODE_Z = 65338; static var ASCII_Z = 90;
    static var UCODE_a = 65345; static var ASCII_a = 97;
    static var UCODE_z = 65370; static var ASCII_z = 122;
    
    static function str_convMByte2SByte(str:String):String {
        var res:String = "";
        for (var i = 0; i < str.length; i++) {
            // convert
            var n:Number = str.charCodeAt(i);
            if (UCODE_A <= n && n <= UCODE_Z) {
                n = n - UCODE_A + ASCII_A;
            }
            else if (UCODE_a <= n && n <= UCODE_z) {
                n = n - UCODE_a + ASCII_a;
            }
            res += String.fromCharCode(n);
        }
        
        return res;
    }
    
    /*
    static function main() {
        //KLog.write(""+ str_convMByte2SByte("AＡZＺaａzｚ"));
        var ss = {str:"+123,456,789"};
        KLog.write("@n="+str_getNumber(ss));
        KLog.write("@s="+ss.str);
    }
    */
}

