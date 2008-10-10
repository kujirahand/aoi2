package com.aoikujira.aoi2.compiler;

public class AVariable {
    
    public static final int UNKNOWN = 0;
    public static final int INT = 1;
    public static final int NUM = 2;
    public static final int STR = 3;
    public static final int ARRAY = 4;
    public static final int HASH = 5;
    // function type (type >= 0x10)
    public static final int SYSFUNC  = 0x11;
    public static final int USERFUNC = 0x12;
    public static final int LIBFUNC  = 0x13;
    
    public String name;
    public int type;
    public int funcno;
    public int varno;
    public AFunction func;
    public Object const_value;
    
    public AVariable(String name, int type) {
        this.name = name;
        this.type = type;
        this.funcno = 0;
        this.varno = -1;
        this.func = null;
        this.const_value = null;
    }
    
    public boolean isFunction() {
        return (this.type > 0x10);
    }
}
