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
import model.Device;
import util.DBContext;

/**
 *
 * @author ADMIN
 */
public class DeviceDAO {

    // Existing methods
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
                device.setDeviceId(rs.getString("device_id"));
                device.setWarehouseId(rs.getString("warehouse_id"));
                device.setDeviceCode(rs.getString("device_code"));
                device.setDeviceName(rs.getString("device_name"));
                device.setMode(rs.getString("mode"));
                device.setRoofStatus(rs.getString("roof_status"));
                device.setLastSeen(rs.getTimestamp("last_seen"));
                device.setStatus(rs.getString("status"));
                return device;
            }
        } catch (SQLException sQLException) {
            sQLException.printStackTrace();
        }
        return null;
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

    public boolean updateRoofStatus(String deviceId, String roofStatus) {
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

    public static void main(String[] args) {
        DeviceDAO dao = new DeviceDAO();
        Device device = dao.getDeviceByWarehouse("W001");
        if (device != null) {
            System.out.println("FOUND DEVICE");
            System.out.println("ID: " + device.getDeviceId());
            System.out.println("Code: " + device.getDeviceCode());
            System.out.println("Mode: " + device.getMode());
            System.out.println("Roof: " + device.getRoofStatus());
        } else {
            System.out.println("NO DEVICE FOUND");
        }
    }

    // New methods from NB13
    private static final String BASE_SELECT =
            "SELECT "
            + "d.device_id, "
            + "d.device_code, "
            + "d.device_name, "
            + "d.warehouse_id, "
            + "w.warehouse_name, "
            + "d.mode, "
            + "d.roof_status, "
            + "d.last_seen, "
            + "d.status "
            + "FROM DEVICE d "
            + "LEFT JOIN WAREHOUSE w "
            + "ON d.warehouse_id = w.warehouse_id ";

    public List<Device> getAllDevices() throws Exception {
        return getDeviceList(BASE_SELECT + "ORDER BY d.device_id");
    }

    public List<Device> getDevicesByManager(String managerId) throws Exception {
        String sql =
                BASE_SELECT
                + "JOIN USER_WAREHOUSE uw "
                + "ON d.warehouse_id = uw.warehouse_id "
                + "WHERE uw.user_id = ? "
                + "ORDER BY d.device_id";

        List<Device> list = new ArrayList<Device>();
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, managerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        }
        return list;
    }

    private List<Device> getDeviceList(String sql) throws Exception {
        List<Device> list = new ArrayList<Device>();
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(map(rs));
            }
        }
        return list;
    }

    private Device map(ResultSet rs) throws SQLException {
        return new Device(
                rs.getString("device_id"),
                rs.getString("device_code"),
                rs.getString("device_name"),
                rs.getString("warehouse_id"),
                rs.getString("warehouse_name"),
                rs.getString("mode"),
                rs.getString("roof_status"),
                rs.getTimestamp("last_seen"),
                rs.getString("status")
        );
    }

    public Device getById(String deviceId) throws Exception {
        String sql = BASE_SELECT + "WHERE d.device_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, deviceId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }
        }
        return null;
    }

    public Device getByCode(String deviceCode) throws Exception {
        String sql = BASE_SELECT + "WHERE d.device_code = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, deviceCode);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }
        }
        return null;
    }

    public boolean isAssignedToManager(String managerId, String deviceId) throws Exception {
        String sql =
                "SELECT COUNT(*) "
                + "FROM DEVICE d "
                + "JOIN USER_WAREHOUSE uw "
                + "ON d.warehouse_id = uw.warehouse_id "
                + "WHERE d.device_id = ? "
                + "AND uw.user_id = ?";
        return DBContext.scalar(sql, deviceId, managerId) > 0;
    }

    public void add(String deviceId, String deviceCode, String deviceName, String warehouseId) throws Exception {
        String sql =
                "INSERT INTO DEVICE "
                + "(device_id, device_code, device_name, "
                + "warehouse_id, mode, roof_status, status) "
                + "VALUES (?, ?, ?, ?, 'AUTO', 'CLOSED', 'ACTIVE')";
        DBContext.exec(sql, deviceId, deviceCode, deviceName, warehouseId);
    }

    public void update(String deviceId, String deviceCode, String deviceName, String warehouseId) throws Exception {
        String sql =
                "UPDATE DEVICE "
                + "SET device_code = ?, "
                + "device_name = ?, "
                + "warehouse_id = ? "
                + "WHERE device_id = ?";
        DBContext.exec(sql, deviceCode, deviceName, warehouseId, deviceId);
    }

    public void updateStatus(String deviceId) throws Exception {
        DBContext.exec(
                "UPDATE DEVICE "
                + "SET status = "
                + "CASE "
                + "WHEN status = 'ACTIVE' THEN 'INACTIVE' "
                + "ELSE 'ACTIVE' "
                + "END "
                + "WHERE device_id = ?",
                deviceId
        );
    }

    public void updateHeartbeat(String deviceId, String roofStatus) throws Exception {
        DBContext.exec(
                "UPDATE DEVICE "
                + "SET last_seen = SYSDATETIME(), "
                + "roof_status = ? "
                + "WHERE device_id = ?",
                roofStatus, deviceId
        );
    }

    public int countOnlineDevices() throws Exception {
        return DBContext.scalar(
                "SELECT COUNT(*) "
                + "FROM DEVICE "
                + "WHERE status = 'ACTIVE' "
                + "AND last_seen >= DATEADD(SECOND, -30, SYSDATETIME())"
        );
    }

    public int countOnlineDevicesByManager(String managerId) throws Exception {
        String sql =
                "SELECT COUNT(*) "
                + "FROM DEVICE d "
                + "JOIN USER_WAREHOUSE uw "
                + "ON d.warehouse_id = uw.warehouse_id "
                + "WHERE uw.user_id = ? "
                + "AND d.status = 'ACTIVE' "
                + "AND d.last_seen >= DATEADD(SECOND, -30, SYSDATETIME())";
        return DBContext.scalar(sql, managerId);
    }
}
