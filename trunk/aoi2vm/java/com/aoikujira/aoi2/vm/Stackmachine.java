/*
 * Stackmachine.java
 *
 * Created on 2007/02/20, 22:30
 */

package com.aoikujira.aoi2.vm;

/**
 *
 * @author kujiramac
 */

import java.lang.reflect.InvocationTargetException;
import java.util.Vector;

import com.aoikujira.aoi2.avalue.AValue;
import com.aoikujira.aoi2.avalue.AValueHashtable;
import com.aoikujira.aoi2.avalue.AValueVector;
import com.aoikujira.aoi2.compiler.Main;
import com.aoikujira.utils.*;

public class Stackmachine {
    
    //public class FuncFrameVector extends Vector <FuncFrame> {}
    public class FuncFrameVector extends Vector {
		private static final long serialVersionUID = 1L;}
    public class IRCodeVector extends Vector {
		private static final long serialVersionUID = 1L;}
    public class AFunctionVector extends Vector {
		private static final long serialVersionUID = 1L;}
    
    AValueVector        stack;
    FuncFrameVector     funcstack;
    IRCodeVector        ir;
    StringVector        string_table;
    AFunctionVector     func_table;
    AModuleVector       module_table;
    StringVector        varname_table;
    public aoivm        parent;
    private int         index;
    public boolean      flag_quit;
    private IRCode      cur;
    public AValueVector globalvar;
    private FuncFrame   cur_frame;
    public int          lineno;
    
    public Stackmachine(aoivm parent) {
        this.parent = parent;
        ir              = new IRCodeVector();
        string_table    = new StringVector();
        func_table      = new AFunctionVector();
        globalvar       = new AValueVector();
        stack           = new AValueVector();
        funcstack       = new FuncFrameVector();
        cur_frame       = new FuncFrame();
        module_table    = new AModuleVector();
        varname_table   = new StringVector();
        funcstack.add(cur_frame);
        index = 0;
        lineno = 0;
        // --- init
        // register arguments
        AValue sore = cur_frame.getSore();
        sore.array_create();
        // console mode
        if (Main.main_args != null) { 
            for (int i = 0; i < Main.main_args.size(); i++) {
                String s = Main.main_args.getStr(i);
                sore.array_add(new AValue(s));
            }
        }
        
    }
    
    public void run() {
        int old_index;
        while (ir.size() > index) {
            if (flag_quit) break;
            old_index = index;
            cur = (IRCode)ir.get(index);
            // debug
            if (parent.isDebugMode) {
                int c = cur.code;
                if (c == vmtable.LOAD || c == vmtable.STORE) {
                    System.out.println(index+":"+cur.name+":"+ 
                            (int)cur.value + ":" + varname_table.getStr((int)cur.value));
                } if (c == vmtable.EOL) {
                    int lineno = (int)cur.value;
                    int fileno = lineno >> 16;
                    lineno = lineno & 0xFFFF;
                    KUtils.print(index + ":EOL=" + fileno + ":" + lineno);
                }else {
                    System.out.println(index+":"+cur.name+":"+ (int)cur.value);
                }
            }
            //
            try {
                exec();
            } catch (Exception e) {
                if (parent.isDebugMode) {
                    e.printStackTrace();
                }
                throw new AOIRuntimeError(e.getMessage());
            }
            if (old_index == index) index++;
        }
    }
    
    public AValue stack_pop() {
        if (stack.size() == 0) {
            if (parent.isDebugMode) {
                KUtils.print("    pop:[ERROR]");
                throw new AOIRuntimeError("Stack Error in stack_pop()");
            }
            return null;
        }
        int i = stack.size() - 1;
        AValue v = stack.getAValue(i);
        stack.remove(i);
        if (parent.isDebugMode) {
            System.out.println("   pop:" + v.getAsStr());
        }
        return v;
    }
    public void stack_push(AValue v) {
        stack.add(v);
        if (parent.isDebugMode) {
            System.out.println("   push:" + v.getAsStr());
        }
    }
    
    private void exec() {
        switch (cur.code) {
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
        }
    }

