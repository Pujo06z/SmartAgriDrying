/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.Device;
import util.DBContext;

/**
 *
 * @author ADMIN
 */
public class DeviceDAO {

    public Device getDeviceByWarehouse(String warehouseId) {
        String sql
                = "SELECT device_id, warehouse_id, device_code, "
                + "device_name, mode, roof_status, last_seen, status "
                + "FROM DEVICE "
                + "WHERE warehouse_id = ? "
                + "AND status = 'ACTIVE'";

        try {
            Connection con = DBContext.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, warehouseId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                Device device = new Device();

                device.setDeviceId(
                        rs.getString("device_id")
                );

                device.setWarehouseId(
                        rs.getString("warehouse_id")
                );

                device.setDeviceCode(
                        rs.getString("device_code")
                );

                device.setDeviceName(
                        rs.getString("device_name")
                );

                device.setMode(
                        rs.getString("mode")
                );

                device.setRoofStatus(
                        rs.getString("roof_status")
                );

                device.setLastSeen(
                        rs.getTimestamp("last_seen")
                );

                device.setStatus(
                        rs.getString("status")
                );

                return device;
            }
        } catch (SQLException sQLException) {
            sQLException.printStackTrace();
        }
        return null;
    }

    public static void main(String[] args) {

        DeviceDAO dao = new DeviceDAO();

        Device device = dao.getDeviceByWarehouse("W001");

        if (device != null) {

            System.out.println("FOUND DEVICE");
            System.out.println(
                    "ID: " + device.getDeviceId()
            );
            System.out.println(
                    "Code: " + device.getDeviceCode()
            );
            System.out.println(
                    "Mode: " + device.getMode()
            );
            System.out.println(
                    "Roof: " + device.getRoofStatus()
            );

        } else {

            System.out.println("NO DEVICE FOUND");
        }
    }

    public boolean updateMode(String deviceId, String mode) {

        String sql
                = "UPDATE DEVICE "
                + "SET mode = ? "
                + "WHERE device_id = ? "
                + "AND status = 'ACTIVE'";

        try ( Connection con = DBContext.getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, mode);
            ps.setString(2, deviceId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean updateRoofStatus(
            String deviceId,
            String roofStatus) {

        String sql
                = "UPDATE DEVICE "
                + "SET roof_status = ? "
                + "WHERE device_id = ? "
                + "AND status = 'ACTIVE'";

        try ( Connection con = DBContext.getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, roofStatus);
            ps.setString(2, deviceId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }
}
