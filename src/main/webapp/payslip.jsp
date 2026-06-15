<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ems.model.Employee, java.math.BigDecimal" %>
<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect(request.getContextPath() + "/login"); return;
    }
	String firstName = (String) session.getAttribute("firstName");
	String lastName  = (String) session.getAttribute("lastName");

	if(firstName == null || firstName.trim().isEmpty()){
    	firstName = "User";
	}

	if(lastName == null){
    	lastName = "";
	}
    String ctx    = request.getContextPath();
    String role   = (String) request.getAttribute("role");
    Employee emp  = (Employee) request.getAttribute("employee");
    int selMonth  = (Integer) request.getAttribute("selectedMonth");
    int selYear   = (Integer) request.getAttribute("selectedYear");
    int curYear   = (Integer) request.getAttribute("currentYear");
    String monthName     = (String)     request.getAttribute("monthName");
    BigDecimal gross     = (BigDecimal) request.getAttribute("gross");
    BigDecimal basic     = (BigDecimal) request.getAttribute("basic");
    BigDecimal hra       = (BigDecimal) request.getAttribute("hra");
    BigDecimal da        = (BigDecimal) request.getAttribute("da");
    BigDecimal other     = (BigDecimal) request.getAttribute("other");
    BigDecimal pf        = (BigDecimal) request.getAttribute("pf");
    BigDecimal profTax   = (BigDecimal) request.getAttribute("profTax");
    BigDecimal totalEarn = (BigDecimal) request.getAttribute("totalEarnings");
    BigDecimal totalDed  = (BigDecimal) request.getAttribute("totalDeductions");
    BigDecimal netPay    = (BigDecimal) request.getAttribute("netPay");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Payslip — <%= emp.getFullName() %></title>
  <link rel="stylesheet" href="<%= ctx %>/css/style.css">
  <link rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>

<!-- ── Topbar (hidden on print) ───────────────────── -->
<header class="topbar no-print">
  <a href="#" class="topbar-logo">EM<span>S</span></a>
  <div class="topbar-spacer"></div>
  <div class="topbar-user">
    <div class="topbar-avatar">
        <%= firstName.charAt(0) %>
    </div>

    <span><%= firstName %> <%= lastName %></span>
</div>
</header>

<!-- ── Sidebar (hidden on print) ─────────────────── -->
<aside class="sidebar no-print">
  <p class="sidebar-section">Main</p>
  <% if ("ADMIN".equals(role)) { %>
    <a href="<%= ctx %>/viewEmployees" class="nav-link active">
      <i class="fas fa-users" aria-hidden="true"></i> Employees
    </a>
    <a href="<%= ctx %>/addEmployee" class="nav-link">
      <i class="fas fa-user-plus" aria-hidden="true"></i> Add Employee
    </a>
  <% } else { %>
    <a href="<%= ctx %>/employeeProfile" class="nav-link">
      <i class="fas fa-user" aria-hidden="true"></i> My Profile
    </a>
    <a href="<%= ctx %>/payslip" class="nav-link active">
      <i class="fas fa-file-invoice-dollar" aria-hidden="true"></i> My Payslip
    </a>
  <% } %>
  <div class="sidebar-footer">
    <a href="<%= ctx %>/logout"
       class="btn btn-danger btn-sm" style="width:100%;justify-content:center;">
      <i class="fas fa-sign-out-alt" aria-hidden="true"></i> Sign Out
    </a>
  </div>
</aside>

