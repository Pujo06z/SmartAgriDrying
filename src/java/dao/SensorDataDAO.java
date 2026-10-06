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

}
