/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.SensorData;
import util.DBContext;

/**
 *
 * @author ADMIN
 */
public class SensorDataDAO {

    // Existing Operator Methods
    public SensorData getLatestSensorData(String deviceId) {
        String sql
                = "SELECT TOP 1 "
                + "sensor_id, device_id, temperature, humidity, "
                + "rain_status, light_status, roof_status, recorded_at "
                + "FROM SENSOR_DATA "
                + "WHERE device_id = ? "
                + "ORDER BY recorded_at DESC";
        try {
            Connection con = DBContext.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, deviceId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                SensorData sensor = new SensorData();
                sensor.setSensorId(rs.getString("sensor_id"));
                sensor.setDeviceId(rs.getString("device_id"));
                sensor.setTemperature(rs.getDouble("temperature"));
                sensor.setHumidity(rs.getDouble("humidity"));
                sensor.setRainStatus(rs.getString("rain_status"));
                sensor.setLightStatus(rs.getString("light_status"));
                sensor.setRoofStatus(rs.getString("roof_status"));
                sensor.setRecordedAt(rs.getTimestamp("recorded_at"));
                return sensor;
            }
        } catch (SQLException sQLException) {
            sQLException.printStackTrace();
        }
        return null;
    }

    public List<SensorData> getRecentSensorData(String deviceId, int limit) {
        List<SensorData> list = new ArrayList<>();
        String sql
                = "SELECT TOP (?) "
                + "sensor_id, device_id, temperature, humidity, "
                + "rain_status, light_status, roof_status, recorded_at "
                + "FROM SENSOR_DATA "
                + "WHERE device_id = ? "
                + "ORDER BY recorded_at DESC";

        try {
            Connection con = DBContext.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, limit);
            ps.setString(2, deviceId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                SensorData sensor = new SensorData();
                sensor.setSensorId(rs.getString("sensor_id"));
                sensor.setDeviceId(rs.getString("device_id"));
                sensor.setTemperature(rs.getDouble("temperature"));
                sensor.setHumidity(rs.getDouble("humidity"));
                sensor.setRainStatus(rs.getString("rain_status"));
                sensor.setLightStatus(rs.getString("light_status"));
                sensor.setRoofStatus(rs.getString("roof_status"));
                sensor.setRecordedAt(rs.getTimestamp("recorded_at"));
                list.add(sensor);
            }
        } catch (SQLException sQLException) {
            sQLException.printStackTrace();
        }
        return list;
    }

    // New Manager Methods
    private static final String SELECT =
            "SELECT TOP 100 "
            + "s.sensor_id, "
            + "s.device_id, "
            + "d.device_code, "
            + "w.warehouse_name, "
            + "s.temperature, "
            + "s.humidity, "
            + "s.rain_status, "
            + "s.light_status, "
            + "s.roof_status, "
            + "s.recorded_at "
            + "FROM SENSOR_DATA s "
            + "JOIN DEVICE d "
            + "ON s.device_id = d.device_id "
            + "JOIN WAREHOUSE w "
            + "ON d.warehouse_id = w.warehouse_id ";

    public List<SensorData> getLatestByManager(String managerId) throws Exception {
        String sql =
                SELECT
                + "JOIN USER_WAREHOUSE uw "
                + "ON d.warehouse_id = uw.warehouse_id "
                + "WHERE uw.user_id = ? "
                + "ORDER BY s.recorded_at DESC";
        return query(sql, managerId);
    }

    public List<SensorData> getHistoryByManager(String managerId, String deviceId) throws Exception {
        String sql =
                "SELECT TOP 200 "
                + "s.sensor_id, "
                + "s.device_id, "
                + "d.device_code, "
                + "w.warehouse_name, "
                + "s.temperature, "
                + "s.humidity, "
                + "s.rain_status, "
                + "s.light_status, "
                + "s.roof_status, "
                + "s.recorded_at "
                + "FROM SENSOR_DATA s "
                + "JOIN DEVICE d "
                + "ON s.device_id = d.device_id "
                + "JOIN WAREHOUSE w "
                + "ON d.warehouse_id = w.warehouse_id "
                + "JOIN USER_WAREHOUSE uw "
                + "ON d.warehouse_id = uw.warehouse_id "
                + "WHERE uw.user_id = ? ";

        if (deviceId != null && !deviceId.trim().isEmpty()) {
            sql += "AND d.device_id = ? ";
        }
        sql += "ORDER BY s.recorded_at DESC";

        if (deviceId != null && !deviceId.trim().isEmpty()) {
            return query(sql, managerId, deviceId);
        }
        return query(sql, managerId);
    }

    public void insert(String deviceId, double temperature, double humidity,
                       String rainStatus, String lightStatus, String roofStatus) throws Exception {
        String sql =
                "INSERT INTO SENSOR_DATA "
                + "(device_id, temperature, humidity, "
                + "rain_status, light_status, roof_status, "
                + "recorded_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, SYSDATETIME())";
        DBContext.exec(sql, deviceId, temperature, humidity, rainStatus, lightStatus, roofStatus);
    }

    private List<SensorData> query(String sql, String... params) throws Exception {
        List<SensorData> list = new ArrayList<SensorData>();
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int i = 0; i < params.length; i++) {
                ps.setString(i + 1, params[i]);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new SensorData(
                            rs.getLong("sensor_id"),
                            rs.getString("device_id"),
                            rs.getString("device_code"),
                            rs.getString("warehouse_name"),
                            rs.getDouble("temperature"),
                            rs.getDouble("humidity"),
                            rs.getString("rain_status"),
                            rs.getString("light_status"),
                            rs.getString("roof_status"),
                            rs.getTimestamp("recorded_at")
                    ));
                }
            }
        }
        return list;
    }
}
