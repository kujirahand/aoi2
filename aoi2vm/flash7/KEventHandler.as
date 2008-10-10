
class KEventHandler {
    
    private var target:MovieClip;
    private var item:Array;
    private var handler:Object;
    
    static function getHandler(mc:MovieClip):KEventHandler {
        return mc["event_handler"];
    };
    
    function KEventHandler(target:MovieClip) {
        this.target = target;
        target.event_handler = this; // ***
        item = new Array();
        handler = new Object;
    }
    
    function addListener(obj:Object):Void {
        var self:KEventHandler = this;
        for (var key in obj) {
            if (!handler[key]) {
                handler[key] = new Array();
            }
            handler[key].push(obj);
            if (!target[key]) {
                target[key] = _createEvent(handler[key], key);
            }
        }
    }
    
    private function _createEvent(e_ary:Array, name:String) {
        return function () {
            for (var i = 0; i < e_ary.length; i++) {
                e_ary[i][name]();
            }
        };
    }
    
}



