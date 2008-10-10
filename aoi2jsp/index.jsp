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
        <title>AOI Editor</title>
    </head>
    <body>

    <h1>Link</h1>
    <a href="aoi2show.jsp?id=20">aoi2show.jsp?id=20</a> |
    <a href="editor.jsp">editor.jsp</a> |
    
    <a href="test.a">test.a</a>
    <a href="test.aoi2">test.aoi2</a>
    <form action="aoi2ir" method="POST">
        <textarea name="source" rows=13 cols=80></textarea>
        <input type="hidden" name="ext" value=".aoi2">
        <input type="submit" value="compile"/>
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
