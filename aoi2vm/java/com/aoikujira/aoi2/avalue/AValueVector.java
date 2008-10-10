package com.aoikujira.aoi2.avalue;
import java.util.Vector;


//class AValueVector extends Vector<AValue>{
public class AValueVector extends Vector {
	private static final long serialVersionUID = 230526948168954105L;
	public AValue getAValue(int index) {
        if (index >= this.size()) {
            return null;
        }
        return (AValue)get(index);
    }
    public AValue setAValue(int index, AValue v) {
        while (index >= this.size()) {
            add(null);
        }
        return (AValue)set(index, v);
    }
};
