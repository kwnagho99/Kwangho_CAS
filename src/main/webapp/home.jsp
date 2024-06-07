<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>홈</title>
</head>
<body>
    <h1>환영합니다, <%= session.getAttribute("username") %>!</h1>
    <a href="logout">로그아웃</a>
</body>
</html>
