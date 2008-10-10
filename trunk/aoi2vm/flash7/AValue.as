
class AValue
{
    static var typeUnknown  = 0;
    static var typeInt      = 1;
    static var typeNum      = 2;
    static var typeStr      = 3;
    static var typeArray    = 4;
    static var typeHash     = 5;
    static var typeFunc     = 6;
    static var typeLink     = 7;
    
    var type:Number;
    var _value:Object;
    
    function AValue() {
        type = AValue.typeUnknown;
    }
    
    static function isIntOrNum(o:Object):Boolean {
        var atype = getType(o);
        return (atype == AValue.typeNum || atype == AValue.typeInt);
    }
    
    static function getType(o:Object):Number {
        // typeof
        var stype:String = typeof(o);
        switch (stype) {
            case "number":      return typeNum;
            case "string":      return typeStr;
            case "function":    return typeFunc;
            case "object":
                if (o instanceof Array)     return typeArray;
                if (o instanceof Number)    return typeNum;
                if (o instanceof String)    return typeStr;
                if (o instanceof AValueLink)return typeLink;
                return typeHash;
        }
        return typeUnknown;
    }
    
    
    static function getTypeStr(o:Object):String {
        switch (getType(o)) {
            case AValue.typeArray:  return "array";
            case AValue.typeFunc:   return "func";
            case AValue.typeNum:    return "num";
            case AValue.typeStr:    return "str";
            case AValue.typeHash:   return "hash";
            case AValue.typeInt:    return "int";
            case AValue.typeLink:   return "link";
            case AValue.typeUnknown:return "unknown";
            default:                return "unknown";
        }
    }
    
    static function getHashKey(o:Object):Array {
        var keys:Array = new Array();
        for (var key in o) {
            keys.push(key);
        }
        return keys;
    }
    
    static function cloneObject(o:Object):Object {
        o = AValue.getLink(o);
        switch (getType(o)) {
            case typeNum:   return new Number(o);
            case typeStr:   return new String(String(o));
            case typeFunc:  return o;
            case typeArray:
                var ary:Array = new Array();
                var src:Array = Array(o);
                for (var i = 0; i < src.length; i++) {
                    ary[i] = AValue.cloneObject(src[i]);
                }
                return ary;
            case typeHash:
                var hash:Object = new Object();
                for (var key in o) {
                    hash[key] = AValue.cloneObject(o[key]);
                }
                return hash;
            default:
                return new Object();
        }
    }
    
    static function convNumber(o:Object):Number {
        switch (getType(o)) {
            case typeNum:       return Number(o);
            case typeStr:
                var n:Number = parseFloat(String(o));
                if (isNaN(n)) n = 0;
                return n;
            case typeArray:     return Array(o).length;
            case typeHash:      return 0;
            case typeLink:
                o = AValueLink(o).getLink();
                return convNumber(o);
            default:
                return 0;
        }
    }
    
    static function EscapeNumOrStr(o:Object):String {
        o = AValue.getLink(o);
        var t:Number = getType(o);
        switch (t) {
            case typeInt:   return "" + o;
            case typeNum:   return "" + o;
            case typeStr:
                var s:String = String(o);
                s = KUtils.str_replaceAll(s, "\\", "\\\\");
                s = KUtils.str_replaceAll(s, "\r", "\\r");
                s = KUtils.str_replaceAll(s, "\n", "\\n");
                s = KUtils.str_replaceAll(s, "\t", "\\t");
                return '"' + s + '"';
            default:
                return convString(o);
        }
    }
    
    static function convString(o:Object):String {
        switch (getType(o)) {
            case typeNum:   return String(o);
            case typeStr:   return String(o);
            case typeArray:
                var ary:Array = Array(o);
                var a_str:String = "[";
                for (var i = 0; i < ary.length; i++) {
                    var a_str_line:String = EscapeNumOrStr(ary[i]);
                    a_str += a_str_line + ",";
                }
                if (ary.length > 0) {
                    a_str = a_str.substr(0, a_str.length - 1);
                }
                a_str += "]";
                return a_str;
            case typeHash:
                var b_str:String = "{";
                for (var key in o) {
                    var b_str_line:String = EscapeNumOrStr(o[key]);
                    b_str += key + ":" + b_str_line + ",";
                }
                if (b_str.length > 1) {
                    b_str = b_str.substr(0, b_str.length - 1);
                }
                b_str += "}";
                return b_str;
            case typeLink:
                o = AValueLink(o).getLink();
                return convString(o);
            default:
                return "";
        }
    }
    
    /**
     * 配列に変換する。その時、oがリンクならoのリンク先を変更する
     */
    static function convArrayWrite(o:Object):Array {
        // oがArrayか?
        var o_link:Object = AValue.getLink(o);
        if (o_link instanceof Array) {
            return Array(o_link);
        }
        
        // o の値を差し替え
        var ary:Array = convArray(o_link);
        changeLinkValue(o, ary);
        return ary;
    }
    
    static function convArray(o:Object):Array {
        switch (getType(o)) {
            case typeNum:   return new Array(o);
            case typeStr:
                // string to array
                var a_str:String = String(o);
                if (a_str.substr(0,1) == "[") {
                    try {
                        o = JSON.parse(a_str);
                    } catch (e) {
                        o = new Array(a_str);
                    }
                }
                return Array(o);
            case typeArray:
                return Array(o);
            case typeHash:
                return new Array(o);
            case typeLink:
                o = AValueLink(o).getLink();
                return convArray(o);
            default:
                return new Array();
        }
    }
    /**
     * 再帰的に配列をチェックする
     */
    static function convArrayEx(o:Object):Array {
        var oa:Array = convArray(o);
        for (var i = 0; i < oa.length; i++) {
            var n:Number = getType(oa[i]);
            if (n == typeLink) {
                oa[i] = AValueLink(oa[i]).getLink();
                n = getType(oa[i]);
            }
            if (n == typeArray) {
                oa[i] = convArrayEx(oa[i]);
            }
        }
        return oa;
    }
    
    static function convHash(o:Object):Object {
        switch (getType(o)) {
            case typeNum:   return new Object();
            case typeStr:
                //todo: string to hash
                return new Object();
            case typeArray:
                return new Object();
            case typeHash:
                return o;
            case typeLink:
                o = AValueLink(o).getLink();
                return convHash(o);
            default:
                return new Object();
        }
    }
    
    function setValueType(v, new_type:Number) {
        type = new_type;
        switch (new_type) {
            case AValue.typeInt:
            case AValue.typeNum:
                _value = Number(v);
                break;
            case AValue.typeStr:
                _value = String(v);
                break;
            default:
                _value = v;
                break;
        }
    }
    
    static function getLink(v:Object):Object {
        var o:Object = v;
        while (o instanceof AValueLink) {
            o = AValueLink(o).getLink();
        }
        return o;
    }
    
    static function changeLinkValue(link:Object, new_obj:Object):Void {
        if (link instanceof AValueLink) {
            AValueLink(link).changeLinkValue(new_obj);
        } else {
            // not link
            link = new_obj;
        }
    }
    
    static function traceLink(link:Object) {
        var o:Object = link;
        var s:String = "";
        for (;;) {
            if (o instanceof AValueLink) {
                o = AValueLink(o).getLink();
                s += "link->";
            } else {
                s += AValue.convString(o) + ":" + AValue.getTypeStr(o);
                break;
            }
        }
        return s;
    }
    
    static function create(v:Object):Object {
        if (typeof(v) == "number") {
            return new Number(v);
        } else
        if (typeof(v) == "string") {
            return Object(new String(String(v)));
        }
        return Object(v);
    }
}

