/*
 * IRCode.java
 *
 * Created on 2007/02/20, 23:26
 *
 */

package com.aoikujira.aoi2.vm;

/**
 *
 * @author kujiramac
 */
public class IRCode {
    
    public String   name;
    public int      code;
    public double   value;
    
    public IRCode() {
    }
    
    public int getAsInt() {
        return (int)value;
    }
    
}
