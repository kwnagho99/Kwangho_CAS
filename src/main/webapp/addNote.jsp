<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>재무제표 주석 입력</title>
</head>
<body>
    <h1>재무제표 주석 입력</h1>
    <%
        String error = request.getParameter("error");
        if (error != null && !error.isEmpty()) {
    %>
        <p style="color:red;">오류: <%= error %></p>
    <%
        }
    %>
    <form action="addNote" method="post">
        회사 ID: <input type="text" name="company_id"><br>
        주석 설명: <input type="text" name="note_description"><br>
        <input type="submit" value="주석 추가">
    </form>
</body>
</html>
