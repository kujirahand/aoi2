/*
 * StringVector.java
 *
 * Created on 2007/03/01, 12:12
 */

package com.aoikujira.utils;

/**
 *
 * @author desk
 */
import java.util.Vector;

//public class StringVector extends Vector<String> {
public class StringVector extends Vector {
	private static final long serialVersionUID = 1L;

	public String getStr(int index) {
        return (String)get(index);
    }
    
    public void addStr(String str) {
        this.add(str);
    }
    
    public int indexOf(String str) {
        for (int i = 0; i < this.size(); i++) {
            String m = (String)this.get(i);
            if (m.compareTo(str) == 0) {
                return i;
            }
        }
        return -1;
    }
    
    public int addUnique(String str) {
        int i = indexOf(str);
        if (i >= 0) return i;
        add((Object)str);
        return this.size() - 1;
        
    }
    
    public void setStr(int index, String str) {
        while (index >= this.size()) {
            this.addStr("");
        }
        this.set(index, str);
    }
}
