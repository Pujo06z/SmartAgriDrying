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

    public Device() {
    }

    public Device(String deviceId, String warehouseId, String deviceCode, String deviceName, String mode, String roofStatus, Timestamp lastSeen, String status) {
        this.deviceId = deviceId;
        this.warehouseId = warehouseId;
        this.deviceCode = deviceCode;
        this.deviceName = deviceName;
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
    
    
}
