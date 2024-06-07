package com.example.database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {
    private static final String URL = "jdbc:oracle:thin:@119.196.227.241:1521:xe"; // URL 형식은 환경에 따라 다를 수 있음
    private static final String USER = "c##kwangho"; // Oracle 데이터베이스 사용자명
    private static final String PASSWORD = "0219"; // Oracle 데이터베이스 비밀번호

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("oracle.jdbc.OracleDriver"); // 드라이버 클래스 이름이 변경되었습니다.
        } catch (ClassNotFoundException e) {
            throw new SQLException("Oracle JDBC Driver not found", e);
        }
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
