/*
 * SourceFiles.java
 *
 * Created on 2007/02/21, 15:41
 */

package com.aoikujira.aoi2.compiler;

/**
 *
 * @author kujiramac
 */
import java.io.File;

import com.aoikujira.utils.KUtils;
import com.aoikujira.utils.StringVector;

public class SourceFiles {
    
    public StringVector files;
    public SourceFiles() {
        files = new StringVector();
    }
    public int add(String filename) {
        int i = files.size();
        files.add(filename);
        return i;
    }
    public int getId(String filename) {
        for (int i = 0; i < files.size(); i++) {
            String s = files.getStr(i);
            if (s.compareTo(filename) == 0) {
                return i;
            }
        }
        return -1;
    }
    public String getFilename(int id) {
        if (id < 0) { return "System"; }
        return files.getStr(id);
    }
    /* static functions */
    public String path_lib;
    public static String appendPathFlag(String path) {
        if (path == null||path.length() == 0) return "";
        char p = path.charAt(path.length()-1);
        if (p == '\\' || p == '/') return path;
        return path + "" + File.separatorChar;
    }
    public String findFile(String fname, int related_file_id) {
        // main path
        if (KUtils.fileExists(fname)) return fname;
        
        // current path
        String curdir = appendPathFlag(KUtils.getCurrentDir());
        String f = curdir + fname;
        if (KUtils.fileExists(f)) return f;
        
        // file path
        if (related_file_id >= 0) {
            String rfile = getFilename(related_file_id);
            if (rfile != null) {
                String path = appendPathFlag(KUtils.extractFilePath(rfile));
                f = path + fname;
                if (KUtils.fileExists(f)) return f;
            }
        }
        
        // library path
        path_lib = appendPathFlag(path_lib);
        f = path_lib + fname;
        if (KUtils.fileExists(f)) return f;
        
        // cur + library
        f = curdir + path_lib + fname;
        if (KUtils.fileExists(f)) return f;
        
        // not found
        return null;
    }
}
