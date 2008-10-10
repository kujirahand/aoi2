/*
 * KEncoder.java
 *
 * Created on 2007/03/29, 9:32
 */

package com.aoikujira.aoi2.vm;

import java.io.ByteArrayOutputStream;

import com.aoikujira.aoi2.compiler.CurString;

/**
 *
 * @author desk
 */

public class KEncoder {
    
    public static String decodeURL(String s, String encoding) {
        ByteArrayOutputStream res = new ByteArrayOutputStream();
        CurString cur = new CurString(s);
        while (cur.hasNext()) {
            char c = cur.getc();
            switch (c) {
                case '%':
                    String hex = "" + cur.getc() + cur.getc();
                    int ch = Integer.parseInt(hex, 16);
                    res.write(ch);
                    break;
                case '+':
                    res.write(' ');
                    break;
                default:
                    res.write(c);
                    break;
            }
        }
        String res_str;
        try {
            if (encoding == null) {
                res_str = res.toString();
            } else {
                res_str = res.toString(encoding);
            }
        } catch (Exception e) {
            res_str = res.toString();
        }
        return res_str;
    }
    
    public static String encodeURL(String s, String encoding) {
        StringBuffer sb = new StringBuffer();
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            if ((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z')
                    || (c >= '0' && c <= '9') || (c == '.') || (c == '-')
                    || (c == '*') || (c == '_')) {
                sb.append(c);
            }
            else if (c == ' ') {
                sb.append('+');
            }
            else {
                byte[] bs;
                try {
                    bs = new String(new char[] { c }).getBytes(encoding);
                } catch (Exception e) {
                    bs = new String(new char[] { c }).getBytes();
                }
                for (int j = 0; j < bs.length; j++) {
                    sb.append('%');
                    String hexStr = Integer.toHexString(bs[j] & 0x000000ff);
                    if(hexStr.length() == 1)
                        sb.append("0");
                    sb.append(hexStr.toUpperCase());
                }
            }
        }
        return sb.toString();
    }
}
