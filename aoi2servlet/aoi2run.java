package servlet;
/*
 * test.java
 *
 * Created on 2007/05/06, 14:05
 *
 */

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.aoikujira.utils.KUtils;
import com.aoikujira.aoi2.vm.*;
import com.aoikujira.aoi2.compiler.Main;

public class aoi2run extends HttpServlet {
    
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
        if (c.compileFile(realpath)) {
            aoivm m = new aoivm();
            m.out      = out; // set writer
            m.request  = request;
            m.response = response;
            m.base_path = KUtils.extractFilePath(realpath);
            try {
                m.loadFromFile(Main.getIRNameFromSourceName(realpath));
                m.run();
            } catch (Exception e) {
                out.println("<pre><div style='color:red'>[ERROR]" + e.getMessage() + "</div>");
            }
        } else {
            out.println("<pre><div style='color:blue'>[ERRPR]"+c.outErrorMessage+"</div>");
        }
        
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
