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
public class SensorData {
    private String sensorId;
    private String deviceId;
    private double temperature;
    private double humidity;
    private String rainStatus;
    private String lightStatus;
    private String roofStatus;
    private Timestamp recordedAt;

    // Thêm cho Manager history views
    private String deviceCode;
    private String warehouseName;

    public SensorData() {
    }

    // Constructor cũ cho Operator
    public SensorData(String sensorId, String deviceId,
                      double temperature, double humidity,
                      String rainStatus, String lightStatus,
                      String roofStatus, Timestamp recordedAt) {
        this.sensorId = sensorId;
        this.deviceId = deviceId;
        this.temperature = temperature;
        this.humidity = humidity;
        this.rainStatus = rainStatus;
        this.lightStatus = lightStatus;
        this.roofStatus = roofStatus;
        this.recordedAt = recordedAt;
    }

    // Constructor đầy đủ cho Manager
    public SensorData(long sensorIdLong, String deviceId,
                      String deviceCode, String warehouseName,
                      double temperature, double humidity,
                      String rainStatus, String lightStatus,
                      String roofStatus, Timestamp recordedAt) {
        this.sensorId = String.valueOf(sensorIdLong);
        this.deviceId = deviceId;
        this.deviceCode = deviceCode;
        this.warehouseName = warehouseName;
        this.temperature = temperature;
        this.humidity = humidity;
        this.rainStatus = rainStatus;
        this.lightStatus = lightStatus;
        this.roofStatus = roofStatus;
        this.recordedAt = recordedAt;
    }

    public String getSensorId() {
        return sensorId;
    }

    public void setSensorId(String sensorId) {
        this.sensorId = sensorId;
    }

    public String getDeviceId() {
        return deviceId;
    }

    public void setDeviceId(String deviceId) {
        this.deviceId = deviceId;
    }

    public double getTemperature() {
        return temperature;
    }

    public void setTemperature(double temperature) {
        this.temperature = temperature;
    }

    public double getHumidity() {
        return humidity;
    }

    public void setHumidity(double humidity) {
        this.humidity = humidity;
    }

    public String getRainStatus() {
        return rainStatus;
    }

    public void setRainStatus(String rainStatus) {
        this.rainStatus = rainStatus;
    }

    public String getLightStatus() {
        return lightStatus;
    }

    public void setLightStatus(String lightStatus) {
        this.lightStatus = lightStatus;
    }

    public String getRoofStatus() {
        return roofStatus;
    }

    public void setRoofStatus(String roofStatus) {
        this.roofStatus = roofStatus;
    }

    public Timestamp getRecordedAt() {
        return recordedAt;
    }

    public void setRecordedAt(Timestamp recordedAt) {
        this.recordedAt = recordedAt;
    }

    public String getDeviceCode() {
        return deviceCode;
    }

    public void setDeviceCode(String deviceCode) {
        this.deviceCode = deviceCode;
    }

    public String getWarehouseName() {
        return warehouseName;
    }

    public void setWarehouseName(String warehouseName) {
        this.warehouseName = warehouseName;
    }
}
