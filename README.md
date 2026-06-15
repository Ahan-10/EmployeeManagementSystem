# Employee Management System

A web-based Employee Management System developed using Java, JSP, Servlets, MySQL, and Apache Tomcat.

## Features

- Admin Login Authentication
- Employee Management (CRUD)
- Employee Profile Management
- Payslip Generation
- Salary Management
- MySQL Database Integration
- Responsive Dark-Themed UI

## Technologies Used

- Java
- JSP
- Servlets
- JDBC
- MySQL
- Apache Tomcat 9
- HTML
- CSS
- JavaScript

## Project Structure

src/
├── dao/
├── model/
├── servlet/
├── util/

src/main/webapp/
├── login.jsp
├── dashboard.jsp
├── addEmployee.jsp
├── updateEmployee.jsp
├── payslip.jsp

## Database

Database: employee_management

Tables:
- users
- employees

## Screenshots

### Login Page
![Login Page](screenshots/Login%20Page.png)

### Admin Dashboard
![Admin Dashboard](screenshots/Admin%20Dashboard.png)

### Employee Profile
![Employee Profile](screenshots/Employee%20Profile.png)

### Edit Employee
![Edit Employee](screenshots/Edit%20Employee.png)

### Payslip Generation
![Payslip Generation](screenshots/Payslip%20Generation.png)

## Deployment

1. Export project as WAR file
2. Copy WAR file to Tomcat webapps folder
3. Start Apache Tomcat
4. Open:

http://localhost:8080/EmployeeManagementSystem/login

## Author

Ahan Chanda
