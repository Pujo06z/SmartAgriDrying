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

    // =====================================================
    // MAP RESULTSET -> DEVICE
    // 
    // =====================================================
    private Device mapDevice(ResultSet rs)
            throws SQLException {

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

    // =====================================================
    // ADMIN
    // TAKE ALL DEVICE
    //  ACTIVE + INACTIVE
    // =====================================================
    public List<Device> getAllDevices() {

        List<Device> list
                = new ArrayList<>();

        String sql
                = "SELECT "
                + "device_id, "
                + "warehouse_id, "
                + "device_code, "
                + "device_name, "
                + "mode, "
                + "roof_status, "
                + "last_seen, "
                + "status "
                + "FROM DEVICE "
                + "ORDER BY device_id";

        try ( Connection con
                = DBContext.getConnection();  PreparedStatement ps
                = con.prepareStatement(sql);  ResultSet rs
                = ps.executeQuery()) {

            while (rs.next()) {

                list.add(
                        mapDevice(rs)
                );
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return list;
    }

    // =====================================================
    // MANAGER
    // 
    // =====================================================
    public List<Device> getDevicesByManager(
            String managerId) {

        List<Device> list
                = new ArrayList<>();

        String sql
                = "SELECT "
                + "d.device_id, "
                + "d.warehouse_id, "
                + "d.device_code, "
                + "d.device_name, "
                + "d.mode, "
                + "d.roof_status, "
                + "d.last_seen, "
                + "d.status "
                + "FROM DEVICE d "
                + "JOIN USER_WAREHOUSE uw "
                + "ON d.warehouse_id = uw.warehouse_id "
                + "WHERE uw.user_id = ? "
                + "AND uw.status = 'ACTIVE' "
                + "AND d.status = 'ACTIVE' "
                + "ORDER BY d.device_id";

        try ( Connection con
                = DBContext.getConnection();  PreparedStatement ps
                = con.prepareStatement(sql)) {

            ps.setString(
                    1,
                    managerId
            );

            try ( ResultSet rs
                    = ps.executeQuery()) {

                while (rs.next()) {

                    list.add(
                            mapDevice(rs)
                    );
                }
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return list;
    }

    // =====================================================
    // ADMIN
    // GET DEVICE BY ID
    // =====================================================
    public Device getById(
            String deviceId) {

        String sql
                = "SELECT "
                + "device_id, "
                + "warehouse_id, "
                + "device_code, "
                + "device_name, "
                + "mode, "
                + "roof_status, "
                + "last_seen, "
                + "status "
                + "FROM DEVICE "
                + "WHERE device_id = ?";

        try ( Connection con
                = DBContext.getConnection();  PreparedStatement ps
                = con.prepareStatement(sql)) {

            ps.setString(
                    1,
                    deviceId
            );

            try ( ResultSet rs
                    = ps.executeQuery()) {

                if (rs.next()) {

                    return mapDevice(rs);
                }
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return null;
    }

    // =====================================================
    // ADMIN
    // GET DEVICE BY CODE
    // =====================================================
    public Device getByCode(
            String deviceCode) {

        String sql
                = "SELECT "
                + "device_id, "
                + "warehouse_id, "
                + "device_code, "
                + "device_name, "
                + "mode, "
                + "roof_status, "
                + "last_seen, "
                + "status "
                + "FROM DEVICE "
                + "WHERE device_code = ?";

        try ( Connection con
                = DBContext.getConnection();  PreparedStatement ps
                = con.prepareStatement(sql)) {

            ps.setString(
                    1,
                    deviceCode
            );

            try ( ResultSet rs
                    = ps.executeQuery()) {

                if (rs.next()) {

                    return mapDevice(rs);
                }
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return null;
    }

    // =====================================================
    // MANAGER
    // CHECK DEVICE IS BELONG TO MANAGER
    // =====================================================
    public boolean isAssignedToManager(
            String managerId,
            String deviceId) {

        String sql
                = "SELECT COUNT(*) AS total "
                + "FROM DEVICE d "
                + "JOIN USER_WAREHOUSE uw "
                + "ON d.warehouse_id = uw.warehouse_id "
                + "WHERE d.device_id = ? "
                + "AND uw.user_id = ? "
                + "AND uw.status = 'ACTIVE'";

        try ( Connection con
                = DBContext.getConnection();  PreparedStatement ps
                = con.prepareStatement(sql)) {

            ps.setString(
                    1,
                    deviceId
            );

            ps.setString(
                    2,
                    managerId
            );

            try ( ResultSet rs
                    = ps.executeQuery()) {

                if (rs.next()) {

                    return rs.getInt(
                            "total"
                    ) > 0;
                }
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return false;
    }

    // =====================================================
    // ADMIN
    // ADD DEVICE
    // =====================================================
    public boolean add(
            String deviceId,
            String deviceCode,
            String deviceName,
            String warehouseId) {

        String sql
                = "INSERT INTO DEVICE "
                + "(device_id, "
                + "warehouse_id, "
                + "device_code, "
                + "device_name, "
                + "mode, "
                + "roof_status, "
                + "status) "
                + "VALUES (?, ?, ?, ?, "
                + "'AUTO', 'CLOSED', 'ACTIVE')";

        try ( Connection con
                = DBContext.getConnection();  PreparedStatement ps
                = con.prepareStatement(sql)) {

            ps.setString(
                    1,
                    deviceId
            );

            ps.setString(
                    2,
                    warehouseId
            );

            ps.setString(
                    3,
                    deviceCode
            );

            ps.setString(
                    4,
                    deviceName
            );

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return false;
    }

    // =====================================================
    // ADMIN
    // UPDATE DEVICE
    // =====================================================
    public boolean update(
            String deviceId,
            String deviceCode,
            String deviceName,
            String warehouseId) {

        String sql
                = "UPDATE DEVICE "
                + "SET device_code = ?, "
                + "device_name = ?, "
                + "warehouse_id = ? "
                + "WHERE device_id = ?";

        try ( Connection con
                = DBContext.getConnection();  PreparedStatement ps
                = con.prepareStatement(sql)) {

            ps.setString(
                    1,
                    deviceCode
            );

            ps.setString(
                    2,
                    deviceName
            );

            ps.setString(
                    3,
                    warehouseId
            );

            ps.setString(
                    4,
                    deviceId
            );

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return false;
    }

    // =====================================================
    // ADMIN
    // ACTIVE <-> INACTIVE
    // =====================================================
    public boolean updateStatus(
            String deviceId) {

        String sql
                = "UPDATE DEVICE "
                + "SET status = "
                + "CASE "
                + "WHEN status = 'ACTIVE' "
                + "THEN 'INACTIVE' "
                + "ELSE 'ACTIVE' "
                + "END "
                + "WHERE device_id = ?";

        try ( Connection con
                = DBContext.getConnection();  PreparedStatement ps
                = con.prepareStatement(sql)) {

            ps.setString(
                    1,
                    deviceId
            );

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return false;
    }

    // =====================================================
    // ESP HEARTBEAT
    // UPDATE last_seen + ROOF STATUS 
    // =====================================================
    public boolean updateHeartbeat(
            String deviceId,
            String roofStatus) {

        String sql
                = "UPDATE DEVICE "
                + "SET last_seen = SYSDATETIME(), "
                + "roof_status = ? "
                + "WHERE device_id = ? "
                + "AND status = 'ACTIVE'";

        try ( Connection con
                = DBContext.getConnection();  PreparedStatement ps
                = con.prepareStatement(sql)) {

            ps.setString(
                    1,
                    roofStatus
            );

            ps.setString(
                    2,
                    deviceId
            );

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return false;
    }

    // =====================================================
    // ADMIN DASHBOARD
    // COUNT DEVICE ONLINE
    // =====================================================
    public int countOnlineDevices() {

        String sql
                = "SELECT COUNT(*) AS total "
                + "FROM DEVICE "
                + "WHERE status = 'ACTIVE' "
                + "AND last_seen >= "
                + "DATEADD(SECOND, -30, SYSDATETIME())";

        try ( Connection con
                = DBContext.getConnection();  PreparedStatement ps
                = con.prepareStatement(sql);  ResultSet rs
                = ps.executeQuery()) {

            if (rs.next()) {

                return rs.getInt(
                        "total"
                );
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return 0;
    }

    // =====================================================
    // MANAGER DASHBOARD
    // COUNT DEVICE ONLINE OF MANAGER
    // =====================================================
    public int countOnlineDevicesByManager(
            String managerId) {

        String sql
                = "SELECT COUNT(*) AS total "
                + "FROM DEVICE d "
                + "JOIN USER_WAREHOUSE uw "
                + "ON d.warehouse_id = uw.warehouse_id "
                + "WHERE uw.user_id = ? "
                + "AND uw.status = 'ACTIVE' "
                + "AND d.status = 'ACTIVE' "
                + "AND d.last_seen >= "
                + "DATEADD(SECOND, -30, SYSDATETIME())";

        try ( Connection con
                = DBContext.getConnection();  PreparedStatement ps
                = con.prepareStatement(sql)) {

            ps.setString(
                    1,
                    managerId
            );

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

    // =====================================================
// ADMIN DASHBOARD
// COUNT ALL DEVICES
// =====================================================
    public int countAll() {

        String sql
                = "SELECT COUNT(*) AS total "
                + "FROM DEVICE";

        try (
                 Connection con = DBContext.getConnection();  PreparedStatement ps = con.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt("total");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

// =====================================================
// ADMIN DASHBOARD
// COUNT ONLINE DEVICES
// =====================================================
    public int countOnline() {

        String sql
                = "SELECT COUNT(*) AS total "
                + "FROM DEVICE "
                + "WHERE status = 'ACTIVE' "
                + "AND last_seen >= DATEADD(SECOND, -30, SYSDATETIME())";

        try (
                 Connection con = DBContext.getConnection();  PreparedStatement ps = con.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt("total");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }
}
