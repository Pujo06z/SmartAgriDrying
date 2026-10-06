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
public class DryingBatch {

    private String batchId;
    private String warehouseId;
    private String operatorId;
    private String operatorName;
    private String productName;
    private double weightKg;
    private Timestamp startTime;
    private Timestamp endTime;
    private String status;
    private String notes;

    // Thêm cho Manager views
    private String warehouseName;
    private String createdBy;
    private String createdByName;

    public DryingBatch() {
    }

    // Constructor cũ cho Operator
    public DryingBatch(String batchId, String warehouseId,
            String operatorId, String operatorName,
            String productName, double weightKg,
            Timestamp startTime, Timestamp endTime,
            String status, String notes) {

        this.batchId = batchId;
        this.warehouseId = warehouseId;
        this.operatorId = operatorId;
        this.operatorName = operatorName;
        this.productName = productName;
        this.weightKg = weightKg;
        this.startTime = startTime;
        this.endTime = endTime;
        this.status = status;
        this.notes = notes;
    }

    // Constructor cho Manager
    public DryingBatch(String batchId, String warehouseId,
                       String warehouseName, Timestamp startTime,
                       Timestamp endTime, String status,
                       String createdBy, String createdByName) {
        this.batchId = batchId;
        this.warehouseId = warehouseId;
        this.warehouseName = warehouseName;
        this.startTime = startTime;
        this.endTime = endTime;
        this.status = status;
        this.createdBy = createdBy;
        this.createdByName = createdByName;
    }

    public String getBatchId() {
        return batchId;
    }

    public void setBatchId(String batchId) {
        this.batchId = batchId;
    }

    public String getWarehouseId() {
        return warehouseId;
    }

    public void setWarehouseId(String warehouseId) {
        this.warehouseId = warehouseId;
    }

    public String getOperatorId() {
        return operatorId;
    }

    public void setOperatorId(String operatorId) {
        this.operatorId = operatorId;
    }

    public String getOperatorName() {
        return operatorName;
    }

    public void setOperatorName(String operatorName) {
        this.operatorName = operatorName;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public double getWeightKg() {
        return weightKg;
    }

    public void setWeightKg(double weightKg) {
        this.weightKg = weightKg;
    }

    public Timestamp getStartTime() {
        return startTime;
    }

    public void setStartTime(Timestamp startTime) {
        this.startTime = startTime;
    }

    public Timestamp getEndTime() {
        return endTime;
    }

    public void setEndTime(Timestamp endTime) {
        this.endTime = endTime;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public String getWarehouseName() {
        return warehouseName;
    }

    public void setWarehouseName(String warehouseName) {
        this.warehouseName = warehouseName;
    }

    public String getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(String createdBy) {
        this.createdBy = createdBy;
    }

    public String getCreatedByName() {
        return createdByName;
    }

    public void setCreatedByName(String createdByName) {
        this.createdByName = createdByName;
    }
}
