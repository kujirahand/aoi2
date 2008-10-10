
package com.aoikujira.aoi2.compiler;

import com.aoikujira.utils.*;

public class AArgument {
    public String name;
    public String defvalue;
    public StringVector josi_list;
    public AArgument() {
        josi_list = new StringVector();
    }
    public String toString() {
        String r =  name;
        if (defvalue != null) { r += "=" + defvalue; }
        r += "(";
        for (int i = 0; i < josi_list.size(); i++) {
            String j = (String)josi_list.get(i);
            r += j + ",";
        }
        r += ")";
        return r;
    }
    public void addJosi(String josi) {
        if (hasJosi(josi) == -1) {
            josi_list.addStr(josi);
        }
    }
    public int hasJosi(String josi) {
        if (josi_list == null) return -1;
        if (josi == null) return -1;
        for (int i = 0; i < josi_list.size(); i++) {
            String j = (String)josi_list.get(i);
            if (j.compareTo(josi) == 0) {
                return i;
            }
        }
        return -1;
    }
}