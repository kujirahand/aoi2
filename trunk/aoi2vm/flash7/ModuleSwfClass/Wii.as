/**
 * Key code for Wii
 */

class ModuleSwfClass.Wii {

    static var status:Array;
    static var _instance:Wii;
    static var lastCode:Number;
    
    static var BTN_UP:Number    = 175;
    static var BTN_DOWN:Number  = 176;
    static var BTN_LEFT:Number  = 177;
    static var BTN_RIGHT:Number = 178;
    static var BTN_A:Number     = 13;
    static var BTN_B:Number     = 171;
    static var BTN_PLUS:Number  = 174;
    static var BTN_MINUS:Number = 170;
    
    static function init() {
        if (!_instance) {
            _instance = new Wii();
        }
        lastCode = 0;
        status = new Array();
        for (var i = 0; i < 255; i++) {
            status[i] = false;
        }
        Key.addListener(_instance);
    }
    
    static function isDown(code:Number):Boolean {
        return status[code];
    }
    
    function onKeyDown() {
        var code:Number = Key.getCode();
        lastCode = code;
        status[code] = true;
    }
    
    function onKeyUp() {
        var code:Number = Key.getCode();
        status[code] = false;
    }
}
