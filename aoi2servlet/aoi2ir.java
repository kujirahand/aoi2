/*
 * aoi2ir.java
 * Created on 2007/05/15, 10:02
 */

package servlet;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.aoikujira.utils.*;
import com.aoikujira.aoi2.compiler.*;


/**
 *
 * @author kujiramac
 * @version
 */
public class aoi2ir extends HttpServlet {
    
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/** Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        String uri = request.getRequestURI();
        String realpath = getServletContext().getRealPath(uri);
        String lib = this.getInitParameter("lib");
        if (lib == null || lib.compareTo("") == 0) {
            lib = KUtils.extractFilePath(realpath);
        }
        Main c = new Main();
        c.global.files.path_lib = lib;
        String result = "";
        try {
            String ext    = request.getParameter("ext");
            String source = request.getParameter("source");
            if (ext == null || ext.length() == 0) { ext = ".aoi2"; }
            result = c.compileAOI(source, ext);
        } catch (Exception e) {
            String s = e.getMessage();
            s = KUtils.replaceAll(s, "\\",  "\\\\");
            s = KUtils.replaceAll(s, "\"", "\\\"");
            s = KUtils.replaceAll(s, "\n",  "\\n");
            result = "{type:\"error\", compile_error:true, message:\"" + s + "\"}";
        }
        out.print(result);
        out.close();
    }
    
    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }
    
    /** Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }
    
    /** Returns a short description of the servlet.
     */
    public String getServletInfo() {
        return "Short description";
    }
    // </editor-fold>
}
