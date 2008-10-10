/*
 * AOITokenizer.java
 *
 * Created on 2007/01/30, 21:11
 */

package com.aoikujira.aoi2.compiler.lang.aoi;

import com.aoikujira.aoi2.compiler.*;
import com.aoikujira.utils.*;

/**
 * AOITokenizer
 * 
 * @author desk
 */
public class AOITokenizer extends Tokenizer{
    
    private StringVector josi_table;
    public final static String SORE = "それ";

    
    public AOITokenizer(GlobalObject global, int fileid, String src) {
        super(global, fileid, src);
    }
    
    public void initTable() {
        initWordTable();
        initJosiTable();
        initReserveTable();
    }
    
    public void plasticOperation() {
        source = JConv.convert(fileid, source);
        //KUtils.saveToFile("aoic/formated"+fileid+".txt",source);
    }
    
        
    /** for debug */
    public String toString() {
        String result = "";
        for (int i = 0; i < tokens.size(); i++) {
            result += "[";
            Token t = (Token)tokens.get(i);
            if (t.value != null) {
                String klass = t.value.getClass().getName();
                if (klass.equals("aoic.AVariable")) {
                    result += ((AVariable)t.value).name;
                } else {
                    result += (String)t.value.toString();
                }
                result += ":" + AOIParser.yyName(t.type);
            } else {
                result += AOIParser.yyName(t.type);
            }
            if (t.josi != null && t.josi.length() > 0) {
                result += "(" + t.josi + ")";
            }
            result += "]";
        }
        return result;
    }
    
