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

    public List<SensorData> searchSensorHistory(
            String deviceId,
            String keyword,
            String rainStatus,
            String lightStatus,
            int page,
            int pageSize) {

        List<SensorData> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder();

        sql.append(
                "SELECT sensor_id, device_id, "
                + "temperature, humidity, "
                + "rain_status, light_status, "
                + "roof_status, recorded_at "
                + "FROM SENSOR_DATA "
                + "WHERE device_id = ? "
        );

        // SEARCH SENSOR ID
        if (keyword != null
                && !keyword.trim().isEmpty()) {

            sql.append(
                    "AND sensor_id LIKE ? "
            );
        }

        // FILTER RAIN
        if (rainStatus != null
                && !rainStatus.trim().isEmpty()) {

            sql.append(
                    "AND rain_status = ? "
            );
        }

        // FILTER LIGHT
        if (lightStatus != null
                && !lightStatus.trim().isEmpty()) {

            sql.append(
                    "AND light_status = ? "
            );
        }

        sql.append(
                "ORDER BY recorded_at DESC "
                + "OFFSET ? ROWS "
                + "FETCH NEXT ? ROWS ONLY"
        );

        try (
                 Connection con = DBContext.getConnection();  PreparedStatement ps
                = con.prepareStatement(sql.toString())) {

            int index = 1;

            ps.setString(index++, deviceId);

            if (keyword != null
                    && !keyword.trim().isEmpty()) {

                ps.setString(
                        index++,
                        "%" + keyword.trim() + "%"
                );
            }

            if (rainStatus != null
                    && !rainStatus.trim().isEmpty()) {

                ps.setString(
                        index++,
                        rainStatus
                );
            }

            if (lightStatus != null
                    && !lightStatus.trim().isEmpty()) {

                ps.setString(
                        index++,
                        lightStatus
                );
            }

            int offset
                    = (page - 1) * pageSize;

            ps.setInt(index++, offset);

            ps.setInt(index, pageSize);

            try ( ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    SensorData sensor
                            = new SensorData();

                    sensor.setSensorId(
                            rs.getString("sensor_id")
                    );

                    sensor.setDeviceId(
                            rs.getString("device_id")
                    );

                    sensor.setTemperature(
                            rs.getDouble("temperature")
                    );

                    sensor.setHumidity(
                            rs.getDouble("humidity")
                    );

                    sensor.setRainStatus(
                            rs.getString("rain_status")
                    );

                    sensor.setLightStatus(
                            rs.getString("light_status")
                    );
                    sensor.setRoofStatus(
                            rs.getString("roof_status")
                    );
                    sensor.setRecordedAt(
                            rs.getTimestamp("recorded_at")
                    );

                    list.add(sensor);
                }
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return list;
    }

    public int countSensorHistory(
            String deviceId,
            String keyword,
            String rainStatus,
            String lightStatus) {

        StringBuilder sql
                = new StringBuilder();

        sql.append(
                "SELECT COUNT(*) AS total "
                + "FROM SENSOR_DATA "
                + "WHERE device_id = ? "
        );

        if (keyword != null
                && !keyword.trim().isEmpty()) {

            sql.append(
                    "AND sensor_id LIKE ? "
            );
        }

        if (rainStatus != null
                && !rainStatus.trim().isEmpty()) {

            sql.append(
                    "AND rain_status = ? "
            );
        }

        if (lightStatus != null
                && !lightStatus.trim().isEmpty()) {

            sql.append(
                    "AND light_status = ? "
            );
        }

        try (
                 Connection con
                = DBContext.getConnection();  PreparedStatement ps
                = con.prepareStatement(
                        sql.toString()
                )) {

            int index = 1;

            ps.setString(index++, deviceId);

            if (keyword != null
                    && !keyword.trim().isEmpty()) {

                ps.setString(
                        index++,
                        "%" + keyword.trim() + "%"
                );
            }

            if (rainStatus != null
                    && !rainStatus.trim().isEmpty()) {

                ps.setString(
                        index++,
                        rainStatus
                );
            }

            if (lightStatus != null
                    && !lightStatus.trim().isEmpty()) {

                ps.setString(
                        index,
                        lightStatus
                );
            }

            try ( ResultSet rs
                    = ps.executeQuery()) {

                if (rs.next()) {

                    return rs.getInt(
                            "total"
                    );
                }
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return 0;
    }

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

                sensor.setSensorId(
                        rs.getString("sensor_id")
                );

                sensor.setDeviceId(
                        rs.getString("device_id")
                );

                sensor.setTemperature(
                        rs.getDouble("temperature")
                );

                sensor.setHumidity(
                        rs.getDouble("humidity")
                );

                sensor.setRainStatus(
                        rs.getString("rain_status")
                );

                sensor.setLightStatus(
                        rs.getString("light_status")
                );

                sensor.setRoofStatus(
                        rs.getString("roof_status")
                );

                sensor.setRecordedAt(
                        rs.getTimestamp("recorded_at")
                );

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

                sensor.setSensorId(
                        rs.getString("sensor_id")
                );

                sensor.setDeviceId(
                        rs.getString("device_id")
                );

                sensor.setTemperature(
                        rs.getDouble("temperature")
                );

                sensor.setHumidity(
                        rs.getDouble("humidity")
                );

                sensor.setRainStatus(
                        rs.getString("rain_status")
                );

                sensor.setLightStatus(
                        rs.getString("light_status")
                );

                sensor.setRoofStatus(
                        rs.getString("roof_status")
                );

                sensor.setRecordedAt(
                        rs.getTimestamp("recorded_at")
                );

                list.add(sensor);
            }
        } catch (SQLException sQLException) {
            sQLException.printStackTrace();
        }
        return list;
    }

    public List<SensorData> getSensorHistory(String deviceId) {

        List<SensorData> list = new ArrayList<>();

        String sql
                = "SELECT sensor_id, device_id, "
                + "temperature, humidity, "
                + "rain_status, light_status, "
                + "roof_status, recorded_at "
                + "FROM SENSOR_DATA "
                + "WHERE device_id = ? "
                + "ORDER BY recorded_at DESC";

        try ( Connection con = DBContext.getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, deviceId);

            try ( ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    SensorData sensor = new SensorData();

                    sensor.setSensorId(
                            rs.getString("sensor_id")
                    );

                    sensor.setDeviceId(
                            rs.getString("device_id")
                    );

                    sensor.setTemperature(
                            rs.getDouble("temperature")
                    );

                    sensor.setHumidity(
                            rs.getDouble("humidity")
                    );

                    sensor.setRainStatus(
                            rs.getString("rain_status")
                    );

                    sensor.setLightStatus(
                            rs.getString("light_status")
                    );

                    sensor.setRoofStatus(
                            rs.getString("roof_status")
                    );

                    sensor.setRecordedAt(
                            rs.getTimestamp("recorded_at")
                    );

                    list.add(sensor);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    // =====================================================
    // MAP RESULTSET -> SENSOR DATA
    // =====================================================
    private SensorData mapSensor(ResultSet rs)
            throws SQLException {

        SensorData sensor = new SensorData();

        sensor.setSensorId(
                rs.getString("sensor_id")
        );

        sensor.setDeviceId(
                rs.getString("device_id")
        );

        sensor.setTemperature(
                rs.getDouble("temperature")
        );

        sensor.setHumidity(
                rs.getDouble("humidity")
        );

        sensor.setRainStatus(
                rs.getString("rain_status")
        );

        sensor.setLightStatus(
                rs.getString("light_status")
        );

        sensor.setRoofStatus(
                rs.getString("roof_status")
        );

        sensor.setRecordedAt(
                rs.getTimestamp("recorded_at")
        );

        return sensor;
    }

    // =====================================================
    // MANAGER HISTORY
    // LẤY SENSOR HISTORY TRONG CÁC WAREHOUSE
    // ĐƯỢC ASSIGN CHO MANAGER
    // =====================================================
    public List<SensorData> getHistoryByManager(
            String managerId,
            String deviceId) {

        List<SensorData> list
                = new ArrayList<>();

        StringBuilder sql
                = new StringBuilder();

        sql.append(
                "SELECT TOP 200 "
        );

        sql.append(
                "s.sensor_id, "
                + "s.device_id, "
                + "s.temperature, "
                + "s.humidity, "
                + "s.rain_status, "
                + "s.light_status, "
                + "s.roof_status, "
                + "s.recorded_at "
        );

        sql.append(
                "FROM SENSOR_DATA s "
                + "JOIN DEVICE d "
                + "ON s.device_id = d.device_id "
                + "JOIN WAREHOUSE w "
                + "ON d.warehouse_id = w.warehouse_id "
                + "JOIN USER_WAREHOUSE uw "
                + "ON d.warehouse_id = uw.warehouse_id "
        );

        sql.append(
                "WHERE uw.user_id = ? "
                + "AND uw.status = 'ACTIVE' "
                + "AND w.status = 'ACTIVE' "
                + "AND d.status = 'ACTIVE' "
        );

        if (deviceId != null
                && !deviceId.trim().isEmpty()) {

            sql.append(
                    "AND d.device_id = ? "
            );
        }

        sql.append(
                "ORDER BY s.recorded_at DESC"
        );

        try ( Connection con
                = DBContext.getConnection();  PreparedStatement ps
                = con.prepareStatement(
                        sql.toString()
                )) {

            int index = 1;

            ps.setString(
                    index++,
                    managerId
            );

            if (deviceId != null
                    && !deviceId.trim().isEmpty()) {

                ps.setString(
                        index++,
                        deviceId
                );
            }

            try ( ResultSet rs
                    = ps.executeQuery()) {

                while (rs.next()) {

                    list.add(
                            mapSensor(rs)
                    );
                }
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return list;
    }

    // =====================================================
    // ESP / API
    // INSERT SENSOR DATA
    // =====================================================
    public boolean insert(
            String deviceId,
            double temperature,
            double humidity,
            String rainStatus,
            String lightStatus,
            String roofStatus) {

        String sql
                = "INSERT INTO SENSOR_DATA "
                + "(device_id, "
                + "temperature, "
                + "humidity, "
                + "rain_status, "
                + "light_status, "
                + "roof_status, "
                + "recorded_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, "
                + "SYSDATETIME())";

        try ( Connection con
                = DBContext.getConnection();  PreparedStatement ps
                = con.prepareStatement(sql)) {

            ps.setString(
                    1,
                    deviceId
            );

            ps.setDouble(
                    2,
                    temperature
            );

            ps.setDouble(
                    3,
                    humidity
            );

            ps.setString(
                    4,
                    rainStatus
            );

            ps.setString(
                    5,
                    lightStatus
            );

            ps.setString(
                    6,
                    roofStatus
            );

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return false;
    }
}
