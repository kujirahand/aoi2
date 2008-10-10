/*
 * CurString.java
 *
 * Created on 2007/01/30, 14:19
 */

package com.aoikujira.aoi2.compiler;
/**
 *
 * @author desk
 */
public class CurString {
    private String src;
    private int index;
    public String result;
    public String opt_str;
    public int lineno;
    public int fileid;

    public CurString(String s) {
        src = s;
        index = 0;
        result = "";
        opt_str = "";
        fileid = 0;
        lineno = 0;
    }
    public String getString() { return src; }
    public void setString(String s) { this.src = s; }
    public int getIndex() { return index; }
    public void setIndex(int i) { this.index = i; }

    public char getc() {
        return src.charAt(index++);
    }
    public char curChar() {
        return src.charAt(index);
    }
    public void next() { index++; }
    public void next(int n) { index += n; }
    public void prev() { index--; }
    public void prev(int n) { index -= n; }
    public boolean hasNext() {
        return (index < src.length());
    }
    public boolean compareKey(String key) {
        int last = index + key.length();
        if (last > src.length()) { return false; }
        String s = src.substring(index, last);
        return (key.compareTo(s) == 0);
    }
    public void skipSpace() {
        while ( this.hasNext() ) {
            char c = this.curChar();
            if ( (c == ' ') || (c == 9) ) {
                this.next();
            } else {
                break;
            }
        }
    }
    public String getToken(String splitter) {
        String res = "";
        while (hasNext()) {
            if (compareKey(splitter)) {
                next(splitter.length());
                break;
            }
            res += this.getc();
        }
        return res;
    }
    public String getStringAfterIndex() {
        return src.substring(index);
    }
}
