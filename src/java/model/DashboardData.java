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
public class DashboardData {

    private double temperature;
    private double humidity;

    private String rainStatus;
    private String lightStatus;
    private String roofStatus;
    private String mode;

    private String connectionStatus;
    private String warning;

    private Timestamp lastSeen;
    private Timestamp recordedAt;

    public DashboardData() {
    }

    public DashboardData(double temperature, double humidity, String rainStatus, String lightStatus, String roofStatus, String mode, String connectionStatus, String warning, Timestamp lastSeen, Timestamp recordedAt) {
        this.temperature = temperature;
        this.humidity = humidity;
        this.rainStatus = rainStatus;
        this.lightStatus = lightStatus;
        this.roofStatus = roofStatus;
        this.mode = mode;
        this.connectionStatus = connectionStatus;
        this.warning = warning;
        this.lastSeen = lastSeen;
        this.recordedAt = recordedAt;
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

    public String getMode() {
        return mode;
    }

    public void setMode(String mode) {
        this.mode = mode;
    }

    public String getConnectionStatus() {
        return connectionStatus;
    }

    public void setConnectionStatus(String connectionStatus) {
        this.connectionStatus = connectionStatus;
    }

    public String getWarning() {
        return warning;
    }

    public void setWarning(String warning) {
        this.warning = warning;
    }

    public Timestamp getLastSeen() {
        return lastSeen;
    }

    public void setLastSeen(Timestamp lastSeen) {
        this.lastSeen = lastSeen;
    }

    public Timestamp getRecordedAt() {
        return recordedAt;
    }

    public void setRecordedAt(Timestamp recordedAt) {
        this.recordedAt = recordedAt;
    }

    
}
