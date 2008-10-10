/**
 * AValueLink
 */

class AValueLink
{
    public var _link:Object;
    
    public function AValueLink(o:Object) {
        _link = o;
    }
    
    public function getLink():Object
    {
        var p:Object = this;
        for (;;) {
            if (p instanceof AValueLink) {
                p = AValueLink(p)._link;
            } else {
                return p;
            }
        }
    }
    
    public function setLink(o:Object):Void {
        _link = o;
    }
    
    public function getLinkRaw():Object {
        return _link;
    }
    
    /**
     * リンク先のオブジェクトを差し替える
     */
    public function changeLinkValue(new_obj:Object):Void {
        var parent_p:Object = null;
        var p:Object = this;
        for (;;) {
            if (p instanceof AValueLink) {
                parent_p = p;
                p = AValueLink(p)._link;
            } else {
                if (parent_p != null) {
                    parent_p._link = new_obj;
                }
                break;
            }
        }
    }
}

