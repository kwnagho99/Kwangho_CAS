package com.example.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.example.database.DatabaseConnection;

@WebServlet("/deleteCompany")
public class DeleteCompanyServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect("company.jsp?error=Invalid company ID");
            return;
        }

        int companyId;
        try {
            companyId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.sendRedirect("company.jsp?error=Invalid company ID format");
            return;
        }

        try (Connection connection = DatabaseConnection.getConnection()) {
            // 자식 레코드의 부모 ID를 변경
            String updateParentSql = "UPDATE Companies SET parent_company_id = NULL WHERE parent_company_id = ?";
            try (PreparedStatement updateParentStmt = connection.prepareStatement(updateParentSql)) {
                updateParentStmt.setInt(1, companyId);
                updateParentStmt.executeUpdate();
            }

            // 회사 데이터 삭제
            String deleteCompanySql = "DELETE FROM Companies WHERE company_id = ?";
            try (PreparedStatement deleteCompanyStmt = connection.prepareStatement(deleteCompanySql)) {
                deleteCompanyStmt.setInt(1, companyId);
                int rowsAffected = deleteCompanyStmt.executeUpdate();
                if (rowsAffected > 0) {
                    response.sendRedirect("company.jsp?message=Company deleted successfully");
                } else {
                    response.sendRedirect("company.jsp?error=No company found with the provided ID");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("company.jsp?error=" + e.getMessage());
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
