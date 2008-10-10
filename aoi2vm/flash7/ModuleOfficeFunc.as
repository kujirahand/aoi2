
class ModuleOfficeFunc extends ModuleBase
{
    // --- 初期化
    // (外部ファイルに分けないで) 埋め込む時はこれを呼ぶ
    static function init() {
        //--- お決まりの呼び出し
        var m = new ModuleOfficeFunc();
        m.module_init("ModuleOffice");
        ModuleOfficeTable.initTable(m.ftable);
    }
    
    function ModuleOfficeFunc() {}
    
    //
    static var kabin_key:String  = "com.nadesi.kabin";
    static var kabin_ip:String   = "127.0.0.1";
    static var kabin_port:Number = 5029;
    static var kabin_password:String = "";
    static var kabin_type:String = "";
    static var kabin_sock:XMLSocket;
    static var kabin_error_message:String = "";
    static var kabin_error_event:String = "";
    
    // *花瓶IP設定(IPを)="ModuleOffice"@1 // 1
    // Officeサーバー(花瓶)の IPを指定する
    static function kabin_setIP(arg:ModuleFunctionArg)
    {
        kabin_ip = arg.getArgStr(0);
    }
    // *花瓶PORT設定(PORTを)="ModuleOffice"@2 // 1
    // Officeサーバー(花瓶)の PORTを指定する
    static function kabin_setPort(arg:ModuleFunctionArg)
    {
        kabin_port = arg.getArgNum(0);
    }
    // *花瓶パスワード設定(PWを)="ModuleOffice"@3 // 1
    // Officeサーバー(花瓶)の Passwordを指定する
    static function kabin_setPassword(arg:ModuleFunctionArg)
    {
        kabin_password = arg.getArgStr(0);
    }
    // *花瓶タイプ設定(TYPEを)="ModuleOffice"@4 // 1
    // MSOffice か OpenOffice.org かを指定する
    static function kabin_setType(arg:ModuleFunctionArg)
    {
        kabin_type = arg.getArgStr(0);
    }
    // *花瓶接続()="ModuleOffice"@5 // 0
    // 花瓶へ接続する
    static function kabin_connect(arg:ModuleFunctionArg)
    {
        KLog.write("kabin_connect.setup:" + kabin_port);
        System.security.loadPolicyFile("xmlsocket://" + kabin_ip + ":" + kabin_port);
        var md5:String = MD5.getHash(kabin_port + ":" + kabin_password + ":" + kabin_key);
        arg.flag_quit = true;
        kabin_sock = new XMLSocket();
        kabin_sock.onConnect = function (ok:Boolean) {
            if (ok) {
                ModuleOfficeFunc.kabin_sock.send('{"command":"password", "password":"'+md5+'"}');
                KLog.write("kabin.connected");
            }
            else {
                ModuleOfficeFunc.kabin_error_message = "接続に失敗(onConnect)";
                ModuleFunctionApi.addEvent(ModuleOfficeFunc.kabin_error_event);
            }
            arg.flag_quit = false;
        };
        kabin_sock.onData = function (data) {
            KLog.write("kabin.onData=" + data);
        };
        if (!kabin_sock.connect(kabin_ip, kabin_port)) {
            KLog.write("kabin.connect failed.");
            ModuleOfficeFunc.kabin_error_message = "接続に失敗(connect)";
            ModuleFunctionApi.addEvent(ModuleOfficeFunc.kabin_error_event);
        }
    }
    // *花瓶切断()="ModuleOffice"@6 // 0
    // 花瓶との接続を切る
    static function kabin_disconnect(arg:ModuleFunctionArg)
    {
        if (kabin_sock) kabin_sock.close();
    }
    
    static function kabin_callbyid(no:Number, arg:ModuleFunctionArg)
    {
        KLog.write("kabin_callbyid");
        arg.flag_quit = true;
        kabin_sock.onData = function (dat:String) {
            arg.flag_quit = false;
            KLog.write("result=" + dat);
            arg.swap_stacktop(dat);
        };
        var arg_json = AValue.convString(arg._args);
        var json:String = '{"command":"callbyid","id":'+no+',"args":'+arg_json+'}';
        KLog.write(json);
        kabin_sock.send(json);
    }
    static function kabin_callbyeval(arg:ModuleFunctionArg)
    {
        KLog.write("kabin_callbyeval");
        arg.flag_quit = true;
        var cmd:String = arg.getArgStr(0);
        kabin_sock.onData = function (dat:String) {
            arg.flag_quit = false;
            KLog.write("result=" + dat);
            arg.swap_stacktop(dat);
        };
        var json:String = '{"command":"callbyeval","source":"'+cmd+'"}';
        KLog.write(json);
        kabin_sock.send(json);
    }
    
