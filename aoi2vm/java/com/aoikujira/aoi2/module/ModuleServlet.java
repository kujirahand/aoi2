/*
 * ModuleServlet.java
 * 
 */

package com.aoikujira.aoi2.vm.module;

import java.util.Enumeration;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.aoikujira.aoi2.avalue.*;
import com.aoikujira.aoi2.vm.*;

public class ModuleServlet {
    
    public ModuleServlet() {
    }
    
    public void aoimodule_call(int func_no, AFunctionArg arg) {
        ModuleServletTable.call(func_no, arg);
    }
    public int aoimodule_getArgCount(int id) {
        return ModuleServletTable.getArgCount(id);
    }
    
    // ●ヘッダ取得 # リクエストヘッダ一覧を表示する
    public static void getHeader(AFunctionArg arg) {
        AValue res = new AValue();
        res.hash_create();
        // enum headers
        HttpServletRequest request = (HttpServletRequest)arg.mac.parent.request;
        Enumeration e = request.getHeaderNames();
        while (e.hasMoreElements()) {
            String name  = (String)e.nextElement();
            String value = request.getHeader(name);
            res.hash_set(name, new AValue(value));
        }
        arg.result = res;        
    }
    // ●フォーム取得 # リクエストパラメータ一覧を表示する
    public static void getForm(AFunctionArg arg) {
        AValue res = new AValue();
        res.hash_create();
        // enum headers
        HttpServletRequest request = (HttpServletRequest)arg.mac.parent.request;
        Enumeration e = request.getParameterNames();
        while (e.hasMoreElements()) {
            String name  = (String)e.nextElement();
            String value = request.getParameter(name);
            res.hash_set(name, new AValue(value));
        }
        arg.result = res;        
    }
    // ●クッキー取得 # クッキーの一覧を表示する
    public static void getCookie(AFunctionArg arg) {
        AValue res = new AValue();
        res.hash_create();
        // enum headers
        HttpServletRequest request = (HttpServletRequest)arg.mac.parent.request;
        Cookie[] e = request.getCookies();
        for (int i = 0; i < e.length; i++) {
            Cookie c = e[i];
            String name = c.getName();
            String value = c.getValue();
            res.hash_set(name, new AValue(value));
        }
        arg.result = res;        
    }
    // ●クッキー設定(NAMEにVALUEをAGEまで|NAMEへ)="servlet.ModuleServlet"@4 # クッキー名NAMEに
    public static void setCookie(AFunctionArg arg) {
        // args
        String name  = arg.getStr(0);
        String value = arg.getStr(1);
        int    age   = arg.getInt(2);
        // get response
        HttpServletResponse response = (HttpServletResponse)arg.mac.parent.response;
        Cookie c = new Cookie(name, value);
        c.setMaxAge(age);
        response.addCookie(c);
    }
    // ●URI取得 # ページURIを表示する
    public static void getURI(AFunctionArg arg) {
        HttpServletRequest request = (HttpServletRequest)arg.mac.parent.request;
        arg.setResult(request.getRequestURI());
    }
    // ●セッション取得(NAMEの) # セッションを開始し、NAMEの値を取得する
    public static void session_get(AFunctionArg arg) {
        String name = arg.getStr(0);
        HttpServletRequest request = (HttpServletRequest)arg.mac.parent.request;
        HttpSession session = request.getSession(true);
        AValue value = (AValue)session.getAttribute(name);
        arg.result = value;
    }
    // ●セッション設定(NAMEにVALUEを|NAMEへVALUEの) # セッションを開始し、NAMEへVALUEを設定する
    public static void session_set(AFunctionArg arg) {
        HttpServletRequest request = (HttpServletRequest)arg.mac.parent.request;
        HttpSession session = request.getSession(true);
        String name  = arg.getStr(0);
        AValue value = arg.getArg(1);
        value = value.getLink();
        session.setAttribute(name, (Object)value);
    }

}
