package com.ems.model;

/**
 * POJO representing a row in the users table.
 */
public class User {

    private int id;
    private String username;
    private String password;
    private String role;
    private int employeeId;
    private boolean active;

    private String firstName;
    private String lastName;
    private String email;

    public User() {
    }

    public User(int id,
                String username,
                String password,
                String role,
                int employeeId,
                boolean active) {

        this.id = id;
        this.username = username;
        this.password = password;
        this.role = role;
        this.employeeId = employeeId;
        this.active = active;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public int getEmployeeId() {
        return employeeId;
    }

    public void setEmployeeId(int employeeId) {
        this.employeeId = employeeId;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getFullName() {

        if (firstName == null || firstName.trim().isEmpty()) {
            return username;
        }

        return firstName + " " + lastName;
    }

    public boolean isAdmin() {

        return role != null &&
               role.equalsIgnoreCase("ADMIN");
    }

    public boolean isEmployee() {

        return role != null &&
               role.equalsIgnoreCase("EMPLOYEE");
    }

    @Override
    public String toString() {

        return "User{id=" + id
                + ", username=" + username
                + ", role=" + role
                + ", active=" + active
                + "}";
    }
}