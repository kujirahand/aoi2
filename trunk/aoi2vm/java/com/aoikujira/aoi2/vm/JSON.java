/*
 * JSON.java
 *
 * Created on 2007/02/20, 15:16
 */

package com.aoikujira.aoi2.vm;

/**
 * JSONのデコードクラス
 * @author kujiramac
 */
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Vector;

import com.aoikujira.aoi2.compiler.CurString;

public class JSON {
        
    public static final int typeNULL    = 0;
    public static final int typeNUM     = 1;
    public static final int typeSTR     = 2;
    public static final int typeARRAY   = 3;
    public static final int typeOBJECT  = 4;
    public static final int typeBOOL    = 5;
    
    int type;
    Object value;
    
    public JSON() {
    }
    
    public String getAsStr() {
        if (type == typeSTR) {
            return (String)value;
        }
        if (type == typeNUM) {
            return String.valueOf((Double)value);
        }
        return "";
    }
    public int getAsInt() {
        if (type == typeSTR) {
            return Integer.parseInt((String)value);
        }
        if (type == typeNUM) {
            Double num = (Double)value;
            return (int)num.doubleValue();
        }
        return 0;
    }
    public double getAsNum() {
        if (type == typeSTR) {
            return Double.parseDouble((String)value);
        }
        if (type == typeNUM) {
            return ((Double)value).doubleValue();
        }
        return 0;
    }
    public Hashtable getAsObject() {
        if (type == typeOBJECT) {
            return (Hashtable)value;
        }
        return null;
    }
    public JSON getObjectValue(String key) {
        Hashtable tbl = getAsObject();
        if (tbl == null) return null;
        JSON j = (JSON)tbl.get(key);
        return j;
    }
    public JSON getArrayValue(int index) {
        Vector ary = getAsArray();
        if (ary == null) return null;
        JSON j = (JSON)ary.get(index);
        return j;
    }
    public Vector getAsArray() {
        if (type == typeARRAY) {
            return (Vector)value;
        }
        return null;
    }
    public String toString(int level) {
        String s = "";
        for (int i = 0; i < level; i++) { s += "  "; }
        switch (type) {
            case typeNULL:  s += "null"; break;
            case typeNUM:   s += value.toString(); break;
            case typeSTR:   s += '"' + (String)value + '"'; break;
            case typeARRAY:
                Vector ary = (Vector)value;
                s += "[";
                for (int i = 0; i < ary.size(); i++) {
                    JSON j = (JSON)ary.get(i);
                    s += j.toString(0);
                    s += ",";
                }
                if (ary.size() > 0) {
                    s = s.substring(0, s.length() - 1);
                }
                s += "]";
                break;
            case typeOBJECT:
                Hashtable tbl = (Hashtable)value;
                Enumeration e = tbl.keys();
                s += "{";
                while(e.hasMoreElements()) {
                    String key = (String)e.nextElement();
                    JSON val = (JSON)tbl.get((Object)key);
                    s += "\"" + key + "\":";
                    s += val.toString(0);
                    s += ",";
                }
                if (tbl.size() > 0) {
                    s = s.substring(0, s.length() - 1);
                }
                s += "}";
                break;
            case typeBOOL:
                boolean b = ((Boolean)value).booleanValue();
                s += (b) ? "true" : "false";
                break;
        }
        return s;
    }
    
    
    private static void parse_skipSpace(CurString cur) {
        while (cur.hasNext()) {
            char c = cur.curChar();
            if (c == ' '|| c == '\t' || c == '\n' || c == '\r') {
                cur.next();
            } else {
                break;
            }
        }
    }
    
