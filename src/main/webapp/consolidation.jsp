<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>연결 재무제표 생성</title>
</head>
<body>
    <h1>연결 재무제표 생성</h1>
    <%
        String error = request.getParameter("error");
        if (error != null && !error.isEmpty()) {
    %>
        <p style="color:red;">오류: <%= error %></p>
    <%
        }
    %>
    <form action="consolidate" method="post">
        모회사 ID: <input type="text" name="parent_company_id"><br>
        <input type="submit" value="연결 재무제표 생성">
    </form>
</body>
</html>
