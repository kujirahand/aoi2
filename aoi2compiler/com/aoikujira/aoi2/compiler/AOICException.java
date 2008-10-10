/*
 * AOICException.java
 *
 * Created on 2007/01/30, 17:35
 * and open the template in the editor.
 */

package com.aoikujira.aoi2.compiler;

import com.aoikujira.utils.*;
/**
 *
 * @author desk
 */
public class AOICException extends RuntimeException {
    private static final long serialVersionUID = 1L;
    public int lineno = -1;
    public int fileid = -1;
    public String getMessage(GlobalObject g) {
        String s = super.getMessage();
        s = KUtils.replaceAll(s, "com.aoikujira.aoi2.compiler.lang.aoi.AOIParser$yyException: irrecoverable syntax error", ErrMsg.SyntaxError);
        s = KUtils.replaceAll(s, "com.aoikujira.aoi2.compiler.lang.basic.AOIParser$yyException: irrecoverable syntax error", ErrMsg.SyntaxError);
        s = KUtils.replaceAll(s, "com.aoikujira.aoi2.compiler.AOICException", ErrMsg.AOICError);
        if (fileid < 0) fileid = g.fileid;
        if (lineno < 0) lineno = g.lineno;
        return "\n[ERROR]" + KUtils.extractFileName( g.files.getFilename(fileid) ) + 
                "(" + Integer.toString(lineno+1) + "):" + s + "\n"; 
    }
    public AOICException(String msg) {
        super(msg);
    }
    public AOICException(String msg, int fileid, int lineno) {
        super(msg);
        this.lineno = lineno;
        this.fileid = fileid;
    }
    public AOICException(String msg, Token tok) {
        super(msg);
        this.lineno = tok.lineno;
        this.fileid = tok.fileid;
    }
    public AOICException(String msg, CurString cur) {
        super(msg);
        this.lineno = cur.lineno;
        this.fileid = cur.fileid;
    }
}
