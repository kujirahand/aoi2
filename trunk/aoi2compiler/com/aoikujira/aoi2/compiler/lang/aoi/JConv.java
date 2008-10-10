package com.aoikujira.aoi2.compiler.lang.aoi;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;

import com.aoikujira.aoi2.compiler.*;
import com.aoikujira.utils.*;

public class JConv {
    private static StringHashtable table = null;
    
    public static String loadFile(String fname) {
        String result = "";
        
        try {
            FileInputStream fis = new FileInputStream(fname);
            InputStreamReader isr = new InputStreamReader(fis, "UTF8");
            BufferedReader br = new BufferedReader(isr);
            String line;
            while ((line = br.readLine()) != null) {
                result += line + "\n";
            }
            br.close();
        } catch (IOException e) {
            throw new AOICException(ErrMsg.FileLoadError + ":" + fname);
        }
        
        return result;
    }
    
    public static String convert(int fileid, String source) {
        CurString cs = new CurString(source);
        cs.fileid = fileid;
        return convert(cs);
    }
    public static String convert(CurString cs) {
        // 改行を¥nに統一する
        String s = cs.getString();
        s = KUtils.replaceAll(s, "\r\n", "\n");
        s = KUtils.replaceAll(s, "\r", "\n");
        // インデントチェックのために余分に改行を加える
        s += "\n\n";
        // 再度セットしなおす
        cs.setString(s);
        cs.setIndex(0);
        // 分岐テーブルの初期化
        initTable();
        // インデントの管理
        Indent indent = new Indent();
        indent.setTop(cs);
        // 変換ループ
        while (cs.hasNext()) {
            char c = cs.getc();
            // check singlebyte char
            if (c <= 0x7F) {
                switch (c) {
                    case '\n':
                        indent.checkIndent(cs);
                        cs.result += '\n';
                        cs.lineno++;
                        break;
                    case '#': // line comment
                        skipLineComment(cs);
                        break;
                    case '/':
                        cs.prev(1);
                        if (cs.compareKey("/*")) {
                            skipRangeComment(cs);
                        } else if (cs.compareKey("//")) {
                            skipLineComment(cs);
                        } else {
                            cs.result += c;
                            cs.next();
                        }
                        break;
                    case '\"': // ext string
                        getExtensionString(cs,'"','"');
                        break;
                    case '\'': // normal string
                        getNormalString(cs, '\'', '\'');
                        break;
                    default:
                        cs.result += c;
                        break;
                }
                continue;
            } else {
                // check multibyte char
                convMultibyte(cs, c);
            }
        } // end of conv_loop
        return cs.result;
    }
    
    public static void convMultibyte(CurString cs, char c) {
        switch (c) {
            case '＃':
                skipLineComment(cs);
                return;
            case '※':
                skipLineComment(cs);
                return;
            case '「':
                getExtensionString(cs, '「','」');
                return;
            case '『':
                getNormalString(cs, '『','』');
                return;
            case '”':
                getExtensionString(cs, '”','”');
                return;
            case '’':
                getNormalString(cs, '’','’');
                return;
        }
        // number ?
        if ('０' <= c && c <= '９') {
            c = (char)((int)c - '０' + '0');
            cs.result += c;
            return;
        }
        // alpha ?
        if ('ａ' <= c && c <= 'ｚ') {
            c = (char)((int)c - 'ａ' + 'a');
            cs.result += c;
            return;
        }
        if ('Ａ' <= c && c <= 'Ｚ') {
            c = (char)((int)c - 'Ａ' + 'A');
            cs.result += c;
            return;
        }
        // flag ?
        Object r = table.get("" + c);
        if (r == null) {
            cs.result += c;
            return;
        } else {
            cs.result += (String)r;
        }
    }
    
