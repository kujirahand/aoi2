/*
 * BasicConv.java
 *
 * Created on 2007/03/15, 14:06
 */

package com.aoikujira.aoi2.compiler.lang.basic;

import com.aoikujira.utils.*;
import com.aoikujira.aoi2.compiler.*;
import com.aoikujira.aoi2.compiler.lang.aoi.JConv;

/**
 *
 * @author kujiramac
 */

public class BasicConv {
    
    static public String convert(int fileid, String source) {
        CurString cur = new CurString(source);
        cur.fileid = fileid;
        return convert(cur);
    }
    
    static public String convert(CurString cs) {
        // 改行を¥nに統一する
        String s = cs.getString();
        s = KUtils.replaceAll(s, "\r\n", "\n");
        s = KUtils.replaceAll(s, "\r", "\n");
        // 再度セットしなおす
        cs.setString(s);
        cs.setIndex(0);
        // 分岐テーブルの初期化
        JConv.initTable();
        // 変換ループ
        while (cs.hasNext()) {
            char c = cs.getc();
            // check singlebyte char
            if (c <= 0x7F) {
                switch (c) {
                    case '\n':
                        cs.result += '\n';
                        cs.lineno++;
                        break;
                    case '\'': // line comment
                        JConv.skipLineComment(cs);
                        break;
                    case '/':
                        cs.prev(1);
                        if (cs.compareKey("/*")) {
                            JConv.skipRangeComment(cs);
                        } else if (cs.compareKey("//")) {
                            JConv.skipLineComment(cs);
                        } else {
                            cs.next(1);
                            cs.result += c;
                        }
                        break;
                    case '\"': // normal string
                        JConv.getNormalString(cs,'"','"');
                        break;
                    case '`': // extension string
                        JConv.getExtensionString(cs, '`', '`');
                        break;
                    default:
                        cs.result += c;
                        break;
                }
                continue;
            } else {
                // check multibyte char
                JConv.convMultibyte(cs, c);
            }
        } // end of conv_loop
        return cs.result;
    }
        
}
