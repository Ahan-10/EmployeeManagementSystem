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

@WebServlet("/updateEmployee")
public class UpdateServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final EmployeeDAO dao = new EmployeeDAO();

    /* GET — load existing employee into edit form */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isAdmin(req)) { resp.sendRedirect("login"); return; }

        String idStr = req.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            resp.sendRedirect("viewEmployees");
            return;
        }

        try {
            Employee emp = dao.getEmployeeById(Integer.parseInt(idStr));
            if (emp == null) {
                resp.sendRedirect(req.getContextPath()
                    + "/viewEmployees?error=Employee+not+found");
                return;
            }
            req.setAttribute("employee",    emp);
            req.setAttribute("departments", dao.getDepartments());
            req.getRequestDispatcher("/edit-employee.jsp").forward(req, resp);

        } catch (SQLException e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath()
                + "/viewEmployees?error=Database+error");
        }
    }

    /* POST — save changes */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isAdmin(req)) { resp.sendRedirect("login"); return; }

        String idStr       = req.getParameter("id");
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
        if (idStr == null || firstName == null || firstName.trim().isEmpty()
         || lastName == null || lastName.trim().isEmpty()
         || email == null || email.trim().isEmpty()) {

            req.setAttribute("error", "ID, first name, last name and email are required.");
            try {
                req.setAttribute("departments", dao.getDepartments());
                req.setAttribute("employee", dao.getEmployeeById(Integer.parseInt(idStr)));
            } catch (Exception ex) { ex.printStackTrace(); }
            req.getRequestDispatcher("/edit-employee.jsp").forward(req, resp);
            return;
        }

        try {
            Employee emp = new Employee();
            emp.setId(Integer.parseInt(idStr));
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

            boolean ok = dao.updateEmployee(emp);
            if (ok) {
                // Send update notification email
                try {
                    String deptName = deptIdStr; // fallback
                    for (String[] dep : dao.getDepartments()) {
                        if (dep[0].equals(deptIdStr)) { deptName = dep[1]; break; }
                    }
                    EmailUtil.sendUpdateEmail(
                        emp.getEmail(),
                        emp.getFirstName(),
                        deptName,
                        emp.getDesignation() != null ? emp.getDesignation() : "—"
                    );
                } catch (Exception mailEx) {
                    System.err.println("Email failed: " + mailEx.getMessage());
                }
                resp.sendRedirect(req.getContextPath()
                    + "/viewEmployees?success=Employee+updated+and+email+sent");
            }else {
                req.setAttribute("error", "Update failed. Please try again.");
                req.setAttribute("departments", dao.getDepartments());
                req.setAttribute("employee", emp);
                req.getRequestDispatcher("/edit-employee.jsp").forward(req, resp);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("error", "Database error: " + e.getMessage());
            try { req.setAttribute("departments", dao.getDepartments()); }
            catch (SQLException ex) { ex.printStackTrace(); }
            req.getRequestDispatcher("/edit-employee.jsp").forward(req, resp);
        }
    }

    private boolean isAdmin(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        return s != null && "ADMIN".equals(s.getAttribute("role"));
    }
}