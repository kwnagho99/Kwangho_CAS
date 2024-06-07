package com.example.database;

import java.sql.Connection;
import java.sql.SQLException;

public class TestDatabaseConnection {
    public static void main(String[] args) {
        try {
            Connection connection = DatabaseConnection.getConnection();
            if (connection != null) {
                System.out.println("데이터베이스 연결 성공!");
                connection.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
