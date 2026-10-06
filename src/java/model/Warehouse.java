/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Timestamp;

/**
 *
 * @author ADMIN
 */
public class Warehouse {
    private String warehouseId;
    private String warehouseCode;
    private String warehouseName;
    private String location;
    private String status;
    private Timestamp createdAt;

    // Thêm cho Admin/Manager dashboard
    private String managerName;
    private int deviceCount;
    private int onlineDeviceCount;
    private int activeBatchCount;

    public Warehouse() {
    }

    // Constructor cũ cho Operator
    public Warehouse(String warehouseId, String warehouseCode,
                     String warehouseName, String location,
                     String status, Timestamp createdAt) {
        this.warehouseId = warehouseId;
        this.warehouseCode = warehouseCode;
        this.warehouseName = warehouseName;
        this.location = location;
        this.status = status;
        this.createdAt = createdAt;
    }

    // Constructor đầy đủ cho Admin/Manager
    public Warehouse(String warehouseId, String warehouseName,
                     String location, String status,
                     String managerName, Timestamp createdAt,
                     int deviceCount, int onlineDeviceCount,
                     int activeBatchCount) {
        this.warehouseId = warehouseId;
        this.warehouseName = warehouseName;
        this.location = location;
        this.status = status;
        this.managerName = managerName;
        this.createdAt = createdAt;
        this.deviceCount = deviceCount;
        this.onlineDeviceCount = onlineDeviceCount;
        this.activeBatchCount = activeBatchCount;
    }

    public String getWarehouseId() {
        return warehouseId;
    }

    public void setWarehouseId(String warehouseId) {
        this.warehouseId = warehouseId;
    }

    // Alias cho JSP
    public String getId() {
        return warehouseId;
    }

    public String getWarehouseCode() {
        return warehouseCode;
    }

    public void setWarehouseCode(String warehouseCode) {
        this.warehouseCode = warehouseCode;
    }

    public String getWarehouseName() {
        return warehouseName;
    }

    public void setWarehouseName(String warehouseName) {
        this.warehouseName = warehouseName;
    }

    // Alias "name" cho NB13 JSP views
    public String getName() {
        return warehouseName;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
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

    public String getManagerName() {
        return managerName;
    }

    public void setManagerName(String managerName) {
        this.managerName = managerName;
    }

    // Alias cho JSP
    public String getManager() {
        return managerName;
    }

    public int getDeviceCount() {
        return deviceCount;
    }

    public void setDeviceCount(int deviceCount) {
        this.deviceCount = deviceCount;
    }

    // Alias
    public int getDevices() {
        return deviceCount;
    }

    public int getOnlineDeviceCount() {
        return onlineDeviceCount;
    }

    public void setOnlineDeviceCount(int onlineDeviceCount) {
        this.onlineDeviceCount = onlineDeviceCount;
    }

    // Alias
    public int getOnline() {
        return onlineDeviceCount;
    }

    public int getActiveBatchCount() {
        return activeBatchCount;
    }

    public void setActiveBatchCount(int activeBatchCount) {
        this.activeBatchCount = activeBatchCount;
    }
}
