<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.example.database.DatabaseConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>계정 관리</title>
</head>
<body>
    <h1>계정 관리</h1>
    <form action="addAccount" method="post">
        계정명: <input type="text" name="account_name"><br>
        계정 유형: <input type="text" name="account_type"><br>
        상위 계정 ID: <input type="text" name="parent_account_id"><br>
        <input type="submit" value="계정 추가">
    </form>

    <%
        String error = request.getParameter("error");
        if (error != null && !error.isEmpty()) {
    %>
        <p style="color:red;">오류: <%= error %></p>
    <%
        }
    %>

    <h2>계정 목록</h2>
    <table border="1">
        <tr>
            <th>ID</th>
            <th>계정명</th>
            <th>계정 유형</th>
            <th>상위 계정 ID</th>
            <th>수정</th>
            <th>삭제</th>
        </tr>
        <%
            Connection connection = null;
            PreparedStatement statement = null;
            ResultSet resultSet = null;
            try {
                connection = DatabaseConnection.getConnection();
                String sql = "SELECT * FROM Accounts ORDER BY account_type, NVL(parent_account_id, account_id), account_id";
                statement = connection.prepareStatement(sql);
                resultSet = statement.executeQuery();
                if (!resultSet.isBeforeFirst()) {
                    %>
                    <tr>
                        <td colspan="5">계정이 없습니다.</td>
                    </tr>
                    <%
                } else {
                    while (resultSet.next()) {
                        int accountId = resultSet.getInt("account_id");
                        String accountName = resultSet.getString("account_name");
                        String accountType = resultSet.getString("account_type");
                        int parentAccountId = resultSet.getInt("parent_account_id");
        %>
        <tr>
            <td><%= accountId %></td>
            <td><%= accountName %></td>
            <td><%= accountType %></td>
            <td><%= parentAccountId != 0 ? parentAccountId : "N/A" %></td>
            <td><a href="editAccount.jsp?id=<%= accountId %>">수정</a></td>
            <td><a href="deleteAccount?id=<%= accountId %>" onclick="return confirm('정말로 삭제하시겠습니까?');">삭제</a></td>
        </tr>
        <%
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (resultSet != null) try { resultSet.close(); } catch (SQLException ignore) {}
                if (statement != null) try { statement.close(); } catch (SQLException ignore) {}
                if (connection != null) try { connection.close(); } catch (SQLException ignore) {}
            }
        %>
    </table>
</body>
</html>
