package com.ems.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String URL =
            "jdbc:mysql://localhost:3306/employee_db"
            + "?useSSL=false&serverTimezone=Asia/Kolkata&allowPublicKeyRetrieval=true";

    private static final String USER = "root";

    private static final String PASSWORD = "root";

    static {

        try {

            Class.forName("com.mysql.cj.jdbc.Driver");

        } catch (ClassNotFoundException e) {

            throw new ExceptionInInitializerError(
                    "MySQL Driver Not Found : " + e.getMessage());

        }
    }

    public static Connection getConnection()
            throws SQLException {

        return DriverManager.getConnection(
                URL,
                USER,
                PASSWORD);
    }

    private DBConnection() {
    }
}