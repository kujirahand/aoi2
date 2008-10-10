
package com.aoikujira.aoi2.compiler;

import java.util.Vector;

//public class TokenVector extends Vector<Token> {
public class TokenVector extends Vector {
	private static final long serialVersionUID = 1L;
	public Token getToken(int index) {
        return (Token)get(index);
    }
    public TokenVector expandItems() {
        TokenVector res = new TokenVector();
        for (int i = 0; i < this.size(); i++) {
            Token t = this.getToken(i);
            if (!t.hasItems()) {
                res.add(t);
                continue;
            }
            // expand
            TokenVector e = t.expand();
            res.appendVector(e);
        }
        return res;
    }
    public void appendVector(TokenVector v) {
        if (v == null) return;
        for (int i = 0; i < v.size(); i++) {
            this.add(v.getToken(i));
        }
    }
}
