// Created by module2txt.nako --- ModuleSystem.aoi2
package com.aoikujira.aoi2.vm.module;
import com.aoikujira.aoi2.vm.AFunctionArg;

class ModuleSystemTable
{
    //--- function args
    public static int getArgCount(int id) {
        switch (id) {
        case 0: return 0;
        case 1: return 0;
        case 2: return 0;
        case 3: return 0;
        case 4: return 2;
        case 5: return 1;
        case 10: return 1;
        case 11: return 2;
        case 12: return 3;
        case 13: return 1;
        case 14: return 1;
        case 15: return 3;
        case 16: return 3;
        case 17: return 3;
        case 18: return 2;
        case 19: return 2;
        case 20: return 2;
        case 21: return 2;
        case 22: return 3;
        case 23: return 1;
        case 24: return 1;
        case 25: return 2;
        case 30: return 0;
        case 31: return 0;
        case 32: return 0;
        case 33: return 2;
        case 34: return 2;
        case 35: return 2;
        case 36: return 2;
        case 40: return 1;
        case 41: return 1;
        case 42: return 1;
        case 50: return 2;
        case 51: return 2;
        case 52: return 3;
        case 53: return 1;
        case 54: return 3;
        case 55: return 3;
        case 56: return 1;
        case 57: return 1;
        case 58: return 1;
        case 59: return 2;
        case 60: return 2;
        case 61: return 1;
        case 62: return 1;
        case 63: return 3;
        case 64: return 4;
        case 70: return 1;
        case 71: return 1;
        case 72: return 1;
        case 80: return 1;
        case 81: return 1;
        case 82: return 1;
        case 100: return 1;
        case 101: return 1;
        case 102: return 2;
        case 103: return 1;
        case 104: return 1;
        case 105: return 1;
        case 106: return 1;
        case 107: return 1;
        case 108: return 1;
        case 109: return 1;
        case 110: return 1;
        case 111: return 1;
        case 112: return 1;
        case 113: return 1;
        case 114: return 2;
        case 115: return 1;
        case 130: return 2;
        case 131: return 2;
        case 132: return 2;
        case 133: return 2;
        case 134: return 2;
        case 135: return 2;
        case 136: return 2;
        case 137: return 2;
        case 138: return 2;
        case 139: return 2;
        case 140: return 2;
        case 141: return 2;
        case 142: return 2;

        default: return 0;
        }
    }
    //--- function table
    public static void call(int id, AFunctionArg arg) {
      switch (id) {
        case 0: ModuleSystem.quit(arg); break;
        case 1: ModuleSystem.platform(arg); break;
        case 2: ModuleSystem.vm_version(arg); break;
        case 3: ModuleSystem.reflesh(arg); break;
        case 4: ModuleSystem.let(arg); break;
        case 5: ModuleSystem._typeof(arg); break;
        case 10: ModuleSystem.str_length(arg); break;
        case 11: ModuleSystem.str_indexof(arg); break;
        case 12: ModuleSystem.str_replace(arg); break;
        case 13: ModuleSystem.asc(arg); break;
        case 14: ModuleSystem.chr(arg); break;
        case 15: ModuleSystem.str_insert(arg); break;
        case 16: ModuleSystem.str_delete(arg); break;
        case 17: ModuleSystem.str_mid(arg); break;
        case 18: ModuleSystem.str_left(arg); break;
        case 19: ModuleSystem.str_right(arg); break;
        case 20: ModuleSystem.str_getToken(arg); break;
        case 21: ModuleSystem.str_split(arg); break;
        case 22: ModuleSystem.str_replaceOne(arg); break;
        case 23: ModuleSystem.str_trim(arg); break;
        case 24: ModuleSystem.format_yen(arg); break;
        case 25: ModuleSystem.format_zero(arg); break;
        case 30: ModuleSystem.time_system(arg); break;
        case 31: ModuleSystem.date_today(arg); break;
        case 32: ModuleSystem.time_now(arg); break;
        case 33: ModuleSystem.date_add(arg); break;
        case 34: ModuleSystem.time_add(arg); break;
        case 35: ModuleSystem.date_sub(arg); break;
        case 36: ModuleSystem.time_sub(arg); break;
        case 40: ModuleSystem.count(arg); break;
        case 41: ModuleSystem.hash_keys(arg); break;
        case 42: ModuleSystem.hash_values(arg); break;
        case 50: ModuleSystem.array_add(arg); break;
        case 51: ModuleSystem.array_delete(arg); break;
        case 52: ModuleSystem.array_insert(arg); break;
        case 53: ModuleSystem.count(arg); break;
        case 54: ModuleSystem.array_indexof(arg); break;
        case 55: ModuleSystem.array_insertArray(arg); break;
        case 56: ModuleSystem.array_sortNum(arg); break;
        case 57: ModuleSystem.array_sortStr(arg); break;
        case 58: ModuleSystem.array_reverse(arg); break;
        case 59: ModuleSystem.array_join(arg); break;
        case 60: ModuleSystem.array_join(arg); break;
        case 61: ModuleSystem.array_random(arg); break;
        case 62: ModuleSystem.csv_toArray(arg); break;
        case 63: ModuleSystem.csv_pickup(arg); break;
        case 64: ModuleSystem.csv_pickupNum(arg); break;
        case 70: ModuleSystem.dialog_say(arg); break;
        case 71: ModuleSystem.dialog_input(arg); break;
        case 72: ModuleSystem.dialog_yesno(arg); break;
        case 80: ModuleSystem.cint(arg); break;
        case 81: ModuleSystem.cstr(arg); break;
        case 82: ModuleSystem.cnum(arg); break;
        case 100: ModuleSystem.trunc(arg); break;
        case 101: ModuleSystem.round(arg); break;
        case 102: ModuleSystem.sisyagonyu(arg); break;
        case 103: ModuleSystem.abs(arg); break;
        case 104: ModuleSystem.sin(arg); break;
        case 105: ModuleSystem.cos(arg); break;
        case 106: ModuleSystem.tan(arg); break;
        case 107: ModuleSystem.asin(arg); break;
        case 108: ModuleSystem.acos(arg); break;
        case 109: ModuleSystem.atan(arg); break;
        case 110: ModuleSystem.sqrt(arg); break;
        case 111: ModuleSystem.exp(arg); break;
        case 112: ModuleSystem.log(arg); break;
        case 113: ModuleSystem.random(arg); break;
        case 114: ModuleSystem.random_range(arg); break;
        case 115: ModuleSystem.dice(arg); break;
        case 130: ModuleSystem.mul(arg); break;
        case 131: ModuleSystem.div(arg); break;
        case 132: ModuleSystem.mod(arg); break;
        case 133: ModuleSystem.add(arg); break;
        case 134: ModuleSystem.sub(arg); break;
        case 135: ModuleSystem.inc(arg); break;
        case 136: ModuleSystem.dec(arg); break;
        case 137: ModuleSystem.comp_eq(arg); break;
        case 138: ModuleSystem.comp_gteq(arg); break;
        case 139: ModuleSystem.comp_lteq(arg); break;
        case 140: ModuleSystem.comp_gt(arg); break;
        case 141: ModuleSystem.comp_lt(arg); break;
        case 142: ModuleSystem.comp_str_eq(arg); break;

      }
    }
}
/*
    // *終了(ARG)@0 // 0
    public static void quit(AFunctionArg arg) {
    }
    // *実行環境(ARG)@1 // 0
    public static void platform(AFunctionArg arg) {
    }
    // *葵バージョン(ARG)@2 // 0
    public static void vm_version(AFunctionArg arg) {
    }
    // *描画処理反映(ARG)@3 // 0
    public static void reflesh(AFunctionArg arg) {
    }
    // *代入(ARG)@4 // 2
    public static void let(AFunctionArg arg) {
    }
    // *TYPEOF(ARG)@5 // 1
    public static void _typeof(AFunctionArg arg) {
    }
    // *文字数(ARG)@10 // 1
    public static void str_length(AFunctionArg arg) {
    }
    // *文字列検索(ARG)@11 // 2
    public static void str_indexof(AFunctionArg arg) {
    }
    // *文字置換(ARG)@12 // 3
    public static void str_replace(AFunctionArg arg) {
    }
    // *ASC(ARG)@13 // 1
    public static void asc(AFunctionArg arg) {
    }
    // *CHR(ARG)@14 // 1
    public static void chr(AFunctionArg arg) {
    }
    // *文字挿入(ARG)@15 // 3
    public static void str_insert(AFunctionArg arg) {
    }
    // *文字削除(ARG)@16 // 3
    public static void str_delete(AFunctionArg arg) {
    }
    // *文字抜き出す(ARG)@17 // 3
    public static void str_mid(AFunctionArg arg) {
    }
    // *文字左部分(ARG)@18 // 2
    public static void str_left(AFunctionArg arg) {
    }
    // *文字右部分(ARG)@19 // 2
    public static void str_right(AFunctionArg arg) {
    }
    // *切り取る(ARG)@20 // 2
    public static void str_getToken(AFunctionArg arg) {
    }
    // *区切る(ARG)@21 // 2
    public static void str_split(AFunctionArg arg) {
    }
    // *単置換(ARG)@22 // 3
    public static void str_replaceOne(AFunctionArg arg) {
    }
    // *トリム(ARG)@23 // 1
    public static void str_trim(AFunctionArg arg) {
    }
    // *通貨形式(ARG)@24 // 1
    public static void format_yen(AFunctionArg arg) {
    }
    // *ゼロ埋め(ARG)@25 // 2
    public static void format_zero(AFunctionArg arg) {
    }
    // *システム時間(ARG)@30 // 0
    public static void time_system(AFunctionArg arg) {
    }
    // *今日(ARG)@31 // 0
    public static void date_today(AFunctionArg arg) {
    }
    // *今(ARG)@32 // 0
    public static void time_now(AFunctionArg arg) {
    }
    // *日付加算(ARG)@33 // 2
    public static void date_add(AFunctionArg arg) {
    }
    // *時間加算(ARG)@34 // 2
    public static void time_add(AFunctionArg arg) {
    }
    // *日数差(ARG)@35 // 2
    public static void date_sub(AFunctionArg arg) {
    }
    // *秒差(ARG)@36 // 2
    public static void time_sub(AFunctionArg arg) {
    }
    // *要素数(ARG)@40 // 1
    public static void count(AFunctionArg arg) {
    }
    // *ハッシュキー列挙(ARG)@41 // 1
    public static void hash_keys(AFunctionArg arg) {
    }
    // *ハッシュ値列挙(ARG)@42 // 1
    public static void hash_values(AFunctionArg arg) {
    }
    // *配列追加(ARG)@50 // 2
    public static void array_add(AFunctionArg arg) {
    }
    // *配列削除(ARG)@51 // 2
    public static void array_delete(AFunctionArg arg) {
    }
    // *配列挿入(ARG)@52 // 3
    public static void array_insert(AFunctionArg arg) {
    }
    // *配列要素数(ARG)@53 // 1
    public static void count(AFunctionArg arg) {
    }
    // *配列検索(ARG)@54 // 3
    public static void array_indexof(AFunctionArg arg) {
    }
    // *配列一括挿入(ARG)@55 // 3
    public static void array_insertArray(AFunctionArg arg) {
    }
    // *配列数値ソート(ARG)@56 // 1
    public static void array_sortNum(AFunctionArg arg) {
    }
    // *配列ソート(ARG)@57 // 1
    public static void array_sortStr(AFunctionArg arg) {
    }
    // *配列逆順(ARG)@58 // 1
    public static void array_reverse(AFunctionArg arg) {
    }
    // *配列結合(ARG)@59 // 2
    public static void array_join(AFunctionArg arg) {
    }
    // *配列連結(ARG)@60 // 2
    public static void array_join(AFunctionArg arg) {
    }
    // *配列シャッフル(ARG)@61 // 1
    public static void array_random(AFunctionArg arg) {
    }
    // *CSV取得(ARG)@62 // 1
    public static void csv_toArray(AFunctionArg arg) {
    }
    // *表ピックアップ(ARG)@63 // 3
    public static void csv_pickup(AFunctionArg arg) {
    }
    // *表数値ピックアップ(ARG)@64 // 4
    public static void csv_pickupNum(AFunctionArg arg) {
    }
    // *言う(ARG)@70 // 1
    public static void dialog_say(AFunctionArg arg) {
    }
    // *尋ねる(ARG)@71 // 1
    public static void dialog_input(AFunctionArg arg) {
    }
    // *二択(ARG)@72 // 1
    public static void dialog_yesno(AFunctionArg arg) {
    }
    // *INT(ARG)@80 // 1
    public static void cint(AFunctionArg arg) {
    }
    // *STR(ARG)@81 // 1
    public static void cstr(AFunctionArg arg) {
    }
    // *NUM(ARG)@82 // 1
    public static void cnum(AFunctionArg arg) {
    }
    // *切捨て(ARG)@100 // 1
    public static void trunc(AFunctionArg arg) {
    }
    // *ROUND(ARG)@101 // 1
    public static void round(AFunctionArg arg) {
    }
    // *四捨五入(ARG)@102 // 2
    public static void sisyagonyu(AFunctionArg arg) {
    }
    // *絶対値(ARG)@103 // 1
    public static void abs(AFunctionArg arg) {
    }
    // *SIN(ARG)@104 // 1
    public static void sin(AFunctionArg arg) {
    }
    // *COS(ARG)@105 // 1
    public static void cos(AFunctionArg arg) {
    }
    // *TAN(ARG)@106 // 1
    public static void tan(AFunctionArg arg) {
    }
    // *ASIN(ARG)@107 // 1
    public static void asin(AFunctionArg arg) {
    }
    // *ACOS(ARG)@108 // 1
    public static void acos(AFunctionArg arg) {
    }
    // *ATAN(ARG)@109 // 1
    public static void atan(AFunctionArg arg) {
    }
    // *SQRT(ARG)@110 // 1
    public static void sqrt(AFunctionArg arg) {
    }
    // *EXP(ARG)@111 // 1
    public static void exp(AFunctionArg arg) {
    }
    // *LOG(ARG)@112 // 1
    public static void log(AFunctionArg arg) {
    }
    // *乱数(ARG)@113 // 1
    public static void random(AFunctionArg arg) {
    }
    // *乱数範囲(ARG)@114 // 2
    public static void random_range(AFunctionArg arg) {
    }
    // *サイコロ振る(ARG)@115 // 1
    public static void dice(AFunctionArg arg) {
    }
    // *掛ける(ARG)@130 // 2
    public static void mul(AFunctionArg arg) {
    }
    // *割る(ARG)@131 // 2
    public static void div(AFunctionArg arg) {
    }
    // *余り(ARG)@132 // 2
    public static void mod(AFunctionArg arg) {
    }
    // *足す(ARG)@133 // 2
    public static void add(AFunctionArg arg) {
    }
    // *引く(ARG)@134 // 2
    public static void sub(AFunctionArg arg) {
    }
    // *直接足す(ARG)@135 // 2
    public static void inc(AFunctionArg arg) {
    }
    // *直接引く(ARG)@136 // 2
    public static void dec(AFunctionArg arg) {
    }
    // *等しい(ARG)@137 // 2
    public static void comp_eq(AFunctionArg arg) {
    }
    // *以上(ARG)@138 // 2
    public static void comp_gteq(AFunctionArg arg) {
    }
    // *以下(ARG)@139 // 2
    public static void comp_lteq(AFunctionArg arg) {
    }
    // *超(ARG)@140 // 2
    public static void comp_gt(AFunctionArg arg) {
    }
    // *未満(ARG)@141 // 2
    public static void comp_lt(AFunctionArg arg) {
    }
    // *文字列等しい(ARG)@142 // 2
    public static void comp_str_eq(AFunctionArg arg) {
    }

*/
