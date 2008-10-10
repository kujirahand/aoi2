/*
 * AFunction.java
 *
 * Created on 2007/02/03, 20:23
 *
 */

package com.aoikujira.aoi2.compiler;

import java.util.Vector;

import com.aoikujira.aoi2.compiler.lang.aoi.*;
import com.aoikujira.utils.*;


/**
 * AFunction Define
 * 
 * @author kujiramac
 */
public class AFunction {
    
    //public class AArgumentVector extends Vector<AArgument> {
    public class AArgumentVector extends Vector {
		private static final long serialVersionUID = 1L;
    }
    
    // AFunction Params
    public String name;
    public AArgumentVector args;
    public IntegerHashtable josi_table;
    public int funcno;
    public int moduleno;
    public boolean is_property;
    public boolean is_accessor;
    public AVariable link_setter;
    public AVariable link_getter;
    
    public AFunction() {
        args = new AArgumentVector();
        josi_table = new IntegerHashtable();
        funcno = -1;
        moduleno = 0;
        is_property = false;
        is_accessor = false;
        link_setter = null;
        link_getter = null;
    }
    
    public int getLibNo() {
        return getModuleFuncNo(moduleno,funcno);
    }
    
    public static int getModuleFuncNo(int moduleno, int funcno) {
        return (moduleno << 8) | funcno;
    }
    
    public AArgument newArgument(String name) {
        AArgument arg = new AArgument();
        arg.name = name;
        this.args.add((AArgument)arg);
        return arg;
    }
    public int getArgName(String name) {
        for (int i = 0; i < args.size(); i++) {
            AArgument arg = (AArgument)args.get(i);
            if (name.compareTo(arg.name) == 0) {
                return i;
            }
        }
        return -1;
    }
    public AArgument getArg(String name) {
        int i = getArgName(name);
        if (i < 0) return null;
        return (AArgument)args.get(i);
    }
    public void setArgs(String def) {
        if (def.length() == 0) return;
        // split args
        AOITokenizer tzr = new AOITokenizer(null, 0, def);
        tzr.split();
        int i = 0;
        while (i < tzr.tokens.size()) {
            Token t = (Token)tzr.tokens.get(i);
            if (t.type == '|') {
                i++; continue;
            }
            if (t.type == AOIParser.WORD) {
                String name = (String)t.value;
                String josi = (String)t.josi;
                if (josi == null) josi = "";
                AArgument arg = getArg(name);
                if (arg == null) {
                    arg = new AArgument();
                    arg.name = name;
                    this.args.add(arg);
                }
                arg.addJosi(josi);
            }
            i++;
        }
    }
}
