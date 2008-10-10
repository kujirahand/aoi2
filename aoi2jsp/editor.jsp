<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%--
The taglib directive below imports the JSTL library. If you uncomment it,
you must also add the JSTL library to the project. The Add Library... action
on Libraries node in Projects view can be used to add the JSTL 1.1 library.
--%>
<%--
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%> 
--%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html>    
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>葵2エディタ</title>
    <script type="text/javascript" src="js/prototype.js"></script>
    <script type="text/javascript" src="js/swfobject.js"></script>
    <script type="text/javascript" src="js/aoi2link.js?r=2308"></script>
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
        editmode = true;
        function fesc(name) { return encodeURIComponent($F(name)); }
        function aoi2_save() {
            // check
            if ($F("confirm") == "") {
                alert("迷惑防止フィールドが空です。入力してください。"); return;
            }
            if ($F("title") == "") {
                alert("タイトルが空です。入力してください。"); return;
            }
            if ($F("name") == "") {
                var o = $("name"); o.value = "名無し";
            }
            // submit
            Element.hide("save_btn");
            var url = "aoi2save";
            var params = "mode=save";
            params += "&name=" + fesc("name");
            params += "&title=" + fesc("title");
            params += "&comment=" + fesc("comment");
            params += "&source=" + fesc("source");
            params += "&confirm=" + fesc("confirm");
            params += "&password=" + fesc("password");
            params += "&ext=.aoi2";
            if (program_id > 0) {
                params += "&id=" + program_id;
            }
            var ajax = new Ajax.Request(
                url, 
                {
                    method:'post', 
                    parameters:params,
                    onComplete: aoi2_save_onComplete
                }
            );
        }
        function aoi2_save_onComplete(r) {
            Element.show("save_btn");
            var res = r.responseText;
            var obj = eval("(" + res + ")");
            if (obj["status"] == "ok") {
                $("save_message").innerHTML = "保存しました。" + res;
                program_id = obj["id"];
                showLink();
            } else {
                $("save_message").innerHTML = res + "保存できませんでした。" + obj["message"];
            }
        }
        function page_onLoad() {
            if (program_id > 0) {
                aoi2_load();
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
    <h1>葵2エディタ</h1>
    <form method="post">
    <textarea id="source" name="source" rows="8" cols="60">
「こんにちは」と言う。
「挨拶」のボタン作成。
●挨拶イベント
　　「こんにちは」と言う。
    </textarea><br>
    <input type="button" id="run_btn" value="実行" onclick="aoi2_compile()">
    <table><tr><td><div id="msg"></div></td></tr></table>
    <h3 id="prog_title"></h3>
    <div id="swf"></div>
    <div id="link"></div>
    <div id="save_form">
        <hr>
        <h2>プログラムの情報：</h2>
        <table>
            <tr>
                <th>作者名</th>
                <td><input type="text" id="name" name="name" maxlength="40" size="20"></td>
            </tr>
            <tr>
                <th>タイトル</th>
                <td><input type="text" id="title" name="title" maxlength="200" size="20" value="無題"></td>
            </tr>
            <tr>
                <th>コメント</th>
                <td><input type="text" id="comment" name="comment" maxlength="200" size="40"></td>
            </tr>
            <tr>
                <th>パスワード</th>
                <td><input type="password" id="password" name="password" size="10"></td>
            </tr>
            <tr>
                <th>いたずら防止</th>
                <td><input type="text" id="confirm" name="confirm" size="10" value="はな">(「花」を訓読みひらがなで入力)</td>
            </tr>
            <tr>
                <th></th>
                <td><input type="button" id="save_btn" value="保存" onclick="aoi2_save()"></td>
            </tr>
        </table>
        <div id="save_message"></div>
    </div>
    </form>
    
    <%--
    This example uses JSTL, uncomment the taglib directive above.
    To test, display the page like this: index.jsp?sayHello=true&name=Murphy
    --%>
    <%--
    <c:if test="${param.sayHello}">
        <!-- Let's welcome the user ${param.name} -->
        Hello ${param.name}!
    </c:if>
    --%>
    
</body>
</html>
