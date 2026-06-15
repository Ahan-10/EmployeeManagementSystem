<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ems.model.Employee" %>
<%
    /* ═══════════════════════════════════════════════
       SESSION GUARD — EMPLOYEE only
       ═══════════════════════════════════════════════ */
    if (session.getAttribute("username") == null
            || !"EMPLOYEE".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String ctx       = request.getContextPath();
    String firstName = (String) session.getAttribute("firstName");
    String lastName  = (String) session.getAttribute("lastName");

    /* Employee object set by EmployeeProfileServlet */
    Employee emp = (Employee) request.getAttribute("employee");
    String error = (String)   request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>My Profile — EMS</title>
  <link rel="stylesheet" href="<%= ctx %>/css/style.css">
  <link rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>

<!-- ── Topbar ─────────────────────────────────────── -->
<header class="topbar">
  <a href="#" class="topbar-logo">EM<span>S</span></a>
  <div class="topbar-spacer"></div>
  <div class="topbar-user">
    <div class="topbar-avatar">
      <%= firstName != null ? firstName.charAt(0) : "?" %><%= lastName != null ? lastName.charAt(0) : "" %>
    </div>
    <span><%= firstName %> <%= lastName %></span>
    <span class="badge badge-employee">Employee</span>
  </div>
</header>

<!-- ── Sidebar ─────────────────────────────────────── -->
<aside class="sidebar">
  <p class="sidebar-section">Portal</p>
  <a href="<%= ctx %>/employeeProfile" class="nav-link active">
    <i class="fas fa-user" aria-hidden="true"></i> My Profile
  </a>
  <!-- ✅ NEW: Payslip link in sidebar -->
  <a href="<%= ctx %>/payslip" class="nav-link">
    <i class="fas fa-file-invoice-dollar" aria-hidden="true"></i> My Payslip
  </a>
  <div class="sidebar-footer">
    <a href="<%= ctx %>/logout"
       class="btn btn-danger btn-sm"
       style="width:100%;justify-content:center;">
      <i class="fas fa-sign-out-alt" aria-hidden="true"></i> Sign Out
    </a>
  </div>
</aside>

<!-- ── Main content ───────────────────────────────── -->
<main class="main-content">

  <div class="page-header">
    <div>
      <h1 class="page-title">My Profile</h1>
      <p class="page-subtitle">Your personal and employment details</p>
    </div>
    <!-- ✅ NEW: View Payslip button in page header -->
    <a href="<%= ctx %>/payslip" class="btn btn-primary">
      <i class="fas fa-file-invoice-dollar" aria-hidden="true"></i>
      View My Payslip
    </a>
  </div>

  <%-- Error alert --%>
  <% if (error != null) { %>
    <div class="alert alert-error">
      <i class="fas fa-exclamation-circle" aria-hidden="true"></i> <%= error %>
    </div>
  <% } %>

  <% if (emp != null) { %>

  <!-- ── Profile hero card ──────────────────────── -->
  <div class="card" style="margin-bottom:1.5rem;">
    <div class="profile-hero">
      <div class="profile-avatar">
        <%= emp.getFirstName().charAt(0) %><%= emp.getLastName().charAt(0) %>
      </div>
      <div>
        <div class="profile-name"><%= emp.getFullName() %></div>
        <div class="profile-role">
          <%= emp.getDesignation() != null ? emp.getDesignation() : "" %>
          &mdash;
          <%= emp.getDepartmentName() != null ? emp.getDepartmentName() : "" %>
        </div>
        <div style="margin-top:8px;display:flex;align-items:center;gap:10px;flex-wrap:wrap;">
          <span class="badge <%= "Active".equals(emp.getStatus()) ? "badge-active" : "badge-inactive" %>">
            <i class="fas fa-circle" style="font-size:7px;" aria-hidden="true"></i>
            <%= emp.getStatus() %>
          </span>
          <!-- ✅ NEW: Quick payslip button inside hero -->
          <a href="<%= ctx %>/payslip"
             style="font-size:12px;color:#5DCAA5;text-decoration:none;
                    display:inline-flex;align-items:center;gap:5px;">
            <i class="fas fa-file-invoice-dollar" aria-hidden="true"></i>
            View Payslip
          </a>
        </div>
      </div>
    </div>
  </div>

  <!-- ── Employment details grid ────────────────── -->
  <div class="card">
    <p style="font-size:13px;font-weight:600;color:var(--text-muted);
              text-transform:uppercase;letter-spacing:.06em;margin-bottom:1.25rem;">
      Employment Details
    </p>
    <div class="info-grid">
      <div class="info-item">
        <label><i class="fas fa-id-badge" aria-hidden="true"></i> Employee ID</label>
        <p>EMS-<%= String.format("%04d", emp.getId()) %></p>
      </div>
      <div class="info-item">
        <label><i class="fas fa-envelope" aria-hidden="true"></i> Email</label>
        <p><%= emp.getEmail() %></p>
      </div>
      <div class="info-item">
        <label><i class="fas fa-phone" aria-hidden="true"></i> Phone</label>
        <p><%= emp.getPhone() != null ? emp.getPhone() : "&mdash;" %></p>
      </div>
      <div class="info-item">
        <label><i class="fas fa-building" aria-hidden="true"></i> Department</label>
        <p><%= emp.getDepartmentName() != null ? emp.getDepartmentName() : "&mdash;" %></p>
      </div>
      <div class="info-item">
        <label><i class="fas fa-briefcase" aria-hidden="true"></i> Designation</label>
        <p><%= emp.getDesignation() != null ? emp.getDesignation() : "&mdash;" %></p>
      </div>
      <div class="info-item">
        <label><i class="fas fa-rupee-sign" aria-hidden="true"></i> Salary</label>
        <p>&#8377; <%= emp.getSalary() != null ? emp.getSalary().toPlainString() : "0.00" %></p>
      </div>
      <div class="info-item">
        <label><i class="fas fa-calendar-alt" aria-hidden="true"></i> Joined</label>
        <p><%= emp.getJoinDate() != null ? emp.getJoinDate().toString() : "&mdash;" %></p>
      </div>
      <div class="info-item">
        <label><i class="fas fa-toggle-on" aria-hidden="true"></i> Status</label>
        <p>
          <span class="badge <%= "Active".equals(emp.getStatus()) ? "badge-active" : "badge-inactive" %>">
            <%= emp.getStatus() %>
          </span>
        </p>
      </div>
    </div>

    <!-- ✅ NEW: Payslip CTA at bottom of details card -->
    <div style="margin-top:1.5rem;padding-top:1.25rem;
                border-top:1px solid var(--border);
                display:flex;align-items:center;
                justify-content:space-between;flex-wrap:wrap;gap:1rem;">
      <div>
        <p style="font-size:13px;font-weight:500;color:var(--text-main);margin:0">
          Need your payslip?
        </p>
        <p style="font-size:12px;color:var(--text-muted);margin:3px 0 0">
          View, print or save as PDF for any month
        </p>
      </div>
      <a href="<%= ctx %>/payslip" class="btn btn-primary">
        <i class="fas fa-file-invoice-dollar" aria-hidden="true"></i>
        Generate Payslip
      </a>
    </div>

  </div><!-- end card -->

  <% } %>

</main>
</body>
</html>