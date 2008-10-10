/*
 * AOITokenChecker.java
 *
 * Created on 2007/02/16, 9:24
 */

package com.aoikujira.aoi2.compiler.lang.aoi;

import com.aoikujira.aoi2.compiler.*;
import com.aoikujira.utils.*;

/**
 * Check token, define function
 * @author desk
 */
public class AOITokenChecker {
    
    private Tokenizer t;
    private GlobalObject global;
    
    public AOITokenChecker(GlobalObject global, Tokenizer tokenizer) {
        this.t = tokenizer;
        this.global = global;
        checkToken(); // Define AFunction
        swapToken();  // swap WORD -> FUNCTION
        swapSimpleFuncToken(); // FUNC(void) ->  '(' FUNC(void) ')'
        // todo: swap function token in calc
        //
        if (Main.isDebugMode) {
            KUtils.print("AOITokenChecker:" + t.toString() + "\n");
        }
    }
    
    private void swapSimpleFuncToken() {
        t.setTokenIndex(0);
        Token oldtok = null;
        while (t.hasNextToken()) {
            Token tok = t.getCurToken();
            if ((tok.type == AOIParser.FUNC || tok.type == AOIParser.FUNCARG)) {
                if (oldtok != null && oldtok.type == '*') {
                    t.nextToken();
                    continue;
                }
                // 例外) １語で終わってしまう時｜式の値とならない場合
                if (t.hasNextToken()) {
                    Token tok2 = t.getNextToken();
                    if (tok2.type == AOIParser.EOL || tok2.type == ';') {
                        t.nextToken();
                        continue;
                    }
                } else {
                    t.nextToken();
                    continue;
                }
                AVariable v = (AVariable)tok.value;
                if (v.func.args.size() == 0) {
                    Token k1 = new Token('(', tok.fileid, tok.lineno);
                    Token k2 = new Token(')', tok.fileid, tok.lineno);
                    k2.josi = tok.josi;
                    tok.type = AOIParser.FUNC;
                    t.tokens.insertElementAt(k1, t.token_index);
                    t.tokens.insertElementAt(k2, t.token_index+2);
                    t.nextToken(2);
                    continue;
                }
            }
            oldtok = tok;
            t.nextToken();
        }
    }
    
    private void swapToken() {
        t.setTokenIndex(0);
        while (t.hasNextToken()) {
            // xxx は xxx
            Token tok = t.getCurToken();
            if (tok.josi != null && tok.josi.compareTo("は") == 0) {
                tok.josi = "";
                Token eq = new Token(AOIParser.EQ, tok.fileid, tok.lineno);
                t.tokens.insertElementAt(eq, t.token_index+1);
                t.nextToken();
                continue;
            }
            // A とは B
            if (tok.josi != null && tok.josi.compareTo("とは") == 0) {
                tok.josi = "";
                Token eq = new Token(AOIParser.AS, tok.fileid, tok.lineno);
                t.tokens.insertElementAt(eq, t.token_index+1);
                t.nextToken();
                continue;
            }
            // skip CONST
            if (tok.type == AOIParser.CONST) {
                t.nextToken(2);
                continue;
            }
            // 関数を取り替える
            if (tok.type == AOIParser.WORD) {
                String      name = (String)tok.value;
                // macro
                if (name.compareTo("__LINE__") == 0) {
                    tok.type = AOIParser.INT;
                    tok.value = new Integer(tok.lineno);
                    t.nextToken();
                    continue;
                } else if (name.compareTo("__FILE__") == 0) {
                    tok.type = AOIParser.STR;
                    tok.value = new String(global.files.getFilename(tok.fileid));
                    t.nextToken();
                    continue;
                }
                
                // 関数かどうか判断してトークンをWORDからFUNCに差し替える
                AVariable var  = global.vars.getVar(name);
                if (var != null) {
                    if (var.isFunction()) {
                        if (tok.josi != null && tok.josi.length() > 0) {
                            tok.type  = AOIParser.FUNCARG;
                        } else {
                            tok.type  = AOIParser.FUNC;
                        }
                        AFunction f = var.func;
                        if (f.is_accessor) {
                            tok.type = AOIParser.ACCESSOR;
                        }
                        tok.value = var;
                        t.nextToken();
                        continue;
                    }
                    // CONSTを置換
                    if (var.const_value != null) {
                        switch (var.type) {
                            case AVariable.INT: tok.type = AOIParser.INT; break;
                            case AVariable.NUM: tok.type = AOIParser.NUM; break;
                            case AVariable.STR: tok.type = AOIParser.STR; break;
                        }
                        tok.value = var.const_value;
                        t.nextToken();
                        continue;
                    }
                }
            }
            t.nextToken();
        }
    }
    
