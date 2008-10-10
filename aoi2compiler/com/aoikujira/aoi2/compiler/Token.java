/*
 * Token.java
 *
 * Created on 2007/01/30, 22:53
 */

package com.aoikujira.aoi2.compiler;

/**
 *
 * @author desk
 */
public class Token {
    public int          type;
    public Object       value;
    public String       josi;
    public int          fileid;
    public int          lineno;
    public TokenVector  items;
    
    public Token(int type, int fileid, int lineno) {
        this.type = type;
        this.fileid = fileid;
        this.lineno = lineno;
        this.items  = null;
    }
    
    public boolean hasItems() {
        if (items == null || items.size() == 0) return false;
        return true;
    }
    
    public TokenVector expand() {
        TokenVector res = new TokenVector();
        if (!hasItems()) {
            res.add(this);
            return res;
        }
        // sub item があるときは、自身はただの節ノードなので、
        // 自身をリストに追加してはいけない
        for (int i = 0; i < items.size(); i++) {
            Token t = items.getToken(i);
            if (!t.hasItems()) {
                res.add(t);
                continue;
            }
            TokenVector e = t.expand();
            res.appendVector(e);
        }
        return res;
    }
    
    public String toString() {
        if (value == null) {
            return "";
        } else {
            String s = value.getClass().getName();
            if (s.equals("aoic.AVariable")) {
                AVariable a = (AVariable)value;
                return a.name;
            } else {
                return value.toString();
            }
        }
    }
}