    private static JSON parse_value(CurString cur) {
        parse_skipSpace(cur);
        char c = cur.curChar();
        if ('0' <= c && c <= '9' || c == '-') {
            return parse_num(cur);
        }
        if (c == '"') {
            return parse_str(cur);
        }
        if (c == '{') {
            return parse_object(cur);
        }
        if (c == '[') {
            return parse_array(cur);
        }
        if (cur.compareKey("true")) {
            JSON j = new JSON();
            j.type = JSON.typeBOOL;
            j.value = new Boolean(true);
            cur.next(4);
            return j;
        }
        if (cur.compareKey("false")) {
            JSON j = new JSON();
            j.type = JSON.typeBOOL;
            j.value = new Boolean(false);
            cur.next(5);
            return j;
        }
        if (cur.compareKey("null")) {
            JSON j = new JSON();
            j.type = JSON.typeNULL;
            j.value = null;
            cur.next(4);
            return j;
        }
        return parse_str(cur);
    }
    
    private static JSON parse_num(CurString cur) {
        int flag = 1;
        String s = "";
        if (cur.curChar() == '-') {
            flag = -1;
            cur.next();
        }
        while (cur.hasNext()) {
            char c = cur.curChar();
            if ('0' <= c && c <= '9') {
                s += c;
                cur.next();
            } else {
                break;
            }
        }
        if (cur.curChar() == '.') {
            s += ".";
            cur.next();
            while (cur.hasNext()) {
                char ch = cur.curChar();
                if ('0' <= ch && ch <= '9' || ch == 'e' || ch == 'E') {
                    s += ch;
                    cur.next();
                } else { 
                    break; 
                }
            }
        }
        JSON j = new JSON();
        j.type  = JSON.typeNUM;
        j.value = new Double(Double.parseDouble(s) * flag);
        return j;
    }
    private static JSON parse_str(CurString cur) {
        String s = "";
        if (cur.curChar() == '"') {
            cur.next();
            while (cur.hasNext()) {
                char c = cur.curChar();
                if (c == '"') {
                    cur.next();
                    break;
                }
                if (c == '\\') {
                    cur.next();
                    c = cur.curChar();
                    cur.next();
                    switch (c) {
                        case 'b': s += '\b'; break;
                        case 'f': s += '\f'; break;
                        case 'n': s += '\n'; break;
                        case 'r': s += '\r'; break;
                        case 't': s += '\t'; break;
                        default:  s += c;    break;
                    }
                    continue;
                }
                s += c;
                cur.next();
            }
        } else {
            parse_skipSpace(cur);
            while (cur.hasNext()) {
                char c = cur.curChar();
                if (c == ':' || c == ']' || c == '}' || c == ',') {
                    break;
                }
                s += c;
                cur.next();
            }
        }
        JSON j = new JSON();
        j.type = JSON.typeSTR;
        j.value = s;
        return j;
    }
    private static JSON parse_object(CurString cur) {
        cur.next(); // skip '{'
        JSONHashtable obj = new JSONHashtable();
        JSON j = new JSON();
        j.type = JSON.typeOBJECT;
        j.value = obj;
        while (cur.hasNext()) {
            JSON name = parse_str(cur);
            JSON value = null;
            parse_skipSpace(cur);
            if (cur.curChar() == ':') {
                cur.next(); // ':'
                value = parse_value(cur);
            }
            parse_skipSpace(cur);
            if (cur.curChar() == ',') {
                cur.next(); // ','
            }
            obj.put((String)name.value, value);
            parse_skipSpace(cur);
            if (cur.curChar() == '}') {
                cur.next();
                break;
            }
        }
        return j;
    }
    
    private static JSON parse_array(CurString cur) {
        cur.next(); // '['
        JSONVector obj = new JSONVector();
        JSON j = new JSON();
        j.type = JSON.typeARRAY;
        j.value = obj;
        while (cur.hasNext()) {
            parse_skipSpace(cur);
            if (cur.curChar() == ']') {
                cur.next();
                break;
            }
            JSON v = parse_value(cur);
            obj.add(v);
            parse_skipSpace(cur);
            if (cur.curChar() == ',') {
                cur.next();
            }
        }
        return j;
    }
    
    public static JSON fromString(String json_str) {
        CurString cur = new CurString(json_str);
        return parse_value(cur);
    }
    
}
