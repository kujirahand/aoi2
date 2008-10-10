
class ModuleSystemFunc extends ModuleBase
{
    // --- 初期化
    // (外部ファイルに分けないで) 埋め込む時はこれを呼ぶ
    static function init() {
        var m = new ModuleSystemFunc();
        m.module_init("ModuleSystem");
        ModuleSystemTable.initTable(m.ftable);
    }
    function ModuleSystemFunc() {}
    
    //------------------------------------------------------------------
    // 以下関数の定義
    //--------------------------------
    // system function define
    //--------------------------------
    // *終了() .. プログラムの実行を終了する
    static function quit(fa:ModuleFunctionArg):Void {
        fa._mac.flag_quit = true;
    }
    // *実行環境() .. 実行環境の種類を返す
    static function platform(fa:ModuleFunctionArg):Void {
        fa.return_str(System.capabilities.os);
    }
    // *葵バージョン() .. 葵のバージョンを返す
    static function vm_version(fa:ModuleFunctionArg):Void {
        fa.return_num(ALoader.VERSION);
    }
    // *文字数(Sの) .. Sの文字数を返す
    static function str_length(fa:ModuleFunctionArg):Void {
        var s = fa.getArgStr(0);
        fa.return_num(s.length);
    }
    // *文字列検索(SからAを|Sで|Sの) .. 文字列Sから検索文字列Aを検索して位置を返す(見つからないと0を返す)
    static function str_indexof(fa:ModuleFunctionArg):Void {
        var s:String = fa.getArgStr(0);
        var a = fa.getArgStr(1);
        var res = s.indexOf(a) + 1;
        fa.return_num(res);
    }
    // *置換(SのAをBに|SでAからBへ) .. 文字列Sの検索文字列Aを置換文字列Bに置換して返す
    static function str_replace(fa:ModuleFunctionArg):Void {
        var s:String = fa.getArgStr(0);
        var a = fa.getArgStr(1);
        var b = fa.getArgStr(2);
        fa.return_str(KUtils.str_replaceAll(s, a, b));
    }
    // *ASC(S) .. 文字列Sの1文字目の文字コードを返す
    static function asc(fa:ModuleFunctionArg):Void {
        var s:String = fa.getArgStr(0);
        fa.return_num( s.charCodeAt(0) );
    }
    // *CHR(V) .. 文字コードVに対応した文字を返す
    static function chr(fa:ModuleFunctionArg):Void {
        var code:Number = fa.getArgNum(0);
        fa.return_str(String.fromCharCode(code));
    }
    // *文字挿入(SのIにAを|Sで) .. 文字列SのI文字目にAを挿入して返す
    static function str_insert(fa:ModuleFunctionArg):Void {
        var s:String = fa.getArgStr(0);
        var i:Number = fa.getArgNum(1) - 1;
        var a:String = fa.getArgStr(2);
        fa.return_str(KUtils.str_insert(s, i, a));
    }
    // *文字削除(SのIからCNTを|Sで) .. 文字列SのI文字目からCNT文字削除して返す
    static function str_delete(fa:ModuleFunctionArg):Void {
        var s:String = fa.getArgStr(0);
        var i:Number = fa.getArgNum(1) - 1;
        var n:Number = fa.getArgNum(2);
        fa.return_str(KUtils.str_delete(s, i, n));
    }
    // *文字抜き出す(SのIからCNTを|Sで) .. 文字列SのI文字目からCNT文字を抜き出して返す
    static function str_mid(fa:ModuleFunctionArg):Void {
        var s:String = fa.getArgStr(0);
        var i:Number = fa.getArgNum(1) - 1;
        var n:Number = fa.getArgNum(2);
        fa.return_str( s.substr(i, n) );
    }
    // *文字左部分(SのCNT|Sから) .. 文字列Sの左からCNT文字を抜き出して返す
    static function str_left(fa:ModuleFunctionArg):Void {
        var s:String = fa.getArgStr(0);
        var n:Number = fa.getArgNum(1);
        fa.return_str( s.substr(0,n) );
    }
    // *文字右部分(SのCNT|Sから) .. 文字列Sの右からCNT文字を抜き出して返す
    static function str_right(fa:ModuleFunctionArg):Void {
        var s:String = fa.getArgStr(0);
        var n:Number = fa.getArgNum(1);
        fa.return_str( KUtils.str_right(s, n) );
    }
    // *切り取る(SからAまで|Sの) .. 文字列Sから区切り文字列Aまでを切り取って返す(Sの内容を変更する)
    static function str_getToken(fa:ModuleFunctionArg):Void {
        var o_val:Object = fa._args[0];
        
        var s:String = AValue.convString(o_val);
        var a:String = fa.getArgStr(1);
        
        var ss:Object  = {str:s};
        var res:String = KUtils.str_getToken(ss, a);
        
        // Sの内容を削る
        AValue.changeLinkValue(o_val, ss.str);
        
        // 結果を返す
        fa.return_str(res);
    }
    // *区切る(SをAで|Sの) .. 文字列Sを区切り文字Aで区切って配列変数として返す
    static function str_split(fa:ModuleFunctionArg):Void {
        var s:String = fa.getArgStr(0);
        var a:String = fa.getArgStr(1);
        fa._result = s.split(a);
    }
    // *単置換(SのAをBに|Sから|Sで) .. 文字列Sで検索文字列Aを置換文字列Bで最初の1つを置換して返す
    static function str_replaceOne(fa:ModuleFunctionArg):Void {
        var s:String = fa.getArgStr(0);
        var a = fa.getArgStr(1);
        var b = fa.getArgStr(2);
        fa.return_str( KUtils.str_replaceOne(s, a, b) );
    }
    // *トリム(Sの|Sから|Sで) .. 文字列Sの前後の空白を除去して返す
    static function str_trim(fa:ModuleFunctionArg):Void {
        var s:String = fa.getArgStr(0);
        fa.return_str(KUtils.str_trim(s));
    }
    // *通貨形式(Vを|Vの) .. 通貨書式(3桁カンマ区切り)にして返す
    static function format_yen(fa:ModuleFunctionArg):Void {
        var n:Number = fa.getArgNum(0);
        fa.return_str(KUtils.formatYen(n));
    }
    static function format_zero(fa:ModuleFunctionArg):Void {
        var n:Number = fa.getArgNum(0);
        var c:Number = fa.getArgNum(1);
        fa.return_str(KUtils.formatZero(n, c));
    }
    // *システム時間() .. 1970-1-1からのミリ秒を返す
    static function time_system(fa:ModuleFunctionArg):Void {
        var d:Date = new Date();
        fa.return_num(d.getTime());
    }
    // *今日() .. 今日の日付をyyyy-mm-ddの形式で返す
    static function date_today(fa:ModuleFunctionArg):Void {
        var d:Date = new Date();
        var yyyy = d.getFullYear();
        var mm   = KUtils.formatZero( d.getMonth() + 1, 2 );
        var dd   = KUtils.formatZero( d.getDate(), 2 );
        fa.return_str("" + yyyy + "-" + mm + "-" + dd);
    }
    // *今() .. 今の時間をhh:nn:ssの形式で返す
    static function time_now(fa:ModuleFunctionArg):Void {
        var d:Date = new Date();
        var hh   = KUtils.formatZero( d.getHours(),   2);
        var nn   = KUtils.formatZero( d.getMinutes(), 2);
        var ss   = KUtils.formatZero( d.getSeconds(), 2);
        fa.return_str("" + hh + ":" + nn + ":" + ss);
    }
    // *日付加算(SにAを|Sへ) .. 日付SにAを加算して返す。日付は「yyyy-mm-dd」の形式で指定。
    static function date_add(fa:ModuleFunctionArg):Void {
        var s:String = fa.getArgStr(0);
        var a:String = fa.getArgStr(1);
        fa.return_str( KUtils.date_add(s, a) );
    }
    // *時間加算(SにAを|Sへ) .. 時間SにAを加算して返す。時間は「hh:nn:ss」の形式で指定。
    static function time_add(fa:ModuleFunctionArg):Void {
        var s:String = fa.getArgStr(0);
        var a:String = fa.getArgStr(1);
        fa.return_str( KUtils.time_add(s, a) );
    }
    // *日数差(SとAの|SからAまでの) .. 日付SからAまでの日数差を返す。日付は「yyyy-mm-dd」の形式で指定。
    static function date_sub(fa:ModuleFunctionArg):Void {
        var s:String = fa.getArgStr(0);
        var a:String = fa.getArgStr(1);
        fa.return_num( KUtils.date_diff(s, a) );
    }
    // *秒差(SとAの|SからAまでの) .. 時間SからAまでの時間差を返す。時間は「hh:nn:ss」の形式で指定。
    static function time_sub(fa:ModuleFunctionArg):Void {
        var s:String = fa.getArgStr(0);
        var a:String = fa.getArgStr(1);
        fa.return_num( KUtils.time_diff(s, a) );
    }
    // *配列要素数(Aの) .. 配列変数Aに含まれる値の数を返す
    static function array_count(fa:ModuleFunctionArg):Void {
        var a:Object = fa._args[0];
        a = AValue.getLink(a);
        if (a instanceof Array) {
            fa.return_num(Array(a).length);
        }
        else if (a instanceof Object) {
            var i = 0;
            for (var j in a) { i++; }
            fa.return_num(i);
        }
        else {
            fa.return_num(1);
        }
    }
    static function count(fa:ModuleFunctionArg):Void {
        array_count(fa);
    }
    // *ハッシュキー列挙(Sから|Sの) .. 配列変数Sのキーを配列形式で返す
    static function hash_keys(fa:ModuleFunctionArg):Void {
        var s:Object = fa._args[0];
        s = AValue.getLink(s);
        
        if (s instanceof Array) {
            fa._result = s;
            return;
        }
        
        var r:Array = new Array();
        for (var j in s) {
            r.push(j);
        }
        fa._result = r;
    }
    // *ハッシュ値列挙(Sから|Sの)
    static function hash_values(fa:ModuleFunctionArg):Void {
        var s:Object = fa._args[0];
        s = AValue.getLink(s);
        var r:Array = new Array();
        for (var j in s) {
            r.push(new AValueLink(s[j]));
        }
        fa._result = r;
    }
    // *配列追加(AにSを|Aへ) .. 配列Aに値Sを追加して返す
    static function array_add(fa:ModuleFunctionArg):Void {
        var a:Object  = fa._args[0];
        var s:Object  = fa._args[1];
        var aa:Object = AValue.getLink(a);
        var ary:Array = AValue.convArrayWrite(a);
        ary.push(s);
        fa._result = a;
    }
    // *配列削除(AからIを|Aの) .. 配列AのI番目を削除して返す
    static function array_delete(fa:ModuleFunctionArg):Void {
        var a:Object = fa._args[0];
        var i = fa.getArgNum(1);
        var ary:Array = AValue.convArrayWrite(a);
        ary.splice(i, 1);
        fa._result = a;
    }
    // *配列挿入(AのIへSを|Iに) .. 配列Aの要素I番に値Sを挿入して返す。
    static function array_insert(fa:ModuleFunctionArg):Void {
        var a_obj:Object    = fa._args[0];
        var i:Number        = fa.getArgNum(1);
        var s_obj:Object    = fa._args[2];
        var ary:Array = AValue.convArrayWrite(a_obj);
        ary.splice(i, 0, AValue.cloneObject(s_obj));
        fa._result = a_obj;
    }
    // *配列検索(AのIからKEYを|Aで) .. 配列Aの要素I番からKEYを検索してそのインデックス番号を返す。見つからなければ0を返す
    static function array_indexof(fa:ModuleFunctionArg):Void {
        var a:Object     = fa._args[0];
        var idx:Number   = fa.getArgNum(1);
        var key:String   = fa.getArgStr(2);
        var ary:Array    = AValue.convArray(a);
        for (var i = idx; i < ary.length; i++) {
            var v:Object = AValue.getLink(ary[i]);
            var s:String = AValue.convString(v);
            if (s == key) {
                fa.return_num(i);
                return;
            }
        }
        fa.return_num(0);
    }
    // *配列一括挿入(AのIへBを|Iに) .. 配列Aの要素I番に配列変数Bを挿入して返す。
    static function array_insertArray(fa:ModuleFunctionArg):Void {
        var a_obj:Object = fa._args[0];
        var index:Number = fa.getArgNum(1);
        var b_obj:Object = fa._args[2];
        var a_ary:Array  = AValue.convArrayWrite(a_obj);
        var b_ary:Array  = AValue.convArray(b_obj);
        for (var i = 0; i < b_ary.length; i++) {
            var o:Object = AValue.cloneObject(b_ary[i]);
            a_ary.splice((index+i), 0, o);
        }
        fa._result = a_obj;
    }
    // *配列数値ソート(Aを|Aの) .. 配列Aを数値順にソートして返す
    static function sort_order_num(a:Object, b:Object):Number {
        var na = AValue.convNumber(a);
        var nb = AValue.convNumber(b);
        if (na < nb) {
            return -1;
        } else if (na > nb) {
            return 1;
        } else {
            return 0;
        }
        return 0;
    }
    static function array_sortNum(fa:ModuleFunctionArg):Void {
        var a:Object = fa._args[0];
        var ary:Array = AValue.convArrayWrite(a);
        ary.sort(sort_order_num);
        fa._result = a;
    }
    // *配列ソート(Aを|Aの) .. 配列Aを文字列順にソートして返す
    static function sort_order_str(a:AValue, b:AValue):Number {
        var na = AValue.convString(a);
        var nb = AValue.convString(b);
        if (na < nb) {
            return -1;
        } else if (na > nb) {
            return 1;
        } else {
            return 0;
        }
        return 0;
    }
    static function array_sortStr(fa:ModuleFunctionArg):Void {
        var a:Object = fa._args[0];
        var ary:Array = AValue.convArrayWrite(a);
        ary.sort(sort_order_str);
        fa._result = a;
    }
    // *配列逆順(Aの|Aを) .. 配列Aの要素を逆さまにして返す
    static function array_reverse(fa:ModuleFunctionArg):Void {
        var a:Object = fa._args[0];
        var a_ary:Array = AValue.convArrayWrite(a);
        KUtils.array_reverse(a_ary);
        fa._result = a;
    }
    // *配列結合(AをSで) .. 配列変数Aを文字列Sを区切りとして結合させて返す
    static function array_join(fa:ModuleFunctionArg):Void {
        var ary:Array  = fa.getArgArray(0);
        var spl:String = fa.getArgStr(1);
        var res:String = "";
        for (var i = 0; i < ary.length; i++) {
            res += AValue.convString(ary[i]) + spl;
        }
        if (res.length > 0) {
            res = res.substr(0, res.length - 1);
        }
        fa.return_str(res);
    }
    // *配列シャッフル(Aの|Aを) .. 配列Aの要素をランダムに入れ替えて返す
    static function array_random(fa:ModuleFunctionArg):Void {
        var a:Object = fa._args[0];
        var a_ary:Array = AValue.convArrayWrite(a);
        KUtils.array_random(a_ary);
        fa._result = a;
    }
    // *CSV取得(Sを|Sから) .. CSV形式の文字列データを二次元配列に変換して返す。
    static function csv_toArray(fa:ModuleFunctionArg):Void {
        var s:String = fa.getArgStr(0);
        s = KUtils.str_replaceAll(s, "\r\n", "\n");
        s = KUtils.str_replaceAll(s, "\r", "\n");
        var a:Array = s.split("\n");
        var ary:Array = new Array();
        for (var row = 0; row < a.length; row++) {
            var line_a = a[row].split(",");
            for (var col = 0; col < line_a.length; col++) {
                line_a[col] = KUtils.str_trim(line_a[col]);
            }
            ary.push(line_a);
        }
        fa._result = ary;
    }
    // *表ピックアップ(AのIからVを) .. 二次元配列AのI列目(0起点)からVに合致する行を二次元配列変数の形式で返す。
    static function csv_pickup(fa:ModuleFunctionArg):Void {
        var a:Array  = fa.getArgArray(0);
        var i:Number = fa.getArgNum(1);
        var v:String = fa.getArgStr(2);
        var res:Array = new Array();
        for (var row = 0; row < a.length; row++) {
            var line:Array  = AValue.convArray(a[row]);
            var cell:String = AValue.convString( line[i] );
            if (cell == v) {
                res.push(AValue.cloneObject(line));
            }
        }
        fa._result = res;
    }
    // *表数値ピックアップ(AのIからVをRANGEで) .. 二次元配列AのI列目(0起点)からVの前後RANGE以内に合致する行を二次元配列変数の形式で返す。
    static function csv_pickupNum(fa:ModuleFunctionArg):Void {
        var a:Array         = fa.getArgArray(0);
        var i:Number        = fa.getArgNum(1);
        var v:Number        = fa.getArgNum(2);
        var range:Number    = fa.getArgNum(3);
        var res:Array = new Array();
        var vFrom:Number = v - range;
        var vTo:Number   = v + range;
        for (var row = 0; row < a.length; row++) {
            var line:Array  = AValue.convArray(a[row]);
            var cell:Number = AValue.convNumber( line[i] );
            if ((vFrom <= cell)&&(cell <= vTo)) {
                res.push(AValue.cloneObject(line));
            }
        }
        fa._result = res;
    }
    // *言う(Sを|Sと|Sで|Sの) .. ダイアログに文字列Sを表示して待機する
    static function dialog_say(fa:ModuleFunctionArg):Void {
        var s:String = fa.getArgStr(0);
        dialog.showMessageBox(fa._mac, s);
    }
    // *尋ねる(Sと|Sで|Sの|Sを) .. 一行入力ダイアログに質問Sを表示して待機し、入力結果を返す
    static function dialog_input(fa:ModuleFunctionArg):Void {
        var s:String = fa.getArgStr(0);
        dialog.showInputDialog(fa._mac, s);
    }
    // *二択(Sと|Sで|Sの|Sを) .. はい/いいえで答えるダイアログと質問Sを表示して待機し、結果を返す
    static function dialog_yesno(fa:ModuleFunctionArg):Void {
        var s:String = fa.getArgStr(0);
        dialog.showYesNoDialog(fa._mac, s);
    }
    // *INT(V) .. 整数に変換して返す
    static function cint(fa:ModuleFunctionArg):Void {
        fa.return_num(Math.floor(fa.getArgNum(0)));
    }
    // *STR(V) .. 文字列に変換して返す
    static function cstr(fa:ModuleFunctionArg):Void {
        fa.return_str(fa.getArgStr(0));
    }
    // *描画処理反映() .. 描画を促す
    static function reflesh(fa:ModuleFunctionArg):Void {
        fa._mac.flag_reflesh = true;
    }
    // *切捨て(Vを) .. 小数点以下を切り捨てて返す
    static function trunc(fa:ModuleFunctionArg):Void {
        var v:Number = fa.getArgNum(0);
        v = Math.floor(v);
        fa.return_num(v);
    }
    // *ROUND(V) .. 小数点以下を丸めて返す
    static function round(fa:ModuleFunctionArg):Void {
        var v:Number = fa.getArgNum(0);
        v = Math.round(v);
        fa.return_num(v);
    }
    // *四捨五入(VをKで) .. 数値VをKの桁で四捨五入して返す
    static function sisyagonyu(fa:ModuleFunctionArg):Void {
        var v:Number = fa.getArgNum(0);
        var k:Number = fa.getArgNum(1);
        var h = (k / 10) * 5;
        v = Math.floor(v + h);
        fa.return_num(v);
    }
    // *絶対値(Vの) .. 絶対値を返す
    static function abs(fa:ModuleFunctionArg):Void {
        var v:Number = fa.getArgNum(0);
        v = Math.abs(v);
        fa.return_num(v);
    }
    // *SIN(V) .. SINを返す
    static function sin(fa:ModuleFunctionArg):Void {
        var v:Number = fa.getArgNum(0);
        v = Math.sin(v);
        fa.return_num(v);
    }
    // *COS(V) .. COSを返す
    static function cos(fa:ModuleFunctionArg):Void {
        var v:Number = fa.getArgNum(0);
        v = Math.cos(v);
        fa.return_num(v);
    }
    // *TAN(V) .. TANを返す
    static function tan(fa:ModuleFunctionArg):Void {
        var v:Number = fa.getArgNum(0);
        v = Math.tan(v);
        fa.return_num(v);
    }
    // *ASIN(V) .. ASINを返す
    static function asin(fa:ModuleFunctionArg):Void {
        var v:Number = fa.getArgNum(0);
        v = Math.asin(v);
        fa.return_num(v);
    }
    // *ACOS(V) .. ACOSを返す
    static function acos(fa:ModuleFunctionArg):Void {
        var v:Number = fa.getArgNum(0);
        v = Math.acos(v);
        fa.return_num(v);
    }
    // *ATAN(V) .. ATANを返す
    static function atan(fa:ModuleFunctionArg):Void {
        var v:Number = fa.getArgNum(0);
        v = Math.atan(v);
        fa.return_num(v);
    }
    // *SQRT(V) .. SQRTを返す
    static function sqrt(fa:ModuleFunctionArg):Void {
        var v:Number = fa.getArgNum(0);
        v = Math.sqrt(v);
        fa.return_num(v);
    }
    // *EXP(V) .. EXPを返す
    static function exp(fa:ModuleFunctionArg):Void {
        var v:Number = fa.getArgNum(0);
        v = Math.exp(v);
        fa.return_num(v);
    }
    // *LOG(V) .. LOGを返す
    static function log(fa:ModuleFunctionArg):Void {
        var v:Number = fa.getArgNum(0);
        v = Math.log(v);
        fa.return_num(v);
    }
    // *乱数(Vの) .. (0からV-1まで)の乱数を返す
    static function random(fa:ModuleFunctionArg):Void {
        var v:Number = fa.getArgNum(0);
        v = Math.floor(Math.random() * v);
        fa.return_num(v);
    }
    // *乱数範囲(AからBの|Bまでの) .. (AからBまで)の乱数を返す
    static function random_range(fa:ModuleFunctionArg):Void {
        var a:Number = fa.getArgNum(0);
        var b:Number = fa.getArgNum(1);
        if (a > b) { var tmp = a; a = b; b = tmp; }
        var v:Number = (b - a) + 1;
        v = Math.floor(Math.random() * v);
        fa.return_num(v + a);
    }
    // *サイコロ振る(Nの) .. Nの目のサイコロを振って返す。(1からNまで)の乱数を返す
    static function dice(fa:ModuleFunctionArg):Void {
        var v:Number = fa.getArgNum(0);
        v = Math.floor(Math.random() * v);
        fa.return_num(v + 1);
    }
    // *代入(EをVARに|EからVARへ) .. 代入を行う。VARの値をEに書き換える。
    static function let(fa:ModuleFunctionArg):Void {
        var e:Object = fa._args[0];
        var v:Object = fa._args[1];
        AValue.changeLinkValue(v, AValue.cloneObject(e));
    }
    // *NUM(V) # 数値型に変換して返す
    public static function cnum(fa:ModuleFunctionArg) {
        fa.return_num(fa.getArgNum(0));
    }
    // *TYPEOF(E) # 値Eの型を返す
    public static function _typeof(fa:ModuleFunctionArg) {
        var e:Object = fa._args[0];
        e = AValue.getLink(e);
        fa.return_str(AValue.getTypeStr(e));
    }
    // *掛ける(AにBを|Aへ)="ModuleSystem"@130 // 2
    // 値Aに値Bを掛けて返す
    static function mul(arg:ModuleFunctionArg)
    {
        arg.return_num(arg.getArgNum(0) * arg.getArgNum(1));
    }
    // *割る(AをBで)="ModuleSystem"@131 // 2
    // 値Aを値Bで割って返す
    static function div(arg:ModuleFunctionArg)
    {
        arg.return_num(arg.getArgNum(0) / arg.getArgNum(1));
    }
    // *余り(AとBの)="ModuleSystem"@132 // 2
    // 値Aを値Bで割った余りを返す
    static function calc_mod(arg:ModuleFunctionArg)
    {
        arg.return_num(arg.getArgNum(0) % arg.getArgNum(1));
    }
    // *足す(AにBを|AとBを|Aへ)="ModuleSystem"@133 // 2
    // 値Aに値Bを足した値を返す(Aを変更しない)
    static function add(arg:ModuleFunctionArg)
    {
        var a = arg._args[0]; a = AValue.getLink(a);
        var b = arg._args[1]; b = AValue.getLink(b);
        if (AValue.isIntOrNum(a)) {
            arg.return_num(a + b);
        }
        else {
            arg.return_str(a + b);
        }
    }
    // *引く(AからBを)="ModuleSystem"@134 // 2
    // 値Aから値Bを引いた値を返す(Aを変更しない)
    static function calc_sub(arg:ModuleFunctionArg)
    {
        arg.return_num(arg.getArgNum(0) - arg.getArgNum(1));
    }
    // *直接足す(AにBを|AとBを|Aへ)="ModuleSystem"@135 // 2
    // 値Aに値Bを足した値を返す(Aを変更する)
    static function inc(arg:ModuleFunctionArg)
    {
        var a:Object = AValueLink(arg._args[0]); 
        var b = arg._args[1];
        var la = AValue.getLink(a);
        var lb = AValue.getLink(b);
        if (AValue.isIntOrNum(a)) {
            la += lb;
            arg.return_num(la);
            AValue.changeLinkValue(a, la);
        }
        else {
            la += lb;
            arg.return_str(la);
            AValue.changeLinkValue(a, la);
        }
    }
    // *直接引く(AにBを|AとBを|Aへ)="ModuleSystem"@136 // 2
    // 値Aから値Bを引いた値を返す(Aを変更する)
    static function dec(arg:ModuleFunctionArg)
    {
        var a = arg._args[0];
        var b = arg._args[1];
        var la = AValue.getLink(a);
        var lb = AValue.getLink(b);
        la -= lb;
        arg.return_str(la);
        AValue.changeLinkValue(a, la);
    }
    // *等しい(AとBが)="ModuleSystem"@137 // 2
    // 値Aと値Bが等しければ1を違えば0を返す
    static function comp_eq(arg:ModuleFunctionArg)
    {
        var a = AValue.getLink(arg._args[0]);
        var b = AValue.getLink(arg._args[1]);
        arg.return_num((a == b) ? 1 : 0);
    }
    // *以上(AがB)="ModuleSystem"@138 // 2
    // 値Aが値B以上なら1違えば0を返す
    static function comp_gteq(arg:ModuleFunctionArg)
    {
        var a = AValue.getLink(arg._args[0]);
        var b = AValue.getLink(arg._args[1]);
        arg.return_num((a >= b) ? 1 : 0);
    }
    // *以下(AがB)="ModuleSystem"@139 // 2
    // 値Aが値B以下なら1違えば0を返す
    static function comp_lteq(arg:ModuleFunctionArg)
    {
        var a = AValue.getLink(arg._args[0]);
        var b = AValue.getLink(arg._args[1]);
        arg.return_num((a <= b) ? 1 : 0);
    }
    // *超(AがB)="ModuleSystem"@140 // 2
    // 値Aが値B超なら1違えば0を返す
    static function comp_gt(arg:ModuleFunctionArg)
    {
        var a = AValue.getLink(arg._args[0]);
        var b = AValue.getLink(arg._args[1]);
        arg.return_num((a > b) ? 1 : 0);
    }
    // *未満(AがB)="ModuleSystem"@141 // 2
    // 値Aが値B未満なら1違えば0を返す
    static function comp_lt(arg:ModuleFunctionArg)
    {
        var a = AValue.getLink(arg._args[0]);
        var b = AValue.getLink(arg._args[1]);
        arg.return_num((a < b) ? 1 : 0);
    }
    // *文字列等しい(AとBが|Bの)="ModuleSystem"@142 // 2
    // 文字列AとBが等しければ1を違えば0を返す
    static function comp_str_eq(arg:ModuleFunctionArg)
    {
        var a = AValue.getLink(arg._args[0]);
        var b = AValue.getLink(arg._args[1]);
        arg.return_num((a == b) ? 1 : 0);
    }
    // *XMLハッシュ変換(Sを|Sの|Sから)="ModuleSystem"@150 // 1
    // XML文字列をハッシュに変更する
    static function xml_toHash(arg:ModuleFunctionArg)
    {
        var s:String = arg.getArgStr(0);
        var k:KXml = new KXml(new XML(s));
        arg._result = k.convertToHash();
    }
}

