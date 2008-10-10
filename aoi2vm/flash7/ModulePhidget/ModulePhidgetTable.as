// Created by module2txt.nako --- "ModulePhidget.aoi2"
class ModulePhidgetTable
{
    function ModulePhidgetTable() {} // constructor  for [Flash IDE]
    //--- function table
    static function initTable(ftable:Array) {
        // *�t�B�W�F�b�gIP�ݒ�(IP��)
        ftable[1] = {func:ModulePhidgetFunc.phidget_setIP, arg:1};
        // *�t�B�W�F�b�gPORT�ݒ�(PORT��)
        ftable[2] = {func:ModulePhidgetFunc.phidget_setPort, arg:1};
        // *�t�B�W�F�b�g�V���A���ԍ��ݒ�(NO��)
        ftable[3] = {func:ModulePhidgetFunc.phidget_setSN, arg:1};
        // *�t�B�W�F�b�g�p�X���[�h�ݒ�(PW��)
        ftable[4] = {func:ModulePhidgetFunc.phidget_setPassword, arg:1};
        // *�t�B�W�F�b�g�Z���T�[�C�x���g�ݒ�(EVENT��|EVENT��)
        ftable[5] = {func:ModulePhidgetFunc.phidget_onSensor, arg:1};
        // *�t�B�W�F�b�g���̓C�x���g�ݒ�(EVENT��|EVENT��)
        ftable[6] = {func:ModulePhidgetFunc.phidget_onInput, arg:1};
        // *�t�B�W�F�b�g�ڑ��C�x���g�ݒ�(EVENT��|EVENT��)
        ftable[7] = {func:ModulePhidgetFunc.phidget_onAttach, arg:1};
        // *�t�B�W�F�b�g�ؒf�C�x���g�ݒ�(EVENT��|EVENT��)
        ftable[8] = {func:ModulePhidgetFunc.phidget_onDetach, arg:1};
        // *�t�B�W�F�b�g�G���[�ݒ�(EVENT��|EVENT��)
        ftable[9] = {func:ModulePhidgetFunc.phidget_onError, arg:1};
        // *�t�B�W�F�b�g�ڑ�()
        ftable[20] = {func:ModulePhidgetFunc.phidget_open, arg:0};
        // *�t�B�W�F�b�g�ؒf()
        ftable[21] = {func:ModulePhidgetFunc.phidget_close, arg:0};
        // *�t�B�W�F�b�g�ԍ��擾()
        ftable[30] = {func:ModulePhidgetFunc.phidget_getNo, arg:0};
        // *�t�B�W�F�b�g�l�擾()
        ftable[31] = {func:ModulePhidgetFunc.phidget_getValue, arg:0};
        // *�t�B�W�F�b�g�G���[�擾()
        ftable[32] = {func:ModulePhidgetFunc.phidget_getError, arg:0};

    }
}
/*
    // *�t�B�W�F�b�gIP�ݒ�(IP��)="ModulePhidget"@1 // 1
    // Phidget IP���w�肷��
    static function phidget_setIP(arg:ModuleFunctionArg)
    {
    }
    // *�t�B�W�F�b�gPORT�ݒ�(PORT��)="ModulePhidget"@2 // 1
    // Phidget PORT���w�肷��
    static function phidget_setPort(arg:ModuleFunctionArg)
    {
    }
    // *�t�B�W�F�b�g�V���A���ԍ��ݒ�(NO��)="ModulePhidget"@3 // 1
    // Phidget SerialNumber���w�肷��
    static function phidget_setSN(arg:ModuleFunctionArg)
    {
    }
    // *�t�B�W�F�b�g�p�X���[�h�ݒ�(PW��)="ModulePhidget"@4 // 1
    // Phidget Password���w�肷��
    static function phidget_setPassword(arg:ModuleFunctionArg)
    {
    }
    // *�t�B�W�F�b�g�Z���T�[�C�x���g�ݒ�(EVENT��|EVENT��)="ModulePhidget"@5 // 1
    // Phidget �Z���T�[�C�x���g��ݒ肷��
    static function phidget_onSensor(arg:ModuleFunctionArg)
    {
    }
    // *�t�B�W�F�b�g���̓C�x���g�ݒ�(EVENT��|EVENT��)="ModulePhidget"@6 // 1
    // Phidget ���̓C�x���g��ݒ肷��
    static function phidget_onInput(arg:ModuleFunctionArg)
    {
    }
    // *�t�B�W�F�b�g�ڑ��C�x���g�ݒ�(EVENT��|EVENT��)="ModulePhidget"@7 // 1
    // Phidget �ڑ��C�x���g��ݒ肷��
    static function phidget_onAttach(arg:ModuleFunctionArg)
    {
    }
    // *�t�B�W�F�b�g�ؒf�C�x���g�ݒ�(EVENT��|EVENT��)="ModulePhidget"@8 // 1
    // Phidget �ڑ��C�x���g��ݒ肷��
    static function phidget_onDetach(arg:ModuleFunctionArg)
    {
    }
    // *�t�B�W�F�b�g�G���[�ݒ�(EVENT��|EVENT��)="ModulePhidget"@9 // 1
    // Phidget Password���w�肷��
    static function phidget_onError(arg:ModuleFunctionArg)
    {
    }
    // *�t�B�W�F�b�g�ڑ�()="ModulePhidget"@20 // 0
    // Phidget Interface �Ɛڑ�����
    static function phidget_open(arg:ModuleFunctionArg)
    {
    }
    // *�t�B�W�F�b�g�ؒf()="ModulePhidget"@21 // 0
    // Phidget Interface �Ɛؒf����
    static function phidget_close(arg:ModuleFunctionArg)
    {
    }
    // *�t�B�W�F�b�g�ԍ��擾()="ModulePhidget"@30 // 0
    // Phidget �̃f�o�C�X�ԍ��𓾂�
    static function phidget_getNo(arg:ModuleFunctionArg)
    {
    }
    // *�t�B�W�F�b�g�l�擾()="ModulePhidget"@31 // 0
    // Phidget �̒l�𓾂�
    static function phidget_getValue(arg:ModuleFunctionArg)
    {
    }
    // *�t�B�W�F�b�g�G���[�擾()="ModulePhidget"@32 // 0
    // Phidget ����G���[�𓾂�
    static function phidget_getError(arg:ModuleFunctionArg)
    {
    }

*/
