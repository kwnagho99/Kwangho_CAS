package com.example.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.example.database.DatabaseConnection;

@WebServlet("/addCompany")
public class AddCompanyServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String parentCompanyIdStr = request.getParameter("parent_company_id");
        Integer parentCompanyId = null;

        if (parentCompanyIdStr != null && !parentCompanyIdStr.isEmpty()) {
            try {
                parentCompanyId = Integer.valueOf(parentCompanyIdStr);

                // 부모 회사 ID 존재 여부 확인
                try (Connection connection = DatabaseConnection.getConnection()) {
                    String checkParentSql = "SELECT company_id FROM Companies WHERE company_id = ?";
                    PreparedStatement checkParentStatement = connection.prepareStatement(checkParentSql);
                    checkParentStatement.setInt(1, parentCompanyId);
                    ResultSet resultSet = checkParentStatement.executeQuery();
                    if (!resultSet.next()) {
                        response.sendRedirect("company.jsp?error=Parent company ID does not exist");
                        return;
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                    response.sendRedirect("company.jsp?error=" + e.getMessage());
                    return;
                }

            } catch (NumberFormatException e) {
                response.sendRedirect("company.jsp?error=Invalid parent company ID");
                return;
            }
        }

        try (Connection connection = DatabaseConnection.getConnection()) {
            String sql = "INSERT INTO Companies (company_id, name, parent_company_id) VALUES (company_seq.NEXTVAL, ?, ?)";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setString(1, name);
            if (parentCompanyId != null) {
                statement.setInt(2, parentCompanyId);
            } else {
                statement.setNull(2, java.sql.Types.INTEGER);
            }

            statement.executeUpdate();
            response.sendRedirect("company.jsp");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("company.jsp?error=" + e.getMessage());
        }
    }
}
