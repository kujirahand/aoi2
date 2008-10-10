/*
 * JType.java
 * Created on 2007/02/01, 16:21
 */

package com.aoikujira.aoi2.compiler;

/**
 * 日本語を含めた文字種類チェックのクラス
 * @author kujiramac
 * @version 1.0
 */
public class JType {
    
    /**
     * ひらがなかどうか調べる
     */
    public static boolean isHiragana(char c) {
        return ('あ' <= c && c <= 'ん');
    }

    /**
     * 送り仮名の省略
     */
    public static String removeOkurigana(String s) {
        if (s.length() == 0) return "";
        char c = s.charAt(0);
        // 「ひらがな」から始まる語の省略
        if (JType.isHiragana(c)) {
            if (s.length() > 2) {
                return s;
            }
            // 定型語句の省略
            if (s.length() > 2) {
                String last2 = s.substring(s.length()-2,s.length());
                if (last2.compareTo("する") == 0) {
                    return s.substring(0, s.length() - 2);
                } else if (last2.compareTo("しろ") == 0) {
                    return s.substring(0, s.length() - 2);
                } else {
                    return s;
                }
            } else return s;
        }
        // 送り仮名を省く
        String res = "";
        for (int i = 0; i < s.length(); i++) {
            c = s.charAt(i);
            if (!JType.isHiragana(c)) {
                res += c;
            }
        }
        return res;
    }

}
