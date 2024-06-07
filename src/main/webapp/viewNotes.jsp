<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.example.database.DatabaseConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>재무제표 주석 조회</title>
</head>
<body>
    <h1>재무제표 주석 조회</h1>
    <table border="1">
        <tr>
            <th>ID</th>
            <th>회사 ID</th>
            <th>주석 설명</th>
            <th>주석 날짜</th>
        </tr>
        <%
            Connection connection = null;
            PreparedStatement statement = null;
            ResultSet resultSet = null;
            try {
                connection = DatabaseConnection.getConnection();
                String sql = "SELECT * FROM Notes";
                statement = connection.prepareStatement(sql);
                resultSet = statement.executeQuery();
                while (resultSet.next()) {
                    int noteId = resultSet.getInt("note_id");
                    int companyId = resultSet.getInt("company_id");
                    String noteDescription = resultSet.getString("note_description");
                    Date noteDate = resultSet.getDate("note_date");
        %>
        <tr>
            <td><%= noteId %></td>
            <td><%= companyId %></td>
            <td><%= noteDescription %></td>
            <td><%= noteDate %></td>
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
