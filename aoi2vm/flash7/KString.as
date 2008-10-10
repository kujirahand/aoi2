class KString
{
    var _str:String;
    
    function KString(s:String)
    {
        _str = s;
    }
    // splitter までの文字列を切り出す。
    function getToken(splitter:String):String
    {
        var i:Number;
        var ret:String;
        var len:Number;
        
        i   = _str.indexOf(splitter, 0);
        len = splitter.length;
        
        if (i == 0) {
            ret = _str;
            _str = "";
            return ret;
        } else {
            // 0123456
            // abcdefg
            // indexOf("de")=> 3 len = 2
            ret  = _str.substr(0, i);
            _str = _str.substr(i + len);
            return ret;
        }
    }
    // findStr を replaceStr に置換する（自身を非破壊）
    function replace(findStr:String, replaceStr:String):String
    {
        var i:Number;
        var len:Number;
        var ret:String;
        var tmp:String;
        len = findStr.length;
        ret = _str;
        for (;;) {
            i   = ret.indexOf(findStr);
            if (i >= 0) {
                tmp = ret.substr(0, i);
                tmp = tmp + replaceStr + ret.substr(i + len);
                ret = tmp;
            } else {
                break;
            }
        }
        return ret;
    }
    // findStr を replaceStr に置換する（自身を破壊的に置換）
    function replaceSelf(findStr:String, replaceStr:String):Void
    {
        _str = this.replace(findStr, replaceStr);
    }
    // 静的に使える汎用関数
    static function replaceAll(s:String, findStr:String, replaceStr:String):String
    {
        var k:KString = new KString(s);
        return k.replace(findStr, replaceStr);
    }
}

