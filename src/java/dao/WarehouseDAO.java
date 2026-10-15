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

    public Warehouse getWarehouseByUser(String userId) {
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

                warehouse.setWarehouseId(
                        rs.getString("warehouse_id")
                );

                warehouse.setWarehouseCode(
                        rs.getString("warehouse_code")
                );

                warehouse.setWarehouseName(
                        rs.getString("warehouse_name")
                );

                warehouse.setLocation(
                        rs.getString("location")
                );

                warehouse.setStatus(
                        rs.getString("status")
                );

                warehouse.setCreatedAt(
                        rs.getTimestamp("created_at")
                );

                return warehouse;
            }
        } catch (SQLException sQLException) {
            sQLException.printStackTrace();
        }
        return null;
    }

    // =====================================================
    // MAP RESULTSET -> WAREHOUSE
    // =====================================================
    private Warehouse mapWarehouse(ResultSet rs)
            throws SQLException {

        Warehouse warehouse = new Warehouse();

        warehouse.setWarehouseId(
                rs.getString("warehouse_id")
        );

        warehouse.setWarehouseCode(
                rs.getString("warehouse_code")
        );

        warehouse.setWarehouseName(
                rs.getString("warehouse_name")
        );

        warehouse.setLocation(
                rs.getString("location")
        );

        warehouse.setStatus(
                rs.getString("status")
        );

        warehouse.setCreatedAt(
                rs.getTimestamp("created_at")
        );

        return warehouse;
    }

    // =====================================================
    // MANAGER
    // GET ALL ASSIGNED WAREHOUSES
    // =====================================================
    public List<Warehouse> getWarehousesByManager(
            String managerId) {

        List<Warehouse> list
                = new ArrayList<>();

        String sql
                = "SELECT "
                + "w.warehouse_id, "
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
                + "AND w.status = 'ACTIVE' "
                + "ORDER BY w.warehouse_id";

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
                            mapWarehouse(rs)
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
    // GET ALL WAREHOUSES
    // ACTIVE + INACTIVE
    // =====================================================
    public List<Warehouse> getAllWarehouses() {

        List<Warehouse> list
                = new ArrayList<>();

        String sql
                = "SELECT "
                + "warehouse_id, "
                + "warehouse_code, "
                + "warehouse_name, "
                + "location, "
                + "status, "
                + "created_at "
                + "FROM WAREHOUSE "
                + "ORDER BY warehouse_id";

        try ( Connection con
                = DBContext.getConnection();  PreparedStatement ps
                = con.prepareStatement(sql);  ResultSet rs
                = ps.executeQuery()) {

            while (rs.next()) {

                list.add(
                        mapWarehouse(rs)
                );
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return list;
    }

    // =====================================================
    // ADMIN
    // GET WAREHOUSE BY ID
    // =====================================================
    public Warehouse getById(
            String warehouseId) {

        String sql
                = "SELECT "
                + "warehouse_id, "
                + "warehouse_code, "
                + "warehouse_name, "
                + "location, "
                + "status, "
                + "created_at "
                + "FROM WAREHOUSE "
                + "WHERE warehouse_id = ?";

        try ( Connection con
                = DBContext.getConnection();  PreparedStatement ps
                = con.prepareStatement(sql)) {

            ps.setString(
                    1,
                    warehouseId
            );

            try ( ResultSet rs
                    = ps.executeQuery()) {

                if (rs.next()) {

                    return mapWarehouse(rs);
                }
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return null;
    }

    // =====================================================
    // MANAGER
    // CHECK IF WAREHOUSE BELONGS TO MANAGER
    // =====================================================
    public boolean isAssignedToManager(
            String managerId,
            String warehouseId) {

        String sql
                = "SELECT COUNT(*) AS total "
                + "FROM USER_WAREHOUSE uw "
                + "JOIN WAREHOUSE w "
                + "ON uw.warehouse_id = w.warehouse_id "
                + "WHERE uw.user_id = ? "
                + "AND uw.warehouse_id = ? "
                + "AND uw.status = 'ACTIVE' "
                + "AND w.status = 'ACTIVE'";

        try ( Connection con
                = DBContext.getConnection();  PreparedStatement ps
                = con.prepareStatement(sql)) {

            ps.setString(
                    1,
                    managerId
            );

            ps.setString(
                    2,
                    warehouseId
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
    // CHECK WAREHOUSE ID EXISTS
    // =====================================================
    public boolean existsWarehouseId(
            String warehouseId) {

        String sql
                = "SELECT COUNT(*) AS total "
                + "FROM WAREHOUSE "
                + "WHERE warehouse_id = ?";

        try (
                 Connection con
                = DBContext.getConnection();  PreparedStatement ps
                = con.prepareStatement(sql)) {

            ps.setString(
                    1,
                    warehouseId
            );

            try (
                     ResultSet rs
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
    // CHECK WAREHOUSE CODE EXISTS
    // =====================================================
    public boolean existsWarehouseCode(
            String warehouseCode) {

        String sql
                = "SELECT COUNT(*) AS total "
                + "FROM WAREHOUSE "
                + "WHERE warehouse_code = ?";

        try (
                 Connection con
                = DBContext.getConnection();  PreparedStatement ps
                = con.prepareStatement(sql)) {

            ps.setString(
                    1,
                    warehouseCode
            );

            try (
                     ResultSet rs
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
    // ADD WAREHOUSE
    // =====================================================
    public boolean add(
            String warehouseId,
            String warehouseCode,
            String warehouseName,
            String location) {

        String sql
                = "INSERT INTO WAREHOUSE "
                + "(warehouse_id, "
                + "warehouse_code, "
                + "warehouse_name, "
                + "location, "
                + "status) "
                + "VALUES (?, ?, ?, ?, 'ACTIVE')";

        try ( Connection con
                = DBContext.getConnection();  PreparedStatement ps
                = con.prepareStatement(sql)) {

            ps.setString(
                    1,
                    warehouseId
            );

            ps.setString(
                    2,
                    warehouseCode
            );

            ps.setString(
                    3,
                    warehouseName
            );

            ps.setString(
                    4,
                    location
            );

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return false;
    }

    // =====================================================
    // ADMIN
    // UPDATE WAREHOUSE
    // =====================================================
    public boolean update(
            String warehouseId,
            String warehouseCode,
            String warehouseName,
            String location) {

        String sql
                = "UPDATE WAREHOUSE "
                + "SET warehouse_code = ?, "
                + "warehouse_name = ?, "
                + "location = ? "
                + "WHERE warehouse_id = ?";

        try ( Connection con
                = DBContext.getConnection();  PreparedStatement ps
                = con.prepareStatement(sql)) {

            ps.setString(
                    1,
                    warehouseCode
            );

            ps.setString(
                    2,
                    warehouseName
            );

            ps.setString(
                    3,
                    location
            );

            ps.setString(
                    4,
                    warehouseId
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
    public boolean toggleStatus(
            String warehouseId) {

        String sql
                = "UPDATE WAREHOUSE "
                + "SET status = "
                + "CASE "
                + "WHEN status = 'ACTIVE' "
                + "THEN 'INACTIVE' "
                + "ELSE 'ACTIVE' "
                + "END "
                + "WHERE warehouse_id = ?";

        try ( Connection con
                = DBContext.getConnection();  PreparedStatement ps
                = con.prepareStatement(sql)) {

            ps.setString(
                    1,
                    warehouseId
            );

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return false;
    }

    // =====================================================
    // ADMIN DASHBOARD
    // COUNT ALL WAREHOUSES
    // =====================================================
    public int countAll() {

        String sql
                = "SELECT COUNT(*) AS total "
                + "FROM WAREHOUSE";

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
    // ADMIN DASHBOARD
    // COUNT ACTIVE WAREHOUSES
    // =====================================================
    public int countActive() {

        String sql
                = "SELECT COUNT(*) AS total "
                + "FROM WAREHOUSE "
                + "WHERE status = 'ACTIVE'";

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

    // Check if warehouse can be deleted
    public boolean canDeleteWarehouse(
            String warehouseId) {

        String sql
                = "SELECT "
                + "(SELECT COUNT(*) FROM DEVICE "
                + " WHERE warehouse_id = ?) "
                + "+ "
                + "(SELECT COUNT(*) FROM DRYING_BATCH "
                + " WHERE warehouse_id = ?) "
                + "+ "
                + "(SELECT COUNT(*) FROM EVENT_LOG "
                + " WHERE warehouse_id = ?) "
                + "AS total";

        try (
                 Connection conn = DBContext.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(
                    1,
                    warehouseId
            );

            ps.setString(
                    2,
                    warehouseId
            );

            ps.setString(
                    3,
                    warehouseId
            );

            try (
                     ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    return rs.getInt(
                            "total"
                    ) == 0;
                }
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return false;
    }

    // DELETE WAREHOUSE
    public boolean deleteWarehouse(
            String warehouseId)
            throws Exception {

        Connection conn = null;

        try {

            conn = DBContext.getConnection();

            conn.setAutoCommit(
                    false
            );

            // Delete user assignments first
            String deleteAssignment
                    = "DELETE FROM USER_WAREHOUSE "
                    + "WHERE warehouse_id = ?";

            try (
                     PreparedStatement ps = conn.prepareStatement(
                            deleteAssignment
                    )) {

                ps.setString(
                        1,
                        warehouseId
                );

                ps.executeUpdate();
            }

            String deleteWarehouse
                    = "DELETE FROM WAREHOUSE "
                    + "WHERE warehouse_id = ?";

            int affected;

            try (
                     PreparedStatement ps = conn.prepareStatement(
                            deleteWarehouse
                    )) {

                ps.setString(
                        1,
                        warehouseId
                );

                affected
                        = ps.executeUpdate();
            }

            conn.commit();

            return affected > 0;

        } catch (Exception e) {

            if (conn != null) {
                conn.rollback();
            }

            throw e;

        } finally {

            if (conn != null) {

                conn.setAutoCommit(
                        true
                );

                conn.close();
            }
        }
    }
}