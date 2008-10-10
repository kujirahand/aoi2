package com.aoikujira.aoi2.compiler;

import java.net.URL;
import java.io.IOException;
import com.aoikujira.utils.*;

public class Scanner {
    
    public Tokenizer tokenizer;
    public int index;
    public Token cur;
    public GlobalObject global;
    protected String source;
    public int fileid;
    public String fileext;
    public Parser parser;
    
    public Scanner(GlobalObject global) {
        index = 0;
        this.global = global;
        source = "";
    }
    
    /**
     * 必ず継承先で指定する
     */
    public void tokenize() {
        // error
        throw new AOICException(ErrMsg.NoParser + ":" + global.files.getFilename(fileid));
    }
    
    public final void loadFile(String fname) {
        if (global.isApplet) {
            fileid = global.files.add(fname);
            try {
                source = KUtils.getUrl(new URL(global.base_url, fname));
            } catch (Exception e) {
                throw new RuntimeException(e.getMessage());
            }
        } else {
            fname = global.files.findFile(fname, -1);
            fileid = global.files.add(fname);
            source = KUtils.loadFromFile(fname);
        }
        tokenize();
        
    }
    
    public final void setSource(String s) {
        this.fileid = global.files.add("Main");
        this.source = s;
        tokenize();
    }
    
    public TokenVector getTokens() {
        return tokenizer.tokens;
    }
    
    public boolean advance() throws IOException {
        if (tokenizer.tokens.size() <= index) {
            return false;
        }
        cur = (Token)tokenizer.tokens.get(index++);
        if (Main.isDebugMode) {
            String s = getTokenStr(cur);
            System.out.print("["+s+"]");
        }
        global.fileid = cur.fileid;
        global.lineno = cur.lineno;
        return true;
    }
    
    public String getTokenStr(Token tok) {
        return String.valueOf(tok.type);
    }

    public int token() {
        return cur.type;
    }
    
    public Object value() {
        return (Object)cur;
    }
    
    public String reportCur() {
        if (cur == null)        { return ErrMsg.SystemError; }
        if (cur.value == null)  { return ErrMsg.SyntaxError; }
        String s = ErrMsg.Nearby +  ":\"" + cur.toString() + '"';
        return s;
    }
}
