<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.example.database.DatabaseConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>연결 재무제표 조회</title>
</head>
<body>
    <h1>연결 재무제표 조회</h1>
    <table border="1">
        <tr>
            <th>ID</th>
            <th>회사 ID</th>
            <th>총 자산</th>
            <th>총 부채</th>
            <th>총 자본</th>
            <th>생성 날짜</th>
        </tr>
        <%
            Connection connection = null;
            PreparedStatement statement = null;
            ResultSet resultSet = null;
            try {
                connection = DatabaseConnection.getConnection();
                String sql = "SELECT * FROM ConsolidatedStatements";
                statement = connection.prepareStatement(sql);
                resultSet = statement.executeQuery();
                while (resultSet.next()) {
                    int statementId = resultSet.getInt("statement_id");
                    int companyId = resultSet.getInt("company_id");
                    double totalAssets = resultSet.getDouble("total_assets");
                    double totalLiabilities = resultSet.getDouble("total_liabilities");
                    double totalEquity = resultSet.getDouble("total_equity");
                    Date statementDate = resultSet.getDate("statement_date");
        %>
        <tr>
            <td><%= statementId %></td>
            <td><%= companyId %></td>
            <td><%= totalAssets %></td>
            <td><%= totalLiabilities %></td>
            <td><%= totalEquity %></td>
            <td><%= statementDate %></td>
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
