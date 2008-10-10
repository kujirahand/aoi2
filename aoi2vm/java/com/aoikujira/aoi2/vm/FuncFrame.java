/*
 * FuncFrame.java
 *
 * Created on 2007/02/20, 23:21
 *
 */

package com.aoikujira.aoi2.vm;

import com.aoikujira.aoi2.avalue.AValue;
import com.aoikujira.aoi2.avalue.AValueVector;

public class FuncFrame {
    
    AValueVector localvar;
    int return_index;
    
    public FuncFrame() {
        return_index = -1;
        localvar = new AValueVector();
        // set sore
        localvar.add(new AValue());
    }
    
    public AValue getSore() {
        return localvar.getAValue(0);
    }
    
}
