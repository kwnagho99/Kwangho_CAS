<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>트랜잭션 입력</title>
</head>
<body>
    <h1>트랜잭션 입력</h1>
    <%
        String error = request.getParameter("error");
        if (error != null && !error.isEmpty()) {
    %>
        <p style="color:red;">오류: <%= error %></p>
    <%
        }
    %>
    <form action="addTransaction" method="post">
        회사 ID: <input type="text" name="company_id"><br>
        계정 ID: <input type="text" name="account_id"><br>
        금액: <input type="text" name="amount"><br>
        트랜잭션 날짜: <input type="date" name="transaction_date"><br>
        설명: <input type="text" name="description"><br>
        <input type="submit" value="트랜잭션 추가">
    </form>
</body>
</html>
