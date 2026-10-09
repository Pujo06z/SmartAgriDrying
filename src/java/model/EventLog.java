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
     private String eventId;
    private String warehouseId;
    private String deviceId;
    private String batchId;
    private String actorUserId;

    private String eventType;
    private String source;
    private String description;

    private Timestamp createdAt;


    public EventLog() {
    }


    public EventLog(
            String eventId,
            String warehouseId,
            String deviceId,
            String batchId,
            String actorUserId,
            String eventType,
            String source,
            String description,
            Timestamp createdAt) {

        this.eventId = eventId;
        this.warehouseId = warehouseId;
        this.deviceId = deviceId;
        this.batchId = batchId;
        this.actorUserId = actorUserId;
        this.eventType = eventType;
        this.source = source;
        this.description = description;
        this.createdAt = createdAt;
    }


    public String getEventId() {
        return eventId;
    }

    public void setEventId(String eventId) {
        this.eventId = eventId;
    }


    public String getWarehouseId() {
        return warehouseId;
    }

    public void setWarehouseId(String warehouseId) {
        this.warehouseId = warehouseId;
    }


    public String getDeviceId() {
        return deviceId;
    }

    public void setDeviceId(String deviceId) {
        this.deviceId = deviceId;
    }


    public String getBatchId() {
        return batchId;
    }

    public void setBatchId(String batchId) {
        this.batchId = batchId;
    }


    public String getActorUserId() {
        return actorUserId;
    }

    public void setActorUserId(String actorUserId) {
        this.actorUserId = actorUserId;
    }


    public String getEventType() {
        return eventType;
    }

    public void setEventType(String eventType) {
        this.eventType = eventType;
    }


    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }


    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }


    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
