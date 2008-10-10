package com.aoikujira.aoi2.compiler.lang.aoi;

import com.aoikujira.aoi2.compiler.*;

public class AOINodeCreator extends ANodeCreator {

    public AOINodeCreator(Parser parser) {
        super(parser);
    }

    public ANode callFunc(Token token_var, ANode callargs, Token tjosi) {
        ANode n = callFunc(token_var, callargs);
        n.josi = tjosi.josi;
        return n;
    }
    
    public ANode callFunc(Token token_var, ANode callargs) {
        ANode topnode;
        
        // 関数の特定
        ANode funcnode;
        AVariable var = (AVariable)token_var.value;
        funcnode = makeFunctionNode(var, token_var.josi);
        
        // 引数の取得
        if (callargs != null || var.func.args.size() > 0) {
            topnode = callFunc_pickup(funcnode, var, callargs);
        } else {
            topnode = funcnode;
        }
        // 引数にならない場合(AしてBするの場合 => Aの後にPOPを入れる)
        if (funcnode.josi != null && funcnode.josi.compareTo("して") == 0) {
            ANode n = new ANode(ANodeTypes.POP);
            topnode.append(n);
        }
        return topnode;
        
    }
    
    private ANode callFunc_pickup(ANode funcnode, AVariable var, ANode callargs) {
        ANode functop = new ANodeNop( "func:" + var.name);
        functop.josi = funcnode.josi;
        ANode n = new ANodeNop( "funcarg:" + var.name);
        functop.addChild(n);
        // 定義関数にある各引数を１つずつ調べていく
        for (int i = 0; i < var.func.args.size(); i++) {
            ANode node = null; 
            String desc_josi_list = "";
            AArgument a = (AArgument)var.func.args.get(i);
            // 呼び出しスタック中に対応する助詞があるか調べる
            if (a.josi_list == null) continue;
            for (int j = 0; j < a.josi_list.size(); j++) {
                String josi = a.josi_list.getStr(j);
                if (callargs != null) {
                    node = callargs.pickupList(josi);
                }
                if (node != null) break;
                desc_josi_list += ":" + josi;
            }
            // 引数補完が必要か？
            if (node == null && i == 0) {
                n.addChild(new ANode(ANodeTypes.LOAD_LOCAL, new Integer(0)));
                continue;
            }
            // 対応する引数があるか？
            if (node == null) {
                throw new AOICException(
                        ErrMsg.NoArgError + ":" + (i + 1) + ":" + a.toString());
            }
            n.addChild(node);
        }
        if (n.list != null) {
            if (n.list.size() != var.func.args.size()) {
                throw new AOICException(ErrMsg.ArgCountError);
            }
        } else {
            if (var.func.args.size() > 0) {
                throw new AOICException(ErrMsg.ArgCountError);
            }
        }
        n.addChild(funcnode);
        // 引数に取り残しがある場合
        if(callargs != null && callargs.list != null && callargs.list.size() > 0) {
            //throw new AOICException(ErrMsg.ArgCountError);
            callargs.addChild(functop);
            return callargs;
        }
        return functop;
    }

}