    public static void skipLineComment(CurString cs) {
        char c;
        while (cs.hasNext()) {
            c = cs.curChar();
            if (c == '\r' || c == '\n') break;
            cs.next();
        }
    }
    public static void skipRangeComment(CurString cs) {
        char c;
        while (cs.hasNext()) {
            if (cs.compareKey("*/")) {
                cs.next(2);
                break;
            }
            c = cs.curChar();
            if (c == '\r' || c == '\n') {
                cs.result += c;
            }
            cs.next();
        }
    }
    public static void getNormalString(CurString cs, char ch_begin, char ch_end) {
        char c;
        cs.result += "\"";
        while (cs.hasNext()) {
            c = cs.getc();
            if (c == ch_end) {
                cs.result += "\"";
                return;
            }
            if (c == '\\') {
                cs.result += "\\\\";
                continue;
            }
            if (c == '\r') {
                cs.result  += "\\\r";
                cs.opt_str += "\\n";
                continue;
            }
            if (c == '\n') {
                cs.result  += "\\\n";
                cs.opt_str += "\\n";
                continue;
            }
            cs.result += c;
        }
    }
    public static void getExtensionString(CurString cs, char ch_begin, char ch_end) {
        // (1) コード展開が必要なもの"{var}"は、文字列と分離して処理する
        // (2) 改行を \r|\n に直す
        char c;
        cs.result += "\"";
        while (cs.hasNext()) {
            c = cs.getc();
            if (c == ch_end) { // end of string ?
                cs.result += "\"";
                cs.result += cs.opt_str;
                cs.opt_str = "";
                return;
            }
            switch (c) {
                case '\\': // escape
                    cs.result += '\\';
                    c = cs.getc();
                    cs.result += c;
                    break;
                case '\"': // double quote (ex: 「aaa"aaa"」)
                    cs.result += "\\\""; 
                    break;
                case '\r': // escape \r
                    cs.result += "\\r";
                    c = cs.getc();
                    if (c != '\n') { // check CR + LF
                        cs.prev();
                    } else {
                        cs.result += "\\n";
                    }
                    cs.opt_str += "\\n";
                    break;
                case '\n': // escape \n
                    cs.result += "\\n";
                    cs.opt_str += "\\n";
                    break;
                case '{': // embed variable or expr
                    getExtractString_embed(cs);
                    break;
                case '｛': // embed variable or expr
                    getExtractString_embed(cs);
                    break;
                default:
                    cs.result += c;
                    break;
            }
        }
        // ここに来たらエラー
        throw new AOICException(ErrMsg.StringNotTerminated); 
    }
    private static void getExtractString_embed(CurString cs) {
        String em = "";
        char c;
        while (cs.hasNext()) {
            c = cs.getc();
            // check end of embed
            if (c == '}' || c == '｝') {
                break;
            }
            // check return code
            if (c == '\r') {
                c = cs.getc(); // check CR + LF
                if (c != '\n') { cs.prev(); }
                cs.opt_str += "\n";
                continue;
            } else if (c == '\n') {
                cs.opt_str += "\n";
                continue;
            }
            em += c;
        }
        if (em.length() > 0) {
            em = JConv.convert(0, em);
            em = KUtils.trim(em);
            cs.result += "\" & (" + em + ") & \"";
        }
    }
    public static void clearTable() {
        if (table != null) { table.clear(); }
    }
    public static void initTable() {
        if (table != null) return;
        table = new StringHashtable();
        table.put("、",",");
        table.put("。",";");
        table.put("，",",");
        table.put("．",".");
        table.put("：",":");
        table.put("；",";");
        table.put("？","?");
        table.put("！","!");
        table.put("＾","^");
        table.put("＿","_");
        table.put("／","/");
        table.put("’","'");
        table.put("”","\"");
        table.put("（","(");
        table.put("）",")");
        table.put("〔","[");
        table.put("〕","]");
        table.put("［","[");
        table.put("］","]");
        table.put("｛","{");
        table.put("｝","}");
        table.put("【","[");
        table.put("】","]");
        table.put("＋","+");
        table.put("－","-");
        table.put("×","*");
        table.put("÷","/");
        table.put("＝","=");
        table.put("≠","<>");
        table.put("＜","<");
        table.put("＞",">");
        table.put("≦","<=");
        table.put("≧",">=");
        table.put("￥","\\");
        table.put("％","%");
        table.put("＃","#");
        table.put("＆","&");
        table.put("＊","*");
        table.put("＠","@");
        table.put("●","*");
        table.put("○","*");
        table.put("※","#");
        table.put("＄","$");
        table.put("～","|");
        table.put("｜","|");
        table.put("　","  "); //white space
    }
}

