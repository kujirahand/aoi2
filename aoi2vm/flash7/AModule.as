/**
 * Module
 */
class AModule
{
    var name:String;
    var mc:MovieClip;
    var func_ary:Array;
    
    function AModule(name:String) {
        this.name = name;
        if (_root[name] == undefined) {
            _root.createEmptyMovieClip(name, _root.getNextHighestDepth());
        }
        this.mc = _root[name];
        mc.module = this;
    }
    function getFunctionList():Array {
        if (!mc.getFunctionList) {
            throw new Error("No getFunctionList");
        }
        func_ary = mc.getFunctionList();
        return func_ary;
    }
}
