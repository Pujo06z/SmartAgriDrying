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
public class EventLog {

    private long eventId;
    private String warehouseName;
    private String deviceCode;
    private String eventType;
    private String description;
    private Timestamp createdAt;

    public EventLog() {
    }

    public EventLog(long eventId, String warehouseName,
                    String deviceCode, String eventType,
                    String description, Timestamp createdAt) {
        this.eventId = eventId;
        this.warehouseName = warehouseName;
        this.deviceCode = deviceCode;
        this.eventType = eventType;
        this.description = description;
        this.createdAt = createdAt;
    }

    public long getEventId() {
        return eventId;
    }

    public String getWarehouseName() {
        return warehouseName;
    }

    public String getDeviceCode() {
        return deviceCode;
    }

    public String getEventType() {
        return eventType;
    }

    public String getDescription() {
        return description;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }
}
