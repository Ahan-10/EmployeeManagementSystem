<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ems.model.Employee, java.util.List" %>
<%
    if (session.getAttribute("username") == null
            || !"ADMIN".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login"); return;
    }
    Employee emp     = (Employee) request.getAttribute("employee");
    List<String[]> departments = (List<String[]>) request.getAttribute("departments");
    String adminName = (String) session.getAttribute("firstName");
    if (emp == null) {
        response.sendRedirect(request.getContextPath() + "/viewEmployees"); return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Edit Employee — EMS</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
  <link rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>

<header class="topbar">
  <a href="#" class="topbar-logo">EM<span>S</span></a>
  <div class="topbar-spacer"></div>
  <div class="topbar-user">
    <div class="topbar-avatar"><%= adminName != null ? adminName.charAt(0) : "A" %></div>
    <span><%= "" %></span>
    <span class="badge badge-admin">Admin</span>
  </div>
</header>

<aside class="sidebar">
  <p class="sidebar-section">Main</p>
  <a href="<%= request.getContextPath() %>/viewEmployees" class="nav-link active">
    <i class="fas fa-users" aria-hidden="true"></i> Employees
  </a>
  <a href="<%= request.getContextPath() %>/addEmployee" class="nav-link">
    <i class="fas fa-user-plus" aria-hidden="true"></i> Add Employee
  </a>
  <div class="sidebar-footer">
    <a href="<%= request.getContextPath() %>/logout"
       class="btn btn-danger btn-sm" style="width:100%;justify-content:center;">
      <i class="fas fa-sign-out-alt" aria-hidden="true"></i> Sign Out
    </a>
  </div>
</aside>

<main class="main-content">
  <div class="page-header">
    <div>
      <h1 class="page-title">Edit Employee</h1>
      <p class="page-subtitle">Updating record for <strong><%= emp.getFullName() %></strong></p>
    </div>
    <a href="<%= request.getContextPath() %>/viewEmployees" class="btn btn-secondary">
      <i class="fas fa-arrow-left" aria-hidden="true"></i> Back
    </a>
  </div>

  <% String error = (String) request.getAttribute("error");
     if (error != null) { %>
    <div class="alert alert-error">
      <i class="fas fa-exclamation-circle" aria-hidden="true"></i> <%= error %>
    </div>
  <% } %>

  <div class="card">
    <form action="<%= request.getContextPath() %>/updateEmployee" method="post">
      <input type="hidden" name="id" value="<%= emp.getId() %>">
      <div class="form-grid">

        <div class="form-group">
          <label>First Name *</label>
          <input type="text" name="firstName" value="<%= emp.getFirstName() %>" required>
        </div>
        <div class="form-group">
          <label>Last Name *</label>
          <input type="text" name="lastName" value="<%= emp.getLastName() %>" required>
        </div>
        <div class="form-group">
          <label>Email *</label>
          <input type="email" name="email" value="<%= emp.getEmail() %>" required>
        </div>
        <div class="form-group">
          <label>Phone</label>
          <input type="text" name="phone"
                 value="<%= emp.getPhone() != null ? emp.getPhone() : "" %>">
        </div>
        <div class="form-group">
          <label>Department *</label>
          <select name="departmentId" required>
            <% if (departments != null) {
                 for (String[] dep : departments) {
                   boolean selected = Integer.parseInt(dep[0]) == emp.getDepartmentId(); %>
              <option value="<%= dep[0] %>" <%= selected ? "selected" : "" %>>
                <%= dep[1] %>
              </option>
            <% } } %>
          </select>
        </div>
        <div class="form-group">
          <label>Designation</label>
          <input type="text" name="designation"
                 value="<%= emp.getDesignation() != null ? emp.getDesignation() : "" %>">
        </div>
        <div class="form-group">
          <label>Salary (₹)</label>
          <input type="number" name="salary" min="0" step="0.01"
                 value="<%= emp.getSalary() != null ? emp.getSalary().toPlainString() : "0" %>">
        </div>
        <div class="form-group">
          <label>Join Date</label>
          <input type="date" name="joinDate"
                 value="<%= emp.getJoinDate() != null ? emp.getJoinDate().toString() : "" %>">
        </div>
        <div class="form-group">
          <label>Status</label>
          <select name="status">
            <option value="Active"  <%= "Active".equals(emp.getStatus())   ? "selected" : "" %>>Active</option>
            <option value="Inactive"<%= "Inactive".equals(emp.getStatus()) ? "selected" : "" %>>Inactive</option>
          </select>
        </div>

      </div>
      <div class="form-actions">
        <button type="submit" class="btn btn-primary">
          <i class="fas fa-save" aria-hidden="true"></i> Update Employee
        </button>
        <a href="<%= request.getContextPath() %>/viewEmployees" class="btn btn-secondary">
          Cancel
        </a>
      </div>
    </form>
  </div>
</main>
</body>
</html>