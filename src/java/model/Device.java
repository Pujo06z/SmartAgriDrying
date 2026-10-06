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
public class Device {
    private String deviceId;
    private String warehouseId;
    private String deviceCode;
    private String deviceName;
    private String mode;
    private String roofStatus;
    private Timestamp lastSeen;
    private String status;

    // Thêm cho Admin/Manager views
    private String warehouseName;

    public Device() {
    }

    // Constructor cũ cho Operator
    public Device(String deviceId, String warehouseId,
                  String deviceCode, String deviceName,
                  String mode, String roofStatus,
                  Timestamp lastSeen, String status) {
        this.deviceId = deviceId;
        this.warehouseId = warehouseId;
        this.deviceCode = deviceCode;
        this.deviceName = deviceName;
        this.mode = mode;
        this.roofStatus = roofStatus;
        this.lastSeen = lastSeen;
        this.status = status;
    }

    // Constructor đầy đủ cho Admin/Manager
    public Device(String deviceId, String deviceCode,
                  String deviceName, String warehouseId,
                  String warehouseName, String mode,
                  String roofStatus, Timestamp lastSeen,
                  String status) {
        this.deviceId = deviceId;
        this.deviceCode = deviceCode;
        this.deviceName = deviceName;
        this.warehouseId = warehouseId;
        this.warehouseName = warehouseName;
        this.mode = mode;
        this.roofStatus = roofStatus;
        this.lastSeen = lastSeen;
        this.status = status;
    }

    public String getDeviceId() {
        return deviceId;
    }

    public void setDeviceId(String deviceId) {
        this.deviceId = deviceId;
    }

    // Alias cho JSP
    public String getId() {
        return deviceId;
    }

    public String getWarehouseId() {
        return warehouseId;
    }

    public void setWarehouseId(String warehouseId) {
        this.warehouseId = warehouseId;
    }

    public String getDeviceCode() {
        return deviceCode;
    }

    public void setDeviceCode(String deviceCode) {
        this.deviceCode = deviceCode;
    }

    public String getDeviceName() {
        return deviceName;
    }

    public void setDeviceName(String deviceName) {
        this.deviceName = deviceName;
    }

    // Alias cho JSP
    public String getName() {
        return deviceName;
    }

    public String getMode() {
        return mode;
    }

    public void setMode(String mode) {
        this.mode = mode;
    }

    public String getRoofStatus() {
        return roofStatus;
    }

    public void setRoofStatus(String roofStatus) {
        this.roofStatus = roofStatus;
    }

    // Alias
    public String getRoof() {
        return roofStatus;
    }

    public Timestamp getLastSeen() {
        return lastSeen;
    }

    public void setLastSeen(Timestamp lastSeen) {
        this.lastSeen = lastSeen;
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

    public String getWarehouseName() {
        return warehouseName;
    }

    public void setWarehouseName(String warehouseName) {
        this.warehouseName = warehouseName;
    }

    public boolean isOnline() {
        if (lastSeen == null) {
            return false;
        }
        long diff = System.currentTimeMillis() - lastSeen.getTime();
        return diff <= 30000;
    }

    public String getConnectionStatus() {
        return isOnline() ? "ONLINE" : "OFFLINE";
    }
}
