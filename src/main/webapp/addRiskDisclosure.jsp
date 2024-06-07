<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>리스크 공시 입력</title>
</head>
<body>
    <h1>리스크 공시 입력</h1>
    <%
        String error = request.getParameter("error");
        if (error != null && !error.isEmpty()) {
    %>
        <p style="color:red;">오류: <%= error %></p>
    <%
        }
    %>
    <form action="addRiskDisclosure" method="post">
        회사 ID: <input type="text" name="company_id"><br>
        리스크 설명: <input type="text" name="risk_description"><br>
        <input type="submit" value="리스크 공시 추가">
    </form>
</body>
</html>
