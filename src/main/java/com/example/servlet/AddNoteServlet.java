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

@WebServlet("/addNote")
public class AddNoteServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int companyId = Integer.parseInt(request.getParameter("company_id"));
        String noteDescription = request.getParameter("note_description");
        Date noteDate = new Date(); // 현재 날짜를 사용하여 주석 추가

        try (Connection connection = DatabaseConnection.getConnection()) {
            String sql = "INSERT INTO Notes (note_id, company_id, note_description, note_date) VALUES (note_seq.NEXTVAL, ?, ?, ?)";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, companyId);
            statement.setString(2, noteDescription);
            statement.setDate(3, new java.sql.Date(noteDate.getTime()));

            statement.executeUpdate();
            response.sendRedirect("viewNotes.jsp");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("addNote.jsp?error=" + e.getMessage());
        }
    }
}
