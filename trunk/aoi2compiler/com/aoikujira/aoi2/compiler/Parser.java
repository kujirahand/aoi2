
package com.aoikujira.aoi2.compiler;

public class Parser {

    public ANode topnode;
    public GlobalObject global;
    
    public Parser(GlobalObject global) {
        this.global = global;
    }
        
    public Object parse(Scanner scanner) throws AOICException{
        return null;
    }
    
    public void expandNode() {
        mixFunction(this.topnode);
        this.topnode.expandList();
    }
    
    private void mixFunction(ANode top) {
        top.append( new ANode(ANodeTypes.EXIT) );
        for (int i = 0; i < global.funcs.size(); i++) {
            FunctionPoint fp = (FunctionPoint)global.funcs.get(i);
            if (fp.node == null) continue;
            fp.node.append( new ANode(ANodeTypes.RET) );
            top.append( fp.node );
        }
    }
}

