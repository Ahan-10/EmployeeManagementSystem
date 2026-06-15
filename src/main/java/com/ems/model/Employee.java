package com.ems.model;

import java.math.BigDecimal;
import java.sql.Date;

/**
 * POJO representing a row in the employees table.
 * Used to transfer data between servlets and JSPs.
 */
public class Employee {

    private int       id;
    private String    firstName;
    private String    lastName;
    private String    email;
    private String    phone;
    private int       departmentId;
    private String    departmentName;  // joined from departments table
    private String    designation;
    private BigDecimal salary;
    private Date      joinDate;
    private String    status;          // "Active" | "Inactive"

    // ── Constructors ────────────────────────────────────────────

    public Employee() {}

    public Employee(int id, String firstName, String lastName,
                    String email, String phone, int departmentId,
                    String departmentName, String designation,
                    BigDecimal salary, Date joinDate, String status) {
        this.id             = id;
        this.firstName      = firstName;
        this.lastName       = lastName;
        this.email          = email;
        this.phone          = phone;
        this.departmentId   = departmentId;
        this.departmentName = departmentName;
        this.designation    = designation;
        this.salary         = salary;
        this.joinDate       = joinDate;
        this.status         = status;
    }

    // ── Getters & Setters ────────────────────────────────────────

    public int        getId()              { return id; }
    public void       setId(int id)        { this.id = id; }

    public String     getFirstName()       { return firstName; }
    public void       setFirstName(String firstName) { this.firstName = firstName; }

    public String     getLastName()        { return lastName; }
    public void       setLastName(String lastName)   { this.lastName = lastName; }

    public String     getFullName()        { return firstName + " " + lastName; }

    public String     getEmail()           { return email; }
    public void       setEmail(String email)         { this.email = email; }

    public String     getPhone()           { return phone; }
    public void       setPhone(String phone)         { this.phone = phone; }

    public int        getDepartmentId()    { return departmentId; }
    public void       setDepartmentId(int departmentId) {
                        this.departmentId = departmentId; }

    public String     getDepartmentName()  { return departmentName; }
    public void       setDepartmentName(String departmentName) {
                        this.departmentName = departmentName; }

    public String     getDesignation()     { return designation; }
    public void       setDesignation(String designation) {
                        this.designation = designation; }

    public BigDecimal getSalary()          { return salary; }
    public void       setSalary(BigDecimal salary)   { this.salary = salary; }

    public Date       getJoinDate()        { return joinDate; }
    public void       setJoinDate(Date joinDate)     { this.joinDate = joinDate; }

    public String     getStatus()          { return status; }
    public void       setStatus(String status)       { this.status = status; }

    @Override
    public String toString() {
        return "Employee{id=" + id + ", name=" + getFullName() +
               ", email=" + email + ", dept=" + departmentName +
               ", status=" + status + "}";
    }
}