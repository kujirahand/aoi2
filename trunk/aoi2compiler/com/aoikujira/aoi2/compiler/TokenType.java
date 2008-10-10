/*
 * TokenType.java
 *
 * Created on 2007/01/30, 21:33
 */

package com.aoikujira.aoi2.compiler;

/**
 * Define Token Type
 * @author desk
 */
public class TokenType {
    public static final int LF          = 13;
    public static final int INTEGER     = 0x1000;
    public static final int NUMBER      = 0x1001;
    public static final int STRING      = 0x1002;
    public static final int WORD        = 0x1003;
    public static final int FLAG        = 0x1004;
    public static final int NOP         = 0xFFFF;
}
