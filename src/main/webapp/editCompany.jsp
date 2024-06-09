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
        int companyId = Integer.parseInt(request.getParameter("id"));
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        try {
            connection = DatabaseConnection.getConnection();
            String sql = "SELECT * FROM Companies WHERE company_id = ?";
            statement = connection.prepareStatement(sql);
            statement.setInt(1, companyId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                String companyName = resultSet.getString("company_name");
                int parentCompanyId = resultSet.getInt("parent_company_id");
    %>
    <form action="updateCompany" method="post">
        <input type="hidden" name="company_id" value="<%= companyId %>">
        회사명: <input type="text" name="company_name" value="<%= companyName %>"><br>
        모회사 ID: <input type="text" name="parent_company_id" value="<%= parentCompanyId != 0 ? parentCompanyId : "N/A" %>"><br>
        <input type="submit" value="수정">
    </form>
    <%
            } else {
    %>
    <p style="color:red;">해당 ID를 가진 회사가 없습니다.</p>
    <%
            }
        } catch (Exception e) {
            e.printStackTrace();
    %>
    <p style="color:red;">오류: <%= e.getMessage() %></p>
    <%
        } finally {
            if (resultSet != null) try { resultSet.close(); } catch (SQLException ignore) {}
            if (statement != null) try { statement.close(); } catch (SQLException ignore) {}
            if (connection != null) try { connection.close(); } catch (SQLException ignore) {}
        }
    %>
</body>
</html>