    private void run_NOP() {}
    private void run_EOL() {
        this.lineno = (int)cur.value;
    }
    private void run_PUSH_NULL() {
        stack_push(new AValue());
    }
    private void run_CONST_INT() {
        stack_push(new AValue((int)cur.value));
    }
    private void run_CONST_NUM() {
        stack_push(new AValue(cur.value));
    }
    private void run_CONST_STR() {
        String s = string_table.getStr((int)cur.value);
        stack_push(new AValue(s));
    }
    private void run_LOAD() {
        int index = cur.getAsInt();
        AValue v = globalvar.getAValue(index);
        if (v == null) {
            v = new AValue();
            globalvar.setAValue(index, v);
        }
        stack_push(v);
    }
    private void run_LOAD_LOCAL() {
        int index = cur.getAsInt();
        AValue v = cur_frame.localvar.getAValue(index);
        if (v == null) {
            v = new AValue();
            cur_frame.localvar.setAValue(index, v);
        }
        stack_push(v);
    }
    private void run_GET_HASH() {
        AValue akey = stack_pop();
        AValue aval = stack_pop();
        akey = akey.getLink();
        aval = aval.getLink();
        // value
        if (aval.type != AValue.typeArray && aval.type != AValue.typeHash) {
            if (akey.type == AValue.typeInt || akey.type == AValue.typeNull) {
                aval.type  = AValue.typeArray;
                aval.value = new AValueVector();
            } else {
                aval.type = AValue.typeHash;
                aval.value = new AValueHashtable();
            }
        }
        // value[key]
        if (aval.type == AValue.typeArray) {
            // Array
            int index = akey.getAsInt();
            AValueVector ary = (AValueVector)aval.value;
            AValue v = (AValue)ary.getAValue(index);
            if (v == null) {
                v = new AValue();
                AValue link = new AValue();
                link.setLink(v);
                ary.setAValue(index, link);
            }
            stack_push(v);
        } else {
            // Hash
            String key = akey.getAsStr();
            AValueHashtable hash = (AValueHashtable)aval.value;
            AValue v = (AValue)hash.getAValue(key);
            if (v == null) {
                v = new AValue();
                AValue link = new AValue();
                link.setLink(v);
                hash.put(key, v);
            }
            stack_push(v);
        }
    }
    private void run_STORE() {
        AValue val = stack_pop();
        int index = cur.getAsInt();
        AValue var = globalvar.getAValue(index);
        if (var == null) {
            var = new AValue();
            globalvar.setAValue(index, var);
        }
        var.setValue(val);
    }
    private void run_STORE_LOCAL() {
        AValue  val     = stack_pop();
        int     index   = cur.getAsInt();
        AValue  var     = cur_frame.localvar.getAValue(index);
        if (var == null) {
            var = new AValue();
            cur_frame.localvar.setAValue(index, var);
        }
        var.setValue(val);
    }
    private void run_LET() {
        AValue v_var = stack_pop();
        AValue v_exp = stack_pop();
        v_var.setValue(v_exp);
    }
    private void run_POP() {
        stack_pop();
    }
    private void run_ADD() {
        AValue v2 = stack_pop();
        AValue v1 = stack_pop();
        double n2 = v2.getAsNum();
        double n1 = v1.getAsNum();
        stack_push(new AValue(n1 + n2));
    }
    private void run_SUB() {
        AValue v2 = stack_pop();
        AValue v1 = stack_pop();
        double n2 = v2.getAsNum();
        double n1 = v1.getAsNum();
        stack_push(new AValue(n1 - n2));
    }
    private void run_MUL() {
        AValue v2 = stack_pop();
        AValue v1 = stack_pop();
        double n2 = v2.getAsNum();
        double n1 = v1.getAsNum();
        stack_push(new AValue(n1 * n2));
    }
    private void run_DIV() {
        AValue v2 = stack_pop();
        AValue v1 = stack_pop();
        double n2 = v2.getAsNum();
        double n1 = v1.getAsNum();
        stack_push(new AValue(n1 / n2));
    }
    private void run_MOD() {
        AValue v2 = stack_pop();
        AValue v1 = stack_pop();
        double n2 = v2.getAsNum();
        double n1 = v1.getAsNum();
        stack_push(new AValue(n1 % n2));
    }
    private void run_ADDSTR() {
        AValue v2 = stack_pop();
        AValue v1 = stack_pop();
        String s2 = v2.getAsStr();
        String s1 = v1.getAsStr();
        stack_push(new AValue((String)(s1 + s2)));
    }
    private void run_comp(int code) {
        AValue v2 = stack_pop();
        AValue v1 = stack_pop();
        v2 = v2.getLink();
        v1 = v1.getLink();
        boolean b = false;
        if (v1.type == AValue.typeStr) {
            String s1 = v1.getAsStr();
            String s2 = v2.getAsStr();
            switch (code) {
                case vmtable.GT:    b = (s1.compareTo(s2) > 0); break;
                case vmtable.GTEQ:  b = (s1.compareTo(s2) >= 0); break;
                case vmtable.LT:    b = (s1.compareTo(s2) < 0); break;
                case vmtable.LTEQ:  b = (s1.compareTo(s2) <= 0); break;
                case vmtable.EQEQ:  b = (s1.compareTo(s2) == 0); break;
                case vmtable.NOTEQ: b = (s1.compareTo(s2) != 0); break;
            }
        } else {
            double n1 = v1.getAsNum();
            double n2 = v2.getAsNum(); 
            switch (code) {
                case vmtable.GT:    b = (n1 > n2); break;
                case vmtable.GTEQ:  b = (n1 >= n2); break;
                case vmtable.LT:    b = (n1 < n2); break;
                case vmtable.LTEQ:  b = (n1 <= n2); break;
                case vmtable.EQEQ:  b = (n1 == n2); break;
                case vmtable.NOTEQ: b = (n1 != n2); break;
            }
        }
        stack_push(new AValue(b));
    }
    private void run_GT() { run_comp(cur.code); }
    private void run_GTEQ() { run_comp(cur.code); }
    private void run_LT() { run_comp(cur.code); }
    private void run_LTEQ() { run_comp(cur.code); }
    private void run_EQEQ() { run_comp(cur.code); }
    private void run_NOTEQ() { run_comp(cur.code); }
    private void run_NOT() {
        AValue  v = stack_pop();
        int     n = v.getAsInt();
        boolean b = (n > 0);
        stack_push(new AValue(!b));
    }
    private void run_AND() {
        AValue v2 = stack_pop();
        AValue v1 = stack_pop();
        int i2 = v2.getAsInt();
        int i1 = v1.getAsInt();
        int n = i1 & i2;
        stack_push(new AValue(n));
    }
    private void run_OR() {
        AValue v2 = stack_pop();
        AValue v1 = stack_pop();
        int i2 = v2.getAsInt();
        int i1 = v1.getAsInt();
        int n = i1 | i2;
        stack_push(new AValue(n));
    }
    private void run_RET() {
        index = cur_frame.return_index;
        AValue sore = cur_frame.localvar.getAValue(0);
        funcstack.remove(funcstack.size() - 1);
        cur_frame = (FuncFrame)funcstack.get(funcstack.size()-1);
        if (index < 0) {
            flag_quit = true;
        }
        cur_frame.localvar.setAValue(0, sore);
        stack_push(sore);
    }
    private void run_JUMP() {
        index = cur.getAsInt();
    }
    private void run_JUMP_ZERO() {
        AValue v = stack_pop();
        int n = v.getAsInt();
        if (n == 0) {
            index = cur.getAsInt();
        }
    }
    private void run_JUMP_NON_ZERO() {
        AValue v = stack_pop();
        int n = v.getAsInt();
        if (n != 0) {
            index = cur.getAsInt();
        }
    }
    private void run_CALL_USR() {
        FuncFrame new_frame = new FuncFrame();
        new_frame.return_index = index + 1;
        funcstack.add(new_frame);
        int fid = cur.getAsInt();
        AFunction func = (AFunction)func_table.get(fid);
        index = func.addr;
        // localvars
        for (int i = 0; i < func.args; i++) {
            int argno = func.args - i; // 0番は「それ」なので1番から乗せる
            AValue v = stack_pop();
            new_frame.localvar.setAValue(argno, v);
        }
        cur_frame = new_frame;
    }
        
    private void run_CALL_LIB() {
        // calc module id & function no
        int v = cur.getAsInt();
        int mod_id  = (v >> 8);
        int mod_fno = (v & 0xFF);
        // get class instance
        AModule m = (AModule)module_table.get(mod_id);
        int arg_count = m.getArgCount(mod_fno);
        //
        AFunctionArg arg = new AFunctionArg();
        arg.mac = this;
        for (int i = 0; i < arg_count; i++ ){
            int no = arg_count - i - 1;
            arg.args.setAValue(no, this.stack_pop());
        }
        // method call
	try {
            m.call(mod_fno, arg);
	} catch (Exception e) {
            throw new AOIRuntimeError(e.getMessage());
        }
        if (arg.result == null) {
            arg.result = new AValue();
        }
        this.cur_frame.localvar.setAValue(0, arg.result);
        this.stack_push(arg.result);
    }
    private void run_EXIT() {
        flag_quit = true;
    }

}
