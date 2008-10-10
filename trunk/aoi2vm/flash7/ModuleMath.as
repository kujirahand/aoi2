//--------------------------------------------------------------------
// 勝手ライブラリ作成例
//--------------------------------------------------------------------

class ModuleMath {
    // エントリポイント
    static function main() {
        // 自身のパスを得る
        var mc:MovieClip = _root.aoimodule["ModuleMath"];
        // 関数の登録
        mc.aoimodule_call = function (func_no, arg:ModuleFunctionArg) {
            switch (func_no) {
                case 0: ModuleMath.func_add(arg); break;
                case 1: ModuleMath.func_sub(arg); break;
                case 2: ModuleMath.func_power(arg); break;
            }
        };
    }
    // 静的なメソッドを定義
    static function func_add(arg:ModuleFunctionArg) {
        arg.return_num( arg.getArgNum(0) + arg.getArgNum(1) );
    }
    static function func_sub(arg:ModuleFunctionArg) {
        arg.return_num( arg.getArgNum(0) - arg.getArgNum(1) );
    }
    static function func_power(arg:ModuleFunctionArg) {
        arg.return_num( arg.getArgNum(0) * arg.getArgNum(1) );
    }
}
