package com.ems.servlet;

import com.ems.dao.UserDAO;
import com.ems.model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final UserDAO userDAO = new UserDAO();

    /* ── GET: show the login page ───────────────────────────────
       Called when browser visits /login for the first time.
       If already logged in, redirect straight to the right page.
    ───────────────────────────────────────────────────────────── */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // If user already has a valid session, skip login page
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("username") != null) {
            redirectByRole((String) session.getAttribute("role"), req, resp);
            return;
        }

        // Show the login page
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    /* ── POST: authenticate and redirect ───────────────────────
       Called when the login form is submitted.
    ───────────────────────────────────────────────────────────── */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        // Basic input validation
        if (username == null || username.trim().isEmpty()
                || password == null || password.trim().isEmpty()) {
            req.setAttribute("error", "Username and password are required.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        try {
            User user = userDAO.authenticate(username.trim(), password);

            if (user != null) {
                // ── Login success: create session ──────────────
                HttpSession session = req.getSession(true);
                session.setAttribute("userId",     user.getId());
                session.setAttribute("username",   user.getUsername());
                session.setAttribute("role",       user.getRole());
                session.setAttribute("employeeId", user.getEmployeeId());
                session.setAttribute("firstName",  user.getFirstName());
                session.setAttribute("lastName",   user.getLastName());
                session.setAttribute("email",      user.getEmail());
                session.setMaxInactiveInterval(30 * 60); // 30 minutes

                redirectByRole(user.getRole(), req, resp);

            } else {
                // ── Login failed ───────────────────────────────
                req.setAttribute("error", "Invalid username or password.");
                req.getRequestDispatcher("/login.jsp").forward(req, resp);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("error", "Database error. Please try again.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }
    }

    /* ── Helper: redirect based on role ────────────────────────
       ADMIN      → /viewEmployees  (admin dashboard)
       EMPLOYEE   → /employeeProfile (employee profile page)
    ───────────────────────────────────────────────────────────── */
    private void redirectByRole(String role,
                                HttpServletRequest req,
                                HttpServletResponse resp)
            throws IOException {
        if ("ADMIN".equals(role)) {
            resp.sendRedirect(req.getContextPath() + "/viewEmployees");
        } else {
            resp.sendRedirect(req.getContextPath() + "/employeeProfile");
        }
    }
}