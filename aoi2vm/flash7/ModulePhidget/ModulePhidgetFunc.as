
class ModulePhidgetFunc extends ModuleBase
{
    // --- 初期化
    // (外部ファイルに分けないで) 埋め込む時はこれを呼ぶ
    static function init() {
        //--- お決まりの呼び出し
        var m = new ModulePhidgetFunc();
        m.module_init("ModulePhidget");
        ModulePhidgetTable.initTable(m.ftable);
    }
    
    function ModulePhidgetFunc() {}
    
    //
    static var ph_ip:String         = "127.0.0.1";
    static var ph_port:Number       = 5001;
    static var ph_sn:Number         = -1;
    static var ph_password:String   = "pass";
    //
    static var ph_sensor_event:String;
    static var ph_input_event:String;
    static var ph_attach_event:String;
    static var ph_detach_event:String;
    static var ph_error_event:String;
    static var IFK:PhidgetInterfaceKit;
    //
    static var ph_error:String;
    static var ph_value:Number;
    static var ph_no:Number;
    
    // *フィジェットIP設定(IPを)="ModulePhidget"@1 // 1
    // Phidget IPを指定する
    static function phidget_setIP(arg:ModuleFunctionArg)
    {
        ph_ip = arg.getArgStr(0);
    }
    // *フィジェットPORT設定(PORTを)="ModulePhidget"@2 // 1
    // Phidget PORTを指定する
    static function phidget_setPort(arg:ModuleFunctionArg)
    {
        ph_port = arg.getArgNum(0);
    }
    // *フィジェットシリアル番号設定(NOを)="ModulePhidget"@3 // 1
    // Phidget SerialNumberを指定する
    static function phidget_setSN(arg:ModuleFunctionArg)
    {
        ph_sn = arg.getArgNum(0);
    }
    // *フィジェットパスワード設定(PWを)="ModulePhidget"@4 // 1
    // Phidget Passwordを指定する
    static function phidget_setPassword(arg:ModuleFunctionArg)
    {
        ph_password = arg.getArgStr(0);
    }
    // *フィジェットセンサーイベント設定(EVENTに|EVENTへ)="ModulePhidget"@5 // 1
    // Phidget センサーイベントを設定する
    static function phidget_onSensor(arg:ModuleFunctionArg)
    {
        ph_sensor_event = arg.getArgStr(0);
    }
    // *フィジェット入力イベント設定(EVENTに|EVENTへ)="ModulePhidget"@6 // 1
    // Phidget 入力イベントを設定する
    static function phidget_onInput(arg:ModuleFunctionArg)
    {
        ph_input_event = arg.getArgStr(0);
    }
    // *フィジェット接続イベント設定(EVENTに|EVENTへ)="ModulePhidget"@7 // 1
    // Phidget 接続イベントを設定する
    static function phidget_onAttach(arg:ModuleFunctionArg)
    {
        ph_attach_event = arg.getArgStr(0);
    }
    // *フィジェット切断イベント設定(EVENTに|EVENTへ)="ModulePhidget"@8 // 1
    // Phidget 接続イベントを設定する
    static function phidget_onDetach(arg:ModuleFunctionArg)
    {
        ph_detach_event = arg.getArgStr(0);
    }
    // *フィジェットエラー設定(EVENTに|EVENTへ)="ModulePhidget"@9 // 1
    // Phidget Passwordを指定する
    static function phidget_onError(arg:ModuleFunctionArg)
    {
        ph_error_event = arg.getArgStr(0);
    }
    // *フィジェット接続()="ModulePhidget"@20 // 0
    // Phidget Interface と接続する
    static function phidget_open(arg:ModuleFunctionArg)
    {
        System.security.loadPolicyFile("xmlsocket://" + ph_ip + ":" + ph_port);
        IFK = new PhidgetInterfaceKit();
        IFK.openRemoteIP(ph_ip, ph_port, ph_sn, ph_password);
        IFK.onAttach = function(phid:Phidget) {
            ModuleFunctionApi.addEvent(ModulePhidgetFunc.ph_attach_event);
        };
        IFK.onDetach = function(phid:Phidget) {
            ModuleFunctionApi.addEvent(ModulePhidgetFunc.ph_detach_event);
        };
        IFK.onError = function(desc:String, code:Number) {
            ModulePhidgetFunc.ph_error = code + ":" + desc;
            ModuleFunctionApi.addEvent(ModulePhidgetFunc.ph_error_event);
        };
        IFK.onInputChange = function(index:Number, newState:Boolean) {
            ModulePhidgetFunc.ph_no    = index;
            ModulePhidgetFunc.ph_value = newState ? 1 : 0;
            ModuleFunctionApi.addEvent(ModulePhidgetFunc.ph_input_event);
        };
        IFK.onSensorChange = function(index:Number,newVal:Number) {
            ModulePhidgetFunc.ph_no    = index;
            ModulePhidgetFunc.ph_value = newVal;
            ModuleFunctionApi.addEvent(ModulePhidgetFunc.ph_sensor_event);
        };
    }
    // *フィジェット切断()="ModulePhidget"@21 // 0
    // Phidget Interface と切断する
    static function phidget_close(arg:ModuleFunctionArg)
    {
        IFK.Close();
    }
    // *フィジェット番号取得()="ModulePhidget"@30 // 0
    // Phidget のデバイス番号を得る
    static function phidget_getNo(arg:ModuleFunctionArg)
    {
        arg.return_num(ph_no);
    }
    // *フィジェット値取得()="ModulePhidget"@31 // 0
    // Phidget の値を得る
    static function phidget_getValue(arg:ModuleFunctionArg)
    {
        arg.return_num(ph_value);
    }
    // *フィジェットエラー取得()="ModulePhidget"@32 // 0
    // Phidget からエラーを得る
    static function phidget_getError(arg:ModuleFunctionArg)
    {
        arg.return_str(ph_error);
    }
}

