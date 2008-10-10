/*
 * aoivm.java
 *
 * Created on 2007/02/20, 14:32
 */

package com.aoikujira.aoi2.vm;

/**
 * aoivm main class
 * @author kujiramac
 */

import com.aoikujira.utils.KUtils;
import java.util.Hashtable;
import java.util.Vector;
import com.aoikujira.aoi2.compiler.*;
import java.io.*;


public class aoivm {
    
    public static final String VERSION = "0.001";
    public Stackmachine mac;
    public boolean isDebugMode = false;
    // for print
    public PrintWriter out;
    // for servlet
    public Object request;
    public Object response;
    // for finding file
    public String base_path;
    
    public static void main(String[] args) {
        // compile
        Main aoic = Main.compileParams(args);
        if (aoic == null) return;
        // run
        aoivm vm = new aoivm();
        try {
            String vmfile = Main.getIRNameFromSourceName(aoic.mainfile);
            vm.isDebugMode = Main.isDebugMode;
            vm.base_path = KUtils.extractFilePath(aoic.mainfile);
            vm.loadFromFile(vmfile);
            vm.run();
        } catch (Exception e) {
            System.out.print("<pre>\n[RUNTIME.ERROR](" + 
                String.valueOf(vm.mac.lineno) + ")" + e.toString());
            e.printStackTrace(System.out);
            return;
        }
    }
    
    public aoivm() {
        // set stdout
        out = new PrintWriter(System.out, true);
        mac = new Stackmachine(this);
        base_path = "";
    }
    public void run() {
        mac.run();
    }
    
    public boolean loadFromFile(String filename) {
        // load
        String json_str = KUtils.loadFromFile(filename);
        // parse JSON
        JSON j = JSON.fromString(json_str);
        if (j.type != JSON.typeOBJECT) {
            throw new AOIRuntimeError("Invalid File Type:header not found:" + filename);
        }
        // check File Type
        Hashtable jo = j.getAsObject();
        JSON j_type = (JSON)jo.get("type");
        if (j_type != null && j_type.getAsStr().compareTo("aoi") != 0) {
            throw new AOIRuntimeError("Invalid File Type:header not found:" + filename);
        }
        JSON j_version = (JSON)jo.get("version");
        if (j_version != null && j_version.getAsNum() != 1000) {
            throw new AOIRuntimeError("Invalid File Version:header not found:" + filename);
        }
        // string_table
        JSON j_strtbl = (JSON)jo.get("string_table");
        if (j_strtbl == null || j_strtbl.type != JSON.typeARRAY) {
            throw new AOIRuntimeError("Invalid File Type:not found string_table:" + filename);
        }
        Vector strtbl = (Vector)j_strtbl.getAsArray();
        for (int i = 0; i < strtbl.size(); i++) {
            JSON jstr = (JSON)strtbl.get(i);
            mac.string_table.add(jstr.getAsStr());
        }
        // func_table
        JSON j_ftbl = (JSON)jo.get("func_table");
        if (j_ftbl == null || j_strtbl.type != JSON.typeARRAY) {
            throw new AOIRuntimeError("Invalid File Type:not found func_table:" + filename);
        }
        Vector ftbl = (Vector)j_ftbl.getAsArray();
        for (int i = 0; i < ftbl.size(); i++) {
            JSON jfunc = (JSON)ftbl.get(i);
            AFunction f = new AFunction();
            JSON jaddr = jfunc.getObjectValue("addr");
            JSON jargs = jfunc.getObjectValue("args");
            JSON jname = jfunc.getObjectValue("name");
            f.addr = (jaddr != null) ? jaddr.getAsInt() : -1;
            f.args = (jargs != null) ? jargs.getAsInt() : 0;
            f.name = (jname != null) ? jname.getAsStr() : "";
            mac.func_table.add(f);
        }
        // Module_table
        JSON j_modtbl = (JSON)jo.get("module_table");
        if (j_modtbl == null || j_modtbl.type != JSON.typeARRAY) {
            throw new AOIRuntimeError("Invalid File Type:not found module_table:" + filename);
        }
        Vector modtbl = (Vector)j_modtbl.getAsArray();
        for (int i = 0; i < modtbl.size(); i++) {
            JSON jmod = (JSON)modtbl.get(i);
            AModule m = new AModule();
            JSON jname = jmod.getObjectValue("name");
            m.name = (jname != null) ? jname.getAsStr() : "";
            JSON jargs = jmod.getObjectValue("args");
            if (jargs != null) {
                Vector args = jargs.getAsArray();
                for (int k = 0; k < args.size(); k++) {
                    JSON v = (JSON)args.get(k);
                    int cnt = (v != null) ? v.getAsInt() : 0;
                    m.args.addInt(cnt);
                }
            }
            m.getMethodFunction();
            mac.module_table.add(m);
        }
        // ir
        JSON jir = (JSON)jo.get("ir");
        if (jir == null || jir.type != JSON.typeSTR) {
            throw new AOIRuntimeError("Invalid File:not found ircode:" + filename);
        }
        String ir = jir.getAsStr();
        setIRCode(ir);
        // variable_table
        JSON j_vartbl = (JSON)jo.get("variable_table");
        if (j_vartbl != null && j_vartbl.type == JSON.typeARRAY) {
            Vector vartbl = (Vector)j_vartbl.getAsArray();
            for (int i = 0; i < vartbl.size(); i++) {
                JSON jstr = (JSON)vartbl.get(i);
                mac.varname_table.add(jstr.getAsStr());
            }
        }
        
        //System.out.println(j.toString(0));
        return true;
    }
    
    private void setIRCode(String ir) {
        CurString cur = new CurString(ir);
        while (cur.hasNext()) {
            IRCode ircode = new IRCode();
            char c = cur.getc();
            vmtable tbl = new vmtable();
            int code = tbl.ftable.getInt(""+c);
            String sarg = cur.getToken(",");
            double arg = 0;
            if (sarg.length() != 0) {
                arg = Double.parseDouble(sarg);
            }
            ircode.code  = code;
            ircode.name  = tbl.nametable.getStr(code);
            ircode.value = arg;
            mac.ir.add(ircode);
        }
    }
}