    private void checkToken() {
        t.setTokenIndex(0);
        while (t.hasNextToken(2)) {
            Token t1 = t.getCurToken();
            Token t2 = t.getNextToken(); // 先読み用
            // find function
            if (t.token_index == 0 && t1.type == '*') {
                t.nextToken(1); // skip > '*'
                checkToken_defFunc();
                continue;
            }
            if (t1.type == AOIParser.EOL && t2.type == '*') {
                t.nextToken(2); // skip > EOL + '*'
                checkToken_defFunc();
                continue;
            }
            if (t1.type == AOIParser.STR && t2.type == AOIParser.INCLUDE) {
                t.nextToken(2);
                checkToken_include((String)t1.value, t2);
                continue;
            }
            // CONST
            if (t1.type == AOIParser.CONST) {
                t.nextToken();
                checkToken_const(t1);
            }
            t.nextToken();
        }
    }
    /**
     * 外部ファイルの取り込み
     */
    private void checkToken_include(String fname, Token include_token) {
        // System.out.println("INCLUDE:"+fname);
        String f = fname;
        if (global.isApplet == false) {
            f = global.files.findFile(fname, this.t.fileid);
            if (f == null) {
                throw new AOICException(ErrMsg.FileIncludeError + fname, include_token);
            }
        }
        // 二重取り込みはしない
        if (global.files.getId(f) >= 0) return; 
        // include
        Scanner scan = new AOIScanner(this.global);
        scan.loadFile(f);
        TokenVector tokens = scan.getTokens();
        Token dummy = new Token(AOIParser.EOL, include_token.fileid, include_token.lineno);
        tokens.insertElementAt(dummy, 0);
        for (int i = 0; i < tokens.size(); i++) {
            Token tok = tokens.getToken(i);
            t.tokens.insertElementAt(tok, t.token_index + i);
        }
        t.nextToken(tokens.size());
    }
    /**
     * 関数の定義を調べて登録する
     */
    private void checkToken_defFunc() {
        Token tok;
        AFunction f = new AFunction();
        // get name
        if (!t.hasNextToken()) {
            t.prevToken(2);
            tok = t.getCurToken();
            throw new AOICException(ErrMsg.DefFuncInvalidName,
                    t.fileid, tok.lineno);
        }
        tok = t.getCurToken();
        if (tok.type != AOIParser.WORD) {
            throw new AOICException(ErrMsg.DefFuncInvalidName,
                    t.fileid, tok.lineno);
        }
        f.name = (String)tok.value;
        t.nextToken(); // skip NAME
        // DEF_PROPERTY||DEF_ACCESSOR
        if (t.hasNextToken()) {
            Token tok2 = t.getCurToken();
            if (tok2.type == AOIParser.DEF_ACCESSOR) {
                tok.type = AOIParser.ACCESSOR;
                defFunc_accessor(f);
            }
        }
        // get args
        if (t.hasNextToken()) {
            defFunc_args(f);
        }
        // regist global
        AVariable v = new AVariable(f.name, AVariable.USERFUNC);
        v.func = f;
        global.vars.add(v);
        f.funcno = v.funcno;
        // define library ?
        tok = t.getCurToken();
        if (tok != null && tok.type == AOIParser.EQ) {
            v.type = AVariable.LIBFUNC;
            defFunc_lib(f);
            v.funcno = f.funcno;
        }
    }
    private void defFunc_accessor(AFunction f) {
        f.is_accessor = true;
        Token tok_accessor = t.getCurToken();
        t.nextToken(); // skip ACCESSOR
        for (int i = 0; (i < 2) && (t.hasNextToken()); i++) {
            Token tok_dir = t.getCurToken(); t.nextToken();
            if (!t.hasNextToken()) {
                throw new AOICException(ErrMsg.DefAccessor, tok_accessor);
            }
            Token tok_func = t.getCurToken(); t.nextToken();
            String s_name = (String)tok_func.value;
            AVariable v = global.vars.getVar(s_name);
            if (v == null) {
                throw new AOICException(
                        ErrMsg.DefAccessor + ErrMsg.NotDefineFunction + ":" + s_name,
                        tok_accessor);
            }
            if (tok_dir.type == AOIParser.LT) {
                f.link_setter = v;
            } else if (tok_dir.type == AOIParser.GT) {
                f.link_getter = v;
            } else {
                throw new AOICException(ErrMsg.DefAccessor, tok_dir);
            }
        }
    }
    private void defFunc_lib(AFunction f) {
        // EQ
        Token tok_eq     = t.getCurToken();
        t.nextToken();
        // MODULE_NAME
        Token tok_module = t.getCurToken();
        if (tok_module == null || tok_module.type != AOIParser.STR) throw new AOICException(ErrMsg.DefFuncLib, tok_eq);
        String mod_name = (String)tok_module.value;
        t.nextToken();
        // AT
        Token tok_at = t.getCurToken();
        if (tok_at == null || tok_at.type != '@') throw new AOICException(ErrMsg.DefFuncLib, tok_eq);
        t.nextToken();
        // FUNCTION NUMBER
        Token tok_num = t.getCurToken();
        if (tok_num == null || tok_num.type != AOIParser.INT) throw new AOICException(ErrMsg.DefFuncLib, tok_eq);
        t.nextToken();
        int funcno = ((Integer)tok_num.value).intValue();
        // ---
        AModule mod = global.getModule(mod_name);
        f.moduleno  = mod.id;
        f.funcno    = funcno;
        mod.setFunction(f.funcno, f);
    }
    
