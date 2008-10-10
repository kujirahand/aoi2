// Created by module2txt.nako --- ModuleJava.aoi2
package com.aoikujira.aoi2.vm.module;
import com.aoikujira.aoi2.vm.AFunctionArg;

class ModuleJavaTable
{
    //--- function args
    public static int getArgCount(int id) {
        switch (id) {
        case 1: return 1;
        case 2: return 1;
        case 3: return 1;
        case 4: return 0;
        case 5: return 1;
        case 20: return 1;
        case 21: return 1;
        case 22: return 2;
        case 23: return 1;
        case 24: return 1;
        case 25: return 1;
        case 26: return 1;
        case 27: return 1;
        case 28: return 1;
        case 31: return 1;
        case 32: return 1;
        case 33: return 1;
        case 34: return 1;
        case 35: return 0;
        case 36: return 0;
        case 37: return 1;
        case 38: return 0;
        case 40: return 0;
        case 50: return 1;
        case 51: return 1;
        case 80: return 3;
        case 81: return 1;
        case 82: return 0;
        case 83: return 0;
        case 84: return 0;

        default: return 0;
        }
    }
    //--- function table
    public static void call(int id, AFunctionArg arg) {
      switch (id) {
        case 1: ModuleJava.print(arg); break;
        case 2: ModuleJava.getenv(arg); break;
        case 3: ModuleJava.readByte(arg); break;
        case 4: ModuleJava.readLine(arg); break;
        case 5: ModuleJava.exec(arg); break;
        case 20: ModuleJava.file_load(arg); break;
        case 21: ModuleJava.file_load(arg); break;
        case 22: ModuleJava.file_save(arg); break;
        case 23: ModuleJava.file_exists(arg); break;
        case 24: ModuleJava.file_delete(arg); break;
        case 25: ModuleJava.file_date(arg); break;
        case 26: ModuleJava.file_size(arg); break;
        case 27: ModuleJava.file_list(arg); break;
        case 28: ModuleJava.dir_list(arg); break;
        case 31: ModuleJava.mkdir(arg); break;
        case 32: ModuleJava.mkdir(arg); break;
        case 33: ModuleJava.file_getName(arg); break;
        case 34: ModuleJava.file_getPath(arg); break;
        case 35: ModuleJava.file_getSplitter(arg); break;
        case 36: ModuleJava.pwd(arg); break;
        case 37: ModuleJava.cd(arg); break;
        case 38: ModuleJava.dir_getBasePath(arg); break;
        case 40: ModuleJava.cgi_getForm(arg); break;
        case 50: ModuleJava.url_encode(arg); break;
        case 51: ModuleJava.url_decode(arg); break;
        case 80: ModuleJava.mysql_connect(arg); break;
        case 81: ModuleJava.mysql_exec(arg); break;
        case 82: ModuleJava.mysql_getAll(arg); break;
        case 83: ModuleJava.mysql_close(arg); break;
        case 84: ModuleJava.mysql_listTables(arg); break;

      }
    }
}
/*
    // *表示(ARG)@1 // 1
    public static void print(AFunctionArg arg) {
    }
    // *環境変数取得(ARG)@2 // 1
    public static void getenv(AFunctionArg arg) {
    }
    // *バイト読む(ARG)@3 // 1
    public static void readByte(AFunctionArg arg) {
    }
    // *一行読む(ARG)@4 // 0
    public static void readLine(AFunctionArg arg) {
    }
    // *起動(ARG)@5 // 1
    public static void exec(AFunctionArg arg) {
    }
    // *開く(ARG)@20 // 1
    public static void file_load(AFunctionArg arg) {
    }
    // *読む(ARG)@21 // 1
    public static void file_load(AFunctionArg arg) {
    }
    // *保存(ARG)@22 // 2
    public static void file_save(AFunctionArg arg) {
    }
    // *存在するか(ARG)@23 // 1
    public static void file_exists(AFunctionArg arg) {
    }
    // *ファイル削除(ARG)@24 // 1
    public static void file_delete(AFunctionArg arg) {
    }
    // *ファイル日時取得(ARG)@25 // 1
    public static void file_date(AFunctionArg arg) {
    }
    // *ファイルサイズ取得(ARG)@26 // 1
    public static void file_size(AFunctionArg arg) {
    }
    // *ファイル一覧取得(ARG)@27 // 1
    public static void file_list(AFunctionArg arg) {
    }
    // *フォルダ一覧取得(ARG)@28 // 1
    public static void dir_list(AFunctionArg arg) {
    }
    // *フォルダ作成(ARG)@31 // 1
    public static void mkdir(AFunctionArg arg) {
    }
    // *フォルダ削除(ARG)@32 // 1
    public static void mkdir(AFunctionArg arg) {
    }
    // *ファイル名抽出(ARG)@33 // 1
    public static void file_getName(AFunctionArg arg) {
    }
    // *ファイルパス抽出(ARG)@34 // 1
    public static void file_getPath(AFunctionArg arg) {
    }
    // *パス区切り記号取得(ARG)@35 // 0
    public static void file_getSplitter(AFunctionArg arg) {
    }
    // *作業フォルダ取得(ARG)@36 // 0
    public static void pwd(AFunctionArg arg) {
    }
    // *作業フォルダ設定(ARG)@37 // 1
    public static void cd(AFunctionArg arg) {
    }
    // *母艦パス取得(ARG)@38 // 0
    public static void dir_getBasePath(AFunctionArg arg) {
    }
    // *CGIフォーム取得(ARG)@40 // 0
    public static void cgi_getForm(AFunctionArg arg) {
    }
    // *URLエンコード(ARG)@50 // 1
    public static void url_encode(AFunctionArg arg) {
    }
    // *URLデコード(ARG)@51 // 1
    public static void url_decode(AFunctionArg arg) {
    }
    // *MYSQL接続(ARG)@80 // 3
    public static void mysql_connect(AFunctionArg arg) {
    }
    // *MYSQL実行(ARG)@81 // 1
    public static void mysql_exec(AFunctionArg arg) {
    }
    // *MYSQL全結果取得(ARG)@82 // 0
    public static void mysql_getAll(AFunctionArg arg) {
    }
    // *MYSQL切断(ARG)@83 // 0
    public static void mysql_close(AFunctionArg arg) {
    }
    // *MYSQLテーブル一覧取得(ARG)@84 // 0
    public static void mysql_listTables(AFunctionArg arg) {
    }

*/
