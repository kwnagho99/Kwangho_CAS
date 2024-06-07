package com.example.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.example.database.DatabaseConnection;

@WebServlet("/addRiskDisclosure")
public class AddRiskDisclosureServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int companyId = Integer.parseInt(request.getParameter("company_id"));
        String riskDescription = request.getParameter("risk_description");
        Date disclosureDate = new Date(); // 현재 날짜를 사용하여 리스크 공시

        try (Connection connection = DatabaseConnection.getConnection()) {
            String sql = "INSERT INTO RiskDisclosures (disclosure_id, company_id, risk_description, disclosure_date) VALUES (risk_disclosure_seq.NEXTVAL, ?, ?, ?)";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, companyId);
            statement.setString(2, riskDescription);
            statement.setDate(3, new java.sql.Date(disclosureDate.getTime()));

            statement.executeUpdate();
            response.sendRedirect("viewRiskDisclosures.jsp");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("addRiskDisclosure.jsp?error=" + e.getMessage());
        }
    }
}
