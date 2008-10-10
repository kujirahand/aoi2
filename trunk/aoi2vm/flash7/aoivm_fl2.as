﻿

class aoivm_fl2 {
    
    //----------------------------------
    // 下記を自動で書き換える
    //----------------------------------
    //<aoi-ircode>
    static var code = 

{type:"aoi",version:1000,maker:"aoic",time:1177563038468,
ir:"i0,t172,~131089,i1,D2,i0,h,=,i2,D2,i1,h,=,i3,D2,i2,h,=,D2,T1,~65541,D1,l41,T4,D4,l40,T5,i0,T3,D3,D5,G,N46,D4,D3,h,T0,D3,i1,+,T3,D0,u6,p,~65543,J29,l0,p,~65545,q,~131186,D2,i102,l256,p,~131187,D2,s0,D1,l257,p,~131188,D2,T0,~131189,r,~131192,D2,i101,l256,p,~131193,D2,s0,D1,l257,p,~131194,D2,T0,~131195,r,~131198,D2,i100,l256,p,~131199,D2,s0,D1,l257,p,~131200,D2,s1,s2,D1,&,s1,&,l257,p,~131201,D2,T0,~131202,r,~131205,D2,i103,l256,p,~131206,D2,s3,D1,l257,p,~131207,D2,T0,~131208,r,~131211,D1,i104,l256,p,~131212,D1,T0,~131213,r,~131216,D1,i105,l256,p,~131217,D1,T0,~131218,r,D1,u0,p,~131221,r",
string_table:["テキスト","イベント","","アイテム"],
func_table:[{name:"ラベル作成",args:1,addr:51},{name:"エディタ作成",args:1,addr:67},{name:"ボタン作成",args:1,addr:83},{name:"リスト作成",args:1,addr:109},{name:"スプライト作成",args:0,addr:125},{name:"メモ作成",args:0,addr:135},{name:"表示",args:1,addr:144}],
module_table:[{name:"ModuleSystem",args:[0,0,0,0,2,0,0,0,0,0,1,2,3,1,1,3,3,3,2,2,2,2,3,1,1,2,0,0,0,0,0,0,0,2,2,2,2,0,0,0,1,1,1,0,0,0,0,0,0,0,2,2,3,1,3,3,1,1,1,2,2,1,1,3,4,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,2,1,1,1,1,1,1,1,1,1,1,1,2,1]},{name:"ModuleSwf",args:[2,3,2,0,2,1,0,1,1,0,4,4,4,1,0,3,0,0,0,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,0,0,0,0,1,2,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,1,2,0,2]}],
variable_table:["オン","オフ","い","いいえ","空","タブ","改行","終","終了","実行環境","葵バージョン","描画処理反映","代入","文字数","検索","文字列検索","置換","文字置換","文字コード取得","ASC","文字コード変換","CHR","文字挿入","文字削除","文字抜出","文字左部分","文字右部分","切取","区切","単置換","空白除去","トリム","通貨形式","ゼロ埋","システム時間","今日","今","日付加算","時間加算","日数差","秒差","要素数","ハッシュキー列挙","ハッシュ値列挙","配列追加","配列削除","配列挿入","配列要素数","配列検索","配列一括挿入","配列数値ソート","配列ソート","配列逆順","配列結合","配列連結","配列シャッフル","CSV取得","表ピックアップ","表数値ピックアップ","言","尋","二択","INT","STR","TRUNC","切捨","ROUND","四捨五入","ABS","絶対値","SIN","COS","TAN","ASIN","ACOS","ATAN","SQRT","EXP","LOG","乱数","乱数範囲","サイコロ振","ボタン","エディタ","ラベル","リスト","スプライト","メモ","黒色","赤色","青色","黄色","緑色","紫色","水色","白色","カーソル左","カーソル上","カーソル右","カーソル下","スペースキー","エンターキー","BSキー","TABキー","SHIFTキー","CTRLキー","WII上","WII下","WII右","WII左","WIIAボタン","WIIBボタン","WIIプラス","WIIマイナス","作","設定","取得","アクティブ部品","移動","部品削除","全部品削除","最前面設定","センタリング","線","四角","円描画","多角形","画面クリア","ブロック描画","線色設定","線色取得","線太設定","線太取得","塗色設定","塗色取得","透明度設定","透明度取得","描画対象設定","描画対象取得","フォントサイズ設定","フォントサイズ取得","フォント色設定","フォント色取得","フォント種類設定","フォント種類取得","秒待","秒タイマー設定","タイマー解除","SWFLOG","最後キー取得","文字キー取得","キー状態","読","開","読込開始","イベントデータ","ポスト","ラベル作成","エディタ作成","ボタン作成","リスト作成","スプライト作成","メモ作成","表示","線太","線色","塗色","透明度","描画対象","フォントサイズ","フォント色","フォント種類","母艦"]}

    ;
    //</aoi-ircode>
    
    //----------------------------------
    // 唯一のエントリポイント
    //----------------------------------
    static function main() {
        // set debug mode
        KLog.isTest   = false;
        KLog.LOG_SIZE = 256;
        
        // 仮想マシン本体を作成
        var vm:ALoader = new ALoader();
        // 引数をチェック
        vm.checkFlashVars();
        // ModuleSwfをロード(FlashLite2のみ)
        ModuleSystemFunction.init();
        ModuleSwfFunc.init();
        // FlashLite2用に負荷を下げる(もし途中で止まるようなら、これを下げる)
        Stackmachine.frame_speed = 20;
        // コードをセットして実行
        vm.setMainCode(code);
    }
}
