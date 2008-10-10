/**
 * ActionScript Module の基礎クラス
 */
class ModuleBase
{
    //------------------------------------------------------------------
    // モジュール化のためのコード
    //------------------------------------------------------------------
    public var ModuleName:String = "ModuleBase";
    public var ftable:Array; // 関数テーブル
    public var self_mc:MovieClip;
    
    public function ModuleBase() {}
    
    public function module_init(module_name):Void {
        // table
        ftable = new Array();
        ModuleName = module_name;
        
        // 自身のパスを得る
        self_mc = _root[ModuleName];
        if (self_mc == undefined) {
            // 初期設定で取り込まれている場合
            _root.createEmptyMovieClip(ModuleName, _root.getNextHighestDepth());
            self_mc = _root[ModuleName];
        }
        // 関数の登録
        var self = this;
        self_mc.getFunctionList = function () {
            return self.ftable;
        };
    }
}

