package com.aoikujira.aoi2.compiler;

import com.aoikujira.aoi2.compiler.lang.aoi.AOIParser;

public class ANodeCreator {
    
    public final String FLAG_CONTINUE = "NODE_CONTINUE";
    public final String FLAG_BREAK    = "NODE_BREAK";
    
    public Parser parser;
    
    public ANodeCreator(Parser parser) {
        this.parser = parser;
    }
    public ANode connect(ANode n1, ANode n2) {
        n1.append(n2);
        return n1;
    }
    public ANode connect(ANode[] n) {
        ANode last = n[0];
        for (int i = 1; i < n.length; i++) {
            last.append(n[i]);
            last = n[i];
        }
        return n[0];
    }
    public void error(String err) {
        throw new AOICException(err);
    }
    public ANode swapNodeAll(ANode node, String findNode, ANode nswap) {
        ANode top = node;
        ANode n = node;
        ANode next;
        ANode oldn = null;
        while (n != null) {
            // search
            if (!(n.type == ANodeTypes.NOP && n.equalDescript(findNode))) {
                oldn = n;
                n = n.getNext();
                continue;
            }
            // found !
            ANode new_nswap = nswap.duplicate();
            next = n.getNext();
            if (oldn == null) { // top
                top = new_nswap;
                new_nswap.append(next);
            } else {
                oldn.setNext(new_nswap);
                new_nswap.append(next);
            }
            n = next;
        }
        return top;
    }
    protected ANode makeFunctionNode(AVariable var, String josi) {
        // 関数の特定
        ANode funcnode;
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
        funcnode.desc = new String(var.name);
        funcnode.josi = josi;
        return funcnode;
    }
    
    //--------------------------------------------------------------------------
    public ANode EOL(Token tok) {
        int v = tok.fileid << 16 | tok.lineno;
        ANode eol = new ANode(ANodeTypes.EOL, new Integer(v));
        return eol;
    }
    
    public ANode let(ANode var, ANode expr) {
        ANode top = expr;
        ANode let = new ANode();
        
        // 純粋に変数への代入が可能な場合
        if (var.countLength() == 1) {
            if (var.type == ANodeTypes.LOAD) { // global
                let.type = ANodeTypes.STORE;
            } else { // local
                let.type = ANodeTypes.STORE_LOCAL;
            }
            let.value = var.value;
            let.desc  = var.desc;
            expr.append(let);
        }
        // 複雑な配列orハッシュアクセスがあった場合
        else {
            // 順番に注意 ( expr, var )
            let.type = ANodeTypes.LET;
            expr.append(var);
            var.append(let);
        }
        return top;
    }
    public ANode nop(String s) {
        return new ANodeNop(s);
    }
    public ANode expr(int op, ANode e1, ANode e2) {
        ANode nop = new ANodeNop("expr");
        ANode opnode = new ANode(op);
        nop.addChild(e1);
        nop.addChild(e2);
        nop.addChild(opnode);
        nop.josi = e2.josi;
        return nop;
    }
    
    public ANode if_node(ANode expr, ANode n_true, ANode n_false) {
        ANode top = new ANodeNop("if");
        ANode end = new ANodeNop( "endif");
        ANode jump_zero = new ANode(ANodeTypes.JUMP_ZERO);
        ANode jump_end  = new ANode(ANodeTypes.JUMP);
        ANode lbl_false = new ANodeNop( "iffalse");
        if (n_false == null) { n_false = new ANode(ANodeTypes.NOP); }
        jump_zero.value = lbl_false;
        jump_end.value  = end;
        ANode[] args = {
            top,
            expr,
            jump_zero,
            n_true,
            jump_end,
            lbl_false,
            n_false,
            end
        };
        ANode.connect(args);
        return top;
    }
    
    public ANode expr_list_top(ANode expr) {
        ANode n = new ANodeNop( "list_top");
        n.addChild(expr);
        return n;
    }
    public ANode expr_list_next(ANode top, ANode expr) {
        top.addChild(expr);
        return top;
    }
    
    public ANode uminus(ANode e) {
        ANode m1 = new ANode(ANodeTypes.CONST_INT);
        m1.value = new Integer(-1);
        ANode mul = new ANode(ANodeTypes.MUL);
        e.append(m1);
        m1.append(mul);
        return e;
    }
    
    public ANode not(ANode e) {
        ANode op = new ANode(ANodeTypes.NOT);
        e.append(op);
        return e;
    }
    
