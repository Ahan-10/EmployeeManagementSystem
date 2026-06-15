<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ems.model.Employee, java.util.List" %>
<%
    /* ═══════════════════════════════════════════════
       SESSION GUARD — ADMIN only
       ═══════════════════════════════════════════════ */
    if (session.getAttribute("username") == null
            || !"ADMIN".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    /* ═══════════════════════════════════════════════
       UNPACK ALL REQUEST ATTRIBUTES HERE
       Declaring every variable at the top prevents
       "cannot be resolved to a variable" JSP errors
       ═══════════════════════════════════════════════ */
    String ctx       = request.getContextPath();
    String adminName = (String) session.getAttribute("firstName");

    List<Employee> employees =
        (List<Employee>) request.getAttribute("employees");

    int total    = 0, active = 0, inactive = 0;
    int currentPage = 1, totalPages = 1;
    String sortBy  = "id";
    String sortDir = "DESC";

    if (request.getAttribute("totalCount")    != null) total      = (int) request.getAttribute("totalCount");
    if (request.getAttribute("activeCount")   != null) active     = (int) request.getAttribute("activeCount");
    if (request.getAttribute("inactiveCount") != null) inactive   = (int) request.getAttribute("inactiveCount");
    if (request.getAttribute("currentPage")   != null) currentPage= (int) request.getAttribute("currentPage");
    if (request.getAttribute("totalPages")    != null) totalPages = (int) request.getAttribute("totalPages");
    if (request.getAttribute("sortBy")        != null) sortBy     = (String) request.getAttribute("sortBy");
    if (request.getAttribute("sortDir")       != null) sortDir    = (String) request.getAttribute("sortDir");

    String flipDir = "ASC".equals(sortDir) ? "DESC" : "ASC";

    String success = (String) request.getAttribute("success");
    String error   = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Admin Dashboard — EMS</title>
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
      <%= adminName != null ? adminName.charAt(0) : "A" %>
    </div>
    
    <span class="badge badge-admin">Admin</span>
  </div>
</header>

<!-- ── Sidebar ─────────────────────────────────────── -->
<aside class="sidebar">
  <p class="sidebar-section">Main</p>
  <a href="<%= ctx %>/viewEmployees" class="nav-link active">
    <i class="fas fa-users" aria-hidden="true"></i> Employees
  </a>
  <a href="<%= ctx %>/addEmployee" class="nav-link">
    <i class="fas fa-user-plus" aria-hidden="true"></i> Add Employee
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
      <h1 class="page-title">Employee Records</h1>
      <p class="page-subtitle">
        Page <%= currentPage %> of <%= totalPages %>
        &nbsp;&mdash;&nbsp;<%= total %> total employees
      </p>
    </div>
    <a href="<%= ctx %>/addEmployee" class="btn btn-primary">
      <i class="fas fa-plus" aria-hidden="true"></i> Add Employee
    </a>
  </div>

  <%-- ── Alerts ──────────────────────────────────── --%>
  <% if (success != null) { %>
    <div class="alert alert-success">
      <i class="fas fa-check-circle" aria-hidden="true"></i> <%= success %>
    </div>
  <% } %>
  <% if (error != null) { %>
    <div class="alert alert-error">
      <i class="fas fa-exclamation-circle" aria-hidden="true"></i> <%= error %>
    </div>
  <% } %>

  <!-- ── Stat cards ─────────────────────────────── -->
  <div class="stats-grid">
    <div class="stat-card">
      <div class="stat-icon blue">
        <i class="fas fa-users" aria-hidden="true"></i>
      </div>
      <div class="stat-label">Total Employees</div>
      <div class="stat-value"><%= total %></div>
    </div>
    <div class="stat-card">
      <div class="stat-icon green">
        <i class="fas fa-user-check" aria-hidden="true"></i>
      </div>
      <div class="stat-label">Active</div>
      <div class="stat-value"><%= active %></div>
    </div>
    <div class="stat-card">
      <div class="stat-icon red">
        <i class="fas fa-user-times" aria-hidden="true"></i>
      </div>
      <div class="stat-label">Inactive</div>
      <div class="stat-value"><%= inactive %></div>
    </div>
  </div>

  <!-- ── Employee table ──────────────────────────── -->
  <div class="card">
    <div class="table-wrap">
      <table>
        <thead>
          <tr>
            <th>#</th>
            <th>
              <a href="<%= ctx %>/viewEmployees?page=1&sortBy=first_name&sortDir=<%= "first_name".equals(sortBy) ? flipDir : "ASC" %>">
                Name <i class="fas <%= "first_name".equals(sortBy) ? ("ASC".equals(sortDir) ? "fa-sort-up" : "fa-sort-down") : "fa-sort" %>" style="<%= "first_name".equals(sortBy) ? "" : "opacity:.35" %>" aria-hidden="true"></i>
              </a>
            </th>
            <th>Email</th>
            <th>
              <a href="<%= ctx %>/viewEmployees?page=1&sortBy=dept_name&sortDir=<%= "dept_name".equals(sortBy) ? flipDir : "ASC" %>">
                Department <i class="fas <%= "dept_name".equals(sortBy) ? ("ASC".equals(sortDir) ? "fa-sort-up" : "fa-sort-down") : "fa-sort" %>" style="<%= "dept_name".equals(sortBy) ? "" : "opacity:.35" %>" aria-hidden="true"></i>
              </a>
            </th>
            <th>
              <a href="<%= ctx %>/viewEmployees?page=1&sortBy=designation&sortDir=<%= "designation".equals(sortBy) ? flipDir : "ASC" %>">
                Designation <i class="fas <%= "designation".equals(sortBy) ? ("ASC".equals(sortDir) ? "fa-sort-up" : "fa-sort-down") : "fa-sort" %>" style="<%= "designation".equals(sortBy) ? "" : "opacity:.35" %>" aria-hidden="true"></i>
              </a>
            </th>
            <th>
              <a href="<%= ctx %>/viewEmployees?page=1&sortBy=salary&sortDir=<%= "salary".equals(sortBy) ? flipDir : "ASC" %>">
                Salary (&#8377;) <i class="fas <%= "salary".equals(sortBy) ? ("ASC".equals(sortDir) ? "fa-sort-up" : "fa-sort-down") : "fa-sort" %>" style="<%= "salary".equals(sortBy) ? "" : "opacity:.35" %>" aria-hidden="true"></i>
              </a>
            </th>
            <th>
              <a href="<%= ctx %>/viewEmployees?page=1&sortBy=status&sortDir=<%= "status".equals(sortBy) ? flipDir : "ASC" %>">
                Status <i class="fas <%= "status".equals(sortBy) ? ("ASC".equals(sortDir) ? "fa-sort-up" : "fa-sort-down") : "fa-sort" %>" style="<%= "status".equals(sortBy) ? "" : "opacity:.35" %>" aria-hidden="true"></i>
              </a>
            </th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <% if (employees == null || employees.isEmpty()) { %>
            <tr>
              <td colspan="8"
                  style="text-align:center;padding:2.5rem;color:var(--text-muted);">
                <i class="fas fa-inbox"
                   style="font-size:2rem;display:block;margin-bottom:.5rem;"
                   aria-hidden="true"></i>
                No employees found.
              </td>
            </tr>
          <% } else {
               for (Employee emp : employees) { %>
            <tr>
              <td class="td-muted">#<%= emp.getId() %></td>
              <td>
                <div style="display:flex;align-items:center;gap:10px;">
                  <div style="width:32px;height:32px;border-radius:50%;
                       background:var(--primary);display:flex;
                       align-items:center;justify-content:center;
                       font-size:12px;font-weight:600;color:#fff;flex-shrink:0;">
                    <%= emp.getFirstName().charAt(0) %><%= emp.getLastName().charAt(0) %>
                  </div>
                  <%= emp.getFullName() %>
                </div>
              </td>
              <td class="td-muted"><%= emp.getEmail() %></td>
              <td><%= emp.getDepartmentName() != null ? emp.getDepartmentName() : "&mdash;" %></td>
              <td class="td-muted"><%= emp.getDesignation() != null ? emp.getDesignation() : "&mdash;" %></td>
              <td><%= emp.getSalary() != null ? emp.getSalary().toPlainString() : "0" %></td>
              <td>
                <span class="badge <%= "Active".equals(emp.getStatus()) ? "badge-active" : "badge-inactive" %>">
                  <%= emp.getStatus() %>
                </span>
              </td>
              <td>
                <div style="display:flex;gap:6px;flex-wrap:nowrap;align-items:center;">
  					<a href="<%= ctx %>/updateEmployee?id=<%= emp.getId() %>"
    					class="btn btn-secondary btn-sm">
    					<i class="fas fa-edit" aria-hidden="true"></i> Edit
  					</a>
  					<a href="<%= ctx %>/payslip?id=<%= emp.getId() %>"
     					class="btn btn-sm"
     					style="background:rgba(29,158,117,.15);color:#5DCAA5;
            				border:1px solid rgba(29,158,117,.3);">
    				<i class="fas fa-file-invoice-dollar" aria-hidden="true"></i> Payslip
  					</a>
  					<a href="<%= ctx %>/deleteEmployee?id=<%= emp.getId() %>"
     					class="btn btn-danger btn-sm"
     					onclick="return confirm('Delete <%= emp.getFullName() %>? This cannot be undone.')">
    					<i class="fas fa-trash" aria-hidden="true"></i>
  					</a>
				</div>
              </td>
            </tr>
          <% } } %>
        </tbody>
      </table>
    </div>

    <!-- Pagination controls -->
    <% if (totalPages > 1) { %>
    <nav class="pagination" aria-label="Employee page navigation">

      <% if (currentPage > 1) { %>
        <a href="<%= ctx %>/viewEmployees?page=<%= (currentPage - 1) %>&sortBy=<%= sortBy %>&sortDir=<%= sortDir %>"
           class="page-btn" aria-label="Previous page">
          <i class="fas fa-chevron-left" aria-hidden="true"></i>
        </a>
      <% } else { %>
        <span class="page-btn disabled">
          <i class="fas fa-chevron-left" aria-hidden="true"></i>
        </span>
      <% } %>

      <%
        int startPage = Math.max(1, currentPage - 2);
        int endPage   = Math.min(totalPages, startPage + 4);
        if ((endPage - startPage) < 4) {
            startPage = Math.max(1, endPage - 4);
        }
        for (int pg = startPage; pg <= endPage; pg++) {
            boolean isCurrent = (pg == currentPage);
            String activeClass = isCurrent ? "page-btn active" : "page-btn";
            String ariaCurrent = isCurrent ? "aria-current='page'" : "";
            String pageUrl = ctx + "/viewEmployees?page=" + pg
                           + "&sortBy=" + sortBy + "&sortDir=" + sortDir;
      %>
        <a href="<%= pageUrl %>" class="<%= activeClass %>" <%= ariaCurrent %>>
          <%= pg %>
        </a>
      <% } %>

      <% if (currentPage < totalPages) { %>
        <a href="<%= ctx %>/viewEmployees?page=<%= (currentPage + 1) %>&sortBy=<%= sortBy %>&sortDir=<%= sortDir %>"
           class="page-btn" aria-label="Next page">
          <i class="fas fa-chevron-right" aria-hidden="true"></i>
        </a>
      <% } else { %>
        <span class="page-btn disabled">
          <i class="fas fa-chevron-right" aria-hidden="true"></i>
        </span>
      <% } %>

    </nav>
    <% } %>

  </div><!-- end .card -->
</main>
</body>
</html>