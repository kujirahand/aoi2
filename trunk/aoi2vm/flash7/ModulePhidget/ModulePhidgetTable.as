// Created by module2txt.nako --- "ModulePhidget.aoi2"
class ModulePhidgetTable
{
    function ModulePhidgetTable() {} // constructor  for [Flash IDE]
    //--- function table
    static function initTable(ftable:Array) {
        // *フィジェットIP設定(IPを)
        ftable[1] = {func:ModulePhidgetFunc.phidget_setIP, arg:1};
        // *フィジェットPORT設定(PORTを)
        ftable[2] = {func:ModulePhidgetFunc.phidget_setPort, arg:1};
        // *フィジェットシリアル番号設定(NOを)
        ftable[3] = {func:ModulePhidgetFunc.phidget_setSN, arg:1};
        // *フィジェットパスワード設定(PWを)
        ftable[4] = {func:ModulePhidgetFunc.phidget_setPassword, arg:1};
        // *フィジェットセンサーイベント設定(EVENTに|EVENTへ)
        ftable[5] = {func:ModulePhidgetFunc.phidget_onSensor, arg:1};
        // *フィジェット入力イベント設定(EVENTに|EVENTへ)
        ftable[6] = {func:ModulePhidgetFunc.phidget_onInput, arg:1};
        // *フィジェット接続イベント設定(EVENTに|EVENTへ)
        ftable[7] = {func:ModulePhidgetFunc.phidget_onAttach, arg:1};
        // *フィジェット切断イベント設定(EVENTに|EVENTへ)
        ftable[8] = {func:ModulePhidgetFunc.phidget_onDetach, arg:1};
        // *フィジェットエラー設定(EVENTに|EVENTへ)
        ftable[9] = {func:ModulePhidgetFunc.phidget_onError, arg:1};
        // *フィジェット接続()
        ftable[20] = {func:ModulePhidgetFunc.phidget_open, arg:0};
        // *フィジェット切断()
        ftable[21] = {func:ModulePhidgetFunc.phidget_close, arg:0};
        // *フィジェット番号取得()
        ftable[30] = {func:ModulePhidgetFunc.phidget_getNo, arg:0};
        // *フィジェット値取得()
        ftable[31] = {func:ModulePhidgetFunc.phidget_getValue, arg:0};
        // *フィジェットエラー取得()
        ftable[32] = {func:ModulePhidgetFunc.phidget_getError, arg:0};

    }
}
/*
    // *フィジェットIP設定(IPを)="ModulePhidget"@1 // 1
    // Phidget IPを指定する
    static function phidget_setIP(arg:ModuleFunctionArg)
    {
    }
    // *フィジェットPORT設定(PORTを)="ModulePhidget"@2 // 1
    // Phidget PORTを指定する
    static function phidget_setPort(arg:ModuleFunctionArg)
    {
    }
    // *フィジェットシリアル番号設定(NOを)="ModulePhidget"@3 // 1
    // Phidget SerialNumberを指定する
    static function phidget_setSN(arg:ModuleFunctionArg)
    {
    }
    // *フィジェットパスワード設定(PWを)="ModulePhidget"@4 // 1
    // Phidget Passwordを指定する
    static function phidget_setPassword(arg:ModuleFunctionArg)
    {
    }
    // *フィジェットセンサーイベント設定(EVENTに|EVENTへ)="ModulePhidget"@5 // 1
    // Phidget センサーイベントを設定する
    static function phidget_onSensor(arg:ModuleFunctionArg)
    {
    }
    // *フィジェット入力イベント設定(EVENTに|EVENTへ)="ModulePhidget"@6 // 1
    // Phidget 入力イベントを設定する
    static function phidget_onInput(arg:ModuleFunctionArg)
    {
    }
    // *フィジェット接続イベント設定(EVENTに|EVENTへ)="ModulePhidget"@7 // 1
    // Phidget 接続イベントを設定する
    static function phidget_onAttach(arg:ModuleFunctionArg)
    {
    }
    // *フィジェット切断イベント設定(EVENTに|EVENTへ)="ModulePhidget"@8 // 1
    // Phidget 接続イベントを設定する
    static function phidget_onDetach(arg:ModuleFunctionArg)
    {
    }
    // *フィジェットエラー設定(EVENTに|EVENTへ)="ModulePhidget"@9 // 1
    // Phidget Passwordを指定する
    static function phidget_onError(arg:ModuleFunctionArg)
    {
    }
    // *フィジェット接続()="ModulePhidget"@20 // 0
    // Phidget Interface と接続する
    static function phidget_open(arg:ModuleFunctionArg)
    {
    }
    // *フィジェット切断()="ModulePhidget"@21 // 0
    // Phidget Interface と切断する
    static function phidget_close(arg:ModuleFunctionArg)
    {
    }
    // *フィジェット番号取得()="ModulePhidget"@30 // 0
    // Phidget のデバイス番号を得る
    static function phidget_getNo(arg:ModuleFunctionArg)
    {
    }
    // *フィジェット値取得()="ModulePhidget"@31 // 0
    // Phidget の値を得る
    static function phidget_getValue(arg:ModuleFunctionArg)
    {
    }
    // *フィジェットエラー取得()="ModulePhidget"@32 // 0
    // Phidget からエラーを得る
    static function phidget_getError(arg:ModuleFunctionArg)
    {
    }

*/
