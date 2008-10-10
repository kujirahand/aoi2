/*
 * ModuleVector.java
 *
 * Created on 2007/03/23, 9:30
 */

package com.aoikujira.aoi2.vm;

/**
 *
 * @author desk
 */
import java.util.Vector;

//public class AModuleVector extends Vector<AModule> {
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

