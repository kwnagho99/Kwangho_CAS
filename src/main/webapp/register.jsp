<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>회원가입</title>
</head>
<body>
    <h1>회원가입</h1>
    <form action="register" method="post">
        사용자명: <input type="text" name="username"><br>
        비밀번호: <input type="password" name="password"><br>
        역할: <input type="text" name="role"><br>
        <input type="submit" value="회원가입">
    </form>
</body>
</html>