    public String toStringMore() {
        String result = "";
        for (int i = 0; i < tokens.size(); i++) {
            Token t = (Token)tokens.get(i);
            result += "[" ;
            if (t.value != null) {
                result += (String)t.value.toString();
            }
            result += ":";
            if (t.josi != null) {
                result += t.josi;
            }
            result += "(" + Integer.toString(t.type) + ")";
            result += "]";
        }
        return result;
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
                                ErrMsg.UnrecognizedChar + ":'" + c + "'(" + (int)c + ")",
                                fileid, lineno);
                }
            } else {
                // multi byte
                getWord();
            }
        }
        tokens.add(new Token(AOIParser.EOL, fileid, lineno));
    }
    
    private void getFlag() {
        char c = cur.getc();
        Token tok = new Token(c, fileid, lineno);
        tok.value = new String("" + c);
        switch (c) {
            case '-':
                // check UMINUS
                if (tokens.size() == 0) {
                    tok.type = AOIParser.UMINUS;
                    break;
                }
                Token t = (Token)tokens.lastElement();
                if (t.type == AOIParser.WORD || t.type == AOIParser.FUNC ||
                       t.type == AOIParser.NUM || t.type == AOIParser.INT ||
                       t.type == ')') {
                    tok.type = '-';
                } else {
                    tok.type = AOIParser.UMINUS;
                }
                break;
            case '=':
                c = cur.curChar();
                if (c == '=') {
                    cur.next();
                    tok.type = AOIParser.EQEQ;
                    tok.value = new String("==");
                } else {
                    tok.type = AOIParser.EQ;
                }
                break;
            case '>':
                c = cur.curChar();
                if (c == '=') {
                    cur.next(); tok.type = AOIParser.GTEQ;
                    tok.value = new String(">=");
                } else {
                    tok.type = AOIParser.GT;
                }
                break;
            case '<':
                c = cur.curChar();
                if (c == '=') {
                    cur.next(); tok.type = AOIParser.LTEQ; 
                    tok.value = new String("<=");
                } else if (c == '>') {
                    cur.next(); tok.type = AOIParser.NOTEQ; 
                    tok.value = new String("<>");
                } else { 
                    tok.type = AOIParser.LT; 
                }
                break;
            case '!':
                c = cur.curChar();
                if (c == '=') {
                    cur.next(); tok.type = AOIParser.NOTEQ; 
                    tok.value = new String("!=");
                } else { 
                    tok.type = AOIParser.NOT; 
                }
                break;
            case '|':
                c = cur.curChar();
                if (c == '|') {
                    tok.type = AOIParser.OR;
                    cur.next();
                    tok.value = new String("||");
                } else {
                    tok.type = '|';
                    tok.value = new String("|");
                }
                break;
            case '&':
                c = cur.curChar();
                if (c == '&') {
                    tok.type = AOIParser.AND;
                    tok.value = new String("&&");
                    cur.next();
                } else {
                    tok.type = '&';
                    tok.value = new String("&");
                }
                break;
            case '\n':
                tok.type = AOIParser.EOL;
                tok.value = new String("\\n");
                lineno++;
                break;
            default:
                tok.type  = c;
                tok.value = new String("" + c);
                checkJosi(tok);
        }
        tokens.add(tok);
    }
    
    private void getNumber() {
        Token tok = new Token(AOIParser.NUM, fileid, lineno);
        char c = cur.curChar();
        // check hex number
        if (c == '$' || cur.compareKey("0x")) {
            if (c == '$') {
                cur.next(); // skip '$'
            } else if (cur.compareKey("0x")) {
                cur.next(2);
            }
            int num = 0;
            tok.type = AOIParser.INT;
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
            checkJosi(tok);
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
            tok.type  = AOIParser.INT;
            tok.value = new Integer(num);
            tokens.add(tok);
            checkJosi(tok);
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
        tok.type  = AOIParser.NUM;
        tok.value = new Double(v);
        tokens.add(tok);
        checkJosi(tok);
        return;
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
        Token tok = new Token(AOIParser.STR, fileid, lineno);
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
        checkJosi(tok);
        return;
    }
    
    private void getWord() {
        Token tok = new Token(AOIParser.WORD, fileid, lineno);
        String str = "";
        char c;
        word_loop: while (cur.hasNext()) {
            c = cur.curChar();
            if (c > 0x7F) { // multibyte
                if (cur.compareKey("または")) {
                    if (str.length() > 0) {
                        cur.next(3);
                        break;
                    }
                    str = "または"; cur.next(3);
                    break;
                }
                // check josi
                for (int i = 0; i < josi_table.size(); i++) {
                    String josi = (String)josi_table.get(i);
                    if (cur.compareKey(josi)) {
                        tok.josi = josi;
                        cur.next(josi.length());
                        break word_loop;
                    }
                }
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
        // 送り仮名の省略
        str = JType.removeOkurigana(str);
        tok.value = new String(str);
        // 予約語をチェックする
        Integer r = reserve_table.getInteger(str);
        if (r != null) {
            tok.type = r.intValue();
            if (tok.type == AOIParser.END) {
                int tmp = cur.getIndex();
                while (cur.hasNext() && cur.curChar() == '\n') {
                    cur.next();
                }
                if (cur.hasNext() && cur.curChar() != '違') {
                    cur.setIndex(tmp);
                }
            }
        }
        // 関数かどうか調べる
        else if (global != null) {
            AVariable var = global.vars.getVar(str);
            if (var != null && var.isFunction()) {
                tok.type  = AOIParser.FUNC;
                tok.value = var;
                if (tok.josi != null && tok.josi.length() > 0) {
                    tok.type = AOIParser.FUNCARG;
                }
            }
        }
        tokens.add(tok);
    }
    
    
    public boolean checkJosi(Token tok) {
        String josi;
        cur.skipSpace();
        for (int i = 0; i < josi_table.size(); i++) {
            josi = (String)josi_table.get(i);
            if (cur.compareKey(josi)) {
                cur.next(josi.length());
                tok.josi = josi;
                return true;
            }
        }
        return false;
    }
    
    private void initJosiTable() {
        // josi table
        josi_table = new StringVector();
        josi_table.add("でなければ");
        josi_table.add("について");
        josi_table.add("ならば");
        josi_table.add("として");
        josi_table.add("くらい");
        josi_table.add("なのか");
        josi_table.add("までを");
        josi_table.add("までの");
        josi_table.add("なら");
        josi_table.add("より");
        josi_table.add("ほど");
        josi_table.add("など");
        josi_table.add("って");
        josi_table.add("から");
        josi_table.add("まで");
        josi_table.add("では");
        josi_table.add("だけ");
        josi_table.add("とは");
        josi_table.add("して");
        josi_table.add("で");
        josi_table.add("を");
        josi_table.add("の");
        josi_table.add("が");
        josi_table.add("に");
        josi_table.add("へ");
        josi_table.add("と");
        josi_table.add("は");
        josi_table.add("て");
        josi_table.add("に");
    }
    
    private void initWordTable() {
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
        table[',' ] = TokenType.NOP;
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
        table['.'] = TokenType.FLAG;
        table['^'] = TokenType.FLAG;
    }
    
    private void initReserveTable() {
        reserve_table.putInt("もし",AOIParser.IF);
        reserve_table.putInt("違",AOIParser.ELSE);
        reserve_table.putInt("繰返",AOIParser.FOR);
        reserve_table.putInt("回",AOIParser.REPEAT);
        reserve_table.putInt("間",AOIParser.WHILE);
        reserve_table.putInt("戻",AOIParser.RETURN);
        reserve_table.putInt("抜",AOIParser.BREAK);
        reserve_table.putInt("続",AOIParser.CONTINUE);
        reserve_table.putInt("取込",AOIParser.INCLUDE);
        reserve_table.putInt("ローカル変数",AOIParser.LOCAL);
        reserve_table.putInt("アクセサ",AOIParser.DEF_ACCESSOR);
        reserve_table.putInt("定数",AOIParser.CONST);
        reserve_table.putInt("または",AOIParser.OR);
        reserve_table.putInt("かつ",AOIParser.AND);
        reserve_table.putInt("反復",AOIParser.FOREACH);
        reserve_table.putInt(Indent.BEGIN, AOIParser.BEGIN);
        reserve_table.putInt(Indent.END, AOIParser.END);
    }
}

