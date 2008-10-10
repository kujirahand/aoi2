// Created by module2txt.nako --- "ModuleSwf.aoi2"
class ModuleSwfTable
{
    function ModuleSwfTable() {} // constructor  for [Flash IDE]
    //--- function table
    static function initTable(ftable:Array) {
        // *作る(OBJをTYPEとして)
        ftable[0] = {func:ModuleSwfFunc.gui_create, arg:2};
        // *設定(OBJのPROPにVを|PROPへ)
        ftable[1] = {func:ModuleSwfFunc.gui_set, arg:3};
        // *取得(OBJのPROPを)
        ftable[2] = {func:ModuleSwfFunc.gui_get, arg:2};
        // *アクティブ部品()
        ftable[3] = {func:ModuleSwfFunc.gui_getActive, arg:0};
        // *移動(XX,YYに|YYへ)
        ftable[4] = {func:ModuleSwfFunc.gui_move, arg:2};
        // *部品削除(OBJの|OBJを)
        ftable[5] = {func:ModuleSwfFunc.gui_remove, arg:1};
        // *全部品削除()
        ftable[6] = {func:ModuleSwfFunc.gui_removeAll, arg:0};
        // *最前面設定(OBJを)
        ftable[7] = {func:ModuleSwfFunc.gui_bringToFront, arg:1};
        // *センタリング(OBJを)
        ftable[8] = {func:ModuleSwfFunc.gui_setCenter, arg:1};
        // *衝突判定(OBJ1とOBJ2で|OBJ2が|OBJ2の)
        ftable[9] = {func:ModuleSwfFunc.gui_hitTest, arg:2};
        // *線(X1,Y1からX2,Y2へ|Y2に|Y2まで)
        ftable[10] = {func:ModuleSwfFunc.draw_line, arg:4};
        // *四角(X1,Y1からX2,Y2へ|Y2に|Y2まで)
        ftable[11] = {func:ModuleSwfFunc.draw_rectangle, arg:4};
        // *円描画(X1,Y1からX2,Y2へ|Y2に|Y2まで)
        ftable[12] = {func:ModuleSwfFunc.draw_circle, arg:4};
        // *多角形(ARRAYの|ARRAYで)
        ftable[13] = {func:ModuleSwfFunc.draw_poly, arg:1};
        // *画面クリア()
        ftable[14] = {func:ModuleSwfFunc.draw_clear, arg:0};
        // *ブロック描画(W,HでDATAを)
        ftable[15] = {func:ModuleSwfFunc.draw_blocks, arg:3};
        // *マウス落書モード開始()
        ftable[16] = {func:ModuleSwfFunc.draw_mousepen_start, arg:0};
        // *マウス落書モード終了()
        ftable[17] = {func:ModuleSwfFunc.draw_mousepen_end, arg:0};
        // *線色設定(COLORに)
        ftable[20] = {func:ModuleSwfFunc.draw_setLineColor, arg:1};
        // *線色取得()
        ftable[21] = {func:ModuleSwfFunc.draw_getLineColor, arg:0};
        // *線太さ設定(Wに)
        ftable[22] = {func:ModuleSwfFunc.draw_setLineWidth, arg:1};
        // *線太さ取得()
        ftable[23] = {func:ModuleSwfFunc.draw_getLineWidth, arg:0};
        // *塗り色設定(COLORに)
        ftable[24] = {func:ModuleSwfFunc.draw_setFillColor, arg:1};
        // *塗り色取得()
        ftable[25] = {func:ModuleSwfFunc.draw_getFillColor, arg:0};
        // *透明度設定(PERCENTに)
        ftable[26] = {func:ModuleSwfFunc.draw_setAlpha, arg:1};
        // *透明度取得()
        ftable[27] = {func:ModuleSwfFunc.draw_getAlpha, arg:0};
        // *描画対象設定(OBJが|OBJに|OBJへ)
        ftable[28] = {func:ModuleSwfFunc.draw_setTarget, arg:1};
        // *描画対象取得()
        ftable[29] = {func:ModuleSwfFunc.draw_getTarget, arg:0};
        // *フォントサイズ設定(SIZEに|SIZEへ)
        ftable[30] = {func:ModuleSwfFunc.font_setSize, arg:1};
        // *フォントサイズ取得()
        ftable[31] = {func:ModuleSwfFunc.font_getSize, arg:0};
        // *フォント色設定(COLに|COLへ)
        ftable[32] = {func:ModuleSwfFunc.font_setColor, arg:1};
        // *フォント色取得()
        ftable[33] = {func:ModuleSwfFunc.font_getColor, arg:0};
        // *フォント種類設定(NAMEに|NAMEへ)
        ftable[34] = {func:ModuleSwfFunc.font_setName, arg:1};
        // *フォント種類取得()
        ftable[35] = {func:ModuleSwfFunc.font_getName, arg:0};
        // *RGB(R,G,B)
        ftable[36] = {func:ModuleSwfFunc.rgb, arg:3};
        // *マクロ描画(SをWAITで)
        ftable[37] = {func:ModuleSwfFunc.draw_macro, arg:2};
        // *タイル描画(W,HでDATAを)
        ftable[38] = {func:ModuleSwfFunc.draw_tiles, arg:3};
        // *マスク設定(MASKをOBJに|OBJへ)
        ftable[39] = {func:ModuleSwfFunc.gui_setMask, arg:2};
        // *秒待つ(N)
        ftable[40] = {func:ModuleSwfFunc.wait, arg:1};
        // *秒タイマー設定(EVENTにN|EVENTを|EVENTへ)
        ftable[41] = {func:ModuleSwfFunc.timer_set, arg:2};
        // *タイマー解除(IDの|IDを)
        ftable[42] = {func:ModuleSwfFunc.timer_clear, arg:1};
        // *SWFLOG(N)
        ftable[43] = {func:ModuleSwfFunc.swflog, arg:1};
        // *FSCOMMAND(CMD,PARAMS)
        ftable[44] = {func:ModuleSwfFunc._fscommand, arg:2};
        // *FSCOMMAND2(CMD,PARAMS)
        ftable[45] = {func:ModuleSwfFunc._fscommand2, arg:2};
        // *最後キー取得()
        ftable[51] = {func:ModuleSwfFunc.key_code, arg:0};
        // *文字キー取得()
        ftable[52] = {func:ModuleSwfFunc.key_getascii, arg:0};
        // *キー状態(KEYの)
        ftable[53] = {func:ModuleSwfFunc.key_isdown, arg:1};
        // *マウスポインタ可視設定(Bに|Bへ|Bで)
        ftable[54] = {func:ModuleSwfFunc.mouse_setVisible, arg:1};
        // *マウスポインタ可視取得()
        ftable[55] = {func:ModuleSwfFunc.mouse_getVisible, arg:0};
        // *マウスポインタ画像変更(IMAGEに)
        ftable[56] = {func:ModuleSwfFunc.mouse_changeImage, arg:1};
        // *キー押した時設定(EVENTに|EVENTを)
        ftable[57] = {func:ModuleSwfFunc.key_setDownEvent, arg:1};
        // *キー離した時設定(EVENTに|EVENTを)
        ftable[58] = {func:ModuleSwfFunc.key_setUpEvent, arg:1};
        // *開く(URLを|URLから)
        ftable[60] = {func:ModuleSwfFunc.net_read, arg:1};
        // *読込開始(URLをEVENTで|URLからEVENTへ|EVENTに)
        ftable[61] = {func:ModuleSwfFunc.net_readASync, arg:2};
        // *イベントデータ()
        ftable[62] = {func:ModuleSwfFunc.net_getEventData, arg:0};
        // *ポスト(URLにDATAを|URLへ)
        ftable[63] = {func:ModuleSwfFunc.net_post, arg:2};
        // *URL移動(URLに|URLへ|URLまで)
        ftable[64] = {func:ModuleSwfFunc.page_jump, arg:1};
        // *ローカル開く(FILEを|FILEから)
        ftable[80] = {func:ModuleSwfFunc.local_read, arg:1};
        // *ローカル保存(FILEにVを|FILEへ)
        ftable[81] = {func:ModuleSwfFunc.local_write, arg:2};
        // *演奏(URLを|URLで)
        ftable[90] = {func:ModuleSwfFunc.play, arg:1};
        // *演奏停止()
        ftable[91] = {func:ModuleSwfFunc.stop, arg:0};
        // *ラベル作成(TEXTの|TEXTで)
        ftable[100] = {func:ModuleSwfFunc.create_label, arg:1};
        // *エディタ作成(TEXTの|TEXTで)
        ftable[101] = {func:ModuleSwfFunc.create_edit, arg:1};
        // *リスト作成(ITEMSの|ITEMSで)
        ftable[102] = {func:ModuleSwfFunc.create_list, arg:1};
        // *スプライト作成()
        ftable[103] = {func:ModuleSwfFunc.create_sprite, arg:0};
        // *メモ作成(TEXTの|TEXTで)
        ftable[104] = {func:ModuleSwfFunc.create_memo, arg:1};
        // *ボタン作成(TEXTの|TEXTで)
        ftable[105] = {func:ModuleSwfFunc.create_button, arg:1};
        // *表示(Sを|Sと|Sで|Sの)
        ftable[106] = {func:ModuleSwfFunc.print, arg:1};
        // *グリッド作成(ITEMSで|ITEMSの)
        ftable[107] = {func:ModuleSwfFunc.create_grid, arg:1};
        // *カメ次郎召喚()
        ftable[120] = {func:ModuleSwfFunc.create_turtle, arg:0};
        // *歩進める(IDをN|IDが)
        ftable[121] = {func:ModuleSwfFunc.turtle_forward, arg:2};
        // *度右回転(IDをN|IDが)
        ftable[122] = {func:ModuleSwfFunc.turtle_right, arg:2};
        // *度左回転(IDをN|IDが)
        ftable[123] = {func:ModuleSwfFunc.turtle_left, arg:2};
        // *カメ待機(IDを|IDの)
        ftable[124] = {func:ModuleSwfFunc.turtle_wait, arg:1};
        // *値設定(OBJのPROPにVALUEを|PROPへ)
        ftable[130] = {func:ModuleSwfFunc.object_set, arg:3};
        // *値取得(OBJのPROPから|PROPを)
        ftable[131] = {func:ModuleSwfFunc.object_get, arg:2};
        // *SWF実行(OBJのMETHODをARGで)
        ftable[132] = {func:ModuleSwfFunc.object_call, arg:3};
        // *親部品設定(OBJが|OBJに|OBJへ)
        ftable[140] = {func:ModuleSwfFunc.gui_setParent, arg:1};
        // *親部品取得()
        ftable[141] = {func:ModuleSwfFunc.gui_getParent, arg:0};
        // *画面ホワイトアウト(Vで)
        ftable[150] = {func:ModuleSwfFunc.effect_whiteout, arg:1};
        // *画面スライド(OBJ1からOBJ2へVで)
        ftable[151] = {func:ModuleSwfFunc.effect_slide, arg:3};
        // *画面スライド2(OBJ1からOBJ2へVで)
        ftable[152] = {func:ModuleSwfFunc.effect_slide2, arg:3};

    }
}
/*
    // *作る(OBJをTYPEとして)="ModuleSwf"@0 // 2
    // GUI部品を作成する
    static function gui_create(arg:ModuleFunctionArg)
    {
    }
    // *設定(OBJのPROPにVを|PROPへ)="ModuleSwf"@1 // 3
    // GUI部品に値を設定する
    static function gui_set(arg:ModuleFunctionArg)
    {
    }
    // *取得(OBJのPROPを)="ModuleSwf"@2 // 2
    // GUI部品の値を取得する
    static function gui_get(arg:ModuleFunctionArg)
    {
    }
    // *アクティブ部品()="ModuleSwf"@3 // 0
    // イベントを発した部品番号を返す
    static function gui_getActive(arg:ModuleFunctionArg)
    {
    }
    // *移動(XX,YYに|YYへ)="ModuleSwf"@4 // 2
    // GUI部品初期配置位置を移動する
    static function gui_move(arg:ModuleFunctionArg)
    {
    }
    // *部品削除(OBJの|OBJを)="ModuleSwf"@5 // 1
    // GUI部品を削除する
    static function gui_remove(arg:ModuleFunctionArg)
    {
    }
    // *全部品削除()="ModuleSwf"@6 // 0
    // 全てのGUI部品を削除する
    static function gui_removeAll(arg:ModuleFunctionArg)
    {
    }
    // *最前面設定(OBJを)="ModuleSwf"@7 // 1
    // GUI部品OBJを最前面に移動する
    static function gui_bringToFront(arg:ModuleFunctionArg)
    {
    }
    // *センタリング(OBJを)="ModuleSwf"@8 // 1
    // GUI部品OBJを中央に移動する
    static function gui_setCenter(arg:ModuleFunctionArg)
    {
    }
    // *衝突判定(OBJ1とOBJ2で|OBJ2が|OBJ2の)="ModuleSwf"@9 // 2
    // GUI部品OBJ1とOBJ2が接触(衝突)しているか判定してはいかいいえを返す
    static function gui_hitTest(arg:ModuleFunctionArg)
    {
    }
    // *線(X1,Y1からX2,Y2へ|Y2に|Y2まで)="ModuleSwf"@10 // 4
    // 線を引く
    static function draw_line(arg:ModuleFunctionArg)
    {
    }
    // *四角(X1,Y1からX2,Y2へ|Y2に|Y2まで)="ModuleSwf"@11 // 4
    // 四角形(矩形)を描画する
    static function draw_rectangle(arg:ModuleFunctionArg)
    {
    }
    // *円描画(X1,Y1からX2,Y2へ|Y2に|Y2まで)="ModuleSwf"@12 // 4
    // 円を描画する
    static function draw_circle(arg:ModuleFunctionArg)
    {
    }
    // *多角形(ARRAYの|ARRAYで)="ModuleSwf"@13 // 1
    // 多角形を描画する
    static function draw_poly(arg:ModuleFunctionArg)
    {
    }
    // *画面クリア()="ModuleSwf"@14 // 0
    // 描画対象に描画された内容を消去する
    static function draw_clear(arg:ModuleFunctionArg)
    {
    }
    // *ブロック描画(W,HでDATAを)="ModuleSwf"@15 // 3
    // 幅W,高さHを1ブロックとして二次元配列DATAを描画
    static function draw_blocks(arg:ModuleFunctionArg)
    {
    }
    // *マウス落書モード開始()="ModuleSwf"@16 // 0
    // マウスで画面に落書できるようにする
    static function draw_mousepen_start(arg:ModuleFunctionArg)
    {
    }
    // *マウス落書モード終了()="ModuleSwf"@17 // 0
    // 落書モードを終了し、落書きデータ(マクロ文字列)を返す
    static function draw_mousepen_end(arg:ModuleFunctionArg)
    {
    }
    // *線色設定(COLORに)="ModuleSwf"@20 // 1
    // 線色を指定
    static function draw_setLineColor(arg:ModuleFunctionArg)
    {
    }
    // *線色取得()="ModuleSwf"@21 // 0
    // 線色を取得
    static function draw_getLineColor(arg:ModuleFunctionArg)
    {
    }
    // *線太さ設定(Wに)="ModuleSwf"@22 // 1
    // 線太さを指定
    static function draw_setLineWidth(arg:ModuleFunctionArg)
    {
    }
    // *線太さ取得()="ModuleSwf"@23 // 0
    // 線の太さを取得
    static function draw_getLineWidth(arg:ModuleFunctionArg)
    {
    }
    // *塗り色設定(COLORに)="ModuleSwf"@24 // 1
    // 塗り色を指定
    static function draw_setFillColor(arg:ModuleFunctionArg)
    {
    }
    // *塗り色取得()="ModuleSwf"@25 // 0
    // 塗り色を取得
    static function draw_getFillColor(arg:ModuleFunctionArg)
    {
    }
    // *透明度設定(PERCENTに)="ModuleSwf"@26 // 1
    // 塗り透明度を指定
    static function draw_setAlpha(arg:ModuleFunctionArg)
    {
    }
    // *透明度取得()="ModuleSwf"@27 // 0
    // 塗り透明度を取得
    static function draw_getAlpha(arg:ModuleFunctionArg)
    {
    }
    // *描画対象設定(OBJが|OBJに|OBJへ)="ModuleSwf"@28 // 1
    // 描画対象オブジェクトを指定
    static function draw_setTarget(arg:ModuleFunctionArg)
    {
    }
    // *描画対象取得()="ModuleSwf"@29 // 0
    // 描画対象オブジェクトのIDを返す
    static function draw_getTarget(arg:ModuleFunctionArg)
    {
    }
    // *フォントサイズ設定(SIZEに|SIZEへ)="ModuleSwf"@30 // 1
    // フォントサイズを設定
    static function font_setSize(arg:ModuleFunctionArg)
    {
    }
    // *フォントサイズ取得()="ModuleSwf"@31 // 0
    // フォントサイズを取得
    static function font_getSize(arg:ModuleFunctionArg)
    {
    }
    // *フォント色設定(COLに|COLへ)="ModuleSwf"@32 // 1
    // フォント色(0xRRGGBB)を設定
    static function font_setColor(arg:ModuleFunctionArg)
    {
    }
    // *フォント色取得()="ModuleSwf"@33 // 0
    // フォント色を取得
    static function font_getColor(arg:ModuleFunctionArg)
    {
    }
    // *フォント種類設定(NAMEに|NAMEへ)="ModuleSwf"@34 // 1
    // フォント種類(「_ゴシック」など)を設定
    static function font_setName(arg:ModuleFunctionArg)
    {
    }
    // *フォント種類取得()="ModuleSwf"@35 // 0
    // フォント種類を取得
    static function font_getName(arg:ModuleFunctionArg)
    {
    }
    // *RGB(R,G,B)="ModuleSwf"@36 // 3
    // Red,Green,Blueの3色を混ぜたカラーコードを返す
    static function rgb(arg:ModuleFunctionArg)
    {
    }
    // *マクロ描画(SをWAITで)="ModuleSwf"@37 // 2
    // マクロ文字列Sで描画する(WAITミリ秒ずつ描画)
    static function draw_macro(arg:ModuleFunctionArg)
    {
    }
    // *タイル描画(W,HでDATAを)="ModuleSwf"@38 // 3
    // 幅W,高さHを1タイルとして配列を描画(Fが透過色)。例)['01','12','23']
    static function draw_tiles(arg:ModuleFunctionArg)
    {
    }
    // *マスク設定(MASKをOBJに|OBJへ)="ModuleSwf"@39 // 2
    // GUI部品MASKをGUI部品OBJにマスクとして設定する
    static function gui_setMask(arg:ModuleFunctionArg)
    {
    }
    // *秒待つ(N)="ModuleSwf"@40 // 1
    // N秒待つ(ミリ秒も指定可能)
    static function wait(arg:ModuleFunctionArg)
    {
    }
    // *秒タイマー設定(EVENTにN|EVENTを|EVENTへ)="ModuleSwf"@41 // 2
    // N秒後にEVENT関数(文字列で指定)を呼ぶタイマーを設定し、タイマーIDを得る
    static function timer_set(arg:ModuleFunctionArg)
    {
    }
    // *タイマー解除(IDの|IDを)="ModuleSwf"@42 // 1
    // 「秒タイマー設定」命令で得たタイマーIDを指定してタイマーを解除する
    static function timer_clear(arg:ModuleFunctionArg)
    {
    }
    // *SWFLOG(N)="ModuleSwf"@43 // 1
    // SWFLOG
    static function swflog(arg:ModuleFunctionArg)
    {
    }
    // *FSCOMMAND(CMD,PARAMS)="ModuleSwf"@44 // 2
    // 拡張機能(fscommand)でCMDにPARAMSで呼び出す
    static function _fscommand(arg:ModuleFunctionArg)
    {
    }
    // *FSCOMMAND2(CMD,PARAMS)="ModuleSwf"@45 // 2
    // 拡張機能(fscommand2)でCMDにPARAMSで呼び出し、結果を返す
    static function _fscommand2(arg:ModuleFunctionArg)
    {
    }
    // *最後キー取得()="ModuleSwf"@51 // 0
    // 最後に押されたキーコードを得る
    static function key_code(arg:ModuleFunctionArg)
    {
    }
    // *文字キー取得()="ModuleSwf"@52 // 0
    // 文字キーの状態を調べる
    static function key_getascii(arg:ModuleFunctionArg)
    {
    }
    // *キー状態(KEYの)="ModuleSwf"@53 // 1
    // KEYを押下中か状態を調べる。押されていれば1、押されてなければ0
    static function key_isdown(arg:ModuleFunctionArg)
    {
    }
    // *マウスポインタ可視設定(Bに|Bへ|Bで)="ModuleSwf"@54 // 1
    // マウスポインタを表示するか設定する
    static function mouse_setVisible(arg:ModuleFunctionArg)
    {
    }
    // *マウスポインタ可視取得()="ModuleSwf"@55 // 0
    // マウスポインタを表示するか調べて返す
    static function mouse_getVisible(arg:ModuleFunctionArg)
    {
    }
    // *マウスポインタ画像変更(IMAGEに)="ModuleSwf"@56 // 1
    // マウスポインタを表示する画像を変更する(IMAGEには画像ファイル名を指定)
    static function mouse_changeImage(arg:ModuleFunctionArg)
    {
    }
    // *キー押した時設定(EVENTに|EVENTを)="ModuleSwf"@57 // 1
    // キー押した時のイベントを設定する
    static function key_setDownEvent(arg:ModuleFunctionArg)
    {
    }
    // *キー離した時設定(EVENTに|EVENTを)="ModuleSwf"@58 // 1
    // キー離した時のイベントを設定する
    static function key_setUpEvent(arg:ModuleFunctionArg)
    {
    }
    // *開く(URLを|URLから)="ModuleSwf"@60 // 1
    // URLにあるデータを取得して返す
    static function net_read(arg:ModuleFunctionArg)
    {
    }
    // *読込開始(URLをEVENTで|URLからEVENTへ|EVENTに)="ModuleSwf"@61 // 2
    // URLにあるデータの読み込みを開始する。読み終わったらEVENT関数(文字列で指定)が呼ばれる。データは「イベントデータ」に入る。
    static function net_readASync(arg:ModuleFunctionArg)
    {
    }
    // *イベントデータ()="ModuleSwf"@62 // 0
    // イベントが起きたときデータが代入される
    static function net_getEventData(arg:ModuleFunctionArg)
    {
    }
    // *ポスト(URLにDATAを|URLへ)="ModuleSwf"@63 // 2
    // URLにデータDATA(ハッシュ形式)をポストし、サーバーからの応答を取得して返す
    static function net_post(arg:ModuleFunctionArg)
    {
    }
    // *URL移動(URLに|URLへ|URLまで)="ModuleSwf"@64 // 1
    // URLにページを移動する
    static function page_jump(arg:ModuleFunctionArg)
    {
    }
    // *ローカル開く(FILEを|FILEから)="ModuleSwf"@80 // 1
    // ブラウザローカル領域(SharedObject)のFILEを読み込んで返す
    static function local_read(arg:ModuleFunctionArg)
    {
    }
    // *ローカル保存(FILEにVを|FILEへ)="ModuleSwf"@81 // 2
    // ブラウザローカル領域(SharedObject)のFILEへVを書き込む
    static function local_write(arg:ModuleFunctionArg)
    {
    }
    // *演奏(URLを|URLで)="ModuleSwf"@90 // 1
    // URLにある音声ファイルを演奏する
    static function play(arg:ModuleFunctionArg)
    {
    }
    // *演奏停止()="ModuleSwf"@91 // 0
    // 演奏を中止する
    static function stop(arg:ModuleFunctionArg)
    {
    }
    // *ラベル作成(TEXTの|TEXTで)="ModuleSwf"@100 // 1
    // TEXTのラベルを作成して、IDを返す
    static function create_label(arg:ModuleFunctionArg)
    {
    }
    // *エディタ作成(TEXTの|TEXTで)="ModuleSwf"@101 // 1
    // TEXTの内容でエディタを作成して、IDを返す
    static function create_edit(arg:ModuleFunctionArg)
    {
    }
    // *リスト作成(ITEMSの|ITEMSで)="ModuleSwf"@102 // 1
    // ITEMSを持つリストを作成して、IDを返す
    static function create_list(arg:ModuleFunctionArg)
    {
    }
    // *スプライト作成()="ModuleSwf"@103 // 0
    // スプライトを作成して、IDを返す
    static function create_sprite(arg:ModuleFunctionArg)
    {
    }
    // *メモ作成(TEXTの|TEXTで)="ModuleSwf"@104 // 1
    // TEXTの内容でメモを作成して、IDを返す
    static function create_memo(arg:ModuleFunctionArg)
    {
    }
    // *ボタン作成(TEXTの|TEXTで)="ModuleSwf"@105 // 1
    // TEXTのボタンを作成して、IDを返す
    static function create_button(arg:ModuleFunctionArg)
    {
    }
    // *表示(Sを|Sと|Sで|Sの)="ModuleSwf"@106 // 1
    // 画面にSを表示する(実際はラベルを作成してIDを返す)
    static function print(arg:ModuleFunctionArg)
    {
    }
    // *グリッド作成(ITEMSで|ITEMSの)="ModuleSwf"@107 // 1
    // ITEMSを持つグリッドを作成し、IDを返す
    static function create_grid(arg:ModuleFunctionArg)
    {
    }
    // *カメ次郎召喚()="ModuleSwf"@120 // 0
    // カメ次郎を召喚してIDを返す
    static function create_turtle(arg:ModuleFunctionArg)
    {
    }
    // *歩進める(IDをN|IDが)="ModuleSwf"@121 // 2
    // カメ次郎IDをN歩前へ進ませる
    static function turtle_forward(arg:ModuleFunctionArg)
    {
    }
    // *度右回転(IDをN|IDが)="ModuleSwf"@122 // 2
    // カメ次郎IDをN度右回転させる
    static function turtle_right(arg:ModuleFunctionArg)
    {
    }
    // *度左回転(IDをN|IDが)="ModuleSwf"@123 // 2
    // カメ次郎IDをN度左回転させる
    static function turtle_left(arg:ModuleFunctionArg)
    {
    }
    // *カメ待機(IDを|IDの)="ModuleSwf"@124 // 1
    // カメ次郎IDの動作終了まで待機する
    static function turtle_wait(arg:ModuleFunctionArg)
    {
    }
    // *値設定(OBJのPROPにVALUEを|PROPへ)="ModuleSwf"@130 // 3
    // FlashのオブジェクトOBJのプロパティPROPに値VALUEを代入する(OBJ/PROPは文字列で指定)
    static function object_set(arg:ModuleFunctionArg)
    {
    }
    // *値取得(OBJのPROPから|PROPを)="ModuleSwf"@131 // 2
    // FlashのオブジェクトOBJのプロパティPROPを取得して返す(OBJ/PROPは文字列で指定)
    static function object_get(arg:ModuleFunctionArg)
    {
    }
    // *SWF実行(OBJのMETHODをARGで)="ModuleSwf"@132 // 3
    // FlashのオブジェクトOBJのMETHODを引数ARGで呼んで結果を返す(OBJ/METHODは文字列で指定)
    static function object_call(arg:ModuleFunctionArg)
    {
    }
    // *親部品設定(OBJが|OBJに|OBJへ)="ModuleSwf"@140 // 1
    // これから生成する部品の親オブジェクトのIDを指定
    static function gui_setParent(arg:ModuleFunctionArg)
    {
    }
    // *親部品取得()="ModuleSwf"@141 // 0
    // これから生成する部品の親オブジェクトのIDを返す
    static function gui_getParent(arg:ModuleFunctionArg)
    {
    }
    // *画面ホワイトアウト(Vで)="ModuleSwf"@150 // 1
    // 画面を塗り色でホワイトアウトする(Vには速度を,10が普通)
    static function effect_whiteout(arg:ModuleFunctionArg)
    {
    }
    // *画面スライド(OBJ1からOBJ2へVで)="ModuleSwf"@151 // 3
    // 画面を表す部品OBJ1からOBJ2へスライドする(Vは速度,10が普通)
    static function effect_slide(arg:ModuleFunctionArg)
    {
    }
    // *画面スライド2(OBJ1からOBJ2へVで)="ModuleSwf"@152 // 3
    // 画面を表す部品OBJ1からOBJ2へスライドする(Vは速度,10が普通,塗り色でホワイトアウト)
    static function effect_slide2(arg:ModuleFunctionArg)
    {
    }

*/
