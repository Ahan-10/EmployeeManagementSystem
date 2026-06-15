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
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.SQLException;
import java.time.Month;
import java.time.Year;

@WebServlet("/payslip")
public class PayslipServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final EmployeeDAO dao = new EmployeeDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        /* ── Auth check ─────────────────────────────────────── */
        if (session == null || session.getAttribute("username") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String role = (String) session.getAttribute("role");

        /* ── Determine which employee's payslip to show ─────── */
        int empId;
        if ("ADMIN".equals(role)) {
            // Admin passes ?id=X in URL
            String idStr = req.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/viewEmployees");
                return;
            }
            empId = Integer.parseInt(idStr);
        } else {
            // Employee always sees their own
            empId = (Integer) session.getAttribute("employeeId");
        }

        /* ── Month and Year (default = current) ─────────────── */
        int currentYear  = Year.now().getValue();
        int currentMonth = java.time.LocalDate.now().getMonthValue();

        String monthStr = req.getParameter("month");
        String yearStr  = req.getParameter("year");

        int selectedMonth = (monthStr != null && !monthStr.isEmpty())
                ? Integer.parseInt(monthStr) : currentMonth;
        int selectedYear  = (yearStr  != null && !yearStr.isEmpty())
                ? Integer.parseInt(yearStr)  : currentYear;

        /* ── Fetch employee ──────────────────────────────────── */
        try {
            Employee emp = dao.getEmployeeById(empId);
            if (emp == null) {
                resp.sendRedirect(req.getContextPath()
                    + "/viewEmployees?error=Employee+not+found");
                return;
            }

            /* ── Salary calculations ─────────────────────────── */
            BigDecimal gross = emp.getSalary() != null
                    ? emp.getSalary() : BigDecimal.ZERO;

            BigDecimal basic     = pct(gross, 50);  // 50% of gross
            BigDecimal hra       = pct(gross, 20);  // 20% of gross
            BigDecimal da        = pct(gross, 15);  // 15% of gross
            BigDecimal other     = pct(gross, 15);  // 15% of gross
            BigDecimal pf        = pct(basic, 12);  // 12% of basic
            BigDecimal profTax   = new BigDecimal("200.00");
            BigDecimal totalEarnings   = basic.add(hra).add(da).add(other);
            BigDecimal totalDeductions = pf.add(profTax);
            BigDecimal netPay          = totalEarnings.subtract(totalDeductions);

            /* ── Set attributes for JSP ──────────────────────── */
            req.setAttribute("employee",        emp);
            req.setAttribute("selectedMonth",   selectedMonth);
            req.setAttribute("selectedYear",    selectedYear);
            req.setAttribute("monthName",
                Month.of(selectedMonth).name().charAt(0)
                + Month.of(selectedMonth).name().substring(1).toLowerCase());
            req.setAttribute("gross",           gross);
            req.setAttribute("basic",           basic);
            req.setAttribute("hra",             hra);
            req.setAttribute("da",              da);
            req.setAttribute("other",           other);
            req.setAttribute("pf",              pf);
            req.setAttribute("profTax",         profTax);
            req.setAttribute("totalEarnings",   totalEarnings);
            req.setAttribute("totalDeductions", totalDeductions);
            req.setAttribute("netPay",          netPay);
            req.setAttribute("role",            role);
            req.setAttribute("currentYear",     currentYear);

            req.getRequestDispatcher("/payslip.jsp").forward(req, resp);

        } catch (SQLException e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath()
                + "/viewEmployees?error=Database+error");
        }
    }

    /** Returns percentage of a value, rounded to 2 decimal places */
    private BigDecimal pct(BigDecimal value, int percent) {
        return value.multiply(new BigDecimal(percent))
                    .divide(new BigDecimal(100), 2, RoundingMode.HALF_UP);
    }
}