    // *花瓶エラー設定(EVENTに|EVENTの)="ModuleOffice"@7 // 1
    // 花瓶のエラーを受け取るイベントを設定する
    static function kabin_setError(arg:ModuleFunctionArg)
    {
        kabin_error_event = arg.getArgStr(0);
    }
    // *花瓶エラー取得()="ModuleOffice"@8 // 0
    // 花瓶のエラーメッセージを表示する
    static function kabin_getError(arg:ModuleFunctionArg)
    {
        arg.return_str(kabin_error_message);
    }
    // *花瓶コマンド実行(Sを|Sの|Sで)="ModuleOffice"@9 // 1
    // 花瓶サーバーに対し任意のコマンドを送る
    static function kabin_command(arg:ModuleFunctionArg)
    {
        kabin_callbyeval(arg);
    }

    // *エクセル起動({)="ModuleOffice"@67 // 1
    // 可視A(オンかオフ)でエクセルを起動する
    static function func67(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4300, arg);
    }
    // *エクセル終了()="ModuleOffice"@68 // 0
    // 起動したエクセルを終了する
    static function func68(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4301, arg);
    }
    // *エクセル新規ブック()="ModuleOffice"@69 // 0
    // 新規ブックを作る
    static function func69(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4302, arg);
    }
    // *エクセル新規シート()="ModuleOffice"@70 // 0
    // 新規シートを追加する
    static function func70(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4303, arg);
    }
    // *エクセル開く(Sを|Sから|Sの)="ModuleOffice"@71 // 1
    // ファイルSからファイルを開く。
    static function func71(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4304, arg);
    }
    // *エクセル保存(Sへ|Sに)="ModuleOffice"@72 // 1
    // ファイルSへファイルを保存する
    static function func72(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4305, arg);
    }
    // *エクセルシート注目(Aの|Aに|Aを)="ModuleOffice"@73 // 1
    // A番目(1～n)または名前Aのシートをアクティブにする
    static function func73(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4306, arg);
    }
    // *エクセルブック注目(Aの|Aに|Aを)="ModuleOffice"@74 // 1
    // A番目(1～n)のブックをアクティブにする
    static function func74(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4307, arg);
    }
    // *エクセルCSV保存(Sへ|Sに)="ModuleOffice"@75 // 1
    // ファイルSへファイルをCSV形式で保存する
    static function func75(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4308, arg);
    }
    // *エクセルTSV保存(Sへ|Sに)="ModuleOffice"@76 // 1
    // ファイルSへファイルをTSV形式で保存する
    static function func76(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4309, arg);
    }
    // *エクセルセル設定(CELLへVを|CELLに)="ModuleOffice"@77 // 2
    // セルA(A1~)へVを設定する
    static function func77(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4310, arg);
    }
    // *エクセルセル取得(CELLの|CELLを)="ModuleOffice"@78 // 1
    // セルA(A1~)を取得して返す
    static function func78(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4311, arg);
    }
    // *エクセル一括設定(CELLへVを|CELLに)="ModuleOffice"@79 // 2
    // セル(A1~)へ二次元配列Vを一括設定する
    static function func79(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4312, arg);
    }
    // *エクセル一括取得(C1からC2まで|C2までの|C2の)="ModuleOffice"@80 // 2
    // セルC1(A1~)からC2までのセルを一括取得して返す。
    static function func80(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4313, arg);
    }
    // *エクセル選択(CELLを|CELLに|CELLへ)="ModuleOffice"@81 // 1
    // セル(A1~)を選択する。A1:C4のように範囲指定も可能。
    static function func81(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4314, arg);
    }
    // *エクセルコピー()="ModuleOffice"@82 // 0
    // 選択されているセルをコピーする。
    static function func82(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4315, arg);
    }
    // *エクセル貼り付け()="ModuleOffice"@83 // 0
    // 選択されているセルへクリップボードから貼り付けする。
    static function func83(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4316, arg);
    }
    // *エクセル着色(Vを|Vで|Vの|Vに)="ModuleOffice"@84 // 1
    // 選択されているセルを色Vで着色する。
    static function func84(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4317, arg);
    }
    // *エクセルマクロ実行(Aを{)="ModuleOffice"@85 // 2
    // マクロAを引数Bで実行。関数なら結果を返す。
    static function func85(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4318, arg);
    }
    // *エクセルシート印刷プレビュー()="ModuleOffice"@86 // 0
    // アクティブなシートを印刷プレビューする
    static function func86(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4319, arg);
    }
    // *エクセルシート印刷()="ModuleOffice"@87 // 0
    // アクティブなシートを印刷する
    static function func87(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4320, arg);
    }
    // *エクセルブック印刷プレビュー()="ModuleOffice"@88 // 0
    // アクティブなワークブックを印刷プレビューする
    static function func88(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4321, arg);
    }
    // *エクセルブック印刷()="ModuleOffice"@89 // 0
    // アクティブなワークブックを印刷する
    static function func89(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4322, arg);
    }
    // *エクセル可視変更(Aに)="ModuleOffice"@90 // 1
    // エクセルの可視をオン(=1)かオフ(=0)に変更する。
    static function func90(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4323, arg);
    }
    // *エクセル全選択()="ModuleOffice"@92 // 0
    // セル全てを選択する。
    static function func92(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4325, arg);
    }
    // *エクセル選択範囲置換(AからBへ|AをBに)="ModuleOffice"@93 // 2
    // 選択範囲のセルにあるAをBに置換する。
    static function func93(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4326, arg);
    }
    // *エクセル選択行高さ設定(Vに|Vへ)="ModuleOffice"@94 // 1
    // 選択範囲のセルの高さを設定する。
    static function func94(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4327, arg);
    }
    // *エクセル選択列幅設定(Vに|Vへ)="ModuleOffice"@95 // 1
    // 選択範囲のセルの幅を設定する。
    static function func95(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4328, arg);
    }
    // *エクセルシート列挙()="ModuleOffice"@98 // 0
    // シートの一覧を取得して返す
    static function func98(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4702, arg);
    }
    // *エクセルキー送信(KEYSの|KEYSを)="ModuleOffice"@99 // 1
    // 現在開いているExcelウィンドウにキーを送信する。
    static function func99(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4703, arg);
    }
    // *エクセルシートコピー(SHEETをNEWSHEETに)="ModuleOffice"@100 // 2
    // ExcelのシートSHEETを複製してNEWSHEETとする
    static function func100(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4704, arg);
    }
    // *エクセルシート名前変更(NAMEをNEWNAMEに|NAMEからNEWNAMEへ)="ModuleOffice"@101 // 2
    // ExcelのシートNAMEの名前をNEWNAMEへ変更する
    static function func101(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4705, arg);
    }
    // *ワード起動({)="ModuleOffice"@104 // 1
    // 可視A(オンかオフ)でワードを起動する
    static function func104(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4330, arg);
    }
    // *ワード終了()="ModuleOffice"@105 // 0
    // ワードを終了する
    static function func105(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4331, arg);
    }
    // *ワード保存(Fへ|Fに)="ModuleOffice"@106 // 1
    // ワード文書Fを保存する
    static function func106(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4332, arg);
    }
    // *ワード開く(Fを|Fで|Fの)="ModuleOffice"@107 // 1
    // ワード文書Fをひらく
    static function func107(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4333, arg);
    }
    // *ワード新規文書()="ModuleOffice"@108 // 0
    // 新規ワード文書を作る
    static function func108(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4334, arg);
    }
    // *ワードブックマーク挿入(SにVを|Sへ)="ModuleOffice"@109 // 2
    // ブックマークSに値Vを挿入する
    static function func109(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4335, arg);
    }
    // *ワード印刷プレビュー()="ModuleOffice"@110 // 0
    // 印刷プレビューを表示する
    static function func110(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4336, arg);
    }
    // *ワード印刷()="ModuleOffice"@111 // 0
    // ワードで印刷する
    static function func111(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4337, arg);
    }
    // *ワードマクロ実行(Aを{)="ModuleOffice"@112 // 2
    // ワードのマクロAを引数Bで実行し関数なら値を返す。
    static function func112(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4338, arg);
    }
    // *ワード本文取得()="ModuleOffice"@113 // 0
    // ワードの本文をテキストで得て返す
    static function func113(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4339, arg);
    }
    // *ワード文章追加({)="ModuleOffice"@114 // 1
    // ワードに文章Sを追加する。
    static function func114(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4340, arg);
    }
    // *ワード文書閉じる()="ModuleOffice"@115 // 0
    // アクティブなワード文書を閉じる
    static function func115(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4341, arg);
    }
    // *ワード可視変更(Aに)="ModuleOffice"@116 // 1
    // ワードの可視をオン(=1)かオフ(=0)に変更する。
    static function func116(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4342, arg);
    }
    // *ワード置換(AをBに|AからBへ)="ModuleOffice"@117 // 2
    // ワードの文章中の文字列AをBに置換する。
    static function func117(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4343, arg);
    }
    // *CALC起動({)="ModuleOffice"@153 // 1
    // 可視A(オンかオフ)でCALCを起動する
    static function func153(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4800, arg);
    }
    // *CALC終了()="ModuleOffice"@154 // 0
    // 起動したCALCを終了する
    static function func154(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4801, arg);
    }
    // *CALC新規ブック()="ModuleOffice"@155 // 0
    // 新規ブックを作る
    static function func155(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4802, arg);
    }
    // *CALC新規シート()="ModuleOffice"@156 // 0
    // 新規シートを追加する
    static function func156(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4803, arg);
    }
    // *CALC開く(Sを|Sから|Sの)="ModuleOffice"@157 // 1
    // ファイルSからファイルを開く。
    static function func157(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4804, arg);
    }
    // *CALC保存(Sへ|Sに)="ModuleOffice"@158 // 1
    // ファイルSへファイルを保存する
    static function func158(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4805, arg);
    }
    // *CALCシート注目(Aの|Aに|Aを)="ModuleOffice"@159 // 1
    // A番目(0～n)または名前Aのシートをアクティブにする
    static function func159(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4806, arg);
    }
    // *CALC_CSV保存(Sへ|Sに)="ModuleOffice"@160 // 1
    // ファイルSへファイルをCSV形式で保存する
    static function func160(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4808, arg);
    }
    // *CALCセル設定(CELLへVを|CELLに)="ModuleOffice"@161 // 2
    // セルA(A1~)へVを設定する
    static function func161(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4810, arg);
    }
    // *CALCセル取得(CELLの|CELLを)="ModuleOffice"@162 // 1
    // セルA(A1~)を取得して返す
    static function func162(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4811, arg);
    }
    // *CALC一括設定(CELLへVを|CELLに)="ModuleOffice"@163 // 2
    // セル(A1~)へ二次元配列Vを一括設定する
    static function func163(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4812, arg);
    }
    // *CALC一括取得(C1からC2まで|C2までの|C2の)="ModuleOffice"@164 // 2
    // セルC1(A1~)からC2までのセルを一括取得して返す。
    static function func164(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4813, arg);
    }
    // *CALC選択(CELLを|CELLに|CELLへ)="ModuleOffice"@165 // 1
    // セル(A1~)を選択する。A1:C4のように範囲指定も可能。
    static function func165(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4814, arg);
    }
    // *CALCコピー()="ModuleOffice"@166 // 0
    // 選択されているセルをコピーする。
    static function func166(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4815, arg);
    }
    // *CALC貼り付け()="ModuleOffice"@167 // 0
    // 選択されているセルへクリップボードから貼り付けする。
    static function func167(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4816, arg);
    }
    // *CALC着色(Vを|Vで|Vの|Vに)="ModuleOffice"@168 // 1
    // 選択されているセルセルを色Vで着色する。
    static function func168(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4817, arg);
    }
    // *CALCシート印刷プレビュー()="ModuleOffice"@169 // 0
    // アクティブなシートを印刷プレビューする
    static function func169(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4819, arg);
    }
    // *CALC印刷()="ModuleOffice"@170 // 0
    // 印刷する
    static function func170(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4820, arg);
    }
    // *CALC全選択()="ModuleOffice"@172 // 0
    // セル全てを選択する。
    static function func172(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4825, arg);
    }
    // *CALC_PDF保存(Sへ|Sに)="ModuleOffice"@173 // 1
    // ファイルSへPDF形式で保存する
    static function func173(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4826, arg);
    }
    // *WRITER起動({)="ModuleOffice"@174 // 1
    // 可視A(オンかオフ)でWriterを起動する
    static function func174(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4830, arg);
    }
    // *WRITER終了()="ModuleOffice"@175 // 0
    // Writerを終了する
    static function func175(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4831, arg);
    }
    // *WRITER保存(Fへ|Fに)="ModuleOffice"@176 // 1
    // 文書Fを保存する
    static function func176(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4832, arg);
    }
    // *WRITER開く(Fを|Fで|Fの)="ModuleOffice"@177 // 1
    // 文書Fをひらく
    static function func177(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4833, arg);
    }
    // *WRITER新規文書()="ModuleOffice"@178 // 0
    // 新規文書を作る
    static function func178(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4834, arg);
    }
    // *WRITERブックマーク挿入(SにVを|Sへ)="ModuleOffice"@179 // 2
    // ブックマークSに値Vを挿入する
    static function func179(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4835, arg);
    }
    // *WRITER印刷プレビュー()="ModuleOffice"@180 // 0
    // 印刷プレビューを表示する
    static function func180(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4836, arg);
    }
    // *WRITER印刷()="ModuleOffice"@181 // 0
    // 印刷する
    static function func181(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4837, arg);
    }
    // *WRITER本文取得()="ModuleOffice"@182 // 0
    // 本文をテキストで得て返す
    static function func182(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4839, arg);
    }
    // *WRITER文章追加({)="ModuleOffice"@183 // 1
    // 文章Sを追加する。
    static function func183(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4840, arg);
    }
    // *WRITER文書閉じる()="ModuleOffice"@184 // 0
    // アクティブな文書を閉じる
    static function func184(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4841, arg);
    }
    // *WRITER_PDF保存(Fへ|Fに)="ModuleOffice"@185 // 1
    // ファイルFへPDFを保存する
    static function func185(arg:ModuleFunctionArg)
    {
        kabin_callbyid(4842, arg);
    }

    
}

