//--------------------------------------------------------------------
// ���胉�C�u�����쐬��
//--------------------------------------------------------------------

class ModuleMath {
    // �G���g���|�C���g
    static function main() {
        // ���g�̃p�X�𓾂�
        var mc:MovieClip = _root.aoimodule["ModuleMath"];
        // �֐��̓o�^
        mc.aoimodule_call = function (func_no, arg:ModuleFunctionArg) {
            switch (func_no) {
                case 0: ModuleMath.func_add(arg); break;
                case 1: ModuleMath.func_sub(arg); break;
                case 2: ModuleMath.func_power(arg); break;
            }
        };
    }
    // �ÓI�ȃ��\�b�h���`
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
