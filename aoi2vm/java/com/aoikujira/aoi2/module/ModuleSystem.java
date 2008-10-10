/*
 * ModuleSystem.java
 * Created on 2007/04/25, 23:42
 */

package com.aoikujira.aoi2.vm.module;

import java.text.NumberFormat;
import java.util.Calendar;
import java.util.Date;

import com.aoikujira.aoi2.avalue.AValue;
import com.aoikujira.aoi2.avalue.AValueVector;
import com.aoikujira.aoi2.compiler.CurString;
import com.aoikujira.aoi2.vm.*;
import com.aoikujira.utils.*;

public class ModuleSystem {
    
    public ModuleSystem() {
    }
        
    public void aoimodule_call(int func_no, AFunctionArg arg) {
        ModuleSystemTable.call(func_no, arg);
    }
    public int aoimodule_getArgCount(int id) {
        return ModuleSystemTable.getArgCount(id);
    }
    
    // *終了() .. プログラムの実行を終了する
    public static void quit(AFunctionArg arg) {
        arg.mac.flag_quit = true;
    }
    
    // *実行環境() .. 実行環境の種類を返す
    public static void platform(AFunctionArg arg) {
        arg.result = new AValue("Java");
    }
    
    // *葵バージョン() .. 葵のバージョンを返す
    public static void vm_version(AFunctionArg arg) {
        arg.result = new AValue(aoivm.VERSION);
    }
    
    // *描画処理反映() .. 描画を促す
    public static void reflesh(AFunctionArg arg) {
    }
    // *代入(EをVARに|EからVARへ) .. 代入を行う。VARの値をEに書き換える。
    public static void let(AFunctionArg arg) {
        AValue e = arg.getArg(0);
        AValue v = arg.getArg(1);
        e = e.getLink();
        v = v.getLink();
        v.setValue(e);
        arg.result = v;
    }
    
    // *文字数(Sの) .. Sの文字数を返す
    public static void str_length(AFunctionArg arg) {
        String s = arg.getStr(0);
        arg.result = new AValue(s.length());
    }
    
    // *文字列検索(SからAを|Sで|Sの) .. 文字列Sから検索文字列Aを検索してその位置を返す(見つからないと0を返す)
    public static void str_indexof(AFunctionArg arg) {
        String s1 = arg.getStr(0);
        String s2 = arg.getStr(1);
        int i = s1.indexOf(s2);
        arg.setResult(i);
    }
    
    // *文字置換(SのAをBに|SでAからBへ) .. 文字列Sの検索文字列Aを置換文字列Bに置換して返す
    public static void str_replace(AFunctionArg arg) {
        // get arguments
        String ss = arg.getStr(0);
        String sa = arg.getStr(1);
        String sb = arg.getStr(2);
        // process
        ss = KUtils.replaceAll(ss, sa, sb);
        // set result
        arg.setResult(ss);
    }
    
    // *ASC(S) .. 文字列Sの1文字目の文字コードを返す
    public static void asc(AFunctionArg arg) {
        String s = arg.getStr(0);
        int asc = 0;
        if (s.length() > 0) {
            asc = s.charAt(0);
        }
        arg.setResult(asc);
    }
    
    // *CHR(V) .. 文字コードVに対応した文字を返す
    public static void chr(AFunctionArg arg) {
        int chr = arg.getInt(0);
        arg.setResult((String)"" + (char)chr);
    }
    
    // *文字挿入(SのIにAを|Sで) .. 文字列SのI文字目にAを挿入して返す
    public static void str_insert(AFunctionArg arg) {
        String    s = arg.getStr(0);
        int       i = arg.getInt(1) - 1;
        String    a = arg.getStr(2);
        String    r = s.substring(0, i);
        r += a + r.substring(i, s.length());
        arg.setResult(r);
    }
    
    // *文字削除(SのIからCNTを|Sで) .. 文字列SのI文字目からCNT文字削除して返す
    public static void str_delete(AFunctionArg arg) {
        String  s   = arg.getStr(0);
        int    i   = arg.getInt(1) - 1;
        int    cnt = arg.getInt(2);
        String mae = s.substring(0, i);
        String usiro = s.substring(i+cnt, s.length());
        arg.setResult(mae + usiro);
    }
    
