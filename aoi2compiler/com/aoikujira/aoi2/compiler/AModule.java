/*
 * AModule.java
 *
 * Created on 2007/03/01, 14:47
 */

package com.aoikujira.aoi2.compiler;


/**
 *
 * @author desk
 */
public class AModule {
    
    public String name;
    public AFunctionVector funcs;
    public int id;
    
    public AModule() {
        funcs = new AFunctionVector();
    }
    public void setFunction(int index, AFunction f) {
        while (funcs.size() <= index) {
            funcs.add(null);
        }
        funcs.set(index, f);
    }
    
}
