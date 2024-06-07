<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.example.database.DatabaseConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>리스크 공시 조회</title>
</head>
<body>
    <h1>리스크 공시 조회</h1>
    <table border="1">
        <tr>
            <th>ID</th>
            <th>회사 ID</th>
            <th>리스크 설명</th>
            <th>공시 날짜</th>
        </tr>
        <%
            Connection connection = null;
            PreparedStatement statement = null;
            ResultSet resultSet = null;
            try {
                connection = DatabaseConnection.getConnection();
                String sql = "SELECT * FROM RiskDisclosures";
                statement = connection.prepareStatement(sql);
                resultSet = statement.executeQuery();
                while (resultSet.next()) {
                    int disclosureId = resultSet.getInt("disclosure_id");
                    int companyId = resultSet.getInt("company_id");
                    String riskDescription = resultSet.getString("risk_description");
                    Date disclosureDate = resultSet.getDate("disclosure_date");
        %>
        <tr>
            <td><%= disclosureId %></td>
            <td><%= companyId %></td>
            <td><%= riskDescription %></td>
            <td><%= disclosureDate %></td>
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
