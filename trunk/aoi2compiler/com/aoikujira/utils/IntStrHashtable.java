
package com.aoikujira.utils;

import java.util.Hashtable;

//public class IntStrHashtable extends Hashtable <Integer, String>{
public class IntStrHashtable extends Hashtable {
	private static final long serialVersionUID = 1L;
	public String getStr(int index) {
        return (String)get(new Integer(index));
    }
    public void putIntStr(int index, String str) {
        put(new Integer(index), str);
    }
}
