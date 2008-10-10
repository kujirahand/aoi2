/*
 * AOIRuntimeError.java
 *
 * Created on 2007/02/21, 9:05
 *
 */

package com.aoikujira.aoi2.vm;

/**
 *
 * @author kujiramac
 */
import java.lang.RuntimeException;

public class AOIRuntimeError extends RuntimeException{
	private static final long serialVersionUID = 1L;

	/** Creates a new instance of AOIRuntimeError */
    public AOIRuntimeError(String msg) {
        super(msg);
    }
    
}
