/*
 * AValue.java
 *
 * Created on 2007/02/20, 22:32
 */

package com.aoikujira.aoi2.avalue;

/**
 *
 * @author kujiramac
 */

import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Vector;

import com.aoikujira.aoi2.compiler.Main;
import com.aoikujira.utils.KUtils;
import com.aoikujira.utils.StringVector;

public class AValue {
    
    public static final int typeNull    = 0;
    public static final int typeInt     = 1;
    public static final int typeNum     = 2;
    public static final int typeStr     = 3;
    public static final int typeArray   = 4;
    public static final int typeHash    = 5;
    public static final int typeFunc    = 6;
    public static final int typeLink    = 7;
    
    public int type;
    public Object value;
    
    public AValue() {
        type = AValue.typeNull;
        value = null;
    }
    public AValue(int init) {
        type = AValue.typeInt;
        value = new Integer(init);
    }
    public AValue(double init) {
        type = AValue.typeNum;
        value = new Double(init);
    }
    public AValue(String init) {
        type = AValue.typeStr;
        value = new String(init);
    }
    public AValue(boolean init) {
        type = AValue.typeInt;
        value = (init) ? new Integer(1) : new Integer(0);
    }
    public void setLink(AValue v) {
        type = AValue.typeLink;
        value = v;
    }
    public AValue getLink() {
        AValue o = this;
        while (o.type == AValue.typeLink) {
            o = (AValue)o.value;
        }
        return o;
    }
    public void setValue(AValue v) {
        if (v == null) {
            type = AValue.typeNull;
            value = null;
            return;
        }
        v    = v.getLink();
        type = v.type;
        switch (type) {
            case AValue.typeInt: value = new Integer(((Integer)v.value).intValue()); break;
            case AValue.typeNum: value = new Double(((Double)v.value).doubleValue()); break;
            case AValue.typeStr: value = new String((String)v.value); break;
            case AValue.typeArray:
                AValueVector av = (AValueVector)v.value;
                AValueVector bv = new AValueVector();
                for (int i = 0; i < av.size(); i++) {
                    AValue n = av.getAValue(i);
                    bv.add(n.cloneAValue());
                }
                this.value = (Object)bv;
                break;
            case AValue.typeHash:
                AValueHashtable atbl = (AValueHashtable)v.value;
                AValueHashtable btbl = new AValueHashtable();
                //Enumeration<String> keys = atbl.keys();
                Enumeration keys = atbl.keys();
                while (keys.hasMoreElements()) {
                    String key = (String)keys.nextElement();
                    AValue ahv = atbl.getAValue(key);
                    AValue bhv = ahv.cloneAValue();
                    btbl.put(key, bhv);
                }
                this.value = (Object)btbl;
                break;
            default:
                this.value = v.value;
                break;
        }
    }
    public int getAsInt() {
        AValue o = getLink();
        switch (type) {
            case typeNull:  return 0;
            case typeInt:   return ((Integer)o.value).intValue();
            case typeNum:
                Double dv = (Double)o.value;
                int iv = dv.intValue();
                return iv;
            case typeStr:
                String s = (String)o.value;
                return Integer.parseInt(s);
            case typeArray: return ((Vector)o.value).size();
            case typeHash:  return ((Hashtable)o.value).size();
            default:        return 0;
        }
    }
    public double getAsNum() {
        AValue o = getLink();
        switch (type) {
            case typeNull:  return 0;
            case typeInt:
                Integer iv = (Integer)o.value;
                return iv.intValue();
            case typeNum:   return ((Double)o.value).doubleValue();
            case typeStr:
                try {
                    String s = (String)o.value;
                    return Integer.parseInt(s);
                } catch (NumberFormatException e) {
                    return 0;
                }
            case typeArray: return ((Vector)o.value).size();
            case typeHash:  return ((Hashtable)o.value).size();
            default:        return 0;
        }
    }
    public String getAsStr() {
        AValue o = this.getLink();
        String s;
        switch (o.type) {
            case typeNull:
                if (Main.isDebugMode) {
                    return "(null)";
                } else {
                    return "";
                }
            case typeInt:
                Integer iv = (Integer)o.value;
                return String.valueOf(iv);
            case typeNum:
                double dv = ((Double)o.value).doubleValue();
                if ((dv - (double)(Math.floor(dv))) == 0.0) {
                    return String.valueOf((int)Math.floor(dv));
                }
                return String.valueOf(dv);
            case typeStr:
                s = (String)o.value;
                return s;
            case typeArray:
                AValueVector ary = (AValueVector)this.value;
                s = "[";
                for (int i = 0; i < ary.size(); i++) {
                    AValue av = ary.getAValue(i);
                    String sav;
                    if (av == null) {
                        sav = "";
                    } else {
                        av = av.getLink();
                        sav = av.getAsStringValue();
                    }
                    s += sav + ",";
                }
                if (ary.size() > 0) {
                    s = s.substring(0, s.length()-1);
                }
                s += "]";
                return s;
            case typeHash:
                AValueHashtable tbl = (AValueHashtable)this.value;
                if (tbl == null) { return "{}"; }
                s = "{";
                //Enumeration<String>e = tbl.keys();
                Enumeration e = tbl.keys();
                while (e.hasMoreElements()) {
                    String key = (String)e.nextElement();
                    AValue hv = tbl.getAValue(key);
                    s += key + ":" + hv.getAsStringValue();
                    s += ",";
                }
                if (tbl.size() > 0) {
                    s = s.substring(0, s.length()-1);
                }
                s += "}";
                return s;
            default:
                return "";
        }
    }
    public String getAsStringValue() {
        if (this.isNumberic()) {
            return this.getAsStr();
        } else if (this.type == typeStr) {
            String sav = this.getAsStr();
            sav = KUtils.replaceAll(sav, "\\", "\\\\");
            sav = KUtils.replaceAll(sav, "\"", "\\\"");
            sav = KUtils.replaceAll(sav, "\n", "\\n");
            sav = KUtils.replaceAll(sav, "\t", "\\t");
            return "\"" + sav + "\"";
        } else {
            return this.getAsStr();
        }
    }
    public boolean isNumberic() {
        return (type == AValue.typeInt || type == AValue.typeNum);
    }
    public String toString() {
        return getAsStr();
    }
    public AValue cloneAValue() {
        AValue o = this.getLink();
        AValue n = new AValue();
        n.setValue(o);
        return n;
    }
    public void hash_create() {
        AValue obj = this.getLink();
        if (obj.type != AValue.typeHash) {
            obj.type = AValue.typeHash;
            obj.value = new AValueHashtable();
        }
    }
    public void hash_set(String key, AValue v) {
        hash_create();
        AValue obj = this.getLink();
        AValueHashtable table = (AValueHashtable)obj.value;
        table.put(key, v);
    }
    public AValue hash_get(String key) {
        hash_create();
        AValue obj = this.getLink();
        AValueHashtable table = (AValueHashtable)obj.value;
        return table.getAValue(key);
    }
    public StringVector hash_keys() {
        StringVector sv = new StringVector();
        hash_create();
        AValue obj = this.getLink();
        AValueHashtable table = (AValueHashtable)obj.value;
        //Enumeration<String> keys = table.keys();
        Enumeration keys = table.keys();
        while (keys.hasMoreElements()) {
            sv.add(keys.nextElement());
        }
        return sv;
    }
    public void array_create() {
        AValue obj = this.getLink();
        if (obj.type != AValue.typeArray) {
            obj.type = AValue.typeArray;
            obj.value = new AValueVector();
        }
    }
    public void array_set(int index, AValue v) {
        array_create();
        AValue obj = this.getLink();
        AValueVector table = (AValueVector)obj.value;
        table.set(index, v);
    }
    public void array_setStringVecotr(StringVector sv) {
        AValueVector r = new AValueVector();
        for (int i = 0; i < sv.size(); i++) {
            String v = sv.getStr(i);
            r.setAValue(i, new AValue(v));
        }
        this.type  = AValue.typeArray;
        this.value = r;
    }
    public void array_add(AValue v) {
        array_create();
        AValue obj = this.getLink();
        AValueVector table = (AValueVector)obj.value;
        table.add(v);
    }
    public AValue array_get(int index) {
        array_create();
        AValue obj = this.getLink();
        AValueVector table = (AValueVector)obj.value;
        return table.getAValue(index);
    }
    public int array_length() {
        array_create();
        AValue obj = this.getLink();
        AValueVector table = (AValueVector)obj.value;
        return table.size();
    }
    public void convertToString() {
        AValue obj = this.getLink();
        this.type = typeStr;
        this.value = new String(obj.getAsStr());
    }
}

