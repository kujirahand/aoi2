/**
 * vmtable.java generated by aoi_ir2java.aoi
 */
 
package com.aoikujira.aoi2.vm;

import java.util.*;
import com.aoikujira.aoi2.compiler.*;
import com.aoikujira.utils.*;

class vmtable {
    public IntegerHashtable ftable;
    public IntStrHashtable nametable;
    public vmtable() {
        ftable = new IntegerHashtable();
        nametable = new IntStrHashtable();
        init();
    }
    private void init() {
        ftable.putInt("_", 0);
        nametable.putIntStr(0, "NOP");
        ftable.putInt("b", 10);
        nametable.putIntStr(10, "PUSH_NULL");
        ftable.putInt("i", 11);
        nametable.putIntStr(11, "CONST_INT");
        ftable.putInt("n", 12);
        nametable.putIntStr(12, "CONST_NUM");
        ftable.putInt("s", 13);
        nametable.putIntStr(13, "CONST_STR");
        ftable.putInt("d", 14);
        nametable.putIntStr(14, "LOAD");
        ftable.putInt("D", 15);
        nametable.putIntStr(15, "LOAD_LOCAL");
        ftable.putInt("h", 16);
        nametable.putIntStr(16, "GET_HASH");
        ftable.putInt("t", 17);
        nametable.putIntStr(17, "STORE");
        ftable.putInt("T", 18);
        nametable.putIntStr(18, "STORE_LOCAL");
        ftable.putInt("=", 19);
        nametable.putIntStr(19, "LET");
        ftable.putInt("p", 20);
        nametable.putIntStr(20, "POP");
        ftable.putInt("+", 21);
        nametable.putIntStr(21, "ADD");
        ftable.putInt("-", 22);
        nametable.putIntStr(22, "SUB");
        ftable.putInt("*", 23);
        nametable.putIntStr(23, "MUL");
        ftable.putInt("/", 24);
        nametable.putIntStr(24, "DIV");
        ftable.putInt("%", 25);
        nametable.putIntStr(25, "MOD");
        ftable.putInt("&", 26);
        nametable.putIntStr(26, "ADDSTR");
        ftable.putInt(">", 27);
        nametable.putIntStr(27, "GT");
        ftable.putInt("G", 28);
        nametable.putIntStr(28, "GTEQ");
        ftable.putInt("<", 29);
        nametable.putIntStr(29, "LT");
        ftable.putInt("L", 30);
        nametable.putIntStr(30, "LTEQ");
        ftable.putInt("e", 31);
        nametable.putIntStr(31, "EQEQ");
        ftable.putInt("o", 32);
        nametable.putIntStr(32, "NOTEQ");
        ftable.putInt("!", 33);
        nametable.putIntStr(33, "NOT");
        ftable.putInt("A", 34);
        nametable.putIntStr(34, "AND");
        ftable.putInt("O", 35);
        nametable.putIntStr(35, "OR");
        ftable.putInt("r", 36);
        nametable.putIntStr(36, "RET");
        ftable.putInt("J", 37);
        nametable.putIntStr(37, "JUMP");
        ftable.putInt("Z", 38);
        nametable.putIntStr(38, "JUMP_ZERO");
        ftable.putInt("N", 39);
        nametable.putIntStr(39, "JUMP_NON_ZERO");
        ftable.putInt("u", 40);
        nametable.putIntStr(40, "CALL_USR");
        ftable.putInt("l", 41);
        nametable.putIntStr(41, "CALL_LIB");
        ftable.putInt("q", 42);
        nametable.putIntStr(42, "EXIT");
        ftable.putInt("~", 43);
        nametable.putIntStr(43, "EOL");
        ftable.putInt("w", 44);
        nametable.putIntStr(44, "POWER");

    }
/* const */
    public static final int NOP = 0;
    public static final int PUSH_NULL = 10;
    public static final int CONST_INT = 11;
    public static final int CONST_NUM = 12;
    public static final int CONST_STR = 13;
    public static final int LOAD = 14;
    public static final int LOAD_LOCAL = 15;
    public static final int GET_HASH = 16;
    public static final int STORE = 17;
    public static final int STORE_LOCAL = 18;
    public static final int LET = 19;
    public static final int POP = 20;
    public static final int ADD = 21;
    public static final int SUB = 22;
    public static final int MUL = 23;
    public static final int DIV = 24;
    public static final int MOD = 25;
    public static final int ADDSTR = 26;
    public static final int GT = 27;
    public static final int GTEQ = 28;
    public static final int LT = 29;
    public static final int LTEQ = 30;
    public static final int EQEQ = 31;
    public static final int NOTEQ = 32;
    public static final int NOT = 33;
    public static final int AND = 34;
    public static final int OR = 35;
    public static final int RET = 36;
    public static final int JUMP = 37;
    public static final int JUMP_ZERO = 38;
    public static final int JUMP_NON_ZERO = 39;
    public static final int CALL_USR = 40;
    public static final int CALL_LIB = 41;
    public static final int EXIT = 42;
    public static final int EOL = 43;
    public static final int POWER = 44;

/*
        switch (code) {
        case vmtable.NOP: run_NOP(); break;
        case vmtable.PUSH_NULL: run_PUSH_NULL(); break;
        case vmtable.CONST_INT: run_CONST_INT(); break;
        case vmtable.CONST_NUM: run_CONST_NUM(); break;
        case vmtable.CONST_STR: run_CONST_STR(); break;
        case vmtable.LOAD: run_LOAD(); break;
        case vmtable.LOAD_LOCAL: run_LOAD_LOCAL(); break;
        case vmtable.GET_HASH: run_GET_HASH(); break;
        case vmtable.STORE: run_STORE(); break;
        case vmtable.STORE_LOCAL: run_STORE_LOCAL(); break;
        case vmtable.LET: run_LET(); break;
        case vmtable.POP: run_POP(); break;
        case vmtable.ADD: run_ADD(); break;
        case vmtable.SUB: run_SUB(); break;
        case vmtable.MUL: run_MUL(); break;
        case vmtable.DIV: run_DIV(); break;
        case vmtable.MOD: run_MOD(); break;
        case vmtable.ADDSTR: run_ADDSTR(); break;
        case vmtable.GT: run_GT(); break;
        case vmtable.GTEQ: run_GTEQ(); break;
        case vmtable.LT: run_LT(); break;
        case vmtable.LTEQ: run_LTEQ(); break;
        case vmtable.EQEQ: run_EQEQ(); break;
        case vmtable.NOTEQ: run_NOTEQ(); break;
        case vmtable.NOT: run_NOT(); break;
        case vmtable.AND: run_AND(); break;
        case vmtable.OR: run_OR(); break;
        case vmtable.RET: run_RET(); break;
        case vmtable.JUMP: run_JUMP(); break;
        case vmtable.JUMP_ZERO: run_JUMP_ZERO(); break;
        case vmtable.JUMP_NON_ZERO: run_JUMP_NON_ZERO(); break;
        case vmtable.CALL_USR: run_CALL_USR(); break;
        case vmtable.CALL_LIB: run_CALL_LIB(); break;
        case vmtable.EXIT: run_EXIT(); break;
        case vmtable.EOL: run_EOL(); break;
        case vmtable.POWER: run_POWER(); break;

        }
*/
/*
    private void run_NOP() {}
    private void run_PUSH_NULL() {}
    private void run_CONST_INT() {}
    private void run_CONST_NUM() {}
    private void run_CONST_STR() {}
    private void run_LOAD() {}
    private void run_LOAD_LOCAL() {}
    private void run_GET_HASH() {}
    private void run_STORE() {}
    private void run_STORE_LOCAL() {}
    private void run_LET() {}
    private void run_POP() {}
    private void run_ADD() {}
    private void run_SUB() {}
    private void run_MUL() {}
    private void run_DIV() {}
    private void run_MOD() {}
    private void run_ADDSTR() {}
    private void run_GT() {}
    private void run_GTEQ() {}
    private void run_LT() {}
    private void run_LTEQ() {}
    private void run_EQEQ() {}
    private void run_NOTEQ() {}
    private void run_NOT() {}
    private void run_AND() {}
    private void run_OR() {}
    private void run_RET() {}
    private void run_JUMP() {}
    private void run_JUMP_ZERO() {}
    private void run_JUMP_NON_ZERO() {}
    private void run_CALL_USR() {}
    private void run_CALL_LIB() {}
    private void run_EXIT() {}
    private void run_EOL() {}
    private void run_POWER() {}

*/
}