/*
 * ModuleFunctionApi
 */

class ModuleFunctionApi
{
    var aoisystem;
    
    function ModuleFunctionApi() {
        aoisystem = _root.aoisystem;
    }
    
    function _addEvent(ename:String) {
        aoisystem.event_stack.push(ename);
    }
    
    static var _instance:ModuleFunctionApi = undefined;
    static function getInstance():ModuleFunctionApi {
        if (_instance == undefined) {
            _instance = new ModuleFunctionApi();
        }
        return _instance;
    }
    
    static function addEvent(ename:String) {
        var i:ModuleFunctionApi = ModuleFunctionApi.getInstance();
        ename = KUtils.str_convMByte2SByte(ename);
        i._addEvent(ename);
    }
}