    // *文字抜き出す(SのIからCNTを|Sで) .. 文字列SのI文字目からCNT文字を抜き出して返す
    public static void str_mid(AFunctionArg arg) {
        String s   = arg.getStr(0);
        int    i   = arg.getInt(1) - 1;
        int    cnt = arg.getInt(2);
        int    len = i + cnt;
        if (i < 0) i = 0;
        if (len >= s.length()) len = s.length();
        s = s.substring(i, len);
        arg.setResult(s);
    }
    
    // *文字左部分(SのCNT|Sから) .. 文字列Sの左からCNT文字を抜き出して返す
    public static void str_left(AFunctionArg arg) {
        String  s   = arg.getStr(0);
        int    cnt = arg.getInt(1);
        s = s.substring(0, cnt);
        arg.setResult(s);
    }
    
    // *文字右部分(SのCNT|Sから) .. 文字列Sの右からCNT文字を抜き出して返す
    public static void str_right(AFunctionArg arg) {
        String  s   = arg.getStr(0);
        int    cnt = arg.getInt(1);
        s = s.substring(s.length() - cnt, s.length());
        arg.setResult(s);
    }
    
    // *切り取る(SからAまで|SのAまでを) .. 文字列Sから区切り文字列Aまでを切り取って返す(Sの内容を変更する)
    public static void str_getToken(AFunctionArg arg) {
        AValue s = arg.getArg(0); s = s.getLink();
        String a = arg.getStr(1);
        CurString cur = new CurString(s.getAsStr());
        String res = cur.getToken(a);
        s.type  = AValue.typeStr;
        s.value = new String(cur.getStringAfterIndex());
        arg.setResult(res);
    }
    
    // *区切る(SをAで|Sの) .. 文字列Sを区切り文字Aで区切って配列変数として返す
    public static void str_split(AFunctionArg arg) {
        String s = arg.getStr(0);
        String a = arg.getStr(1);
        StringVector sv = KUtils.str_split(s, a);
        AValue res = new AValue();
        res.array_setStringVecotr(sv);
        arg.result = res;
    }
    
    // *単置換(SのAをBに|Sから|Sで) .. 文字列Sで検索文字列Aを置換文字列Bで最初の1つを置換して返す
    public static void str_replaceOne(AFunctionArg arg) {
        String s = arg.getStr(0);
        String a = arg.getStr(1);
        String b = arg.getStr(2);
        String res = KUtils.replaceOne(s, a, b);
        arg.setResult(res);
    }
    
    // *トリム(Sの|Sから|Sで) .. 文字列Sの前後の空白を除去して返す
    public static void str_trim(AFunctionArg arg) {
        arg.setResult(KUtils.trim(arg.getStr(0)));
    }
    
    // *通貨形式(Vを|Vの) .. 通貨書式(3桁カンマ区切り)にして返す
    public static void format_yen(AFunctionArg arg) {
        double v = arg.getNum(0);
        String f = NumberFormat.getNumberInstance().format(v);
        arg.setResult(f);
    }
    
    // *ゼロ埋め(VをCNTで|VへCNTの) .. VをCNT桁の0で埋めて返す
    public static void format_zero(AFunctionArg arg) {
        String  v   = arg.getStr(0);
        int     cnt = arg.getInt(1);
        arg.setResult(KUtils.str_fillZero(v, cnt));
    }
    
    // *システム時間() .. 1970-1-1からのミリ秒を返す
    public static void time_system(AFunctionArg arg) {
        Date d = new Date();
        long msec = d.getTime();
        arg.setResult(msec);
    }
    
    // *今日() .. 今日の日付をyyyy-mm-ddの形式で返す
    public static void date_today(AFunctionArg arg) {
        String s = KUtils.date_toString(Calendar.getInstance());
        arg.setResult(s);
    }
    
    // *今() .. 今の時間をhh:nn:ssの形式で返す
    public static void time_now(AFunctionArg arg) {
        String s = KUtils.time_toString(Calendar.getInstance());
        arg.setResult(s);
    }
    
