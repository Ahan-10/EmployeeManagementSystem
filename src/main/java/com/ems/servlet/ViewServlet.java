package com.ems.servlet;

import com.ems.dao.EmployeeDAO;
import com.ems.model.Employee;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/viewEmployees")
public class ViewServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final EmployeeDAO dao = new EmployeeDAO();

    private static final int PAGE_SIZE = 5; // rows per page

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isAdmin(req)) { resp.sendRedirect("login"); return; }

        /* ── 1. Read + sanitise URL parameters ──────────────── */
        int    page    = parseIntParam(req.getParameter("page"),    1);
        String sortBy  = req.getParameter("sortBy");
        String sortDir = req.getParameter("sortDir");

        if (page < 1) page = 1;
        if (sortBy  == null || sortBy.trim().isEmpty())  sortBy  = "id";
        if (sortDir == null || sortDir.trim().isEmpty()) sortDir = "DESC";
        // Flip direction if same column clicked again — handled in JSP link logic

        /* ── 2. Compute offset ───────────────────────────────── */
        int offset = (page - 1) * PAGE_SIZE;

        try {
            /* ── 3. Fetch one page from DB ───────────────────── */
            List<Employee> employees =
                dao.getEmployeesPaged(sortBy, sortDir, PAGE_SIZE, offset);

            /* ── 4. Stats ────────────────────────────────────── */
            int total    = dao.getTotalCount();
            int active   = dao.getActiveCount();
            int inactive = total - active;
            int totalPages = (int) Math.ceil((double) total / PAGE_SIZE);
            if (totalPages < 1) totalPages = 1;

            /* ── 5. Pass everything to JSP ───────────────────── */
            req.setAttribute("employees",    employees);
            req.setAttribute("totalCount",   total);
            req.setAttribute("activeCount",  active);
            req.setAttribute("inactiveCount",inactive);
            req.setAttribute("currentPage",  page);
            req.setAttribute("totalPages",   totalPages);
            req.setAttribute("sortBy",       sortBy);
            req.setAttribute("sortDir",      sortDir);

            // Pass through flash messages from redirects
            String success = req.getParameter("success");
            String error   = req.getParameter("error");
            if (success != null) req.setAttribute("success", success);
            if (error   != null) req.setAttribute("error",   error);

        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("error", "Failed to load employees: " + e.getMessage());
        }

        req.getRequestDispatcher("/admin-dashboard.jsp").forward(req, resp);
    }

    /* ── Helpers ─────────────────────────────────────────────── */
    private int parseIntParam(String val, int defaultVal) {
        try { return Integer.parseInt(val); }
        catch (NumberFormatException | NullPointerException e) { return defaultVal; }
    }

    private boolean isAdmin(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        return s != null && "ADMIN".equals(s.getAttribute("role"));
    }
}