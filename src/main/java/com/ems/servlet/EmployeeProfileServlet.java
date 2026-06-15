package com.ems.servlet;

import com.ems.dao.EmployeeDAO;
import com.ems.model.Employee;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/employeeProfile")
public class EmployeeProfileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final EmployeeDAO dao = new EmployeeDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        /* ── Session guard: EMPLOYEE only ───────────────────── */
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        if (!"EMPLOYEE".equals(session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/viewEmployees");
            return;
        }

        /* ── Fetch employee data from DB ────────────────────── */
        int empId = (Integer) session.getAttribute("employeeId");

        try {
            Employee emp = dao.getEmployeeById(empId);

            if (emp == null) {
                req.setAttribute("error", "Employee record not found.");
            } else {
                req.setAttribute("employee", emp);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("error", "Database error: " + e.getMessage());
        }

        req.getRequestDispatcher("/employee-profile.jsp").forward(req, resp);
    }
}