class FunctionArg
{
    var _mac:Stackmachine;
    var _args:Array;
    var _result:Object;
    
    function FunctionArg(mac:Stackmachine) {
        _mac = mac;
        _args = undefined;
        _result = undefined;
    }
    
    function getArgStr(no:Number):String {
        return String(AValue.convString(_args[no]));
    }
    
    function getArgNum(no:Number):Number {
        return Number(AValue.convNumber(_args[no]));
    }
    
    function getArgArray(no:Number):Array {
        return Array( AValue.convArray(_args[no]) );
    }
    
    function return_str(s:String):Void {
        this._result = s;
    }
    
    function return_num(n:Number):Void {
        this._result = n;
    }
    /* wait */
    function set flag_quit(b:Boolean):Void {
        _mac.flag_quit = b;
    }
    function get flag_quit():Boolean {
        return _mac.flag_quit;
    }
    /* swap_stacktop */
    function swap_stacktop(v:AValue):Void {
        Stackmachine.swap_stacktop(_mac, v);
    }
}