    // *日付加算(SにAを|Sへ) .. 日付SにAを加算して返す。日付は「yyyy-mm-dd」の形式で指定。減算するときは「-yyy-mm-dd」と指定
    public static void date_add(AFunctionArg arg) {
        // get arg
        String s = arg.getStr(0);
        String a = arg.getStr(1);
        // convert
        Calendar s_cal = KUtils.str_toDate(s);
        int flag = 1;
        if (a.charAt(0) == '-') {
            flag = -1; a = a.substring(1);
        }
        if (a.charAt(0) == '+') {
            flag = 1; a = a.substring(1);
        }
        // separator
        String splitter = "-";
        if (a.indexOf("/") >= 0) splitter = "/";
        if (a.indexOf(".") >= 0) splitter = ".";
        StringVector a_ary = KUtils.str_split(a, splitter);
        int a_yy = 0;
        int a_mm = 0;
        int a_dd = 0;
        if (a_ary.size() >= 3) {
            a_yy = Integer.parseInt(a_ary.getStr(0));
            a_mm = Integer.parseInt(a_ary.getStr(1));
            a_dd = Integer.parseInt(a_ary.getStr(2));
        }
        else if (a_ary.size() >= 2) {
            a_mm = Integer.parseInt(a_ary.getStr(0));
            a_dd = Integer.parseInt(a_ary.getStr(1));
        }
        else if (a_ary.size() >= 1) {
            a_dd = Integer.parseInt(a_ary.getStr(0));
        }
        // calc
        s_cal.roll(Calendar.YEAR,  a_yy * flag);
        s_cal.roll(Calendar.MONTH, a_mm * flag);
        s_cal.roll(Calendar.DATE,  a_dd * flag);
        //
        String res = KUtils.date_toString(s_cal);
        arg.setResult(res);
    }
    
    // *時間加算(SにAを|Sへ) .. 時間SにAを加算して返す。時間は「hh:nn:ss」の形式で指定。減算するときは「-hh:nn:ss」と指定
    public static void time_add(AFunctionArg arg) {
        // get arg
        String s = arg.getStr(0);
        String a = arg.getStr(1);
        // convert
        Calendar s_cal = KUtils.str_toTime(s);
        int flag = 1;
        if (a.charAt(0) == '-') {
            flag = -1; a = a.substring(1);
        }
        if (a.charAt(0) == '+') {
            flag = 1; a = a.substring(1);
        }
        // separator
        StringVector a_ary = KUtils.str_split(a, ":");
        int a_hh = 0;
        int a_nn = 0;
        int a_ss = 0;
        if (a_ary.size() >= 3) {
            a_hh = Integer.parseInt(a_ary.getStr(0));
            a_nn = Integer.parseInt(a_ary.getStr(1));
            a_ss = Integer.parseInt(a_ary.getStr(2));
        }
        else if (a_ary.size() >= 2) {
            a_hh = Integer.parseInt(a_ary.getStr(0));
            a_nn = Integer.parseInt(a_ary.getStr(1));
        }
        else if (a_ary.size() >= 1) {
            a_hh = Integer.parseInt(a_ary.getStr(0));
        }
        // calc
        s_cal.roll(Calendar.HOUR,   a_hh * flag);
        s_cal.roll(Calendar.MINUTE, a_nn * flag);
        s_cal.roll(Calendar.SECOND, a_ss * flag);
        //
        String res = KUtils.time_toString(s_cal);
        arg.setResult(res);
    }
    
    // *日数差(SとAの|SからAまでの) .. 日付SからAまでの日数差を返す。日付は「yyyy-mm-dd」の形式で指定。
    public static void date_sub(AFunctionArg arg) {
        String s = arg.getStr(0);
        String a = arg.getStr(1);
        Calendar cs = KUtils.str_toDate(s);
        Calendar ca = KUtils.str_toDate(a);
        long tm_s = cs.getTime().getTime();
        long tm_a = ca.getTime().getTime();
        long sa = tm_a - tm_s;
        sa = sa / ( 24 * 60 * 60 * 1000 );
        arg.setResult(sa);
    }
    
