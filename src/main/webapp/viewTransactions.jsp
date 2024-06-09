<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.example.database.DatabaseConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>트랜잭션 조회</title>
</head>
<body>
    <h1>트랜잭션 조회</h1>
    <table border="1">
        <tr>
            <th>ID</th>
            <th>회사 ID</th>
            <th>계정 ID</th>
            <th>계정 유형</th>
            <th>금액</th>
            <th>트랜잭션 날짜</th>
            <th>설명</th>
        </tr>
        <%
            Connection connection = null;
            PreparedStatement statement = null;
            ResultSet resultSet = null;
            try {
                connection = DatabaseConnection.getConnection();
                String sql = "SELECT t.transaction_id, t.company_id, t.account_id, a.account_type, t.amount, t.transaction_date, t.description " +
                             "FROM Transactions t, Accounts a " +
                             "WHERE t.account_id = a.account_id " +
                             "ORDER BY t.transaction_id";
                statement = connection.prepareStatement(sql);
                resultSet = statement.executeQuery();
                while (resultSet.next()) {
                    int transactionId = resultSet.getInt("transaction_id");
                    int companyId = resultSet.getInt("company_id");
                    int accountId = resultSet.getInt("account_id");
                    String accountType = resultSet.getString("account_type");
                    double amount = resultSet.getDouble("amount");
                    Date transactionDate = resultSet.getDate("transaction_date");
                    String description = resultSet.getString("description");
        %>
        <tr>
            <td><%= transactionId %></td>
            <td><%= companyId %></td>
            <td><%= accountId %></td>
            <td><%= accountType %></td>
            <td><%= amount %></td>
            <td><%= transactionDate %></td>
            <td><%= description %></td>
        </tr>
        <%
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
