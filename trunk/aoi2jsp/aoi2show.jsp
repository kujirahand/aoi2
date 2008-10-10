<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">
<html>    
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>葵2プログラム</title>
    <script type="text/javascript" src="js/prototype.js"></script>
    <script type="text/javascript" src="js/swfobject.js"></script>
    <script type="text/javascript" src="js/aoi2link.js"></script>
    <script type="text/javascript"><!--
        <%
            String id = request.getParameter("id");
            if (id == null || id.length() == 0) {
                out.print("program_id = -1;");
            } else {
                // load source
                try {
                    int pid = Integer.valueOf(id).intValue();
                    id = String.valueOf(pid);
                } catch (Exception e) {
                    id = "-1";
                }
                out.print("program_id = " + id + ";");
            }
        %>
        editmode = false;
        function page_onLoad() {
            if (program_id > 0) {
                aoi2_load();
                var edit_url = "editor.jsp?id=" + program_id;
                $("edit_link").innerHTML = "<a href='"+edit_url+"'>&gt;編集</a>";
            } else {
                Element.hide("save_form");
            }
        }
        window.addEventListener("load", page_onLoad, false);
    -->
    </script>
</head>
    
<body>
    <center>
    <div id="test"></div>
    <h1 id="prog_title">葵2エディタ</h1>
    <textarea id="source" style="display:none"></textarea>
    <input type="button" id="run_btn" style="display:none">
    <div id="msg"></div>
    <div id="swf"></div>
    <div id="link"></div>
    <div id="save_form">
        <h3>プログラムの情報：</h3>
        <input type="hidden" name="mode" value="save">
        <table>
            <tr>
                <th>作者名</th>
                <td><input type="text" id="name" name="name" maxlength="40" size="20"></td>
            </tr>
            <tr>
                <th>タイトル</th>
                <td><input type="text" id="title" name="title" maxlength="200" size="20"></td>
            </tr>
            <tr>
                <th>コメント</th>
                <td><input type="text" id="comment" name="comment" maxlength="200" size="40"></td>
            </tr>
            <tr>
                <th></th>
                <td><div id="edit_link"></div></td>
            </tr>
        </table>
        <div id="save_message"></div>
    </div>
        
</body>
</html>
