/*
 * BasicTokenizer.java
 *
 * Created on 2007/03/15, 13:33
 */

package com.aoikujira.aoi2.compiler.lang.basic;

import com.aoikujira.aoi2.compiler.*;


/**
 *
 * @author kujiramac
 */

public class BasicTokenizer extends Tokenizer {
    
    public BasicTokenizer(GlobalObject global, int fileid, String src) {
        super(global, fileid, src);
    }
    
    public void initTable () {
        initWordTable();
        initReserveTable();
    }
    
    public void plasticOperation() {
        source = BasicConv.convert(fileid, source);
    }
    
    public void split() {
        char c;
        lineno = 0;
        while (cur.hasNext()) {
            c = cur.curChar();
            if (c <= 0x7f) {
                // single byte
                switch (table[c]) {
                    case TokenType.NUMBER:
                        getNumber();
                        break;
                    case TokenType.FLAG:
                        getFlag();
                        break;
                    case TokenType.STRING:
                        getString();
                        break;
                    case TokenType.WORD:
                        getWord();
                        break;
                    case TokenType.NOP:
                        cur.next();
                        break;
                    default:
                        throw new AOICException(
                                ErrMsg.UnrecognizedChar + ":'" + c + "'(" + (int)c + ")");
                }
            } else {
                // multi byte
                getWord();
            }
        }
        Token eol_token = new Token(BasicParser.EOL, fileid, lineno);
        tokens.add(eol_token);
    }
    private void getFlag() {
        char c = cur.getc();
        Token tok = new Token(c, fileid, lineno);
        tok.value = new String("" + c);
        switch (c) {
            case '-':
                // check UMINUS
                if (tokens.size() == 0) {
                    tok.type = BasicParser.UMINUS;
                    break;
                }
                Token t = (Token)tokens.lastElement();
                if (t.type == BasicParser.WORD || t.type == BasicParser.FUNC || t.type == BasicParser.NUM || t.type == BasicParser.INT) {
                    tok.type = '-';
                } else {
                    tok.type = BasicParser.UMINUS;
                }
                break;
            case '=':
                c = cur.curChar();
                if (c == '=') {
                    cur.next();
                    tok.type = BasicParser.EQEQ;
                    tok.value = new String("==");
                } else {
                    tok.type = BasicParser.EQ;
                }
                break;
            case '>':
                c = cur.curChar();
                if (c == '=') {
                    cur.next(); tok.type = BasicParser.GTEQ;
                    tok.value = new String(">=");
                } else {
                    tok.type = BasicParser.GT;
                }
                break;
            case '<':
                c = cur.curChar();
                if (c == '=') {
                    cur.next(); tok.type = BasicParser.LTEQ; 
                    tok.value = new String("<=");
                } else { 
                    tok.type = BasicParser.LT; 
                }
                break;
            case '!':
                c = cur.curChar();
                if (c == '=') {
                    cur.next(); tok.type = BasicParser.NOTEQ; 
                    tok.value = new String("!=");
                } else { 
                    tok.type = BasicParser.NOT; 
                }
                break;
            case '%':
                tok.type = BasicParser.MOD;
                break;
            case '\n':
                tok.type = BasicParser.EOL;
                tok.lineno = lineno;
                tok.fileid = fileid;
                lineno++;
                break;
            default:
                tok.type  = c;
                tok.value = new String("" + c);
        }
        tokens.add(tok);
    }
    
    private void getString() {
        String str = "";
        char flag_end = cur.getc();
        char c;
        while (cur.hasNext()) {
            c = cur.getc();
            if (c == flag_end) break;
            if (c == '\\' && flag_end == '"') { // expand escape string
                c = cur.getc();
                switch (c) {
                    case 'n': str += "\n"; break;
                    case 'r': str += "\r"; break;
                    case 't': str += "\t"; break;
                    default:  str += c; break;
                }
                continue;
            }
            str += c;
        }
        Token tok = new Token(BasicParser.STR, fileid, lineno);
        tok.value = new String(str);
        tokens.add(tok);
        /** 文字列中にあった改行の個数を覚えておくための特殊措置
         * @link aoic.JConv.getNormalString
         * @link aoic.JConv.getExtensionString
         * 文字列中に改行があると "文字列"\n\n のような形式にする
         */
        while (cur.compareKey("\\n")) {
            lineno++;
            cur.next(2);
        }
        // ここまで
        return;
    }
    
    private void getWord() {
        Token tok = new Token(BasicParser.WORD, fileid, lineno);
        String str = "";
        char c;
        while (cur.hasNext()) {
            c = cur.curChar();
            if (c > 0x7F) { // multibyte
                str += c;
                cur.next();
                continue;
            }
            // singlebyte
            if (('a' <= c && c <= 'z') || ('A' <= c && c <= 'Z') || c == '_' ||
                    ('0' <= c && c <= '9')) {
                str += c;
                cur.next();
                continue;
            }
            break;
        }
        if (str.length() == 0) {
            return;
        }
        tok.value = new String(str);
        // 予約語をチェックする
        Integer r = reserve_table.getInteger(str);
        if (r != null) {
            tok.type = r.intValue();
        }
        // 関数かどうか調べる
        else if (global != null) {
            AVariable var = global.vars.getVar(str);
            if (var != null && var.isFunction()) {
                tok.type  = BasicParser.FUNC;
                tok.value = var;
            }
        }
        tokens.add(tok);
    }
    
