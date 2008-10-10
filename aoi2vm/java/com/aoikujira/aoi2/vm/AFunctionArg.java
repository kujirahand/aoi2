/*
 * AFunctionArg.java
 *
 * Created on 2007/03/23, 9:48
 */

package com.aoikujira.aoi2.vm;

import com.aoikujira.aoi2.avalue.AValue;
import com.aoikujira.aoi2.avalue.AValueVector;

/**
 *
 * @author desk
 */
public class AFunctionArg {
    
    public Stackmachine mac;
    public AValueVector args;
    public AValue result;
    
    public AFunctionArg() {
        args = new AValueVector();
        result = null;
    }
    public AValue getArg(int no) {
        if (args.size() > no) {
            return args.getAValue(no);
        } else {
            return new AValue();
        }
    }
    public String getStr(int no) {
        AValue v = getArg(no);
        if (v == null) return "";
        return v.getAsStr();
    }
    public int getInt(int no) {
        AValue v = getArg(no);
        if (v == null) return 0;
        return v.getAsInt();
    }
    public double getNum(int no) {
        AValue v = getArg(no);
        if (v == null) return 0.0;
        return v.getAsNum();
    }
    public void setResult(String r) {
        AValue v = new AValue(r);
        this.result = v;
    }
    public void setResult(int r) {
        AValue v = new AValue(r);
        this.result = v;
    }
    public void setResult(double r) {
        AValue v = new AValue(r);
        this.result = v;
    }
}
