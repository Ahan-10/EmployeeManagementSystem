package com.ems.servlet;

import com.ems.dao.EmployeeDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/deleteEmployee")
public class DeleteServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final EmployeeDAO dao = new EmployeeDAO();

    /* DELETE is triggered via GET from a confirm link/button */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isAdmin(req)) { resp.sendRedirect("login"); return; }

        String idStr = req.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/viewEmployees");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);
            boolean ok = dao.deleteEmployee(id);
            if (ok) {
                resp.sendRedirect(req.getContextPath()
                    + "/viewEmployees?success=Employee+deleted+successfully");
            } else {
                resp.sendRedirect(req.getContextPath()
                    + "/viewEmployees?error=Employee+not+found");
            }

        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath()
                + "/viewEmployees?error=Invalid+employee+ID");
        } catch (SQLException e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath()
                + "/viewEmployees?error=Database+error+during+delete");
        }
    }

    private boolean isAdmin(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        return s != null && "ADMIN".equals(s.getAttribute("role"));
    }
}
