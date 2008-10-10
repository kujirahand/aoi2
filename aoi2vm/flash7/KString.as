class KString
{
    var _str:String;
    
    function KString(s:String)
    {
        _str = s;
    }
    // splitter �܂ł̕������؂�o���B
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
    // findStr �� replaceStr �ɒu������i���g���j��j
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
    // findStr �� replaceStr �ɒu������i���g��j��I�ɒu���j
    function replaceSelf(findStr:String, replaceStr:String):Void
    {
        _str = this.replace(findStr, replaceStr);
    }
    // �ÓI�Ɏg����ėp�֐�
    static function replaceAll(s:String, findStr:String, replaceStr:String):String
    {
        var k:KString = new KString(s);
        return k.replace(findStr, replaceStr);
    }
}

