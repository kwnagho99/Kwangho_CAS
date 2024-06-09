<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.example.database.DatabaseConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>회사 수정</title>
</head>
<body>
    <h1>회사 수정</h1>
    <%
        String id = request.getParameter("id");
        if (id == null || id.isEmpty()) {
            out.println("<p>오류: 유효한 회사 ID가 제공되지 않았습니다.</p>");
        } else {
            Connection connection = null;
            PreparedStatement statement = null;
            ResultSet resultSet = null;
            try {
                connection = DatabaseConnection.getConnection();
                String sql = "SELECT * FROM Companies WHERE company_id = ?";
                statement = connection.prepareStatement(sql);
                statement.setInt(1, Integer.parseInt(id));
                resultSet = statement.executeQuery();
                if (resultSet.next()) {
                    String name = resultSet.getString("name");
                    int parentCompanyId = resultSet.getInt("parent_company_id");
    %>
    <form action="updateCompany" method="post">
        <input type="hidden" name="company_id" value="<%= id %>">
        회사명: <input type="text" name="name" value="<%= name %>"><br>
        모회사 ID: <input type="text" name="parent_company_id" value="<%= parentCompanyId != 0 ? parentCompanyId : "" %>"><br>
        <input type="submit" value="회사 수정">
    </form>
    <%
                } else {
                    out.println("<p>오류: 해당 ID를 가진 회사를 찾을 수 없습니다.</p>");
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (resultSet != null) try { resultSet.close(); } catch (SQLException ignore) {}
                if (statement != null) try { statement.close(); } catch (SQLException ignore) {}
                if (connection != null) try { connection.close(); } catch (SQLException ignore) {}
            }
        }
    %>
</body>
</html>