    public ANode setProperty(ANode n_var, Token prop, ANode n_expr) {
        AVariable cmd = parser.global.vars.getVar("設定");
        ANode top = new ANodeNop( "setProperty");
        String prop_name;
        if (prop.type == AOIParser.ACCESSOR) {
            prop_name = ((AVariable)prop.value).name;
        } else {
            prop_name = (String)prop.value;
        }
        
        ANode args[] = {
          top,
          n_var,
          new ANode(ANodeTypes.CONST_STR, prop_name),
          n_expr,
          new ANode(ANodeTypes.CALL_LIB, new Integer(cmd.func.getLibNo())),
          new ANode(ANodeTypes.POP)
        };
        connect(args);
        return n_var;
    }
    
    public ANode getProperty(ANode n_var, Token prop) {
        String v_prop = (String)prop.value;
        AVariable cmd = parser.global.vars.getVar("取得");
        ANode top = new ANodeNop( "getProperty");
        ANode args[] = {
          top,
          n_var,
          new ANode(ANodeTypes.CONST_STR, v_prop),
          new ANode(ANodeTypes.CALL_LIB, new Integer(cmd.func.getLibNo()))
        };
        connect(args);
        return n_var;
    }
    
    public ANode setAccessor(Token tok, ANode expr) {
        AVariable v = (AVariable)tok.value;
        AFunction f = v.func;
        if (f.link_setter == null) {
            throw new AOICException(ErrMsg.NoSetter);
        }
        AVariable v_setter = f.link_setter;
        ANode callnode = makeFunctionNode(v_setter, null);
        expr.append(callnode);
        return expr;
    }
    
    public ANode getAccessor(Token tok) {
        AVariable v = (AVariable)tok.value;
        AFunction f = v.func;
        if (f.link_getter == null) {
            throw new AOICException(ErrMsg.NoSetter);
        }
        AVariable v_getter = f.link_getter;
        ANode callnode = makeFunctionNode(v_getter, tok.josi);
        return callnode;
    }
    
    public ANode getVariable(Token tword) {
        ANode n = new ANode();
        int varno;
        String word = (String)tword.value;
        //---
        // check local var
        varno = parser.global.localvars.getNo(word);
        if (varno >= 0 ) {
            n.type = ANodeTypes.LOAD_LOCAL;
        } else {
            // check global var
            varno = parser.global.vars.getNo(word);
            if (varno < 0) {
                // create global var
                AVariable av = new AVariable(word, AVariable.UNKNOWN);
                varno = parser.global.vars.add(av);
            }
            n.type = ANodeTypes.LOAD;
        }
        n.value = new Integer(varno);
        n.desc  = word;
        n.josi  = tword.josi;
        return n;
    }
    public ANode localvar(Token tword, ANode expr) {
        String word = (String)tword.value;
        // check local var
        int varno = (int)parser.global.localvars.getNo(word);
        if (varno >= 0 ) {
            throw new AOICException(ErrMsg.AlreadyExistsVar);
        }
        varno = parser.global.localvars.add(new AVariable(word, AVariable.UNKNOWN));
        ANode n = new ANodeNop( "localvar");
        if (expr != null) {
            n.append(expr);
            expr.append(new ANode(ANodeTypes.STORE_LOCAL, new Integer(varno)));
        }
        return n;
    }
    
    public ANode getHash(ANode varref, ANode key) {
        ANode n = new ANode(ANodeTypes.GET_HASH);
        ANode[] arg = {varref, key, n};
        varref.josi = key.josi;
        connect(arg);
        return varref;
    }
    
    public ANode constInt(Token ti) {
        ANode n = new ANode(ANodeTypes.CONST_INT);
        n.value = ti.value;
        n.josi  = ti.josi;
        return n;
    }
    
    public ANode constNum(Token td) {
        ANode n = new ANode(ANodeTypes.CONST_NUM);
        n.value = td.value;
        n.josi  = td.josi;
        return n;
    }
    
    public ANode constStr(Token ts) {
        ANode n = new ANode(ANodeTypes.CONST_STR);
        n.value = ts.value;
        n.josi  = ts.josi;
        return n;
    }
    
    public ANode setJosi(ANode expr, Token tjosi) {
        expr.josi = tjosi.josi;
        return expr;
    }
        
