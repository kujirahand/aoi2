/**
 * 葵IRコードを書き出すクラス 
 */
package com.aoikujira.aoi2.compiler;

import java.util.Date;

import com.aoikujira.utils.KUtils;
import com.aoikujira.utils.StringVector;

public class ANodePrinter {
    private ANode top;
    private GlobalObject global;
    
    public ANodePrinter(ANode top, GlobalObject global) {
        this.top = top;
        this.global = global;
    }
    /**
     * DEBUG用の出力を行う
     */
    public String printToString(int level) {
        String str = "";
        ANode n = top;
        int no = 0;
        while (n != null) {
            n.tag = no++;
            String name = ANodeTypes.names[n.type];
            int args = ANodeTypes.args[n.type];
            str += "" + n.tag + ":";
            for (int i = 0; i < level; i++) { str += " "; }
            str += name;
            switch (args) {
                case 1:
                    if (n.value == null) {
                        str += "(ERROR)";
                    } else {
                        if (n.isJumpNode()) {
                            ANode jpn = (ANode)n.value;
                            if (n.type == ANodeTypes.NOP) {
                                str += "(" + jpn.desc + ")";
                            } else {
                                str += ";" + jpn.tag;
                            }
                        } else {
                            str += " " + n.value;
                        }
                    }
            }
            if (n.desc != null) {
                str += " ;" + n.desc;
            }
            if (n.josi != null) {
                str += ";;" + n.josi;
            }
            str += "\n";
            if (n.list != null) {
                for (int i = 0; i < n.list.size(); i++) {
                    ANode cn = (ANode)n.list.get(i);
                    ANodePrinter p = new ANodePrinter(cn, global);
                    str += p.printToString(level + 2);
                }
            }
            n = n.getNext();
        }
        return str;
    }
    
    /**
     * 最適化(NOPを削除)
     */
    private void optimize_delete_nop() {
        // ジャンプ先がNOPの場合、NOPでないノードまでずらす
        ANode n = top;
        while (n != null) {
            if (n.isJumpNode()) {
                ANode j = (ANode)n.value;
                while (j != null && j.isNOPorEOL()) {
                    j = j.getNext();
                }
                n.value = j;
            }
            n = n.getNext();
        }
        // ユーザー関数のあるノードアドレスでNOPを飛ばすように修正
        for (int i = 0; i < global.funcs.size(); i++) {
            FunctionPoint fp = (FunctionPoint)global.funcs.get(i);
            while (fp.node.isNOPorEOL()) {
                fp.node = fp.node.getNext();
            }
        
        }
        // --- NOPノードを削除する
        // NOP以外のノードをリストに追加する
        ANodeVector nodes = new ANodeVector();
        n = top;
        while (n != null) {
            if (n.type != ANodeTypes.NOP) {
                // 通常のノードを加える
                nodes.add(n);
            }
            n = n.getNext();
        }
        // リストをつなぎなおす
        for (int i = 0; i < nodes.size()-1; i++) {
            n = nodes.getNode(i);
            n.setNext(nodes.getNode(i+1));
        }
        if (nodes.size() > 0) {
            this.top = nodes.getNode(0);
            n = nodes.getNode(nodes.size() - 1);
            n.setNext(null);
        }
        // 連続するEOLを削除する
        ANodeVector nodes2 = new ANodeVector();
        n = top;
        ANode oldn = n;
        while (n != null) {
            if (oldn.type == ANodeTypes.EOL && n.type == ANodeTypes.EOL) {
                n = n.getNext();
                continue;
            }
            nodes2.add(n);
            oldn = n;
            n = n.getNext();
        }
        nodes = nodes2;
        // リストをつなぎなおす
        for (int i = 0; i < nodes.size()-1; i++) {
            n = nodes.getNode(i);
            n.setNext(nodes.getNode(i+1));
        }
        if (nodes.size() > 0) {
            this.top = nodes.getNode(0);
            n = nodes.getNode(nodes.size() - 1);
            n.setNext(null);
        }
    }
    
    private void optimize() {
        optimize_delete_nop();
        //System.out.println("--- optimized ---");
        //System.out.println(this.printToString(0));
    }
    
