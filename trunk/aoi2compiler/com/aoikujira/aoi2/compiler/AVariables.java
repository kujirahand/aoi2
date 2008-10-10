package com.aoikujira.aoi2.compiler;

import java.util.Enumeration;

import com.aoikujira.utils.StringVector;

public class AVariables {
    public AVariableHashtable table;
    int count;
    
    public AVariables() {
        table = new AVariableHashtable();
        count = 0;
    }
    
    public int add(AVariable var) {
        int no = count;
        if (var.varno < 0) {
            var.varno = no;
            count++;
        } else {
            no = var.varno;
            if (no > count) { count = no + 1; }
        }
        table.put(var.name, var);
        return no;
    }
    public int addImplicitVar() {
        String      name = ":" + count;
        AVariable   v    = new AVariable(name, AVariable.UNKNOWN);
        return add(v);
    }
    
    public int getNo(String key) {
        AVariable v = (AVariable)table.get(key);
        if (v != null) {
            return v.varno;
        } else {
            return -1;
        }
    }
    
    public AVariable getVar(String key) {
        return (AVariable)table.get(key);
    }
    
    public StringVector getAsArray() {
        StringVector res = new StringVector();
        Enumeration keys = table.keys();
        while (keys.hasMoreElements()) {
            String  key = (String)keys.nextElement();
            int     no = getNo(key);
            if (no >= 0) res.setStr(no, key);
        }
        return res;
    }
}
