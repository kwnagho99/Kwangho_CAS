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

@WebServlet("/updateAccount")
public class UpdateAccountServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int accountId = Integer.parseInt(request.getParameter("account_id"));
        String accountName = request.getParameter("account_name");
        String accountType = request.getParameter("account_type");
        String parentAccountIdStr = request.getParameter("parent_account_id");
        Integer parentAccountId = null;

        if (parentAccountIdStr != null && !parentAccountIdStr.isEmpty()) {
            try {
                parentAccountId = Integer.valueOf(parentAccountIdStr);

                // 부모 계정 ID 존재 여부 확인
                try (Connection connection = DatabaseConnection.getConnection()) {
                    String checkParentSql = "SELECT account_id FROM Accounts WHERE account_id = ?";
                    PreparedStatement checkParentStatement = connection.prepareStatement(checkParentSql);
                    checkParentStatement.setInt(1, parentAccountId);
                    ResultSet resultSet = checkParentStatement.executeQuery();
                    if (!resultSet.next()) {
                        response.sendRedirect("editAccount.jsp?id=" + accountId + "&error=Parent account ID does not exist");
                        return;
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                    response.sendRedirect("editAccount.jsp?id=" + accountId + "&error=" + e.getMessage());
                    return;
                }

            } catch (NumberFormatException e) {
                response.sendRedirect("editAccount.jsp?id=" + accountId + "&error=Invalid parent account ID");
                return;
            }
        }

        try (Connection connection = DatabaseConnection.getConnection()) {
            String sql = "UPDATE Accounts SET account_name = ?, account_type = ?, parent_account_id = ? WHERE account_id = ?";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setString(1, accountName);
            statement.setString(2, accountType);
            if (parentAccountId != null) {
                statement.setInt(3, parentAccountId);
            } else {
                statement.setNull(3, java.sql.Types.INTEGER);
            }
            statement.setInt(4, accountId);

            statement.executeUpdate();
            response.sendRedirect("account.jsp");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("editAccount.jsp?id=" + accountId + "&error=" + e.getMessage());
        }
    }
}