    public ANode addPOP(ANode node) {
        ANode n = new ANode(ANodeTypes.POP);
        node.append(n);
        return node;
    }
    
    
    public ANode for_node(ANode callargs, ANode stmts) {
        ANode lbl_begin     = new ANodeNop( "for_begin");
        ANode lbl_condition = new ANodeNop( "for_condition");
        ANode lbl_inc       = new ANodeNop( "for_inc");
        ANode lbl_end       = new ANodeNop( "for_end");
        ANode nvar;
        ANode nfrom;
        ANode nto;
        int vno_var;
        int vno_to;
        int nvar_load_type;
        int nvar_store_type;
        // get args
        nvar = callargs.pickupList("で");
        if (nvar == null) { nvar = callargs.pickupList("を"); }
        if (nvar == null ||
                (nvar.type != ANodeTypes.LOAD && nvar.type != ANodeTypes.LOAD_LOCAL) ||
                (nvar.countLength() > 1)
        ) {
            throw new AOICException(ErrMsg.InvalidForVar);
        }
        // global or local ?
        nvar_load_type = nvar.type;
        nvar_store_type = (nvar_load_type == ANodeTypes.LOAD) ? ANodeTypes.STORE : ANodeTypes.STORE_LOCAL;
        // from .. to
        nfrom   = callargs.pickupList("から");
        nto     = callargs.pickupList("まで");
        if (nfrom == null || nto == null) {
            throw new AOICException(ErrMsg.InvalidForArg);
        }
        vno_var = ((Integer)nvar.value).intValue();
        vno_to  = parser.global.localvars.addImplicitVar();
        // connect
        ANode args[] = {
            lbl_begin,
                // [vno_var] = nfrom
                nfrom,
                new ANode(nvar_store_type, nvar.value),
                // [vno_to] = nto
                nto,
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
                new ANode(ANodeTypes.CONST_INT, new Integer(1)),
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
    
    public String LOOP_COUNTER_NAME = "回数";
    public ANode repeat_node(ANode times, ANode stmts) {
        ANode lbl_begin     = new ANodeNop( "repeat_begin");
        ANode lbl_condition = new ANodeNop( "repeat_condition");
        ANode lbl_end       = new ANodeNop( "repeat_end");
        int vno_var;
        int vno_to;
        int vno_sore = 0; // must
        // get loop counter
        int vno_counter = parser.global.vars.getNo(LOOP_COUNTER_NAME);
        if (vno_counter < 0) {
            AVariable new_var = new AVariable(LOOP_COUNTER_NAME, AVariable.INT);
            vno_counter = parser.global.vars.add(new_var);
        }
        
        vno_var = parser.global.localvars.addImplicitVar();
        vno_to  = parser.global.localvars.addImplicitVar();
        // connect
        ANode args[] = {
            lbl_begin,
                // var = 1
                new ANode(ANodeTypes.CONST_INT, 1),
                new ANode(ANodeTypes.STORE_LOCAL, vno_var),
                // to = times
                times,
                new ANode(ANodeTypes.STORE_LOCAL, vno_to),
            lbl_condition,
                // set sore
                new ANode(ANodeTypes.LOAD_LOCAL, vno_var),
                new ANode(ANodeTypes.STORE_LOCAL, vno_sore),
                new ANode(ANodeTypes.LOAD_LOCAL, vno_var),
                new ANode(ANodeTypes.STORE, vno_counter),
                // var <= to
                new ANode(ANodeTypes.LOAD_LOCAL, vno_var),
                new ANode(ANodeTypes.LOAD_LOCAL, vno_to),
                new ANode(ANodeTypes.LTEQ),
                new ANode(ANodeTypes.JUMP_ZERO, lbl_end),
            // inc
                new ANode(ANodeTypes.LOAD_LOCAL, vno_var),
                new ANode(ANodeTypes.CONST_INT, 1),
                new ANode(ANodeTypes.ADD),
                new ANode(ANodeTypes.STORE_LOCAL, vno_var),
            // lbl_body,
                stmts,
                new ANode(ANodeTypes.JUMP, lbl_condition),
            lbl_end
        };
        ANode.connect(args);
        // swap BREAK/CONTINUE node
        // swap BREAK/CONTINUE node
        swapNodeAll(stmts, FLAG_BREAK, new ANode(ANodeTypes.JUMP, lbl_end));
        swapNodeAll(stmts, FLAG_CONTINUE, new ANode(ANodeTypes.JUMP, lbl_condition));
        return lbl_begin;
    }
    public ANode while_node(ANode expr, ANode stmts) {
        ANode lbl_begin     = new ANodeNop( "while_begin");
        ANode lbl_end       = new ANodeNop( "while_end");
        // connect
        ANode args[] = {
            lbl_begin,
                // while (n)
                expr,
                new ANode(ANodeTypes.JUMP_ZERO, lbl_end),
                stmts,
                new ANode(ANodeTypes.JUMP, lbl_begin),
            lbl_end
        };
        ANode.connect(args);
        // swap BREAK/CONTINUE node
        swapNodeAll(stmts, FLAG_BREAK, new ANode(ANodeTypes.JUMP, lbl_end));
        swapNodeAll(stmts, FLAG_CONTINUE, new ANode(ANodeTypes.JUMP, lbl_begin));
        return lbl_begin;
    }
    
    public ANode foreach_node(ANode variable, ANode expr, ANode stmts) {
        ANode lbl_begin     = new ANodeNop( "foreach_begin");
        ANode lbl_end       = new ANodeNop( "foreach_end");
        ANode lbl_continue  = new ANodeNop( "foreach_continue");
        ANode lbl_body      = new ANodeNop( "foreach_body" );
        AModule mod_system  = parser.global.modules.indexOf("ModuleSystem");
        if (mod_system == null) throw new AOICException(ErrMsg.NoSystemModule);
        int id_mod          = mod_system.id;
        int id_getValues    = AFunction.getModuleFuncNo(id_mod,41); //parser.global.vars.getNo("ハッシュキー列挙");
        int id_getCount     = AFunction.getModuleFuncNo(id_mod,40); //parser.global.vars.getNo("要素数");
        int id_i            = parser.global.localvars.addImplicitVar();
        int id_values       = parser.global.localvars.addImplicitVar();
        int id_count        = parser.global.localvars.addImplicitVar();
        ANode let_var       = new ANodeNop("foreach_letVar");
        if (variable != null) {
            // variable = $_
            let_var.append(new ANode(ANodeTypes.LOAD_LOCAL, 0));
            let_var.append(variable);
            let_var.append(new ANode(ANodeTypes.LET));
        }
        /* begin:
         *  values = hash_values(expr)
         *  count  = getCount(values)
         *  i = 0
         * cond:
         *  if i >= count then goto end
         * body:
         *  stmts
         *  goto cond
         * end:
         */
        // connect
        ANode args[] = {
            lbl_begin,
                // values = getValues(expr)
                expr,
                new ANode(ANodeTypes.CALL_LIB,      id_getValues),
                new ANode(ANodeTypes.STORE_LOCAL,   id_values),
                // cunt = getCount(values)
                new ANode(ANodeTypes.LOAD_LOCAL,    id_values),
                new ANode(ANodeTypes.CALL_LIB,      id_getCount),
                new ANode(ANodeTypes.STORE_LOCAL,   id_count),
                // i = 0
                new ANode(ANodeTypes.CONST_INT,     0),
                new ANode(ANodeTypes.STORE_LOCAL,    id_i),
            lbl_continue,
                // if i >= count then goto end
                new ANode(ANodeTypes.LOAD_LOCAL,    id_i),
                new ANode(ANodeTypes.LOAD_LOCAL,    id_count),
                new ANode(ANodeTypes.GTEQ),
                new ANode(ANodeTypes.JUMP_NON_ZERO, lbl_end),
            lbl_body,
                // $_ = values[i]
                new ANode(ANodeTypes.LOAD_LOCAL,    id_values),
                new ANode(ANodeTypes.LOAD_LOCAL,    id_i),
                new ANode(ANodeTypes.GET_HASH),
                new ANode(ANodeTypes.STORE_LOCAL,   0),
                let_var,
                // i++
                new ANode(ANodeTypes.LOAD_LOCAL,    id_i),
                new ANode(ANodeTypes.CONST_INT,     1),
                new ANode(ANodeTypes.ADD),
                new ANode(ANodeTypes.STORE_LOCAL,   id_i),
                // body
                stmts,
                new ANode(ANodeTypes.JUMP,          lbl_continue),
            lbl_end
        };
        ANode.connect(args);
        // swap BREAK/CONTINUE node
        swapNodeAll(stmts, FLAG_BREAK,      new ANode(ANodeTypes.JUMP, lbl_end));
        swapNodeAll(stmts, FLAG_CONTINUE,   new ANode(ANodeTypes.JUMP, lbl_continue));
        return lbl_begin;
    }
    
    public ANode registerFunc(Token tok, ANode stmts) {
        AVariable v = (AVariable)tok.value;
        String name = (String)v.name;
        ANode top_stmts = new ANodeNop( "FUNC:" + name);
        top_stmts.append(stmts);
        parser.global.addFunctionPoint(name, top_stmts, v.func);
        return new ANode(ANodeTypes.NOP);
    }
    
    public Token registerFuncHeader(Token tok) {
        AVariable v = (AVariable)tok.value;
        parser.global.funcscope = v.func;
        // register args
        parser.global.localvars = new AVariables();
        parser.global.addSoreToLocalvars();
        for (int i = 0; i < v.func.args.size(); i++) {
            AArgument arg = (AArgument)v.func.args.get(i);
            AVariable var = new AVariable(arg.name, AVariable.UNKNOWN);
            parser.global.localvars.add(var);
        }
        return tok;
    }
    
    public ANode return_node() {
        return new ANode(ANodeTypes.RET);
    }
    public ANode return_node(ANode expr) {
        ANode args[] = {
          expr,
          new ANode(ANodeTypes.STORE_LOCAL, 0),
          new ANode(ANodeTypes.RET)
        };
        connect(args);
        return expr;
    }
    public ANode array_list_begin(ANode expr) {
        ANode top = new ANodeNop( "array_list_top");
        top.tag = 0;
        int vno = parser.global.localvars.addImplicitVar();
        top.value = new Integer(vno);
        // => expr, var ( ref, key ), let
        ANode args[] = {
            top,
            expr,
            new ANode(ANodeTypes.LOAD_LOCAL, new Integer(vno)),
            new ANode(ANodeTypes.CONST_INT, new Integer(0)),
            new ANode(ANodeTypes.GET_HASH),
            new ANode(ANodeTypes.LET)
        };
        this.connect(args);
        return top;
    }
    public ANode array_list_end(ANode list) {
        list.append(new ANode(ANodeTypes.LOAD_LOCAL, (Object)list.value));
        return list;
    }
    public ANode array_list_0() {
        ANode n = new ANode(ANodeTypes.CONST_INT, new Integer(0));
        return n;
    }
    public ANode constNull() {
        ANode n = new ANode(ANodeTypes.PUSH_NULL);
        return n;
    }
    public ANode array_list_append(ANode top, ANode expr) {
        top.tag++;
        int index = top.tag;
        int vno   = ((Integer)top.value).intValue();
        ANode top2 = new ANodeNop( "array_list_append");
        ANode args[] = {
            top,
            top2,
            expr,
            new ANode(ANodeTypes.LOAD_LOCAL,(Object) new Integer(vno)),
            new ANode(ANodeTypes.CONST_INT, (Object)new Integer(index)),
            new ANode(ANodeTypes.GET_HASH),
            new ANode(ANodeTypes.LET)
        };
        this.connect(args);
        return top;
    }
    public ANode hash_list_begin(ANode pair) {
        ANode top = new ANodeNop( "hash_list_top");
        int vno = parser.global.localvars.addImplicitVar();
        top.value = new Integer(vno);
        // => expr, var ( ref, key ), let
        ANode args[] = {
            top,
            pair,
            new ANode(ANodeTypes.LOAD_LOCAL, (Object)new Integer(vno)),
            new ANode(ANodeTypes.CONST_STR, (Object)pair.value), // @see hash_list_pair
            new ANode(ANodeTypes.GET_HASH),
            new ANode(ANodeTypes.LET)
        };
        this.connect(args);
        return top;
    }
    public ANode hash_list_pair(Token key, ANode expr) {
        ANode pair = new ANode(ANodeTypes.NOP, (Object)key.value); // 仕込み
        pair.append(expr);
        return pair;
    }
    public ANode hash_list_end(ANode list) {
        list.append(new ANode(ANodeTypes.LOAD_LOCAL, list.value));
        return list;
    }
    public ANode hash_list_append(ANode top, ANode pair) {
        int vno   = ((Integer)top.value).intValue();
        ANode top2 = new ANodeNop( "hash_list_top_append");
        ANode args[] = {
            top,
            top2,
            pair,
            new ANode(ANodeTypes.LOAD_LOCAL, (Object)new Integer(vno)),
            new ANode(ANodeTypes.CONST_STR, (Object)pair.value),
            new ANode(ANodeTypes.GET_HASH),
            new ANode(ANodeTypes.LET)
        };
        this.connect(args);
        return top;
    }
    public ANode it() {
        ANode n = new ANode(ANodeTypes.LOAD_LOCAL, 0);
        return n;
    }
}
