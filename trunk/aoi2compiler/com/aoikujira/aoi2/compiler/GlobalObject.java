/**
 * GlobalObject.java
 * Created on 2007/02/02, 16:44
 * @author kujiramac
 */

package com.aoikujira.aoi2.compiler;
import java.net.URL;
import java.util.Vector;

import com.aoikujira.aoi2.compiler.lang.aoi.AOITokenizer;

public class GlobalObject {
    
    //public class FunctionPointVector extends Vector<FunctionPoint> {}
    public class FunctionPointVector extends Vector{
		private static final long serialVersionUID = 1L;
    }
    
    public AVariables vars; // Global Variables
    public FunctionPointVector funcs; // Vector<FunctionPoint>
    public AFunction funcscope;   // パース中に利用する関数のスコープ制御用
    public AVariables localvars;  // パース中に利用するローカル変数
    public AModuleVector modules; // 利用するモジュール
    public boolean isApplet = false;
    public URL base_url;
    public SourceFiles files;
    public int fileid;
    public int lineno;
    
    public GlobalObject() {
        vars = new AVariables();
        localvars = new AVariables();
        funcs = new FunctionPointVector();
        modules = new AModuleVector();
        files = new SourceFiles();
        // 必ずローカル変数「それ」が存在する
        this.addSoreToLocalvars();
    }
    public int getModuleno(String mod_name) {
        AModule mid = getModule(mod_name);
        return mid.id;
    }
    public AModule getModule(String mod_name) {
        AModule mid = modules.indexOf(mod_name);
        if (mid == null) {
            mid = new AModule();
            mid.name = mod_name;
            modules.add(mid);
            mid.id = modules.size() - 1;
        }
        return mid;
    }
    
    public void addSoreToLocalvars() {
        AVariable var_result = new AVariable(AOITokenizer.SORE, AVariable.UNKNOWN);
        localvars.add(var_result);
    }
    
    public void addFunctionPoint(String name, ANode node, AFunction func) {
        FunctionPoint fp = new FunctionPoint();
        fp.name = name;
        fp.node = node;
        fp.func = func;
        fp.func.funcno = funcs.size();
        funcs.add(fp);
    }
}
