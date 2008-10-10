/*
 * IntegerHashtable.java
 *
 * Created on 2007/04/04, 23:12
 */

package com.aoikujira.utils;

import java.util.Hashtable;

/**
 *
 * @author desk
 */
public class IntegerHashtable extends Hashtable {
	private static final long serialVersionUID = 1L;

	public int getInt(String key) {
        Integer i = getInteger(key);
        return i.intValue();
    }
    
    public Integer getInteger(String key) {
        return (Integer)get(key);
    }
    
    public void putInt(String key, int value) {
        this.put(key, new Integer(value));
    }
}