<!-- ── Main content ───────────────────────────────── -->
<main class="main-content">

  <!-- Page header + actions (hidden on print) -->
  <div class="page-header no-print">
    <div>
      <h1 class="page-title">Payslip</h1>
      <p class="page-subtitle"><%= emp.getFullName() %> &mdash; <%= monthName %> <%= selYear %></p>
    </div>
    <div style="display:flex;gap:10px;flex-wrap:wrap;">
      <% if ("ADMIN".equals(role)) { %>
        <a href="<%= ctx %>/viewEmployees" class="btn btn-secondary">
          <i class="fas fa-arrow-left" aria-hidden="true"></i> Back
        </a>
      <% } else { %>
        <a href="<%= ctx %>/employeeProfile" class="btn btn-secondary">
          <i class="fas fa-arrow-left" aria-hidden="true"></i> Back
        </a>
      <% } %>
      <button onclick="window.print()" class="btn btn-primary">
        <i class="fas fa-print" aria-hidden="true"></i> Print / Save PDF
      </button>
    </div>
  </div>

  <!-- Month/Year selector (hidden on print) -->
  <div class="card no-print" style="margin-bottom:1.5rem;">
    <form method="get" action="<%= ctx %>/payslip"
          style="display:flex;gap:1rem;align-items:flex-end;flex-wrap:wrap;">
      <% if ("ADMIN".equals(role)) { %>
        <input type="hidden" name="id" value="<%= emp.getId() %>">
      <% } %>
      <div class="form-group" style="margin:0;">
        <label>Month</label>
        <select name="month" style="min-width:140px;">
          <% String[] months = {"January","February","March","April","May","June",
                                "July","August","September","October","November","December"};
             for (int m = 1; m <= 12; m++) { %>
            <option value="<%= m %>" <%= m == selMonth ? "selected" : "" %>>
              <%= months[m-1] %>
            </option>
          <% } %>
        </select>
      </div>
      <div class="form-group" style="margin:0;">
        <label>Year</label>
        <select name="year" style="min-width:100px;">
          <% for (int y = curYear; y >= curYear - 4; y--) { %>
            <option value="<%= y %>" <%= y == selYear ? "selected" : "" %>>
              <%= y %>
            </option>
          <% } %>
        </select>
      </div>
      <button type="submit" class="btn btn-primary">
        <i class="fas fa-search" aria-hidden="true"></i> Generate
      </button>
    </form>
  </div>

  <!-- ══════════════════════════════════════════════
       PRINTABLE PAYSLIP — this section prints
       ══════════════════════════════════════════════ -->
  <div class="payslip-paper">

    <!-- Header -->
    <div class="payslip-header">
      <div>
        <div class="payslip-company">Employee Management System</div>
        <div class="payslip-company-sub">Human Resources Department</div>
      </div>
      <div class="payslip-title-block">
        <div class="payslip-title">PAYSLIP</div>
        <div class="payslip-period"><%= monthName %> <%= selYear %></div>
      </div>
    </div>

    <div class="payslip-divider"></div>

    <!-- Employee details -->
    <div class="payslip-emp-grid">
      <div class="payslip-emp-item">
        <span class="ps-label">Employee Name</span>
        <span class="ps-value"><%= emp.getFullName() %></span>
      </div>
      <div class="payslip-emp-item">
        <span class="ps-label">Employee ID</span>
        <span class="ps-value">EMS-<%= String.format("%04d", emp.getId()) %></span>
      </div>
      <div class="payslip-emp-item">
        <span class="ps-label">Designation</span>
        <span class="ps-value"><%= emp.getDesignation() != null ? emp.getDesignation() : "—" %></span>
      </div>
      <div class="payslip-emp-item">
        <span class="ps-label">Department</span>
        <span class="ps-value"><%= emp.getDepartmentName() != null ? emp.getDepartmentName() : "—" %></span>
      </div>
      <div class="payslip-emp-item">
        <span class="ps-label">Email</span>
        <span class="ps-value"><%= emp.getEmail() %></span>
      </div>
      <div class="payslip-emp-item">
        <span class="ps-label">Pay Period</span>
        <span class="ps-value"><%= monthName %> <%= selYear %></span>
      </div>
    </div>

    <div class="payslip-divider"></div>

    <!-- Earnings and Deductions table -->
    <div class="payslip-table-wrap">
      <table class="payslip-table">
        <thead>
          <tr>
            <th colspan="2">Earnings</th>
            <th colspan="2">Deductions</th>
          </tr>
          <tr class="payslip-sub-head">
            <th>Component</th>
            <th>Amount (₹)</th>
            <th>Component</th>
            <th>Amount (₹)</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>Basic Salary <span class="ps-pct">(50%)</span></td>
            <td class="ps-amt"><%= basic.toPlainString() %></td>
            <td>Provident Fund <span class="ps-pct">(12% of Basic)</span></td>
            <td class="ps-amt"><%= pf.toPlainString() %></td>
          </tr>
          <tr>
            <td>HRA <span class="ps-pct">(20%)</span></td>
            <td class="ps-amt"><%= hra.toPlainString() %></td>
            <td>Professional Tax</td>
            <td class="ps-amt"><%= profTax.toPlainString() %></td>
          </tr>
          <tr>
            <td>Dearness Allowance <span class="ps-pct">(15%)</span></td>
            <td class="ps-amt"><%= da.toPlainString() %></td>
            <td></td><td></td>
          </tr>
          <tr>
            <td>Other Allowances <span class="ps-pct">(15%)</span></td>
            <td class="ps-amt"><%= other.toPlainString() %></td>
            <td></td><td></td>
          </tr>
        </tbody>
        <tfoot>
          <tr class="payslip-total-row">
            <td>Total Earnings</td>
            <td class="ps-amt"><%= totalEarn.toPlainString() %></td>
            <td>Total Deductions</td>
            <td class="ps-amt"><%= totalDed.toPlainString() %></td>
          </tr>
        </tfoot>
      </table>
    </div>

    <!-- Net Pay -->
    <div class="payslip-net">
      <span class="payslip-net-label">Net Pay for <%= monthName %> <%= selYear %></span>
      <span class="payslip-net-value">&#8377; <%= netPay.toPlainString() %></span>
    </div>

    <!-- Footer -->
    <div class="payslip-footer">
      <div>
        <div class="ps-sign-line"></div>
        <div class="ps-sign-label">Employee Signature</div>
      </div>
      <div>
        <p class="payslip-note">
          This is a computer-generated payslip and does not require a physical signature.
        </p>
      </div>
      <div>
        <div class="ps-sign-line"></div>
        <div class="ps-sign-label">Authorized Signatory</div>
      </div>
    </div>

  </div><!-- end payslip-paper -->
</main>
</body>
</html>