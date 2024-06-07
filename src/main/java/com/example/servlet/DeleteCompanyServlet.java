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
        int companyId = Integer.parseInt(request.getParameter("id"));

        try (Connection connection = DatabaseConnection.getConnection()) {
            String sql = "DELETE FROM Companies WHERE company_id = ?";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, companyId);

            statement.executeUpdate();
            response.sendRedirect("company.jsp");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("company.jsp?error=" + e.getMessage());
        }
    }
}
