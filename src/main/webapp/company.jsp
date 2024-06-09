<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.example.database.DatabaseConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>회사 관리</title>
</head>
<body>
    <h1>회사 관리</h1>
    <form action="addCompany" method="post">
        회사명: <input type="text" name="name"><br>
        모회사 ID: <input type="text" name="parent_company_id"><br>
        <input type="submit" value="회사 추가">
    </form>

    <%
        String error = request.getParameter("error");
        if (error != null && !error.isEmpty()) {
    %>
        <p style="color:red;">오류: <%= error %></p>
    <%
        }
    %>

    <h2>회사 목록</h2>
    <table border="1">
        <tr>
            <th>ID</th>
            <th>회사명</th>
            <th>모회사 ID</th>
            <th>수정</th>
            <th>삭제</th>
        </tr>
        <%
            Connection connection = null;
            PreparedStatement statement = null;
            ResultSet resultSet = null;
            try {
                connection = DatabaseConnection.getConnection();
                String sql = "SELECT * FROM Companies ORDER BY company_id";
                statement = connection.prepareStatement(sql);
                resultSet = statement.executeQuery();
                if (!resultSet.isBeforeFirst()) {
                    %>
                    <tr>
                        <td colspan="5">회사가 없습니다.</td>
                    </tr>
                    <%
                } else {
                    while (resultSet.next()) {
                        int companyId = resultSet.getInt("company_id");
                        String name = resultSet.getString("name");
                        int parentCompanyId = resultSet.getInt("parent_company_id");
        %>
        <tr>
            <td><%= companyId %></td>
            <td><%= name %></td>
            <td><%= parentCompanyId != 0 ? parentCompanyId : "N/A" %></td>
            <td><a href="editCompany.jsp?id=<%= companyId %>">수정</a></td>
            <td><a href="deleteCompany?id=<%= companyId %>" onclick="return confirm('정말로 삭제하시겠습니까?');">삭제</a></td>
        </tr>
        <%
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<p style='color:red;'>데이터를 조회하는 동안 오류가 발생했습니다.</p>");
            } finally {
                if (resultSet != null) try { resultSet.close(); } catch (SQLException ignore) {}
                if (statement != null) try { statement.close(); } catch (SQLException ignore) {}
                if (connection != null) try { connection.close(); } catch (SQLException ignore) {}
            }
        %>
    </table>
</body>
</html>