    private void getNumber() {
        Token tok = new Token(BasicParser.NUM, fileid, lineno);
        char c = cur.curChar();
        // check hex number
        if (c == '$' || cur.compareKey("0x")) {
            if (c == '$') {
                cur.next(); // skip '$'
            } else if (cur.compareKey("0x")) {
                cur.next(2);
            }
            int num = 0;
            tok.type = BasicParser.INT;
            while (cur.hasNext()) {
                c = cur.curChar();
                if ('0' <= c && c <= '9') {
                    int n = c - '0';
                    num = (num << 4) + n;
                } else if ('a' <= c && c <= 'f') {
                    int n = c - 'a' + 10;
                    num = (num << 4) + n;
                } else if ('A' <= c && c <= 'F') {
                    int n = c - 'A' + 10;
                    num = (num << 4) + n;
                } else {
                    break;
                }
                cur.next();
            }
            tok.value = new Integer(num);
            tokens.add(tok);
            return;
        }
        // check integer
        int num = 0;
        while (cur.hasNext()) {
            c = cur.curChar();
            if ('0' <= c && c <= '9') {
                num = (num * 10) + (c - '0');
            } else {
                break;
            }
            cur.next();
        }
        // check double
        c = cur.curChar();
        if (c != '.') {
            tok.type  = BasicParser.INT;
            tok.value = new Integer(num);
            tokens.add(tok);
            return;
        }
        cur.next(); // skip '.'
        double f = 0.1;
        double v = (double)num;
        while (cur.hasNext()) {
            c = cur.curChar();
            if ('0' <= c && c <= '9') {
                v += (f * (c - '0'));
                f = f / 10;
                cur.next();
            } else {
                break;
            }
        }
        tok.type  = BasicParser.NUM;
        tok.value = new Double(v);
        tokens.add(tok);
        return;
    }
    
    public void initWordTable() {
        // word table
        table = new int[256];
        
        // initialize
        for (int i = 0; i < table.length; i++) {
            table[i] = 0;
        }
        // ---------------------------------------------------------------------
        // type table
        // ---------------------------------------------------------------------
        // number
        for (int i = '0'; i <= '9'; i++) {
            table[i] = TokenType.NUMBER;
        }
        table['$'] = TokenType.NUMBER;
        // ---------------------------------------------------------------------
        // word
        for (int i = 'a'; i <= 'z'; i++) {
            table[i] = TokenType.WORD;
        }
        for (int i = 'A'; i <= 'Z'; i++) {
            table[i] = TokenType.WORD;
        }
        table['_'] = TokenType.WORD;
        // ---------------------------------------------------------------------
        table[' ' ] = TokenType.NOP;
        table['\t'] = TokenType.NOP;
        table[',' ] = TokenType.FLAG;
        // string
        table['\n'] = TokenType.FLAG;
        table['\r'] = TokenType.FLAG;
        table['\"'] = TokenType.STRING;
        table['\''] = TokenType.STRING;
        // flag
        table['-'] = TokenType.FLAG;
        table['+'] = TokenType.FLAG;
        table['*'] = TokenType.FLAG;
        table['/'] = TokenType.FLAG;
        table['%'] = TokenType.FLAG;
        table['>'] = TokenType.FLAG;
        table['<'] = TokenType.FLAG;
        table['&'] = TokenType.FLAG;
        table['^'] = TokenType.FLAG;
        table['~'] = TokenType.FLAG;
        table['|'] = TokenType.FLAG;
        table['['] = TokenType.FLAG;
        table[']'] = TokenType.FLAG;
        table['('] = TokenType.FLAG;
        table[')'] = TokenType.FLAG;
        table['{'] = TokenType.FLAG;
        table['}'] = TokenType.FLAG;
        table['='] = TokenType.FLAG;
        table[';'] = TokenType.FLAG;
        table[':'] = TokenType.FLAG;
        table['&'] = TokenType.FLAG;
        table['!'] = TokenType.FLAG;
        table['@'] = TokenType.FLAG;
    }
    
    public void initReserveTable() {
        reserve_table.putInt("if",         BasicParser.IF);
        reserve_table.putInt("then",       BasicParser.THEN);
        reserve_table.putInt("for",        BasicParser.FOR);
        reserve_table.putInt("next",       BasicParser.NEXT);
        reserve_table.putInt("to",         BasicParser.TO);
        reserve_table.putInt("step",       BasicParser.STEP);
        reserve_table.putInt("while",      BasicParser.WHILE);
        reserve_table.putInt("wend",       BasicParser.WEND);
        reserve_table.putInt("function",   BasicParser.FUNCTION);
        reserve_table.putInt("end",        BasicParser.END);
        reserve_table.putInt("include",    BasicParser.INCLUDE);
        reserve_table.putInt("dim",        BasicParser.DIM);
        reserve_table.putInt("it",         BasicParser.IT);
        reserve_table.putInt("break",      BasicParser.BREAK);
        reserve_table.putInt("continue",   BasicParser.CONTINUE);
        reserve_table.putInt("const",      BasicParser.CONST);
        reserve_table.putInt("or",         BasicParser.OR);
        reserve_table.putInt("and",        BasicParser.AND);
        reserve_table.putInt("mod",        BasicParser.MOD);
        reserve_table.putInt("foreach",    BasicParser.FOREACH);
        reserve_table.putInt("in",         BasicParser.IN);
        reserve_table.putInt("return",     BasicParser.RETURN);
        reserve_table.putInt("sub",        BasicParser.SUB);
    }
}
