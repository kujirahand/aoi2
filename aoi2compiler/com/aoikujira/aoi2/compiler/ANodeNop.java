/*
 * ANodeNop.java
 *
 * Created on 2007/03/13, 9:30
 */

package com.aoikujira.aoi2.compiler;

/**
 *
 * @author desk
 */
public class ANodeNop extends ANode{
    
    public ANodeNop(String desc) {
        super(ANodeTypes.NOP);
        this.desc = new String(desc);
    }
    public ANodeNop(int flag) {
        super(ANodeTypes.NOP);
        this.value = new Integer(flag);
    }
}
