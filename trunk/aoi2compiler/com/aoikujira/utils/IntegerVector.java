/*
 * IntegerVector.java
 *
 * Created on 2007/03/01, 14:57
 */

package com.aoikujira.utils;

import java.util.Vector;

/**
 *
 * @author desk
 */
//public class IntegerVector extends Vector<Integer> {
public class IntegerVector extends Vector {
	private static final long serialVersionUID = 1L;

	public void setInt(int index, int value) {
        while (this.size() <= index) {
            add(new Integer(0));
        }
        set(index, new Integer(value));
    }
    
    public Integer getInteger(int index) {
        return (Integer)get(index);
    }
    
    public int getInt(int index, int def_value) {
        Integer i = getInteger(index);
        if (i == null) return def_value;
        return i.intValue();
    }
    
    public void addInt(int value) {
        add(new Integer(value));
    }
}
