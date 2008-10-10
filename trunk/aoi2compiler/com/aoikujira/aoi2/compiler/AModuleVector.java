/*
 * AModuleVector.java
 *
 * Created on 2007/03/01, 14:53
 */

package com.aoikujira.aoi2.compiler;

import java.util.Vector;

/**
 *
 * @author desk
 */

// public class AModuleVector extends Vector<AModule> {
public class AModuleVector extends Vector {
	private static final long serialVersionUID = 1L;

	public AModule indexOf(String name) {
        for (int i = 0; i < this.size(); i++) {
            AModule m = (AModule)this.get(i);
            if (m.name.compareTo(name) == 0) {
                return m;
            }
        }
        return null;
    }    
}
