/*
 * Main.java
 *
 * Created on 2007/05/03, 15:47
 */

package aoi2applet;

/**
 * @author desk
 */

import java.applet.Applet;
import java.awt.Label;

public class Main  extends Applet  {
    
    /**
	 * aoi2 applet compiler
	 */
	private static final long serialVersionUID = 1L;

	public void init() {
        add(new Label("葵2"));
    }
    
    public String compileAOI(String source, String ext) {
        aoic.Main c = new aoic.Main();
        c.global.isApplet = true;
        c.global.base_url = this.getCodeBase();
        try {
            String res;
            res = c.compileAOI(source, ext);
            return res;
        } catch (Exception e) {
            return "[ERROR]:\n" + e.getMessage();
        }
    }
}
