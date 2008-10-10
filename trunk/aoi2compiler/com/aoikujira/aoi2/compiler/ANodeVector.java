
package com.aoikujira.aoi2.compiler;

import java.util.Vector;

//public class ANodeVector extends Vector <ANode> {
public class ANodeVector extends Vector {
	private static final long serialVersionUID = 1L;
	public ANode getNode(int index) {
        return (ANode)get(index);
    }
    public void setNode(int index, ANode node) {
        while (index >= this.size()) {
            this.add(null);
        }
        this.set(index, node);
    }
}
