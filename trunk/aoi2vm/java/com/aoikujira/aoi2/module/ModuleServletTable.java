// Created by module2txt.nako --- ModuleServlet.aoi2
package com.aoikujira.aoi2.vm.module;
import com.aoikujira.aoi2.vm.AFunctionArg;

class ModuleServletTable
{
    //--- function args
    public static int getArgCount(int id) {
        switch (id) {
        case 1: return 0;
        case 2: return 0;
        case 3: return 0;
        case 4: return 3;
        case 5: return 0;
        case 6: return 1;
        case 7: return 2;

        default: return 0;
        }
    }
    //--- function table
    public static void call(int id, AFunctionArg arg) {
      switch (id) {
        case 1: ModuleServlet.getHeader(arg); break;
        case 2: ModuleServlet.getForm(arg); break;
        case 3: ModuleServlet.getCookie(arg); break;
        case 4: ModuleServlet.setCookie(arg); break;
        case 5: ModuleServlet.getURI(arg); break;
        case 6: ModuleServlet.session_get(arg); break;
        case 7: ModuleServlet.session_set(arg); break;

      }
    }
}
/*
    // *ヘッダ取得(ARG)@1 // 0
    public static void getHeader(AFunctionArg arg) {
    }
    // *フォーム取得(ARG)@2 // 0
    public static void getForm(AFunctionArg arg) {
    }
    // *クッキー取得(ARG)@3 // 0
    public static void getCookie(AFunctionArg arg) {
    }
    // *クッキー設定(ARG)@4 // 3
    public static void setCookie(AFunctionArg arg) {
    }
    // *URI取得(ARG)@5 // 0
    public static void getURI(AFunctionArg arg) {
    }
    // *セッション取得(ARG)@6 // 1
    public static void session_get(AFunctionArg arg) {
    }
    // *セッション設定(ARG)@7 // 2
    public static void session_set(AFunctionArg arg) {
    }

*/
