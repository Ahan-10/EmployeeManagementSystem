package com.ems.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        /* 1. Grab existing session — don't create a new one */
        HttpSession session = req.getSession(false);

        /* 2. Invalidate it — wipes ALL session attributes */
        if (session != null) {
            session.invalidate();
        }

        /* 3. Prevent browser back-button from showing cached pages */
        resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        resp.setHeader("Pragma",        "no-cache");
        resp.setDateHeader("Expires",   0);

        /* 4. Redirect to login */
        resp.sendRedirect(req.getContextPath() + "/login");
    }

    /* Also handle POST logout (e.g. from a form button) */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }
}