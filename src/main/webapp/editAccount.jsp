<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.example.database.DatabaseConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>계정 수정</title>
</head>
<body>
    <h1>계정 수정</h1>
    <%
        int accountId = Integer.parseInt(request.getParameter("id"));
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        String accountName = "";
        String accountType = "";
        int parentAccountId = 0;
        
        try {
            connection = DatabaseConnection.getConnection();
            String sql = "SELECT * FROM Accounts WHERE account_id = ?";
            statement = connection.prepareStatement(sql);
            statement.setInt(1, accountId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                accountName = resultSet.getString("account_name");
                accountType = resultSet.getString("account_type");
                parentAccountId = resultSet.getInt("parent_account_id");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (resultSet != null) try { resultSet.close(); } catch (SQLException ignore) {}
            if (statement != null) try { statement.close(); } catch (SQLException ignore) {}
            if (connection != null) try { connection.close(); } catch (SQLException ignore) {}
        }
    %>
    <form action="updateAccount" method="post">
        <input type="hidden" name="account_id" value="<%= accountId %>">
        계정명: <input type="text" name="account_name" value="<%= accountName %>"><br>
        계정 유형: <input type="text" name="account_type" value="<%= accountType %>"><br>
        상위 계정 ID: <input type="text" name="parent_account_id" value="<%= parentAccountId != 0 ? parentAccountId : "" %>"><br>
        <input type="submit" value="계정 수정">
    </form>
</body>
</html>
