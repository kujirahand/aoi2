/*
 * BasicScanner.java
 *
 * Created on 2007/03/15, 12:02
 */

package com.aoikujira.aoi2.compiler.lang.basic;

import com.aoikujira.aoi2.compiler.*;

/**
 *
 * @author kujiramac
 */

public class BasicScanner extends Scanner implements BasicParser.yyInput {
    
    public BasicScanner(GlobalObject global) {
        super(global);
    }
    public void tokenize() {
        tokenizer = new BasicTokenizer(global, fileid, source);
        tokenizer.split();
        new BasicTokenChecker(global, tokenizer);
        parser = new BasicParser(global);
    }
    
    public String getTokenStr(Token tok) {
        switch (tok.type) {
            case BasicParser.INT:    return (String)(tok.value.toString());
            case BasicParser.NUM:    return (String)(tok.value.toString());
            case BasicParser.STR:    return '"' + (String)(tok.value) + '"';
            case BasicParser.WORD:   return (String)(tok.value);
            case BasicParser.FUNC:
                AVariable v = (AVariable)tok.value;
                return v.name;
        }
        return BasicParser.yyName(tok.type);
    }
}
