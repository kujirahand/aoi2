/*
 * Indent.java
 *
 * Created on 2007/02/01, 10:31
 */

package com.aoikujira.aoi2.compiler.lang.aoi;

import com.aoikujira.aoi2.compiler.*;
import com.aoikujira.utils.*;


/**
 * @author kujiramac
 */
public class Indent {
    
    IntegerVector levels;
    int level;
    int num;
    
    public static final String BEGIN = "BEGIN";
    public static final String END   = "END";
    private String sbegin;
    private String send;
    
    public Indent() {
        levels = new IntegerVector();
        num   = 0;
        level = 0;
        sbegin = " " + BEGIN;
        send   = ";" + END;
    }
    
    public void setTop(CurString cs) {
        num = countIndent(cs);
        levels.add(new Integer(num));
    }
    
    public void checkIndent(CurString cs) {
        int oldnum = num;
        num = countIndent(cs);
        // 連続の空白はカウントしない
        /*
        if (cs.compareKey("\n\n")) {
            cs.result += '\n';
            return;
        }
         */
        // 空白行は前のインデントレベルと同じと判断する
        if (cs.hasNext() && cs.curChar() == '\n') {
            num = oldnum;
        }
        if (oldnum == num) return;
        // level up
        if (oldnum < num) {
            level++;
            levels.addInt(num);
            cs.result += sbegin;
            return;
        }
        // level down
        while(true) {
            if (levels.size() <= 1) break;
            levels.remove(levels.size()-1);
            int n = ((Integer)levels.get(levels.size()-1)).intValue();
            if (num == n) {
                num = n;
                level--;
                if (level >= 0) {
                    cs.result += send;
                } else {
                    level = 0;
                }
                break;
            }
            if (num > n) {
                throw new AOICException(
                        cs.fileid + "(" + Integer.toString(cs.lineno) + ")" + 
                        ErrMsg.InvalidIndentNum);
            }
            cs.result += send;
        }
        if (num == 0 && levels.size() == 0) {
            levels.addInt(0);
        }
    }
    
    public static int countIndent(CurString cs) {
        int i = 0;
        spc_loop: while (cs.hasNext()) {
            char c = cs.curChar();
            switch (c) {
                case ' ': // whitespace single
                    i++;
                    cs.next();
                    break;
                case '\t':
                    i += 4;
                    cs.next();
                    break;
                case '　': // whitespace multibyte
                    i += 2;
                    cs.next();
                    break;
                case '・':
                    i += 2;
                    cs.next();
                    break;
                default:
                    break spc_loop;
            }
        }
        return i;
    }
        
}
