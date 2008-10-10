package com.aoikujira.aoi2.vm;

import java.util.Vector;

public class JSONVector extends Vector {    
	private static final long serialVersionUID = 1L;

	public JSON getJSON(int index) {
        return (JSON)get(index);
    }
}
