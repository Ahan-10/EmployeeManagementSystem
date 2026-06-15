package com.ems.dao;

import com.ems.util.DBConnection;
import com.ems.model.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Data Access Object for the users table.
 * Handles authentication and user retrieval.
 */
public class UserDAO {

    /**
     * Authenticate user by username and password.
     * Returns User object if credentials are valid,
     * otherwise returns null.
     */
    public User authenticate(String username, String password)
            throws SQLException {

        String sql =
                "SELECT u.id, u.username, u.password, u.role, " +
                "u.employee_id, u.is_active, " +
                "e.first_name, e.last_name, e.email " +
                "FROM users u " +
                "LEFT JOIN employees e ON u.employee_id = e.id " +
                "WHERE u.username = ? " +
                "AND u.password = ? " +
                "AND u.is_active = TRUE";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username.trim());
            ps.setString(2, password.trim());

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    User user = new User();

                    user.setId(rs.getInt("id"));
                    user.setUsername(rs.getString("username"));
                    user.setPassword(rs.getString("password"));
                    user.setRole(rs.getString("role"));
                    user.setEmployeeId(rs.getInt("employee_id"));
                    user.setActive(rs.getBoolean("is_active"));

                    user.setFirstName(rs.getString("first_name"));
                    user.setLastName(rs.getString("last_name"));
                    user.setEmail(rs.getString("email"));

                    return user;
                }
            }
        }

        return null;
    }

    /**
     * Find user by username.
     */
    public User findByUsername(String username)
            throws SQLException {

        String sql =
                "SELECT id, username, role, employee_id, is_active " +
                "FROM users " +
                "WHERE username = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username.trim());

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    User user = new User();

                    user.setId(rs.getInt("id"));
                    user.setUsername(rs.getString("username"));
                    user.setRole(rs.getString("role"));
                    user.setEmployeeId(rs.getInt("employee_id"));
                    user.setActive(rs.getBoolean("is_active"));

                    return user;
                }
            }
        }

        return null;
    }
}