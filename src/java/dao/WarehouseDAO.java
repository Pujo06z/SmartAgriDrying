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
import model.Warehouse;
import util.DBContext;

/**
 *
 * @author ADMIN
 */
public class WarehouseDAO {
    
    // Existing method
    public Warehouse getWarehouseByUser(String userId){
        String sql
                = "SELECT w.warehouse_id, "
                + "w.warehouse_code, "
                + "w.warehouse_name, "
                + "w.location, "
                + "w.status, "
                + "w.created_at "
                + "FROM WAREHOUSE w "
                + "JOIN USER_WAREHOUSE uw "
                + "ON w.warehouse_id = uw.warehouse_id "
                + "WHERE uw.user_id = ? "
                + "AND uw.status = 'ACTIVE' "
                + "AND w.status = 'ACTIVE'";
        
        try {
            Connection con = DBContext.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Warehouse warehouse = new Warehouse();
                warehouse.setWarehouseId(rs.getString("warehouse_id"));
                warehouse.setWarehouseCode(rs.getString("warehouse_code"));
                warehouse.setWarehouseName(rs.getString("warehouse_name"));
                warehouse.setLocation(rs.getString("location"));
                warehouse.setStatus(rs.getString("status"));
                warehouse.setCreatedAt(rs.getTimestamp("created_at"));
                return warehouse;
            }
        } catch (SQLException sQLException) {
            sQLException.printStackTrace();
        }
        return null;
    }

    // New methods from NB13
    public List<Warehouse> getAllWarehouses() throws Exception {
        String sql =
                "SELECT "
                + "w.warehouse_id, "
                + "w.warehouse_name, "
                + "w.location, "
                + "w.status, "
                + "w.created_at, "

                + "(SELECT TOP 1 "
                + "u.full_name + ' (' + u.username + ')' "
                + "FROM USERS u "
                + "JOIN USER_WAREHOUSE uw "
                + "ON u.user_id = uw.user_id "
                + "WHERE uw.warehouse_id = w.warehouse_id "
                + "AND u.role = 'MANAGER' "
                + "AND u.status = 'ACTIVE' "
                + "ORDER BY u.user_id) AS manager_name, "

                + "(SELECT COUNT(*) "
                + "FROM DEVICE d "
                + "WHERE d.warehouse_id = w.warehouse_id) AS device_count, "

                + "(SELECT COUNT(*) "
                + "FROM DEVICE d "
                + "WHERE d.warehouse_id = w.warehouse_id "
                + "AND d.status = 'ACTIVE' "
                + "AND d.last_seen >= DATEADD(SECOND, -30, SYSDATETIME())) "
                + "AS online_device_count, "

                + "(SELECT COUNT(*) "
                + "FROM DRYING_BATCH b "
                + "WHERE b.warehouse_id = w.warehouse_id "
                + "AND b.status = 'DRYING') "
                + "AS active_batch_count "

                + "FROM WAREHOUSE w "
                + "ORDER BY w.warehouse_id";

        return executeList(sql);
    }

    public List<Warehouse> getWarehousesByManager(String userId) throws Exception {
        String sql =
                "SELECT "
                + "w.warehouse_id, "
                + "w.warehouse_name, "
                + "w.location, "
                + "w.status, "
                + "w.created_at, "

                + "(SELECT TOP 1 "
                + "u.full_name + ' (' + u.username + ')' "
                + "FROM USERS u "
                + "JOIN USER_WAREHOUSE uw2 "
                + "ON u.user_id = uw2.user_id "
                + "WHERE uw2.warehouse_id = w.warehouse_id "
                + "AND u.role = 'MANAGER' "
                + "ORDER BY u.user_id) AS manager_name, "

                + "(SELECT COUNT(*) "
                + "FROM DEVICE d "
                + "WHERE d.warehouse_id = w.warehouse_id) AS device_count, "

                + "(SELECT COUNT(*) "
                + "FROM DEVICE d "
                + "WHERE d.warehouse_id = w.warehouse_id "
                + "AND d.status = 'ACTIVE' "
                + "AND d.last_seen >= DATEADD(SECOND, -30, SYSDATETIME())) "
                + "AS online_device_count, "

                + "(SELECT COUNT(*) "
                + "FROM DRYING_BATCH b "
                + "WHERE b.warehouse_id = w.warehouse_id "
                + "AND b.status = 'DRYING') "
                + "AS active_batch_count "

                + "FROM WAREHOUSE w "
                + "JOIN USER_WAREHOUSE uw "
                + "ON w.warehouse_id = uw.warehouse_id "
                + "WHERE uw.user_id = ? "
                + "AND w.status = 'ACTIVE' "
                + "ORDER BY w.warehouse_id";

        List<Warehouse> list = new ArrayList<Warehouse>();
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        }
        return list;
    }

    private List<Warehouse> executeList(String sql) throws Exception {
        List<Warehouse> list = new ArrayList<Warehouse>();
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(map(rs));
            }
        }
        return list;
    }

    private Warehouse map(ResultSet rs) throws SQLException {
        return new Warehouse(
                rs.getString("warehouse_id"),
                rs.getString("warehouse_name"), // mapping warehouse_name instead of name
                rs.getString("location"),
                rs.getString("status"),
                rs.getString("manager_name"),
                rs.getTimestamp("created_at"),
                rs.getInt("device_count"),
                rs.getInt("online_device_count"),
                rs.getInt("active_batch_count")
        );
    }

    public boolean isAssignedToManager(String userId, String warehouseId) throws Exception {
        return DBContext.scalar(
                "SELECT COUNT(*) FROM USER_WAREHOUSE WHERE user_id = ? AND warehouse_id = ?",
                userId, warehouseId
        ) > 0;
    }

    public void add(String id, String name, String location) throws Exception {
        DBContext.exec(
                "INSERT INTO WAREHOUSE (warehouse_id, warehouse_name, location, status) VALUES (?, ?, ?, 'ACTIVE')",
                id, name, location
        );
    }

    public void update(String id, String name, String location) throws Exception {
        DBContext.exec(
                "UPDATE WAREHOUSE SET warehouse_name = ?, location = ? WHERE warehouse_id = ?",
                name, location, id
        );
    }

    public void toggleStatus(String id) throws Exception {
        DBContext.exec(
                "UPDATE WAREHOUSE "
                + "SET status = "
                + "CASE "
                + "WHEN status = 'ACTIVE' THEN 'INACTIVE' "
                + "ELSE 'ACTIVE' "
                + "END "
                + "WHERE warehouse_id = ?",
                id
        );
    }

    public int countAll() throws Exception {
        return DBContext.scalar("SELECT COUNT(*) FROM WAREHOUSE");
    }

    public int countActive() throws Exception {
        return DBContext.scalar("SELECT COUNT(*) FROM WAREHOUSE WHERE status = 'ACTIVE'");
    }
}
