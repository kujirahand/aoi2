/*
 * BasicTokenChecker.java
 *
 * Created on 2007/03/15, 16:42
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.aoikujira.aoi2.compiler.lang.basic;

import com.aoikujira.aoi2.compiler.*;

public class BasicTokenChecker {
    
    private Tokenizer t;
    private GlobalObject global;
    
    public BasicTokenChecker(GlobalObject global, Tokenizer tokenizer) {
        t = tokenizer;
        this.global = global;
        defineFunction(); // Define User Function
        swapToken();  // swap WORD -> FUNCTION
    }
    
    private void defineFunction() {
        t.setTokenIndex(0);
        while (t.hasNextToken()) {
            Token tok = t.getCurToken();
            // end function
            if (tok.type == BasicParser.END) {
                t.nextToken(); // skip 'END'
                tok = t.getCurToken();
                if (tok != null && tok.type == BasicParser.FUNCTION) {
                    t.nextToken(); // skip 'FUNCTION'
                    continue;
                }
            }
            // define
            if (tok.type == BasicParser.FUNCTION) {
                defineFunction_def();
                continue;
            }
            // include
            if (tok.type == BasicParser.INCLUDE) {
                t.nextToken();
                Token tok_fname = t.getCurToken();
                if (tok_fname == null) {
                    throw new AOICException(ErrMsg.FileIncludeError, tok);
                }
                t.nextToken(); // skip 'NAME'
                defineFunction_include((String)tok_fname.value, tok);
            }
            // const
            if (tok.type == BasicParser.CONST) {
                Token t1 = tok;
                t.nextToken(); // skip CONST
                checkToken_const(t1);
            }
            t.nextToken();
        }
    }
    
    /**
     * INCLUDE FILE
     */
    private void defineFunction_include(String fname, Token include_token) {
        // System.out.println("INCLUDE:"+fname);
        String f = fname;
        if (! global.isApplet) {
            f = global.files.findFile(fname, this.t.fileid);
            if (f == null) {
                throw new AOICException(ErrMsg.FileIncludeError + fname, include_token);
            }
        }
        // double include ?
        if (global.files.getId(f) >= 0) return;
        // include
        Scanner scan = new BasicScanner(this.global);
        scan.loadFile(f);
        TokenVector tokens = scan.getTokens();
        Token dummy = new Token(BasicParser.EOL, include_token.fileid, include_token.lineno);
        tokens.insertElementAt(dummy, 0);
        for (int i = 0; i < tokens.size(); i++) {
            Token tok = tokens.getToken(i);
            t.tokens.insertElementAt(tok, t.token_index + i);
        }
        t.nextToken(tokens.size());
    }

    private void defineFunction_def() {
        Token tok;
        AFunction f = new AFunction();
        // function
        tok = t.getCurToken();
        t.nextToken(); // skip 'function'
        // name
        if (t.hasNextToken() == false) {
            throw new AOICException(ErrMsg.DefFuncInvalidName,
                    t.fileid, tok.lineno);
        }
        tok = t.getCurToken();
        if (tok.type != BasicParser.WORD) {
            throw new AOICException(ErrMsg.DefFuncInvalidName,
                    t.fileid, tok.lineno);
        }
        f.name = (String)tok.value;
        // args
        if (t.hasNextToken()) {
            t.nextToken(); // skip NAME
            tok = t.getCurToken();
            if (tok.type == '(') {
                t.nextToken(); // skip '('
                while (t.hasNextToken()) {
                    tok = t.getCurToken();
                    if (tok.type == ')') {
                        t.nextToken();
                        break;
                    }
                    if (tok.type == BasicParser.WORD) {
                        f.newArgument((String)tok.value);
                    } else {
                        throw new AOICException(ErrMsg.DefFuncInvalidArg,
                            t.fileid, tok.lineno);
                    }
                    t.nextToken(); // skip WORD
                    if (t.hasNextToken()) {
                        tok = t.getCurToken();
                        if (tok.type == ',') {
                            t.nextToken();
                        }
                    }
                }
            }
        }
        // regist global
        AVariable v = new AVariable(f.name, AVariable.USERFUNC);
        v.func = f;
        global.vars.add(v);
        f.funcno = v.funcno;
        // define library ?
        tok = t.getCurToken();
        if (tok != null && tok.type == BasicParser.EQ) {
            v.type = AVariable.LIBFUNC;
            defineFunction_lib(f);
            v.funcno = f.funcno;
        }
    }
    private void defineFunction_lib(AFunction f) {
        Tokenizer tokenizer = t;
        // EQ
        Token tok_eq     = tokenizer.getCurToken();
        tokenizer.nextToken();
        // MODULE_NAME
        Token tok_module = tokenizer.getCurToken();
        if (tok_module == null || tok_module.type != BasicParser.STR) throw new AOICException(ErrMsg.DefFuncLib, tok_eq);
        String mod_name = (String)tok_module.value;
        tokenizer.nextToken();
        // AT
        Token tok_at = tokenizer.getCurToken();
        if (tok_at == null || tok_at.type != '@') throw new AOICException(ErrMsg.DefFuncLib, tok_eq);
        tokenizer.nextToken();
        // FUNCTION NUMBER
        Token tok_num = tokenizer.getCurToken();
        if (tok_num == null || tok_num.type != BasicParser.INT) throw new AOICException(ErrMsg.DefFuncLib, tok_eq);
        tokenizer.nextToken();
        int funcno = ((Integer)tok_num.value).intValue();
        // ---
        AModule mod = global.getModule(mod_name);
        f.moduleno  = mod.id;
        f.funcno    = funcno;
        mod.setFunction(f.funcno, f);
    }
    
    private void swapToken() {
        t.setTokenIndex(0);
        while (t.hasNextToken()) {
            Token tok = t.getCurToken();
            
            // skip CONST
            if (tok.type == BasicParser.CONST) {
                t.nextToken(2);
                continue;
            }
            // swap WORD -> FUNC
            if (tok.type == BasicParser.WORD) {
                AVariable v = global.vars.getVar((String)tok.value);
                if (v != null) {
                    if (v.isFunction()) {
                        tok.type = BasicParser.FUNC;
                        tok.value = v;
                        t.nextToken();
                        continue;
                    }
                    // CONSTを置換
                    if (v.const_value != null) {
                        switch (v.type) {
                            case AVariable.INT: tok.type = BasicParser.INT; break;
                            case AVariable.NUM: tok.type = BasicParser.NUM; break;
                            case AVariable.STR: tok.type = BasicParser.STR; break;
                        }
                        tok.value = v.const_value;
                        t.nextToken();
                        continue;
                    }
                }
                String name = (String)tok.value;
                // macro
                if (name.compareTo("__LINE__") == 0) {
                    tok.type = BasicParser.INT;
                    tok.value = new Integer(tok.lineno);
                    t.nextToken();
                    continue;
                } else if (name.compareTo("__FILE__") == 0) {
                    tok.type = BasicParser.STR;
                    tok.value = new String(global.files.getFilename(tok.fileid));
                    t.nextToken();
                    continue;
                }
            }
            
            t.nextToken();
        }
    }
    private void checkToken_const(Token tok_const) {
        // CONST VAR = VALUE
        Token tok_name = t.getCurToken();
        if (tok_name == null) throw new AOICException(ErrMsg.DefConst, tok_const);
        // VAR
        String s_name  = (String)tok_name.value;
        t.nextToken();
        // EQ
        Token tok_eq = t.getCurToken();
        if (tok_eq == null) throw new AOICException(ErrMsg.DefConst, tok_const);
        if (tok_eq.type == BasicParser.EQ) {
            t.nextToken();
        } else {
            throw new AOICException(ErrMsg.DefConst, tok_const);
        }
        // VALUE
        Token tok_value = t.getCurToken();
        if (tok_value == null) throw new AOICException(ErrMsg.DefConst, tok_const);
        // define
        AVariable v = global.vars.getVar(s_name);
        if (v != null) { throw new AOICException(ErrMsg.AlreadyExistsVar, tok_const); }
        switch (tok_value.type) {
            case BasicParser.STR: v = new AVariable(s_name, AVariable.STR); break;
            case BasicParser.NUM: v = new AVariable(s_name, AVariable.NUM); break;
            case BasicParser.INT: v = new AVariable(s_name, AVariable.INT); break;
            default: throw new AOICException(ErrMsg.AlreadyExistsVar, tok_const);
        }
        v.const_value = tok_value.value;
        global.vars.add(v);
    }
}


