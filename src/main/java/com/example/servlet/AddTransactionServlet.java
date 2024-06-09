package com.example.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.example.database.DatabaseConnection;

@WebServlet("/addTransaction")
public class AddTransactionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	request.setCharacterEncoding("UTF-8");
        int companyId = Integer.parseInt(request.getParameter("company_id"));
        int accountId = Integer.parseInt(request.getParameter("account_id"));
        double amount = Double.parseDouble(request.getParameter("amount"));
        String transactionDateStr = request.getParameter("transaction_date");
        String description = request.getParameter("description");

        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        Date transactionDate = null;
        try {
            transactionDate = dateFormat.parse(transactionDateStr);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("addTransaction.jsp?error=Invalid date format");
            return;
        }

        // 부모 키 존재 여부 확인
        try (Connection connection = DatabaseConnection.getConnection()) {
            String checkCompanySql = "SELECT company_id FROM Companies WHERE company_id = ?";
            PreparedStatement checkCompanyStatement = connection.prepareStatement(checkCompanySql);
            checkCompanyStatement.setInt(1, companyId);
            ResultSet companyResultSet = checkCompanyStatement.executeQuery();
            if (!companyResultSet.next()) {
                response.sendRedirect("addTransaction.jsp?error=Invalid company ID");
                return;
            }

            String checkAccountSql = "SELECT account_id FROM Accounts WHERE account_id = ?";
            PreparedStatement checkAccountStatement = connection.prepareStatement(checkAccountSql);
            checkAccountStatement.setInt(1, accountId);
            ResultSet accountResultSet = checkAccountStatement.executeQuery();
            if (!accountResultSet.next()) {
                response.sendRedirect("addTransaction.jsp?error=Invalid account ID");
                return;
            }

            // 트랜잭션 삽입
            String sql = "INSERT INTO Transactions (transaction_id, company_id, account_id, amount, transaction_date, description) VALUES (transaction_seq.NEXTVAL, ?, ?, ?, ?, ?)";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, companyId);
            statement.setInt(2, accountId);
            statement.setDouble(3, amount);
            statement.setDate(4, new java.sql.Date(transactionDate.getTime()));
            statement.setString(5, description);

            statement.executeUpdate();
            response.sendRedirect("viewTransactions.jsp");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("addTransaction.jsp?error=" + e.getMessage());
        }
    }
}
