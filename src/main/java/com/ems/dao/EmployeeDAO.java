package com.ems.dao;

import com.ems.util.DBConnection;
import com.ems.model.Employee;
import java.sql.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * All SQL for the employees table lives here.
 * Servlets call these methods — zero SQL in servlets.
 *
 * Methods:
 *  - getAllEmployees()       → full list, no paging (used internally)
 *  - getEmployeesPaged()    → paginated + sorted (used by ViewServlet)
 *  - getEmployeeById()      → single record (used by UpdateServlet GET)
 *  - addEmployee()          → INSERT
 *  - updateEmployee()       → UPDATE
 *  - deleteEmployee()       → DELETE
 *  - getTotalCount()        → total rows (for pagination + stat card)
 *  - getActiveCount()       → active rows (for stat card)
 *  - getDepartments()       → dropdown data
 *  - mapRow()               → private ResultSet → Employee mapper
 */
public class EmployeeDAO {

    /* ══════════════════════════════════════════════════════
       WHITELIST — only these column names allowed in ORDER BY
       Prevents SQL injection since ORDER BY can't use ?
       ══════════════════════════════════════════════════════ */
    private static final Set<String> ALLOWED_SORT = new HashSet<>(Arrays.asList(
        "first_name", "last_name", "email",
        "dept_name",  "designation", "salary",
        "join_date",  "status", "id"
    ));

    /* ══════════════════════════════════════════════════════
       READ — ALL (no pagination, used for exports if needed)
       ══════════════════════════════════════════════════════ */
    public List<Employee> getAllEmployees() throws SQLException {
        List<Employee> list = new ArrayList<>();
        String sql = "SELECT e.*, d.name AS dept_name "
                   + "FROM employees e "
                   + "LEFT JOIN departments d ON e.department_id = d.id "
                   + "ORDER BY e.id DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    /* ══════════════════════════════════════════════════════
       READ — PAGED + SORTED (used by ViewEmployeeServlet)
       ══════════════════════════════════════════════════════ */
    public List<Employee> getEmployeesPaged(
            String sortBy, String sortDir,
            int limit,     int offset) throws SQLException {

        // Sanitise sort column — fall back to "id" if invalid
        String col = ALLOWED_SORT.contains(sortBy) ? sortBy : "id";
        // Sanitise direction — only ASC or DESC allowed
        String dir = "DESC".equalsIgnoreCase(sortDir) ? "DESC" : "ASC";

        // NOTE: col and dir are safe — whitelisted above, NOT from raw user input
        String sql = "SELECT e.*, d.name AS dept_name "
                   + "FROM employees e "
                   + "LEFT JOIN departments d ON e.department_id = d.id "
                   + "ORDER BY " + col + " " + dir + " "
                   + "LIMIT ? OFFSET ?";

        List<Employee> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ps.setInt(2, offset);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        }
        return list;
    }

    /* ══════════════════════════════════════════════════════
       READ — SINGLE (used by UpdateServlet GET)
       ══════════════════════════════════════════════════════ */
    public Employee getEmployeeById(int id) throws SQLException {
        String sql = "SELECT e.*, d.name AS dept_name "
                   + "FROM employees e "
                   + "LEFT JOIN departments d ON e.department_id = d.id "
                   + "WHERE e.id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        }
        return null;
    }

    /* ══════════════════════════════════════════════════════
       CREATE
       ══════════════════════════════════════════════════════ */
    public boolean addEmployee(Employee emp) throws SQLException {
        String sql = "INSERT INTO employees "
                   + "(first_name, last_name, email, phone, "
                   + " department_id, designation, salary, join_date, status) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, emp.getFirstName());
            ps.setString(2, emp.getLastName());
            ps.setString(3, emp.getEmail());
            ps.setString(4, emp.getPhone());
            ps.setInt   (5, emp.getDepartmentId());
            ps.setString(6, emp.getDesignation());
            ps.setBigDecimal(7, emp.getSalary());
            ps.setDate  (8, emp.getJoinDate());
            ps.setString(9, emp.getStatus());
            return ps.executeUpdate() > 0;
        }
    }

    /* ══════════════════════════════════════════════════════
       UPDATE
       ══════════════════════════════════════════════════════ */
    public boolean updateEmployee(Employee emp) throws SQLException {
        String sql = "UPDATE employees SET "
                   + "first_name=?, last_name=?, email=?, phone=?, "
                   + "department_id=?, designation=?, salary=?, "
                   + "join_date=?, status=? "
                   + "WHERE id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, emp.getFirstName());
            ps.setString(2, emp.getLastName());
            ps.setString(3, emp.getEmail());
            ps.setString(4, emp.getPhone());
            ps.setInt   (5, emp.getDepartmentId());
            ps.setString(6, emp.getDesignation());
            ps.setBigDecimal(7, emp.getSalary());
            ps.setDate  (8, emp.getJoinDate());
            ps.setString(9, emp.getStatus());
            ps.setInt   (10, emp.getId());
            return ps.executeUpdate() > 0;
        }
    }

    /* ══════════════════════════════════════════════════════
       DELETE
       ══════════════════════════════════════════════════════ */
    public boolean deleteEmployee(int id) throws SQLException {
        String sql = "DELETE FROM employees WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    /* ══════════════════════════════════════════════════════
       COUNT — TOTAL (pagination + stat card)
       ══════════════════════════════════════════════════════ */
    public int getTotalCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM employees";
        try (Connection con = DBConnection.getConnection();
             Statement  st  = con.createStatement();
             ResultSet  rs  = st.executeQuery(sql)) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    /* ══════════════════════════════════════════════════════
       COUNT — ACTIVE (stat card)
       ══════════════════════════════════════════════════════ */
    public int getActiveCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM employees WHERE status = 'Active'";
        try (Connection con = DBConnection.getConnection();
             Statement  st  = con.createStatement();
             ResultSet  rs  = st.executeQuery(sql)) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    /* ══════════════════════════════════════════════════════
       DEPARTMENTS — for Add / Edit dropdowns
       ══════════════════════════════════════════════════════ */
    public List<String[]> getDepartments() throws SQLException {
        List<String[]> deps = new ArrayList<>();
        String sql = "SELECT id, name FROM departments ORDER BY name";
        try (Connection con = DBConnection.getConnection();
             Statement  st  = con.createStatement();
             ResultSet  rs  = st.executeQuery(sql)) {
            while (rs.next())
                deps.add(new String[]{ rs.getString("id"), rs.getString("name") });
        }
        return deps;
    }

    /* ══════════════════════════════════════════════════════
       PRIVATE — ResultSet row → Employee object
       ══════════════════════════════════════════════════════ */
    private Employee mapRow(ResultSet rs) throws SQLException {
        Employee e = new Employee();
        e.setId(rs.getInt("id"));
        e.setFirstName(rs.getString("first_name"));
        e.setLastName(rs.getString("last_name"));
        e.setEmail(rs.getString("email"));
        e.setPhone(rs.getString("phone"));
        e.setDepartmentId(rs.getInt("department_id"));
        e.setDepartmentName(rs.getString("dept_name"));
        e.setDesignation(rs.getString("designation"));
        e.setSalary(rs.getBigDecimal("salary"));
        e.setJoinDate(rs.getDate("join_date"));
        e.setStatus(rs.getString("status"));
        return e;
    }

}