    private void defFunc_args(AFunction f) {
        Token tok = t.getCurToken();
        if (tok.type != '(') return;
        t.nextToken(); // skip '(''
        
        while (t.hasNextToken()) {
            tok = t.getCurToken();
            if (tok.type == ')') {
                t.nextToken();
                break;
            }
            if (tok.type == '|') {
                t.nextToken();
                continue;
            }
            if (tok.type == AOIParser.WORD) {
                String name = (String)tok.value;
                String josi = (String)tok.josi;
                AArgument arg = f.getArg(name);
                if (arg == null) {
                    arg = f.newArgument(name);
                }
                arg.addJosi(josi);
            } else {
                throw new AOICException(ErrMsg.DefFuncInvalidName, 
                        t.fileid, tok.lineno);
            }
            t.nextToken();
        }
    }
    /**
     * 定数の定義
     */
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
        if (tok_eq.type == AOIParser.EQ) {
            t.nextToken();
        }
        // VALUE
        Token tok_value = t.getCurToken();
        if (tok_value == null) throw new AOICException(ErrMsg.DefConst, tok_const);
        // define
        AVariable v = global.vars.getVar(s_name);
        if (v != null) { throw new AOICException(ErrMsg.AlreadyExistsVar, tok_const); }
        switch (tok_value.type) {
            case AOIParser.STR: v = new AVariable(s_name, AVariable.STR); break;
            case AOIParser.NUM: v = new AVariable(s_name, AVariable.NUM); break;
            case AOIParser.INT: v = new AVariable(s_name, AVariable.INT); break;
        }
        v.const_value = tok_value.value;
        global.vars.add(v);
    }
    
}
