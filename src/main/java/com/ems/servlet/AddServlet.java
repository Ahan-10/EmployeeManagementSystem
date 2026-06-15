package com.ems.servlet;

import com.ems.dao.EmployeeDAO;
import com.ems.model.Employee;
import com.ems.util.EmailUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.SQLException;

@WebServlet("/addEmployee")
public class AddServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final EmployeeDAO dao = new EmployeeDAO();

    /* GET — show the blank add form */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isAdmin(req)) { resp.sendRedirect("login"); return; }

        try {
            req.setAttribute("departments", dao.getDepartments());
        } catch (SQLException e) { e.printStackTrace(); }

        req.getRequestDispatcher("/add-employee.jsp").forward(req, resp);
    }

    /* POST — validate + insert */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isAdmin(req)) { resp.sendRedirect("login"); return; }

        String firstName   = req.getParameter("firstName");
        String lastName    = req.getParameter("lastName");
        String email       = req.getParameter("email");
        String phone       = req.getParameter("phone");
        String deptIdStr   = req.getParameter("departmentId");
        String designation = req.getParameter("designation");
        String salaryStr   = req.getParameter("salary");
        String joinDateStr = req.getParameter("joinDate");
        String status      = req.getParameter("status");

        /* ── Validation ─────────────────────────────── */
        if (firstName == null || firstName.trim().isEmpty()
         || lastName  == null || lastName.trim().isEmpty()
         || email     == null || email.trim().isEmpty()
         || deptIdStr == null || deptIdStr.trim().isEmpty()) {

            req.setAttribute("error", "First name, last name, email and department are required.");
            try { req.setAttribute("departments", dao.getDepartments()); }
            catch (SQLException ex) { ex.printStackTrace(); }
            req.getRequestDispatcher("/add-employee.jsp").forward(req, resp);
            return;
        }

        try {
            Employee emp = new Employee();
            emp.setFirstName(firstName.trim());
            emp.setLastName(lastName.trim());
            emp.setEmail(email.trim());
            emp.setPhone(phone != null ? phone.trim() : "");
            emp.setDepartmentId(Integer.parseInt(deptIdStr));
            emp.setDesignation(designation != null ? designation.trim() : "");
            emp.setSalary(salaryStr != null && !salaryStr.isEmpty()
                    ? new BigDecimal(salaryStr) : BigDecimal.ZERO);
            emp.setJoinDate(joinDateStr != null && !joinDateStr.isEmpty()
                    ? Date.valueOf(joinDateStr) : null);
            emp.setStatus(status != null ? status : "Active");

            boolean ok = dao.addEmployee(emp);
            if (ok) {
                // Send welcome email — runs after DB save, failure won't affect redirect
                try {
                    // Fetch dept name for the email (we only have deptId from the form)
                    String deptName = designation; // fallback
                    for (String[] dep : dao.getDepartments()) {
                        if (dep[0].equals(deptIdStr)) { deptName = dep[1]; break; }
                    }
                    EmailUtil.sendWelcomeEmail(
                        emp.getEmail(),
                        emp.getFirstName(),
                        deptName,
                        emp.getDesignation() != null ? emp.getDesignation() : "—"
                    );
                } catch (Exception mailEx) {
                    System.err.println("Email failed: " + mailEx.getMessage());
                }
                resp.sendRedirect(req.getContextPath()
                    + "/viewEmployees?success=Employee+added+and+email+sent");
            } else {
                req.setAttribute("error", "Failed to add employee. Please try again.");
                req.setAttribute("departments", dao.getDepartments());
                req.getRequestDispatcher("/add-employee.jsp").forward(req, resp);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("error", "Database error: " + e.getMessage());
            try { req.setAttribute("departments", dao.getDepartments()); }
            catch (SQLException ex) { ex.printStackTrace(); }
            req.getRequestDispatcher("/add-employee.jsp").forward(req, resp);
        }
    }

    private boolean isAdmin(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        return s != null && "ADMIN".equals(s.getAttribute("role"));
    }
}