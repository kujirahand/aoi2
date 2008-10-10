/*
 * BasicNodeCreator.java
 *
 * Created on 2007/03/15, 10:45
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.aoikujira.aoi2.compiler.lang.basic;

import com.aoikujira.aoi2.compiler.*;


/**
 *
 * @author kujiramac
 */

public class BasicNodeCreator extends ANodeCreator{
        
    public BasicNodeCreator(Parser parser) {
        super(parser);
    }
    
    public ANode callFunc(Token token_var, ANode callargs) {
        ANode topnode;
        
        // 関数の特定
        ANode funcnode;
        AVariable var = (AVariable)token_var.value;
        if (var.type == AVariable.LIBFUNC) {
            // library func
            AFunction f = var.func;
            f.funcno = var.funcno;
            funcnode = new ANode(ANodeTypes.CALL_LIB);
            funcnode.value = new Integer(f.getLibNo());
        } else {
            // user func
            funcnode = new ANode(ANodeTypes.CALL_USR);
            funcnode.value = var.func;
        }
        funcnode.josi = token_var.josi;
        funcnode.desc = new String(var.name);
        
        // 引数の取得
        if (callargs != null || var.func.args.size() > 0) {
            topnode = callFunc_pickup(funcnode, var, callargs);
        } else {
            topnode = funcnode;
        }
        return topnode;
    }

    private ANode callFunc_pickup(ANode funcnode, AVariable var, ANode callargs) {
        // check args count
        AFunction f = var.func;
        if (f.args.size() != callargs.list.size()) {
            throw new AOICException(ErrMsg.ArgCountError + ":" + f.name + "(" + f.args.size() + ")!=" + callargs.list.size());
        }
        callargs.append(funcnode);
        return callargs;
    }
    
/* for     $1  $2       $3 $4   $5 $6   $7       $8    $9
for_stmt : FOR variable EQ expr TO expr stmt_end stmts for_end
         {  $$ = nc.for_node($2, $4, $6, $8); }*/
    public ANode for_basic(ANode nvar, ANode from_node, ANode to_node, ANode stmts, ANode step) {
        // check args
        if (nvar == null || from_node == null || to_node == null) {
            throw new AOICException(ErrMsg.InvalidForArg);
        }
        ANode lbl_begin     = new ANodeNop( "for_begin");
        ANode lbl_condition = new ANodeNop( "for_condition");
        ANode lbl_end       = new ANodeNop( "for_end");
        ANode lbl_inc       = new ANodeNop( "for_inc");
        int vno_var;
        int vno_to;
        int nvar_load_type;
        int nvar_store_type;
        // is variable simple ?
        if (nvar.countLength() >= 2) {
            throw new AOICException(ErrMsg.InvalidForArg);
        }
        // check step
        if (step == null) {
            step = new ANode(ANodeTypes.CONST_INT, 1);
        }
        // global or local ?
        nvar_load_type = nvar.type;
        nvar_store_type = (nvar_load_type == ANodeTypes.LOAD) ? ANodeTypes.STORE : ANodeTypes.STORE_LOCAL;
        vno_var = ((Integer)nvar.value).intValue();
        vno_to  = parser.global.localvars.addImplicitVar();
        // connect
        ANode args[] = {
            lbl_begin,
                // [vno_var] = nfrom
                from_node,
                new ANode(nvar_store_type, nvar.value),
                // [vno_to] = nto
                to_node,
                new ANode(ANodeTypes.STORE_LOCAL, new Integer(vno_to)),
            lbl_condition,
                // if !([vno_var] > [vno_to]) then lbl_end 
                new ANode(nvar_load_type,       new Integer(vno_var)),
                new ANode(ANodeTypes.LOAD_LOCAL,new Integer(vno_to)),
                new ANode(ANodeTypes.GT),
                new ANode(ANodeTypes.JUMP_NON_ZERO, (Object)lbl_end),
            // lbl_body,
                stmts,
            // inc
            lbl_inc,
                new ANode(nvar_load_type,       new Integer(vno_var)),
                step,
                new ANode(ANodeTypes.ADD),
                new ANode(nvar_store_type,      new Integer(vno_var)),
                new ANode(ANodeTypes.JUMP, (Object)lbl_condition),
            lbl_end
        };
        ANode.connect(args);
        // ---------------------------------------------------------------------
        // swap BREAK/CONTINUE node
        swapNodeAll(stmts, FLAG_BREAK, new ANode(ANodeTypes.JUMP, lbl_end));
        swapNodeAll(stmts, FLAG_CONTINUE, new ANode(ANodeTypes.JUMP, lbl_inc));
        return lbl_begin;
    }

}
