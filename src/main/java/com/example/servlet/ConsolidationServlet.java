package com.example.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.example.database.DatabaseConnection;

@WebServlet("/consolidate")
public class ConsolidationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int parentCompanyId = Integer.parseInt(request.getParameter("parent_company_id"));
        Date statementDate = new Date(); // 현재 날짜를 사용하여 연결 재무제표 생성

        try (Connection connection = DatabaseConnection.getConnection()) {
            // 자산, 부채, 자본 합산
        	String sql = "SELECT " +
                    "SUM(CASE WHEN account_type = 'Asset' THEN amount ELSE 0 END) AS total_assets, " +
                    "SUM(CASE WHEN account_type = 'Liability' THEN amount ELSE 0 END) AS total_liabilities, " +
                    "SUM(CASE WHEN account_type = 'Equity' OR account_type = 'Revenue' THEN amount ELSE 0 END) AS total_equity " +
                    "FROM Transactions t JOIN Accounts a ON t.account_id = a.account_id " +
                    "WHERE t.company_id = ? OR t.company_id IN (SELECT company_id FROM Companies WHERE parent_company_id = ?)";


            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, parentCompanyId);
            statement.setInt(2, parentCompanyId);
            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {
                double totalAssets = resultSet.getDouble("total_assets");
                double totalLiabilities = resultSet.getDouble("total_liabilities");
                double totalEquity = resultSet.getDouble("total_equity");

                // 연결 재무제표 저장
                String insertSql = "INSERT INTO ConsolidatedStatements (statement_id, company_id, total_assets, total_liabilities, total_equity, statement_date) VALUES (consolidated_statement_seq.NEXTVAL, ?, ?, ?, ?, ?)";
                PreparedStatement insertStatement = connection.prepareStatement(insertSql);
                insertStatement.setInt(1, parentCompanyId);
                insertStatement.setDouble(2, totalAssets);
                insertStatement.setDouble(3, totalLiabilities);
                insertStatement.setDouble(4, totalEquity);
                insertStatement.setDate(5, new java.sql.Date(statementDate.getTime()));
                insertStatement.executeUpdate();

                response.sendRedirect("viewConsolidatedStatements.jsp");
            } else {
                response.sendRedirect("consolidation.jsp?error=No data found for the given company ID");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("consolidation.jsp?error=" + e.getMessage());
        }
    }
}
