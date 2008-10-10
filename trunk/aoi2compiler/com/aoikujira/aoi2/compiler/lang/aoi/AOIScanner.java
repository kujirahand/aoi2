/*
 * AOIScanner.java
 *
 * Created on 2007/03/15, 12:01
 */

package com.aoikujira.aoi2.compiler.lang.aoi;

import com.aoikujira.aoi2.compiler.*;

/**
 *
 * @author kujiramac
 *
 * tokenize = JConv -> AOITokenizer -> AOITokenChecker -> [parse]
 *
 */

public class AOIScanner extends Scanner implements AOIParser.yyInput {
    
    public AOIScanner(GlobalObject global) {
        super(global);
    }
    
    public void tokenize() {
        tokenizer = new AOITokenizer(global, fileid, source);
        tokenizer.split();
        //KUtils.print( "*tokens:\n" + tokenizer.toString() + "\n\n");
        new AOITokenChecker(global, tokenizer);
        //KUtils.print( "*after:\n" + tokenizer.toString() + "\n\n");
        parser = new AOIParser(global);
    }
    
    public String getTokenStr(Token tok) {
        switch (tok.type) {
            case AOIParser.INT:    return (String)(tok.value.toString());
            case AOIParser.NUM:    return (String)(tok.value.toString());
            case AOIParser.STR:    return (String)(tok.value);
            case AOIParser.WORD:   return (String)(tok.value);
            case AOIParser.FUNC:
                AVariable v = (AVariable)tok.value;
                return v.name;
        }
        return AOIParser.yyName(tok.type);
    }
}