    // *秒差(SとAの|SからAまでの) .. 時間SからAまでの時間差を返す。時間は「hh:nn:ss」の形式で指定。
    public static void time_sub(AFunctionArg arg) {
        String s = arg.getStr(0);
        String a = arg.getStr(1);
        Calendar cs = KUtils.str_toTime(s);
        Calendar ca = KUtils.str_toTime(a);
        long tm_s = cs.getTime().getTime();
        long tm_a = ca.getTime().getTime();
        long sa = tm_a - tm_s;
        sa = sa / 1000;
        arg.setResult(sa);
    }
    
    // *配列要素数(Aの) .. 配列変数Aに含まれる値の数を返す
    public static void count(AFunctionArg arg) {
        AValue a = arg.getArg(0);
        a.array_create();
        arg.setResult(a.array_length());
    }
    
    // *ハッシュキー列挙(Sから|Sの) .. 配列変数Sのキーを配列形式で返す
    public static void hash_keys(AFunctionArg arg) {
        AValue a = arg.getArg(0);
        AValue res = new AValue();
        
        if (a.type == AValue.typeArray) {
            arg.result = a;
            return;
        }
        res.array_create();
        a.hash_create();
        StringVector sv = a.hash_keys();
        res.array_setStringVecotr(sv);
        arg.result = res;
    }
    
    // *ハッシュ値列挙(Sから|Sの) .. 文字列Sから検索文字列Aを検索してその番号を返す
    public static void hash_values(AFunctionArg arg) {
        AValue a = arg.getArg(0);
        AValue res = new AValue();
        
        if (a.type == AValue.typeArray) {
            arg.result = a;
            return;
        }
        
        res.array_create();
        a.hash_create();
        StringVector sv = a.hash_keys();
        for (int i = 0; i < sv.size(); i++) {
            String key = sv.getStr(i);
            AValue v   = a.hash_get(key);
            res.array_set(i, v);
        }
        arg.result = res;
    }
    
    // *配列追加(AにSを|Aへ) .. 配列Aに値Sを追加して返す(配列A自身に変更)
    public static void array_add(AFunctionArg arg) {
        AValue a = arg.getArg(0);
        AValue s = arg.getArg(1);
        a = a.getLink();
        a.array_create();
        a.array_add(s);
    }
    
    // *配列削除(AからIを|Aの) .. 配列AのI番目を削除して返す(配列A自身を変更)
    public static void array_delete(AFunctionArg arg) {
        AValue a = arg.getArg(0);
        int i = arg.getInt(1);
        a = a.getLink();
        a.array_create();
        AValueVector av = (AValueVector)a.value;
        av.remove(i);
        arg.result = new AValue();
        arg.result.setLink(a);
    }
    
    // *配列挿入(AのIへSを|Iに) .. 配列Aの要素I番に値Sを挿入して返す(配列A自身を変更)
    public static void array_insert(AFunctionArg arg) {
        AValue a = arg.getArg(0);
        int i = arg.getInt(1);
        AValue s = arg.getArg(2);
        a = a.getLink();
        s = s.getLink();
        a.array_create();
        s.array_create();
        AValueVector av = (AValueVector)a.value;
        AValueVector sv = (AValueVector)s.value;
        for (int j = 0; j < sv.size(); j++) {
            AValue v = sv.getAValue(j);
            if (v == null) { v = new AValue(); }
            AValue new_v = v.cloneAValue();
            int index = i + j;
            while (av.size() < index) { av.add(new AValue()); }
            av.insertElementAt(new_v, index);
        }
        arg.result = a;
    }
    
    // *配列検索(AのIからKEYを|Aで) .. 配列Aの要素I番からKEYを検索してそのインデックス番号を返す。見つからなければ0を返す
    public static void array_indexof(AFunctionArg arg) {
        throw new RuntimeException("TODO");
    }
    
    // *配列一括挿入(AのIへBを|Iに) .. 配列Aの要素I番に配列変数Bを挿入して返す(配列A自身を変更)
    public static void array_insertArray(AFunctionArg arg) {
        throw new RuntimeException("TODO");
    }
    
    // *配列数値ソート(Aを|Aの) .. 配列Aを数値順にソートして返す(配列A自身を変更)
    public static void array_sortNum(AFunctionArg arg) {
        throw new RuntimeException("TODO");
    }
    
