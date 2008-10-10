/*
 * Main.java
 *
 * Created on 2007/05/03, 15:47
 */

package com.aoikujira.aoi2.applet;

/**
 * @author desk
 */

import java.applet.*;
import java.awt.*;
import com.aoikujira.aoi2.compiler.*;

public class AppletMain  extends Applet  {
    
	private static final long serialVersionUID = -4067674216671352822L;
	protected Label label = new Label("葵2");
    
    public void init() {
        add(label);
        //test();
    }
    
    public void test() {
        label.setText(
            compileAOI("include\"ModuleSwf.bas\"\n",".bas", false)
        );
    }
    
    public String compileAOI(String source, String ext, boolean debug_mode) {
        Main c = new Main();
        c.global.isApplet = true;
        c.global.base_url = this.getCodeBase();
        try {
            String res;
            res = c.compileAOI(source, ext, debug_mode);
            return res;
        } catch (AOICException e) {
            return e.getMessage(c.global);
        } catch (Exception e) {
            return "[ERROR]:\n" + e.getMessage();
        }
    }
}
