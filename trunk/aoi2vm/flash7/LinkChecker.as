
class LinkChecker
{
    private var _parent:MovieClip;
    private var _checkname:String;
    
    public function setParent(p:MovieClip)
    {
        _parent = p;
    }
    
    public function LinkChecker(parent:MovieClip, checkname:String)
    {
        _parent =parent;
        _checkname = checkname;
    }
    
    public function check(name:String)
    {
        if (_parent == undefined) {
            KLog.write("[ERROR] check() not set parent [ " + _checkname + "]");
            return;
        }
        if (_parent[name] == undefined) {
            KLog.write("[LINK.ERROR]"+_parent._name+"."+name);
        }
    }
}

