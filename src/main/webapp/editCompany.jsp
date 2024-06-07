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
        String name = "";
        int parentCompanyId = 0;
        
        try {
            connection = DatabaseConnection.getConnection();
            String sql = "SELECT * FROM Companies WHERE company_id = ?";
            statement = connection.prepareStatement(sql);
            statement.setInt(1, companyId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                name = resultSet.getString("name");
                parentCompanyId = resultSet.getInt("parent_company_id");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (resultSet != null) try { resultSet.close(); } catch (SQLException ignore) {}
            if (statement != null) try { statement.close(); } catch (SQLException ignore) {}
            if (connection != null) try { connection.close(); } catch (SQLException ignore) {}
        }
    %>
    <form action="updateCompany" method="post">
        <input type="hidden" name="company_id" value="<%= companyId %>">
        회사명: <input type="text" name="name" value="<%= name %>"><br>
        모회사 ID: <input type="text" name="parent_company_id" value="<%= parentCompanyId != 0 ? parentCompanyId : "" %>"><br>
        <input type="submit" value="회사 수정">
    </form>
</body>
</html>