    /**
     * 葵IRを書き出す
     */
    public String writeCode() {
        optimize();
        StringVector strtbl = new StringVector();
        // mark tag
        int no = 0;
        ANode n = top;
        ANode jn;
        while (n != null) {
            n.tag = no++;
            n = n.getNext();
        }
        // write ir
        Date d = new Date();
        String json = "{type:\"aoi\",version:1000,maker:\"aoic\",time:"+d.getTime()+",\n";
        json += "ir:\"";
        n = top;
        while (n != null) {
            // ch
            String ch = ANodeTypes.codes[n.type];
            json += ch;
            // arg
            switch (n.type) {
                case ANodeTypes.JUMP:
                    jn = (ANode)n.value; json += "" + jn.tag; break;
                case ANodeTypes.JUMP_NON_ZERO:
                    jn = (ANode)n.value; json += "" + jn.tag; break;
                case ANodeTypes.JUMP_ZERO:
                    jn = (ANode)n.value; json += "" + jn.tag; break;
                case ANodeTypes.CONST_INT:
                    json += (Integer)n.value; break;
                case ANodeTypes.CONST_NUM:
                    json += (Double)n.value; break;
                case ANodeTypes.CONST_STR:
                    String  rstr = (String)n.value;
                    int rid = strtbl.addUnique(rstr);
                    json += rid;
                    break;
                case ANodeTypes.LOAD:
                    json += (Integer)n.value; break;
                case ANodeTypes.LOAD_LOCAL:
                    json += (Integer)n.value; break;
                case ANodeTypes.STORE:
                    json += (Integer)n.value; break;
                case ANodeTypes.STORE_LOCAL:
                    json += (Integer)n.value; break;
                case ANodeTypes.CALL_LIB:
                    json += (Integer)n.value; break;
                case ANodeTypes.CALL_USR:
                    AFunction func = (AFunction)n.value;
                    json += "" + func.funcno; break;
                case ANodeTypes.EOL:
                    if (n.value != null) json += (Integer)n.value; 
                    break;
            }
            json += ",";
            n = n.getNext();
        }
        json = json.substring(0, json.length()-1);
        json += "\",\n";
        // string table
        if (strtbl.size() > 0) {
            json += "string_table:[";
            for(int i=0; i < strtbl.size(); i++) {
                String s = strtbl.getStr(i);
                s = KUtils.replaceAll(s, "\\", "\\\\");
                s = KUtils.replaceAll(s, "\"", "\\\"");
                s = KUtils.replaceAll(s, "\n", "\\n");
                s = KUtils.replaceAll(s, "\t", "\\t");
                json += "\"" + s + "\",";
            }
            json = json.substring(0, json.length()-1);
            json += "]";
        } else {
            json += "string_table:[]";
        }
        // function table
        json += ",\n";
        if (global.funcs.size() > 0) {
            json += "func_table:[";
            for (int i = 0; i < global.funcs.size(); i++) {
                FunctionPoint fp = (FunctionPoint)global.funcs.get(i);
                AFunction f = fp.func;
                json += "{";
                json += "name:\"" + f.name + "\",";
                json += "args:" + f.args.size() + ",";
                json += "addr:" + fp.node.tag + "";
                json += "},";
            }
            json = json.substring(0, json.length()-1);
            json += "]";
        } else {
            json += "func_table:[]";
        }
        // module table
        json += ",\n";
        if (global.modules.size() > 0) {
            json += "module_table:[";
            for (int i = 0; i < global.modules.size(); i++) {
                AModule m = (AModule)global.modules.get(i);
                json += "{";
                    json += "name:\"" + m.name + "\"";
                json += "},";
            }
            json = json.substring(0, json.length()-1);
            json += "]";
        } else {
            json += "module_table:[]";
        }
        // debug info
        // 変数の書き出し
        if (Main.isDebugMode) {
            json += ",\nvariable_table:[";
            StringVector sv = global.vars.getAsArray();
            for (int i = 0; i < sv.size(); i++) {
                String s = sv.getStr(i);
                json += "\"" + s + "\",";
            }
            if (sv.size() > 0) {
                json = json.substring(0, json.length() - 1);
            }
            json += "]";
        }
        // end of json
        json += "}\n";
        return json;
    }
}