    // *配列ソート(Aを|Aの) .. 配列Aを文字列順にソートして返す(配列A自身を変更)
    public static void array_sortStr(AFunctionArg arg) {
        throw new RuntimeException("TODO");
    }
    
    // *配列逆順(Aの|Aを) .. 配列Aの要素を逆さまにして返す(配列A自身を変更)
    public static void array_reverse(AFunctionArg arg) {
        throw new RuntimeException("TODO");
    }
    
    // *配列連結(AをSで) .. 配列変数Aを文字列Sを区切りとして連結させて返す(A[0] s a[1] s a[2]..)
    public static void array_join(AFunctionArg arg) {
        throw new RuntimeException("TODO");
    }
    
    // *配列シャッフル(Aの|Aを) .. 配列Aの要素をランダムに入れ替えて返す(配列A自身を変更)
    public static void array_random(AFunctionArg arg) {
        throw new RuntimeException("TODO");
    }
    
  // *CSV取得(Sを|Sから) .. CSV形式の文字列データを二次元配列に変換して返す。
  public static void csv_toArray(AFunctionArg arg) {
   throw new RuntimeException("TODO");
  }
  
  // *表ピックアップ(AのIからVを) .. 二次元配列AのI列目(0起点)からVに合致する行を二次元配列変数の形式で返す。
  public static void csv_pickup(AFunctionArg arg) {
   throw new RuntimeException("TODO");
  }
  // *表数値ピックアップ(AのIからVをRANGEで) .. 二次元配列AのI列目(0起点)からVの前後RANGE以内に合致する行を二次元配列変数の形式で返す。
  public static void csv_pickupNum(AFunctionArg arg) {
   throw new RuntimeException("TODO");
  }
    // *言う(Sを|Sと|Sで|Sの) .. ダイアログに文字列Sを表示して待機する
    public static void dialog_say(AFunctionArg arg) {
        throw new RuntimeException("TODO");
    }
    
    // *尋ねる(Sと|Sで|Sの|Sを) .. 一行入力ダイアログに質問Sを表示して待機し、入力結果を返す
    public static void dialog_input(AFunctionArg arg) {
        throw new RuntimeException("TODO");
    }
    
    // *二択(Sと|Sで|Sの|Sを) .. はい/いいえで答えるダイアログと質問Sを表示して待機し、結果を返す
    public static void dialog_yesno(AFunctionArg arg) {
        throw new RuntimeException("TODO");
    }
    
    // *INT(V) .. 整数に変換して返す
    public static void cint(AFunctionArg arg) {
        int v = arg.getInt(0);
        arg.setResult(v);
    }
    
    // *STR(V) .. 文字列に変換して返す
    public static void cstr(AFunctionArg arg) {
        String v = arg.getStr(0);
        arg.setResult(v);
    }
    
    // *切捨て(Vを) .. 小数点以下を切り捨てて返す
    public static void trunc(AFunctionArg arg) {
        throw new RuntimeException("TODO");
    }
    
    // *ROUND(V) .. 小数点以下を丸めて返す
    public static void round(AFunctionArg arg) {
        double v = arg.getNum(0);
        int iv = (int)Math.round(v);
        arg.setResult(iv);
    }
    
    // *四捨五入(VをKで) .. 数値VをKの桁で四捨五入して返す(1,10,100のように指定する)
    public static void sisyagonyu(AFunctionArg arg) {
        throw new RuntimeException("TODO");
    }
    
    // *絶対値(Vの) .. 絶対値を返す
    public static void abs(AFunctionArg arg) {
        double v = arg.getNum(0);
        v = Math.abs(v);
        arg.setResult(v);
    }
    
    // *SIN(V) .. SINを返す
    public static void sin(AFunctionArg arg) {
        double v = arg.getNum(0);
        v = Math.sin(v);
        arg.setResult(v);
    }
    
    // *COS(V) .. COSを返す
    public static void cos(AFunctionArg arg) {
        double v = arg.getNum(0);
        v = Math.cos(v);
        arg.setResult(v);
    }
    
    // *TAN(V) .. TANを返す
    public static void tan(AFunctionArg arg) {
        double v = arg.getNum(0);
        v = Math.tan(v);
        arg.setResult(v);
    }
    
