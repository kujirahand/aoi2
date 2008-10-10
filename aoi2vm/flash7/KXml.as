/*
 * ---------------------------------------------------------------------
 * KXml
 * ---------------------------------------------------------------------
 */

class KXml
{
    var _xml:XML;
    var onLoad:Function;
    
    function KXml(init_xml:XML)
    {
        if (init_xml == undefined) {
            _xml = new XML();
        } else {
            _xml = init_xml;
        }
    }
    
    function get childNodes():Array
    {
        return _xml.childNodes;
    }
    
    function get nodeName():String
    {
        return _xml.nodeName;
    }
    
    private function sub_getPath(target:KXml, path_ary:Array, idx:Number, res:Array):Void
    {
        // Check target
        if (target == undefined) return;
        
        // Check index
        if (path_ary.length <= idx) {
            res.push(target);
            return;
        }
        
        // Path
        var path:String = path_ary[idx];
        var r:Array = target.findChildNodes(path);
        
        for (var i = 0; i < r.length; i++) {
            var x:KXml = r[i];
            sub_getPath(x, path_ary, (idx+1), res);
        }
    }
    
    function dumpArray(r:Array):String
    {
        var s:String = "";
        for (var i = 0; i < r.length; i++) {
            s = s + r[i] + "\n";
        }
        return s;
    }
    
    /**
     * �w��̊K�w�ɂ���XMLNode�𓾂�
     * ����)
     * onLoad����̂Ƃ������́A�e����w�肷�邪�A
     *  getPath�������̂́A�q����w�肷��
     */
    function getPath(path:String):Array
    {
        var path_ary:Array = path.split("/");
        var res:Array = new Array();
        sub_getPath(this, path_ary, 0, res);
        return res;
    }
    
    function getPathAsString(path:String):String
    {
        var a:Array = getPath(path);
        var r:String = "";
        for (var i = 0; i < a.length; i++) {
            var x:KXml = a[i];
            r = r + x.toString() + "\n";
        }
        return r;
    }
    
    /**
     * �w��̊K�w�ɂ���XMLNode�̈�ԏ�ɂ���l�𓾂�
     */
    
    function getPathTopValue(path:String):String
    {
        var a:Array = getPath(path);
        if (a.length == 0) return "";
        var x:KXml = a[0];
        return x.textValue;
    }
    
    /**
     * �w��̃^�O������T���Ĕz��Ƃ��ĕԂ�
     * @param   name    �^�O��
     * @return          ���������^�O�ւ̃m�[�h(Array of KXml)
     */
    function findChildNodes(name:String):Array
    {
        var res:Array = new Array();
        for (var i = 0; i < _xml.childNodes.length; i++)
        {
            var x:XML;
            x = _xml.childNodes[i];
            if (x.nodeName == name) {
                res.push( new KXml(x) );
            }
        }
        return res;
    }
    
    function toString()
    {
        return _xml.toString();
    }
    
    /**
     * �^�O�������������l��Ԃ�
     */
    function get textValue():String
    {
        return getValueAsText();
    }
    
    function getValueAsText():String
    {
        var s:String = _xml.toString();
        var i:Number = s.indexOf(">");
        if (i < 0) { return s; } // tag not found
        s = s.substr(i + 1);
        i = s.indexOf("<");
        s = s.substr(0, i);
        var ks:KString = new KString(s);
        ks.replaceSelf("&lt;","<");
        ks.replaceSelf("&gt;",">");
        ks.replaceSelf("&quot;","\"");
        ks.replaceSelf("&apos;","'");
        return ks._str;
    }
    
    function load(url:String):Boolean
    {
        _xml.onLoad = this.onLoad;
        _xml.ignoreWhite = true;
        return _xml.load(url);
    }
    
    /**
     * �m�[�h���n�b�V���ɂ��ĕԂ�
     * [name][index][name][index]...�̌`��
     */
    function _convertToHash(cn:Array):Object
    {
        if (cn == undefined) return undefined;
        
        var obj:Object = new Object();
        for (var i = 0; i < cn.length; i++) {
            var x:XMLNode = cn[i];
            var name:String  = x.nodeName;
            // �q������΍ċA�I�Ƀn�b�V���ɕϊ�����
            if (x.hasChildNodes() && x.firstChild.nodeType != 3/*TextNode*/) {
                var value:Object = _convertToHash(x.childNodes);
                if (obj[name] == undefined) {
                    obj[name] = new Array();
                }
                obj[name].push(value);
                continue;
            }
            var value:String = x.firstChild.nodeValue;
            
            // �n�b�V���ւ̑��
            if (obj[name] == undefined) {
                obj[name] = new Array();
            }
            obj[name].push(value);
        }
        return obj;
    }
    
    function convertToHash():Object
    {
        return _convertToHash(this.childNodes);
    }
}
