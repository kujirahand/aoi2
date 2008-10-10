/*
 * aoi2save.java
 * MYSQLに保存する機能
 * Created on 2007/05/15, 14:11
 */

package servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

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
public class aoi2save extends HttpServlet {
    
	private static final long serialVersionUID = 1L;
	
	/** Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     */
    private String dburl        = "jdbc:mysql://localhost/aoi2?characterEncoding=UTF8";
    private String dbuser       = "kujira";
    private String dbpassword   = "abcd";
    private String errmsg = "";
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        errmsg = "";
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            String mode = gf(request, "mode");
            if (mode.equals("load")) {
                loadSource(request, out);
                return;
            }
            if (mode.equals("ir")) {
                loadIr(request, out);
                return;
            }
            
            if (!checkParams(request)) { 
                out.print("{status:\"error\", messsage:\""+errmsg+"\"}");
                return;
            }
            /*
            // check driver
            try {
                Class.forName("org.gjt.mm.mysql.Driver");
            } catch (Exception e) {
                out.print("{status:\"error\", messsage:\"SERVER ERROR : NO DRIVER!\"}");
                return;
            }
            // connect database
            try {
                Connection con = DriverManager.getConnection(dburl,dbuser,dbpassword);
                String id_str = gf(request, "id");
                // insert or update
                if (id_str.equals("")) {
                    // insert
                    String sql = "INSERT INTO aoi2source " +
                            "(name,title,comment,password,source) VALUES " +
                            "(?,?,?,?,?)";
                    PreparedStatement stmt = con.prepareStatement(sql);
                    stmt.setString(1, gf(request, "name"));
                    stmt.setString(2, gf(request, "title"));
                    stmt.setString(3, gf(request, "comment"));
                    stmt.setString(4, gf(request, "password"));
                    stmt.setString(5, gf(request, "source"));
                    stmt.executeUpdate();
                    ResultSet rs = stmt.executeQuery("select LAST_INSERT_ID()");
                    rs.next();
                    String insertid = rs.getString(1);
                    out.print("{status:\"ok\", id:"+insertid+", update:false}");
                } else {
                    // update
                    // check password
                    int qid = Integer.valueOf(id_str).intValue();
                    PreparedStatement stmt = con.prepareStatement("select password from aoi2source where id=?");
                    stmt.setInt(1, qid);
                    ResultSet rs = stmt.executeQuery();
                    if (rs == null || rs.next() == false) {
                        throw new RuntimeException("Invalid id:" + id_str);
                    }
                    String password = gf(request, "password");
                    String pw = rs.getString("password");
                    if (!pw.equals(password)) {
                        throw new RuntimeException("パスワードが違います?");
                    }
                    // update
                    stmt = con.prepareStatement("update aoi2source set " +
                            "name=?,title=?,comment=?,source=?,ir='' where id=?");
                    stmt.setString(1, gf(request, "name"));
                    stmt.setString(2, gf(request, "title"));
                    stmt.setString(3, gf(request, "comment"));
                    stmt.setString(4, gf(request, "source"));
                    stmt.setString(5, id_str);
                    stmt.executeUpdate();
                    out.print("{status:\"ok\", id:"+id_str+", update:true}");
                }
            } catch (Exception e) {
                String s = errmsg + e.getMessage();
                out.print("{status:\"error\", messsage:\"SQL ERROR:"+escapeStr(s)+"\"}");
            }
            */
        } finally {
            out.close();
        }
    }
    private String gf(HttpServletRequest r, String name) {
        String s = r.getParameter(name);
        if (s == null) s = "";
        return s;
    }
    private boolean checkParams(HttpServletRequest r) {
        boolean b = true;
        String confirm = gf(r, "confirm");
        if ( confirm.equals("はな") == false ) {
            b = false;
            errmsg = "迷惑防止キーが違います";
        }
        if (gf(r,"source").equals("")) {
            b = false;
            errmsg = "プログラムが空です。";
        }
        return b;
    }
    
    private void loadSource(HttpServletRequest r, PrintWriter out) {
        try {
            Class.forName("org.gjt.mm.mysql.Driver");
        } catch (Exception e) {
            out.print("{status:\"error\", messsage:\"SERVER ERROR : NO DRIVER!\"}");
            return;
        }
        try {
            String id_str = gf(r,"id");
            if (id_str.equals("")) { throw new RuntimeException("ID did not set."); }
            Connection con = DriverManager.getConnection(dburl,dbuser,dbpassword);
            String sql = "select * from aoi2source where id=?";
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setString(1, id_str);
            ResultSet rs = stmt.executeQuery();
            rs.next();
            String json = "{status:\"ok\",";
            // get source
            byte[] source_bytes  = rs.getBytes("source");
            String src = new String(source_bytes, "UTF8");
            json += "source:" + escapeStr(src)+",";
            json += "name:" + escapeStr(rs.getString("name"))+",";
            json += "title:" + escapeStr(rs.getString("title"))+",";
            json += "comment:" + escapeStr(rs.getString("comment"));
            json += "}";
            out.print(json);
        } catch (Exception e) {
            errmsg += e.getMessage();
            out.print("{status:\"error\", messsage:"+escapeStr(errmsg)+"}");
        }
    }
    private void loadIr(HttpServletRequest r, PrintWriter out) {
        try {
            Class.forName("org.gjt.mm.mysql.Driver");
        } catch (Exception e) {
            out.print("{status:\"error\", messsage:\"SERVER ERROR : NO DRIVER!\"}");
            return;
        }
        try {
            String id_str = gf(r,"id");
            if (id_str.equals("")) { throw new RuntimeException("ID did not set."); }
            Connection con = DriverManager.getConnection(dburl,dbuser,dbpassword);
            String sql = "select * from aoi2source where id=?";
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setString(1, id_str);
            ResultSet rs = stmt.executeQuery();
            rs.next();
            // get ir
            byte[] ir_bytes  = rs.getBytes("ir");
            if (ir_bytes != null && ir_bytes.length > 0) {
                String ir = new String(ir_bytes, "UTF8");
                out.println(ir);
                return;
            }
            // no ir, compile source
            String uri = r.getRequestURI();
            String realpath = getServletContext().getRealPath(uri);
            String lib = this.getInitParameter("lib");
            if (lib == null || lib.compareTo("") == 0) {
                lib = KUtils.extractFilePath(realpath);
            }
            byte[] src_bytes = rs.getBytes("source");
            String src = new String(src_bytes, "UTF8");
            String ext = rs.getString("ext");
            if (ext.equals(".aoi2")) {
                src = "「ModuleSwf.aoi2」を取り込a??" + src;
            }
            Main c = new Main();
            c.global.files.path_lib = lib;
            String ir = c.compileAOI(src, ext);
            // set ir to DB
            sql = "update aoi2source set ir=? where id=?";
            stmt = con.prepareStatement(sql);
            stmt.setString(1, ir);
            stmt.setString(2, id_str);
            stmt.executeUpdate();
            out.print(ir);
        } catch (Exception e) {
            errmsg += e.getMessage();
            out.print("{status:\"error\", messsage:"+escapeStr(errmsg)+"}");
        }
    }
    private String escapeStr(String s) {
        s = KUtils.replaceAll(s, "\\","\\\\");
        s = KUtils.replaceAll(s, "\n","\\n");
        s = KUtils.replaceAll(s, "\"","\\\"");
        return '"' + s + '"';
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
