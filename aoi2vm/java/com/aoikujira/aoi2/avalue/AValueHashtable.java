package com.aoikujira.aoi2.avalue;

import java.util.Hashtable;

//class AValueHashtable extends Hashtable<String,AValue>{};
public class AValueHashtable extends Hashtable{
	private static final long serialVersionUID = -5225677621619480014L;

	public AValue getAValue(String key) {
        return (AValue)get(key);
    }
    
};