    // *ASIN(V) .. ASINを返す
    public static void asin(AFunctionArg arg) {
        double v = arg.getNum(0);
        v = Math.asin(v);
        arg.setResult(v);
    }
    
    // *ACOS(V) .. ACOSを返す
    public static void acos(AFunctionArg arg) {
        double v = arg.getNum(0);
        v = Math.acos(v);
        arg.setResult(v);
    }
    
    // *ATAN(V) .. ATANを返す
    public static void atan(AFunctionArg arg) {
        double v = arg.getNum(0);
        v = Math.atan(v);
        arg.setResult(v);
    }
    
    // *SQRT(V) .. SQRTを返す
    public static void sqrt(AFunctionArg arg) {
        double v = arg.getNum(0);
        v = Math.sqrt(v);
        arg.setResult(v);
    }
    
    // *EXP(V) .. EXPを返す
    public static void exp(AFunctionArg arg) {
        double v = arg.getNum(0);
        v = Math.exp(v);
        arg.setResult(v);
    }
    
    // *LOG(V) .. LOGを返す
    public static void log(AFunctionArg arg) {
        double v = arg.getNum(0);
        v = Math.log(v);
        arg.setResult(v);
    }
    
    // *乱数(Vの) .. (0からV-1まで)の乱数を返す
    public static void random(AFunctionArg arg) {
        int v = arg.getInt(0);
        int r = (int)Math.floor( Math.random() * (double)v );
        arg.setResult(r);
    }
    
    // *乱数範囲(AからBの|Bまでの) .. (AからBまで)の乱数を返す
    public static void random_range(AFunctionArg arg) {
        throw new RuntimeException("TODO");
    }
    
    // *サイコロ振る(Nの) .. Nの目のサイコロを振って返す。(1からNまで)の乱数を返す
    public static void dice(AFunctionArg arg) {
        throw new RuntimeException("TODO");
    }
    // *TYPEOF(E) # 値Eの型を返す
    public static void _typeof(AFunctionArg arg) {
        throw new RuntimeException("TODO");
    }
    // *NUM(V) # 数値型に変換して返す
    public static void cnum(AFunctionArg arg) {
        throw new RuntimeException("TODO");
    }
    // *掛ける(ARG)@130 // 2
    public static void mul(AFunctionArg arg) {
        throw new RuntimeException("TODO");
    }
    // *割る(ARG)@131 // 2
    public static void div(AFunctionArg arg) {
        throw new RuntimeException("TODO");
    }
    // *余り(ARG)@132 // 2
    public static void mod(AFunctionArg arg) {
        throw new RuntimeException("TODO");
    }
    // *足す(ARG)@133 // 2
    public static void add(AFunctionArg arg) {
        throw new RuntimeException("TODO");
    }
    // *引く(ARG)@134 // 2
    public static void sub(AFunctionArg arg) {
        throw new RuntimeException("TODO");
    }
    // *直接足す(ARG)@135 // 2
    public static void inc(AFunctionArg arg) {
        throw new RuntimeException("TODO");
    }
    // *直接引く(ARG)@136 // 2
    public static void dec(AFunctionArg arg) {
        throw new RuntimeException("TODO");
    }
    // *等しい(ARG)@137 // 2
    public static void comp_eq(AFunctionArg arg) {
        throw new RuntimeException("TODO");
    }
    // *以上(ARG)@138 // 2
    public static void comp_gteq(AFunctionArg arg) {
        throw new RuntimeException("TODO");
    }
    // *以下(ARG)@139 // 2
    public static void comp_lteq(AFunctionArg arg) {
        throw new RuntimeException("TODO");
    }
    // *超(ARG)@140 // 2
    public static void comp_gt(AFunctionArg arg) {
        throw new RuntimeException("TODO");
    }
    // *未満(ARG)@141 // 2
    public static void comp_lt(AFunctionArg arg) {
        throw new RuntimeException("TODO");
    }
    // *文字列等しい(ARG)@142 // 2
    public static void comp_str_eq(AFunctionArg arg) {
        throw new RuntimeException("TODO");
    }

}
