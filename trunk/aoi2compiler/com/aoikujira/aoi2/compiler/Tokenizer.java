/*
 * Tokenizer.java
 *
 * Created on 2007/03/15, 9:25
 *
 * @author kujiramac
 *
 */

package com.aoikujira.aoi2.compiler;

import com.aoikujira.utils.*;

public class Tokenizer {

    // data
    protected GlobalObject global;
    public int token_index;
    public TokenVector tokens;
    // source info
    public int fileid;
    public int lineno;
    protected CurString cur;
    protected String source;
    // table
    protected IntegerHashtable reserve_table;
    protected int[] table;
    // memory posision
    protected IntegerVector pos_stack;
    
    public Tokenizer(GlobalObject global, int fileid, String src) {
        // set object
        this.global = global;
        this.fileid = fileid;
        this.source = src;
        // create object
        tokens = new TokenVector();
        reserve_table = new IntegerHashtable();
        // init
        init();
    }
    
    private void init() {
        initTable();
        plasticOperation();
        cur = new CurString(source);
        cur.fileid = fileid;
        pos_stack = new IntegerVector();
    }
    
    /** 継承先クラスで以下のメソッドを実装する */
    public void initTable() {}
    public void plasticOperation() {}
    public void split() {}
    
    /** for token_index */
    public void setTokenIndex(int index) {
        token_index = index;
    }
    public boolean hasNextToken() {
        return (token_index  < tokens.size());
    }
    public boolean hasNextToken(int len) {
        return ((token_index + len) < tokens.size());
    }
    public void nextToken() {
        token_index++;
    }
    public void nextToken(int inc) {
        token_index += inc;
    }
    public Token getCurToken() {
        return tokens.getToken(token_index);
    }
    public Token getNextToken() {
        return tokens.getToken(token_index + 1);
    }
    public void prevToken(int dec) {
        token_index -= dec;
    }
    public void pushIndex() {
        pos_stack.add(new Integer(token_index));
    }
    public boolean popIndex() {
        if (pos_stack.size() == 0) return false;
        token_index = pos_stack.getInt(pos_stack.size() - 1, 0);
        pos_stack.remove(pos_stack.size() - 1);
        return true;
    }
    public boolean popIndexToRemove() {
        if (pos_stack.size() == 0) return false;
        pos_stack.remove(pos_stack.size() - 1);
        return true;
    }
}
