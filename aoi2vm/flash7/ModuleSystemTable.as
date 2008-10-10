// Created by module2txt.nako --- "ModuleSystem.aoi2"
class ModuleSystemTable
{
    function ModuleSystemTable() {} // constructor  for [Flash IDE]
    //--- function table
    static function initTable(ftable:Array) {
        // *終了()
        ftable[0] = {func:ModuleSystemFunc.quit, arg:0};
        // *実行環境()
        ftable[1] = {func:ModuleSystemFunc.platform, arg:0};
        // *葵バージョン()
        ftable[2] = {func:ModuleSystemFunc.vm_version, arg:0};
        // *描画処理反映()
        ftable[3] = {func:ModuleSystemFunc.reflesh, arg:0};
        // *代入(EをVARに|EからVARへ)
        ftable[4] = {func:ModuleSystemFunc.let, arg:2};
        // *TYPEOF(E)
        ftable[5] = {func:ModuleSystemFunc._typeof, arg:1};
        // *文字数(Sの)
        ftable[10] = {func:ModuleSystemFunc.str_length, arg:1};
        // *文字列検索(SからAを|Sで|Sの)
        ftable[11] = {func:ModuleSystemFunc.str_indexof, arg:2};
        // *文字置換(SのAをBに|SでAからBへ)
        ftable[12] = {func:ModuleSystemFunc.str_replace, arg:3};
        // *ASC(S)
        ftable[13] = {func:ModuleSystemFunc.asc, arg:1};
        // *CHR(V)
        ftable[14] = {func:ModuleSystemFunc.chr, arg:1};
        // *文字挿入(SのIにAを|Sで)
        ftable[15] = {func:ModuleSystemFunc.str_insert, arg:3};
        // *文字削除(SのIからCNT|Sで)
        ftable[16] = {func:ModuleSystemFunc.str_delete, arg:3};
        // *文字抜き出す(SのIからCNT|Sで)
        ftable[17] = {func:ModuleSystemFunc.str_mid, arg:3};
        // *文字左部分(SのCNT|Sから)
        ftable[18] = {func:ModuleSystemFunc.str_left, arg:2};
        // *文字右部分(SのCNT|Sから)
        ftable[19] = {func:ModuleSystemFunc.str_right, arg:2};
        // *切り取る(SからAまで|SのAまでを)
        ftable[20] = {func:ModuleSystemFunc.str_getToken, arg:2};
        // *区切る(SをAで|Sの)
        ftable[21] = {func:ModuleSystemFunc.str_split, arg:2};
        // *単置換(SのAをBに|Sから|Sで)
        ftable[22] = {func:ModuleSystemFunc.str_replaceOne, arg:3};
        // *トリム(Sを|Sの|Sから|Sで)
        ftable[23] = {func:ModuleSystemFunc.str_trim, arg:1};
        // *通貨形式(Vを|Vの)
        ftable[24] = {func:ModuleSystemFunc.format_yen, arg:1};
        // *ゼロ埋め(VをCNTで|VへCNTの)
        ftable[25] = {func:ModuleSystemFunc.format_zero, arg:2};
        // *システム時間()
        ftable[30] = {func:ModuleSystemFunc.time_system, arg:0};
        // *今日()
        ftable[31] = {func:ModuleSystemFunc.date_today, arg:0};
        // *今()
        ftable[32] = {func:ModuleSystemFunc.time_now, arg:0};
        // *日付加算(SにAを|Sへ)
        ftable[33] = {func:ModuleSystemFunc.date_add, arg:2};
        // *時間加算(SにAを|Sへ)
        ftable[34] = {func:ModuleSystemFunc.time_add, arg:2};
        // *日数差(SとAの|SからAまでの)
        ftable[35] = {func:ModuleSystemFunc.date_sub, arg:2};
        // *秒差(SとAの|SからAまでの)
        ftable[36] = {func:ModuleSystemFunc.time_sub, arg:2};
        // *要素数(Aの)
        ftable[40] = {func:ModuleSystemFunc.count, arg:1};
        // *ハッシュキー列挙(Sから|Sの)
        ftable[41] = {func:ModuleSystemFunc.hash_keys, arg:1};
        // *ハッシュ値列挙(Sから|Sの)
        ftable[42] = {func:ModuleSystemFunc.hash_values, arg:1};
        // *配列追加(AにSを|Aへ)
        ftable[50] = {func:ModuleSystemFunc.array_add, arg:2};
        // *配列削除(AからIを|Aの)
        ftable[51] = {func:ModuleSystemFunc.array_delete, arg:2};
        // *配列挿入(AのIへSを|Iに)
        ftable[52] = {func:ModuleSystemFunc.array_insert, arg:3};
        // *配列要素数(Aの)
        ftable[53] = {func:ModuleSystemFunc.array_count, arg:1};
        // *配列検索(AのIからKEYを|Aで)
        ftable[54] = {func:ModuleSystemFunc.array_indexof, arg:3};
        // *配列一括挿入(AのIへBを|Iに)
        ftable[55] = {func:ModuleSystemFunc.array_insertArray, arg:3};
        // *配列数値ソート(Aを|Aの)
        ftable[56] = {func:ModuleSystemFunc.array_sortNum, arg:1};
        // *配列ソート(Aを|Aの)
        ftable[57] = {func:ModuleSystemFunc.array_sortStr, arg:1};
        // *配列逆順(Aの|Aを)
        ftable[58] = {func:ModuleSystemFunc.array_reverse, arg:1};
        // *配列結合(AをSで)
        ftable[59] = {func:ModuleSystemFunc.array_join, arg:2};
        // *配列連結(AをSで)
        ftable[60] = {func:ModuleSystemFunc.array_join, arg:2};
        // *配列シャッフル(Aの|Aを)
        ftable[61] = {func:ModuleSystemFunc.array_random, arg:1};
        // *CSV取得(Sを|Sから)
        ftable[62] = {func:ModuleSystemFunc.csv_toArray, arg:1};
        // *表ピックアップ(AのIからVを)
        ftable[63] = {func:ModuleSystemFunc.csv_pickup, arg:3};
        // *表数値ピックアップ(AのIからVをRANGEで)
        ftable[64] = {func:ModuleSystemFunc.csv_pickupNum, arg:4};
        // *言う(Sを|Sと|Sで|Sの)
        ftable[70] = {func:ModuleSystemFunc.dialog_say, arg:1};
        // *尋ねる(Sと|Sで|Sの|Sを)
        ftable[71] = {func:ModuleSystemFunc.dialog_input, arg:1};
        // *二択(Sと|Sで|Sの|Sを)
        ftable[72] = {func:ModuleSystemFunc.dialog_yesno, arg:1};
        // *INT(V)
        ftable[80] = {func:ModuleSystemFunc.cint, arg:1};
        // *STR(V)
        ftable[81] = {func:ModuleSystemFunc.cstr, arg:1};
        // *NUM(V)
        ftable[82] = {func:ModuleSystemFunc.cnum, arg:1};
        // *切捨て(Vを)
        ftable[100] = {func:ModuleSystemFunc.trunc, arg:1};
        // *ROUND(V)
        ftable[101] = {func:ModuleSystemFunc.round, arg:1};
        // *四捨五入(VをKで)
        ftable[102] = {func:ModuleSystemFunc.sisyagonyu, arg:2};
        // *絶対値(Vの)
        ftable[103] = {func:ModuleSystemFunc.abs, arg:1};
        // *SIN(V)
        ftable[104] = {func:ModuleSystemFunc.sin, arg:1};
        // *COS(V)
        ftable[105] = {func:ModuleSystemFunc.cos, arg:1};
        // *TAN(V)
        ftable[106] = {func:ModuleSystemFunc.tan, arg:1};
        // *ASIN(V)
        ftable[107] = {func:ModuleSystemFunc.asin, arg:1};
        // *ACOS(V)
        ftable[108] = {func:ModuleSystemFunc.acos, arg:1};
        // *ATAN(V)
        ftable[109] = {func:ModuleSystemFunc.atan, arg:1};
        // *SQRT(V)
        ftable[110] = {func:ModuleSystemFunc.sqrt, arg:1};
        // *EXP(V)
        ftable[111] = {func:ModuleSystemFunc.exp, arg:1};
        // *LOG(V)
        ftable[112] = {func:ModuleSystemFunc.log, arg:1};
        // *乱数(Vの)
        ftable[113] = {func:ModuleSystemFunc.random, arg:1};
        // *乱数範囲(AからBの|Bまでの)
        ftable[114] = {func:ModuleSystemFunc.random_range, arg:2};
        // *サイコロ振る(Nの)
        ftable[115] = {func:ModuleSystemFunc.dice, arg:1};
        // *掛ける(AにBを|Aへ)
        ftable[130] = {func:ModuleSystemFunc.mul, arg:2};
        // *割る(AをBで)
        ftable[131] = {func:ModuleSystemFunc.div, arg:2};
        // *余り(AとBの)
        ftable[132] = {func:ModuleSystemFunc.calc_mod, arg:2};
        // *足す(AにBを|AとBを|Aへ)
        ftable[133] = {func:ModuleSystemFunc.add, arg:2};
        // *引く(AからBを)
        ftable[134] = {func:ModuleSystemFunc.calc_sub, arg:2};
        // *直接足す(AにBを|AとBを|Aへ)
        ftable[135] = {func:ModuleSystemFunc.inc, arg:2};
        // *直接引く(AにBを|AとBを|Aへ)
        ftable[136] = {func:ModuleSystemFunc.dec, arg:2};
        // *等しい(AとBが)
        ftable[137] = {func:ModuleSystemFunc.comp_eq, arg:2};
        // *以上(AがB)
        ftable[138] = {func:ModuleSystemFunc.comp_gteq, arg:2};
        // *以下(AがB)
        ftable[139] = {func:ModuleSystemFunc.comp_lteq, arg:2};
        // *超(AがB)
        ftable[140] = {func:ModuleSystemFunc.comp_gt, arg:2};
        // *未満(AがB)
        ftable[141] = {func:ModuleSystemFunc.comp_lt, arg:2};
        // *文字列等しい(AとBが|Bの)
        ftable[142] = {func:ModuleSystemFunc.comp_str_eq, arg:2};
        // *XMLハッシュ変換(Sを|Sの|Sから)
        ftable[150] = {func:ModuleSystemFunc.xml_toHash, arg:1};

    }
}
/*
    // *終了()="ModuleSystem"@0 // 0
    // プログラムの実行を終了する
    static function quit(arg:ModuleFunctionArg)
    {
    }
    // *実行環境()="ModuleSystem"@1 // 0
    // 実行環境の種類を返す
    static function platform(arg:ModuleFunctionArg)
    {
    }
    // *葵バージョン()="ModuleSystem"@2 // 0
    // 葵のバージョンを返す
    static function vm_version(arg:ModuleFunctionArg)
    {
    }
    // *描画処理反映()="ModuleSystem"@3 // 0
    // 描画を促す
    static function reflesh(arg:ModuleFunctionArg)
    {
    }
    // *代入(EをVARに|EからVARへ)="ModuleSystem"@4 // 2
    // 代入を行う。VARの値をEに書き換える。
    static function let(arg:ModuleFunctionArg)
    {
    }
    // *TYPEOF(E)="ModuleSystem"@5 // 1
    // 値Eの型を返す
    static function _typeof(arg:ModuleFunctionArg)
    {
    }
    // *文字数(Sの)="ModuleSystem"@10 // 1
    // Sの文字数を返す
    static function str_length(arg:ModuleFunctionArg)
    {
    }
    // *文字列検索(SからAを|Sで|Sの)="ModuleSystem"@11 // 2
    // 文字列Sから検索文字列Aを検索してその位置を返す(見つからないと0を返す)
    static function str_indexof(arg:ModuleFunctionArg)
    {
    }
    // *文字置換(SのAをBに|SでAからBへ)="ModuleSystem"@12 // 3
    // 文字列Sの検索文字列Aを置換文字列Bに置換して返す
    static function str_replace(arg:ModuleFunctionArg)
    {
    }
    // *ASC(S)="ModuleSystem"@13 // 1
    // 文字列Sの1文字目の文字コードを返す
    static function asc(arg:ModuleFunctionArg)
    {
    }
    // *CHR(V)="ModuleSystem"@14 // 1
    // 文字コードVに対応した文字を返す
    static function chr(arg:ModuleFunctionArg)
    {
    }
    // *文字挿入(SのIにAを|Sで)="ModuleSystem"@15 // 3
    // 文字列SのI文字目にAを挿入して返す
    static function str_insert(arg:ModuleFunctionArg)
    {
    }
    // *文字削除(SのIからCNT|Sで)="ModuleSystem"@16 // 3
    // 文字列SのI文字目からCNT文字削除して返す
    static function str_delete(arg:ModuleFunctionArg)
    {
    }
    // *文字抜き出す(SのIからCNT|Sで)="ModuleSystem"@17 // 3
    // 文字列SのI文字目からCNT文字を抜き出して返す
    static function str_mid(arg:ModuleFunctionArg)
    {
    }
    // *文字左部分(SのCNT|Sから)="ModuleSystem"@18 // 2
    // 文字列Sの左からCNT文字を抜き出して返す
    static function str_left(arg:ModuleFunctionArg)
    {
    }
    // *文字右部分(SのCNT|Sから)="ModuleSystem"@19 // 2
    // 文字列Sの右からCNT文字を抜き出して返す
    static function str_right(arg:ModuleFunctionArg)
    {
    }
    // *切り取る(SからAまで|SのAまでを)="ModuleSystem"@20 // 2
    // 文字列Sから区切り文字列Aまでを切り取って返す(Sの内容を変更する)
    static function str_getToken(arg:ModuleFunctionArg)
    {
    }
    // *区切る(SをAで|Sの)="ModuleSystem"@21 // 2
    // 文字列Sを区切り文字Aで区切って配列変数として返す
    static function str_split(arg:ModuleFunctionArg)
    {
    }
    // *単置換(SのAをBに|Sから|Sで)="ModuleSystem"@22 // 3
    // 文字列Sで検索文字列Aを置換文字列Bで最初の1つを置換して返す
    static function str_replaceOne(arg:ModuleFunctionArg)
    {
    }
    // *トリム(Sを|Sの|Sから|Sで)="ModuleSystem"@23 // 1
    // 文字列Sの前後の空白を除去して返す
    static function str_trim(arg:ModuleFunctionArg)
    {
    }
    // *通貨形式(Vを|Vの)="ModuleSystem"@24 // 1
    // 通貨書式(3桁カンマ区切り)にして返す
    static function format_yen(arg:ModuleFunctionArg)
    {
    }
    // *ゼロ埋め(VをCNTで|VへCNTの)="ModuleSystem"@25 // 2
    // VをCNT桁の0で埋めて返す
    static function format_zero(arg:ModuleFunctionArg)
    {
    }
    // *システム時間()="ModuleSystem"@30 // 0
    // 1970-1-1からのミリ秒を返す
    static function time_system(arg:ModuleFunctionArg)
    {
    }
    // *今日()="ModuleSystem"@31 // 0
    // 今日の日付をyyyy-mm-ddの形式で返す
    static function date_today(arg:ModuleFunctionArg)
    {
    }
    // *今()="ModuleSystem"@32 // 0
    // 今の時間をhh:nn:ssの形式で返す
    static function time_now(arg:ModuleFunctionArg)
    {
    }
    // *日付加算(SにAを|Sへ)="ModuleSystem"@33 // 2
    // 日付SにAを加算して返す。日付は「yyyy-mm-dd」の形式で指定。減算するときは「-yyy-mm-dd」と指定
    static function date_add(arg:ModuleFunctionArg)
    {
    }
    // *時間加算(SにAを|Sへ)="ModuleSystem"@34 // 2
    // 時間SにAを加算して返す。時間は「hh:nn:ss」の形式で指定。減算するときは「-hh:nn:ss」と指定
    static function time_add(arg:ModuleFunctionArg)
    {
    }
    // *日数差(SとAの|SからAまでの)="ModuleSystem"@35 // 2
    // 日付SからAまでの日数差を返す。日付は「yyyy-mm-dd」の形式で指定。
    static function date_sub(arg:ModuleFunctionArg)
    {
    }
    // *秒差(SとAの|SからAまでの)="ModuleSystem"@36 // 2
    // 時間SからAまでの時間差を返す。時間は「hh:nn:ss」の形式で指定。
    static function time_sub(arg:ModuleFunctionArg)
    {
    }
    // *要素数(Aの)="ModuleSystem"@40 // 1
    // 配列変数Aに含まれる値の数を返す
    static function count(arg:ModuleFunctionArg)
    {
    }
    // *ハッシュキー列挙(Sから|Sの)="ModuleSystem"@41 // 1
    // 配列変数Sのキーを配列形式で返す
    static function hash_keys(arg:ModuleFunctionArg)
    {
    }
    // *ハッシュ値列挙(Sから|Sの)="ModuleSystem"@42 // 1
    // 文字列Sから検索文字列Aを検索してその番号を返す
    static function hash_values(arg:ModuleFunctionArg)
    {
    }
    // *配列追加(AにSを|Aへ)="ModuleSystem"@50 // 2
    // 配列Aに値Sを追加して返す(配列A自身に変更)
    static function array_add(arg:ModuleFunctionArg)
    {
    }
    // *配列削除(AからIを|Aの)="ModuleSystem"@51 // 2
    // 配列AのI番目を削除して返す(配列A自身を変更)
    static function array_delete(arg:ModuleFunctionArg)
    {
    }
    // *配列挿入(AのIへSを|Iに)="ModuleSystem"@52 // 3
    // 配列Aの要素I番に値Sを挿入して返す(配列A自身を変更)
    static function array_insert(arg:ModuleFunctionArg)
    {
    }
    // *配列要素数(Aの)="ModuleSystem"@53 // 1
    // 配列変数Aに含まれる値の数を返す
    static function array_count(arg:ModuleFunctionArg)
    {
    }
    // *配列検索(AのIからKEYを|Aで)="ModuleSystem"@54 // 3
    // 配列Aの要素I番からKEYを検索してそのインデックス番号を返す。見つからなければ0を返す
    static function array_indexof(arg:ModuleFunctionArg)
    {
    }
    // *配列一括挿入(AのIへBを|Iに)="ModuleSystem"@55 // 3
    // 配列Aの要素I番に配列変数Bを挿入して返す(配列A自身を変更)
    static function array_insertArray(arg:ModuleFunctionArg)
    {
    }
    // *配列数値ソート(Aを|Aの)="ModuleSystem"@56 // 1
    // 配列Aを数値順にソートして返す(配列A自身を変更)
    static function array_sortNum(arg:ModuleFunctionArg)
    {
    }
    // *配列ソート(Aを|Aの)="ModuleSystem"@57 // 1
    // 配列Aを文字列順にソートして返す(配列A自身を変更)
    static function array_sortStr(arg:ModuleFunctionArg)
    {
    }
    // *配列逆順(Aの|Aを)="ModuleSystem"@58 // 1
    // 配列Aの要素を逆さまにして返す(配列A自身を変更)
    static function array_reverse(arg:ModuleFunctionArg)
    {
    }
    // *配列結合(AをSで)="ModuleSystem"@59 // 2
    // 配列変数Aを文字列Sを区切りとして結合させて返す
    static function array_join(arg:ModuleFunctionArg)
    {
    }
    // *配列連結(AをSで)="ModuleSystem"@60 // 2
    // 配列変数Aを文字列Sを区切りとして連結させて返す(A[0] s a[1] s a[2]..)
    static function array_join(arg:ModuleFunctionArg)
    {
    }
    // *配列シャッフル(Aの|Aを)="ModuleSystem"@61 // 1
    // 配列Aの要素をランダムに入れ替えて返す(配列A自身を変更)
    static function array_random(arg:ModuleFunctionArg)
    {
    }
    // *CSV取得(Sを|Sから)="ModuleSystem"@62 // 1
    // CSV形式の文字列データを二次元配列に変換して返す。
    static function csv_toArray(arg:ModuleFunctionArg)
    {
    }
    // *表ピックアップ(AのIからVを)="ModuleSystem"@63 // 3
    // 二次元配列AのI列目(0起点)からVに合致する行を二次元配列変数の形式で返す。
    static function csv_pickup(arg:ModuleFunctionArg)
    {
    }
    // *表数値ピックアップ(AのIからVをRANGEで)="ModuleSystem"@64 // 4
    // 二次元配列AのI列目(0起点)からVの前後RANGE以内に合致する行を二次元配列変数の形式で返す。
    static function csv_pickupNum(arg:ModuleFunctionArg)
    {
    }
    // *言う(Sを|Sと|Sで|Sの)="ModuleSystem"@70 // 1
    // ダイアログに文字列Sを表示して待機する
    static function dialog_say(arg:ModuleFunctionArg)
    {
    }
    // *尋ねる(Sと|Sで|Sの|Sを)="ModuleSystem"@71 // 1
    // 一行入力ダイアログに質問Sを表示して待機し、入力結果を返す
    static function dialog_input(arg:ModuleFunctionArg)
    {
    }
    // *二択(Sと|Sで|Sの|Sを)="ModuleSystem"@72 // 1
    // はい/いいえで答えるダイアログと質問Sを表示して待機し、結果を返す
    static function dialog_yesno(arg:ModuleFunctionArg)
    {
    }
    // *INT(V)="ModuleSystem"@80 // 1
    // 整数型に変換して返す
    static function cint(arg:ModuleFunctionArg)
    {
    }
    // *STR(V)="ModuleSystem"@81 // 1
    // 文字列に変換して返す
    static function cstr(arg:ModuleFunctionArg)
    {
    }
    // *NUM(V)="ModuleSystem"@82 // 1
    // 数値型に変換して返す
    static function cnum(arg:ModuleFunctionArg)
    {
    }
    // *切捨て(Vを)="ModuleSystem"@100 // 1
    // 小数点以下を切り捨てて返す
    static function trunc(arg:ModuleFunctionArg)
    {
    }
    // *ROUND(V)="ModuleSystem"@101 // 1
    // 小数点以下を丸めて返す
    static function round(arg:ModuleFunctionArg)
    {
    }
    // *四捨五入(VをKで)="ModuleSystem"@102 // 2
    // 数値VをKの桁で四捨五入して返す(1,10,100のように指定する)
    static function sisyagonyu(arg:ModuleFunctionArg)
    {
    }
    // *絶対値(Vの)="ModuleSystem"@103 // 1
    // 絶対値を返す
    static function abs(arg:ModuleFunctionArg)
    {
    }
    // *SIN(V)="ModuleSystem"@104 // 1
    // SINを返す
    static function sin(arg:ModuleFunctionArg)
    {
    }
    // *COS(V)="ModuleSystem"@105 // 1
    // COSを返す
    static function cos(arg:ModuleFunctionArg)
    {
    }
    // *TAN(V)="ModuleSystem"@106 // 1
    // TANを返す
    static function tan(arg:ModuleFunctionArg)
    {
    }
    // *ASIN(V)="ModuleSystem"@107 // 1
    // ASINを返す
    static function asin(arg:ModuleFunctionArg)
    {
    }
    // *ACOS(V)="ModuleSystem"@108 // 1
    // ACOSを返す
    static function acos(arg:ModuleFunctionArg)
    {
    }
    // *ATAN(V)="ModuleSystem"@109 // 1
    // ATANを返す
    static function atan(arg:ModuleFunctionArg)
    {
    }
    // *SQRT(V)="ModuleSystem"@110 // 1
    // SQRTを返す
    static function sqrt(arg:ModuleFunctionArg)
    {
    }
    // *EXP(V)="ModuleSystem"@111 // 1
    // EXPを返す
    static function exp(arg:ModuleFunctionArg)
    {
    }
    // *LOG(V)="ModuleSystem"@112 // 1
    // LOGを返す
    static function log(arg:ModuleFunctionArg)
    {
    }
    // *乱数(Vの)="ModuleSystem"@113 // 1
    // (0からV-1まで)の乱数を返す
    static function random(arg:ModuleFunctionArg)
    {
    }
    // *乱数範囲(AからBの|Bまでの)="ModuleSystem"@114 // 2
    // (AからBまで)の乱数を返す
    static function random_range(arg:ModuleFunctionArg)
    {
    }
    // *サイコロ振る(Nの)="ModuleSystem"@115 // 1
    // Nの目のサイコロを振って返す。(1からNまで)の乱数を返す
    static function dice(arg:ModuleFunctionArg)
    {
    }
    // *掛ける(AにBを|Aへ)="ModuleSystem"@130 // 2
    // 値Aに値Bを掛けて返す
    static function mul(arg:ModuleFunctionArg)
    {
    }
    // *割る(AをBで)="ModuleSystem"@131 // 2
    // 値Aを値Bで割って返す
    static function div(arg:ModuleFunctionArg)
    {
    }
    // *余り(AとBの)="ModuleSystem"@132 // 2
    // 値Aを値Bで割った余りを返す
    static function calc_mod(arg:ModuleFunctionArg)
    {
    }
    // *足す(AにBを|AとBを|Aへ)="ModuleSystem"@133 // 2
    // 値Aに値Bを足した値を返す(Aを変更しない)
    static function add(arg:ModuleFunctionArg)
    {
    }
    // *引く(AからBを)="ModuleSystem"@134 // 2
    // 値Aから値Bを引いた値を返す(Aを変更しない)
    static function calc_sub(arg:ModuleFunctionArg)
    {
    }
    // *直接足す(AにBを|AとBを|Aへ)="ModuleSystem"@135 // 2
    // 値Aに値Bを足した値を返す(Aを変更する)
    static function inc(arg:ModuleFunctionArg)
    {
    }
    // *直接引く(AにBを|AとBを|Aへ)="ModuleSystem"@136 // 2
    // 値Aから値Bを引いた値を返す(Aを変更する)
    static function dec(arg:ModuleFunctionArg)
    {
    }
    // *等しい(AとBが)="ModuleSystem"@137 // 2
    // 値Aと値Bが等しければ1を違えば0を返す
    static function comp_eq(arg:ModuleFunctionArg)
    {
    }
    // *以上(AがB)="ModuleSystem"@138 // 2
    // 値Aが値B以上なら1違えば0を返す
    static function comp_gteq(arg:ModuleFunctionArg)
    {
    }
    // *以下(AがB)="ModuleSystem"@139 // 2
    // 値Aが値B以下なら1違えば0を返す
    static function comp_lteq(arg:ModuleFunctionArg)
    {
    }
    // *超(AがB)="ModuleSystem"@140 // 2
    // 値Aが値B超なら1違えば0を返す
    static function comp_gt(arg:ModuleFunctionArg)
    {
    }
    // *未満(AがB)="ModuleSystem"@141 // 2
    // 値Aが値B未満なら1違えば0を返す
    static function comp_lt(arg:ModuleFunctionArg)
    {
    }
    // *文字列等しい(AとBが|Bの)="ModuleSystem"@142 // 2
    // 文字列AとBが等しければ1を違えば0を返す
    static function comp_str_eq(arg:ModuleFunctionArg)
    {
    }
    // *XMLハッシュ変換(Sを|Sの|Sから)="ModuleSystem"@150 // 1
    // XML文字列をハッシュに変更する
    static function xml_toHash(arg:ModuleFunctionArg)
    {
    }

*/
