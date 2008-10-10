/*
 * AModule.java
 *
 * Created on 2007/03/23, 9:27
 */

package com.aoikujira.aoi2.vm;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import com.aoikujira.utils.IntegerVector;

/**
 *
 * @author desk
 */
public class AModule {
    
    public String name;
    public IntegerVector args;
    public Class klass;
    public Object instance;
    protected Method m_call;
    protected Method m_getArgCount;
    
    public AModule() {
        args = new IntegerVector();
    }
    
    public void getMethodFunction() {
        AModule m = this;
        String mod_name = m.name;
        // get class
        try {
            // complete path?
            if (mod_name.indexOf(".") >= 0) {
                m.klass = Class.forName(mod_name);
            }
            else {
                m.klass = Class.forName("com.aoikujira.aoi2.vm.module."+mod_name);
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            return;
        }
        // get instance
        try {
            m.instance = m.klass.newInstance();
        } catch (InstantiationException e1) {
            e1.printStackTrace();
            return;
        }catch (IllegalAccessException e1) {
            e1.printStackTrace();
            return;
        }
        // get method
        // get call method
        try {
            m_call = m.klass.getMethod("aoimodule_call", new Class[]{int.class, AFunctionArg.class});
        } catch (SecurityException e2) {
            e2.printStackTrace(); return;
        } catch (NoSuchMethodException e2) {
            e2.printStackTrace(); return;
        }
        // getArgCount method
        try {
            m.m_getArgCount = m.klass.getMethod("aoimodule_getArgCount", new Class[]{int.class});
        } catch (SecurityException e2) {
            e2.printStackTrace(); return;
        } catch (NoSuchMethodException e2) {
            e2.printStackTrace(); return;
        }
    }
    
    public int getArgCount(int mod_fno) {
        if (m_getArgCount == null) return 0;
        Object ret;
        // method call
	try {
            ret = m_getArgCount.invoke(instance, new Object[]{ new Integer(mod_fno) });
            //  = object.メソッド((int)1); と同じ
	} catch (IllegalArgumentException e3) {
            e3.printStackTrace(); return 0;
	} catch (IllegalAccessException e3) {
            e3.printStackTrace(); return 0;
	} catch (InvocationTargetException e3) {
            e3.printStackTrace(); return 0;
	} catch (Exception e) {
            throw new AOIRuntimeError(e.getMessage());
        }
        if (ret == null) return 0;
        return ((Integer)ret).intValue();
    }
    
    public void call(int mod_fno, AFunctionArg arg) {
        // method call
	try {
            m_call.invoke(instance, new Object[]{ new Integer(mod_fno), arg});
            //  = object.メソッド((int)1); と同じ
	} catch (IllegalArgumentException e3) {
            e3.printStackTrace(); return;
	} catch (IllegalAccessException e3) {
            e3.printStackTrace(); return;
	} catch (InvocationTargetException e3) {
            e3.printStackTrace(); return;
	} catch (Exception e) {
            throw new AOIRuntimeError(e.getMessage());
        }
    }
}
