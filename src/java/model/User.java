/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author ADMIN
 */


import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class User {

    private String userId;
    private String username;
    private String password;
    private String fullName;
    private String role;
    private String status;
    private Timestamp createdAt;

    // Quan hệ USER_WAREHOUSE (cho Admin quản lý)
    private List<String> warehouseIds;
    private List<String> warehouseNames;

    public User() {
        warehouseIds = new ArrayList<String>();
        warehouseNames = new ArrayList<String>();
    }

    public User(String userId, String username, String password,
                String fullName, String role, String status,
                Timestamp createdAt) {
        this.userId = userId;
        this.username = username;
        this.password = password;
        this.fullName = fullName;
        this.role = role;
        this.status = status;
        this.createdAt = createdAt;
        warehouseIds = new ArrayList<String>();
        warehouseNames = new ArrayList<String>();
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    // Alias cho JSP
    public String getId() {
        return userId;
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

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public boolean isActive() {
        return "ACTIVE".equalsIgnoreCase(status);
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public List<String> getWarehouseIds() {
        return warehouseIds;
    }

    public void setWarehouseIds(List<String> warehouseIds) {
        this.warehouseIds = warehouseIds;
    }

    public List<String> getWarehouseNames() {
        return warehouseNames;
    }

    public void setWarehouseNames(List<String> warehouseNames) {
        this.warehouseNames = warehouseNames;
    }
}
